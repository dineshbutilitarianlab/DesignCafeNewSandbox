/*
Copyright (c) 2011, salesforce.com, Inc.
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, 
are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, 
this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, 
this list of conditions and the following disclaimer in the documentation 
and/or other materials provided with the distribution.
* Neither the name of the salesforce.com, Inc. nor the names of its contributors 
may be used to endorse or promote products derived from this software 
without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, 
BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF 
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE 
OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED 
OF THE POSSIBILITY OF SUCH DAMAGE.

*/
public without sharing class Milestone1_Milestone_Trigger_Utility {
    
    public static final String INSUFFICIENT_PRIVILEGES_TO_ACCESS_PARENT_MILESTONE = system.label.Milestone1_InsufficientPrivilegesToAccessParentMilestone;
    public static final String INSUFFICIENT_PRIVILEGES_TO_ACCESS_PROJECT = system.label.Milestone1_InsufficientPrivileges;
    
    public static Boolean alreadyMadeParent = false;
    
    // Add By Jai Kumar 
    public static void handleUpdateCustomerOnPAInsert(Map<Id, Milestone1_Milestone__c> recs){
        ProjectActivityHandler.updateCustomerOnPAInsert(recs);
        
    }
    public static void handleCreateTask(Map<Id, Milestone1_Milestone__c> recs){
        TaskHandler.createTask(recs);
        
    }
    public static void handleUpdateTask(Map<Id, Milestone1_Milestone__c> recs,Map<Id,Milestone1_Milestone__c> objprojectActivityMap){
        TaskHandler.updateTask(recs,objprojectActivityMap);
        
    }
    
    public static void handleMilestoneDeleteTrigger(Map<Id, Milestone1_Milestone__c> oldMap){
        ID lMilestoneTemplateRecTypeID = null;
        
        for(Schema.RecordTypeInfo lRecType : Milestone1_Milestone__c.SObjectType.getDescribe().getRecordTypeInfos()) {
            if(lRecType.getDeveloperName() == 'Milestone_Template') {
                lMilestoneTemplateRecTypeID = lRecType.getRecordTypeId();
            }
        }
        
        for(Milestone1_Milestone__c lOldRec : oldMap.values()) {
            if(lOldRec.RecordTypeId == lMilestoneTemplateRecTypeID) {
                lOldRec.addError('Project Milestone Template records are not allowed to be deleted from the system.');
            }
        }
        
        //query for list of child milestones that are NOT part of the recs collection
        List<Milestone1_Milestone__c> extraChildren = new List<Milestone1_Milestone__c>();
        
        extraChildren = [SELECT Id
                         FROM Milestone1_Milestone__c
                         WHERE Parent_Milestone__c IN :oldMap.keySet()
                         AND Id NOT IN :oldMap.keySet()
                        ];
        
        
        // Delete / Batch delete milestones
        if( extraChildren.size() > 0 ){
            if( extraChildren.size() + Limits.getDMLRows() > Limits.getLimitDmlRows() ){
                Database.executeBatch( new Milestone1_Milestone_Batch_Delete(extraChildren) );
            }
            else{
                
                DescribeSObjectResult dsr = Milestone1_Milestone__c.SObjectType.getDescribe();
                if (!dsr.isDeletable()) {
                    throw new Milestone1_Exception('Insufficient Privileges');
                }
                delete extraChildren;
            }
        }
        
    }
    
    
    public static void checkMilestoneManualReparent(Map<Id, Milestone1_Milestone__c> oldMap, Map<Id, Milestone1_Milestone__c> newMap){
        Boolean allPassed = true;
        for(Milestone1_Milestone__c newRec : newMap.values()){
            Milestone1_Milestone__c oldRec = oldMap.get(newRec.Id);
            
            if(oldRec.Project__c != newRec.Project__c && newRec.Okay_to_Reparent__c == false){
                //don't want to reparent if not OK to reparent.
                allPassed = false;
                newRec.Project__c.addError(system.label.Milestone1_MilestonesShouldNotBeMoved);
            } 
        }
        
        if(allPassed){
            handleMilestoneBeforeTrigger(newMap.values(), newMap);
        }
    }
    
    /*
uses changes in milestone deadline to modify successor task kickoff and deadline dates.
*/
    public static void checkSuccessorDependencies(Map<Id, Milestone1_Milestone__c> oldMap, Map<Id, Milestone1_Milestone__c> newMap) {
        Map<Id, Set<Milestone1_Milestone__c>> successorMap = new Map<Id, Set<Milestone1_Milestone__c>>();
        for(Milestone1_Milestone__c successor: [SELECT Id, Kickoff__c, Deadline__c, Predecessor_Milestone__c FROM Milestone1_Milestone__c WHERE Predecessor_Milestone__c IN :newMap.keySet()]) {
            if(!successorMap.containsKey(successor.Predecessor_Milestone__c)) {
                successorMap.put(successor.Predecessor_Milestone__c, new Set<Milestone1_Milestone__c>());
            }
            successorMap.get(successor.Predecessor_Milestone__c).add(successor);
        }
        List<Milestone1_Milestone__c> successorsToUpdate = new List<Milestone1_Milestone__c>();
        for(Milestone1_Milestone__c newRec : newMap.values()) {
            Milestone1_Milestone__c oldRec = oldMap.get(newRec.Id);
            if(oldRec.Deadline__c != null && newRec.Deadline__c != null) {
                Integer deadlineShift = oldRec.Deadline__c.daysBetween(newRec.Deadline__c);
                if(deadlineShift != 0 && successorMap.containsKey(newRec.Id)) {
                    for(Milestone1_Milestone__c successor: successorMap.get(newRec.Id)) {
                        successor.Kickoff__c = successor.Kickoff__c.addDays(deadlineShift);
                        successor.Deadline__c = successor.Deadline__c.addDays(deadlineShift);
                    }
                    successorsToUpdate.addAll(successorMap.get(newRec.Id));
                }
            }
        }
        update successorsToUpdate;
    }
    
    public static void checkChildDependencies(Map<Id, Milestone1_Milestone__c> oldMap, Map<Id, Milestone1_Milestone__c> newMap) {
        Map<Id, Set<Milestone1_Milestone__c>> childMap = new Map<Id, Set<Milestone1_Milestone__c>>();
        for(Milestone1_Milestone__c child: [SELECT Id, Kickoff__c, Deadline__c, Parent_Milestone__c FROM Milestone1_Milestone__c WHERE Parent_Milestone__c IN :newMap.keySet()]) {
            if(!childMap.containsKey(child.Parent_Milestone__c)) {
                childMap.put(child.Parent_Milestone__c, new Set<Milestone1_Milestone__c>());
            }
            childMap.get(child.Parent_Milestone__c).add(child);
        }
        List<Milestone1_Milestone__c> childrenToUpdate = new List<Milestone1_Milestone__c>();
        for(Milestone1_Milestone__c newRec : newMap.values()) {
            Milestone1_Milestone__c oldRec = oldMap.get(newRec.Id);
            if(oldRec.Kickoff__c != null && oldRec.Deadline__c != null && newRec.Kickoff__c != null && newRec.Deadline__c != null) {
                Integer kickoffShift = oldRec.Kickoff__c.daysBetween(newRec.Kickoff__c);
                Integer deadlineShift = oldRec.Deadline__c.daysBetween(newRec.Deadline__c);
                if(kickoffShift == deadlineShift && deadlineShift != 0 &&childMap.containsKey(newRec.Id)) {
                    for(Milestone1_Milestone__c child: childMap.get(newRec.Id)) {
                        child.Kickoff__c = child.Kickoff__c.addDays(deadlineShift);
                        child.Deadline__c = child.Deadline__c.addDays(deadlineShift);
                    }
                    childrenToUpdate.addAll(childMap.get(newRec.Id));
                }
            }
        }
        alreadyMadeParent = true;
        update childrenToUpdate;
    }
    
    public static void checkTaskDependencies(Map<Id, Milestone1_Milestone__c> oldMap, Map<Id, Milestone1_Milestone__c> newMap) {
        Map<Id, Set<Milestone1_Task__c>> taskMap = new Map<Id, Set<Milestone1_Task__c>>();
        for(Milestone1_Task__c task: [SELECT Id, Start_Date__c, Due_Date__c, Project_Milestone__c FROM Milestone1_Task__c WHERE Project_Milestone__c IN :newMap.keySet()]) {
            if(!taskMap.containsKey(task.Project_Milestone__c)) {
                taskMap.put(task.Project_Milestone__c, new Set<Milestone1_Task__c>());
            }
            taskMap.get(task.Project_Milestone__c).add(task);
        }
        
        if(taskMap.size() > 0) {
            List<Milestone1_Task__c> tasksToUpdate = new List<Milestone1_Task__c>();
            for(Milestone1_Milestone__c newRec : newMap.values()) {
                Milestone1_Milestone__c oldRec = oldMap.get(newRec.Id);
                if(oldRec.Kickoff__c != null && oldRec.Deadline__c != null && newRec.Kickoff__c != null && newRec.Deadline__c != null) {
                    Integer kickoffShift = oldRec.Kickoff__c.daysBetween(newRec.Kickoff__c);
                    Integer deadlineShift = oldRec.Deadline__c.daysBetween(newRec.Deadline__c);
                    if(kickoffShift == deadlineShift && deadlineShift != 0 && taskMap.containsKey(newRec.Id)) {
                        for(Milestone1_Task__c task: taskMap.get(newRec.Id)) {
                            if (task.Start_Date__c != null)
                            {
                                task.Start_Date__c = task.Start_Date__c.addDays(deadlineShift);
                            }
                            if (task.Due_Date__c != null)
                            {
                                task.Due_Date__c = task.Due_Date__c.addDays(deadlineShift);
                            }
                        }
                        tasksToUpdate.addAll(taskMap.get(newRec.Id));
                    }
                }
            }
            update tasksToUpdate;
        }
    }
    
    public static void handleMilestoneBeforeTrigger(List<Milestone1_Milestone__c> recs, Map<Id, Milestone1_Milestone__c> recMapById){
        
        if(checkAccessRightLookUpFields(recs)){
            
            //create a map of records by parent milestone ID
            Map<Id, List<Milestone1_Milestone__c>> recMapByParentId = refreshRecordMapByParent(recs);
            
            //ensure parent project IDs for all records
            Set<Id> parentMilestoneIds = new Set<Id>();
            for(Milestone1_Milestone__c rec : recs){
                //reset to false--only set to true temporarily.
                rec.Okay_to_Reparent__c = false;
                if(rec.Parent_Milestone__c != null){
                    parentMilestoneIds.add(rec.Parent_Milestone__c);
                }
            }
            if(parentMilestoneIds.size() > 0){
                List<Milestone1_Milestone__c> parentMilestones = [SELECT Id,
                                                                  Project__c,
                                                                  Parent_Milestone__c
                                                                  FROM Milestone1_Milestone__c
                                                                  WHERE Id IN :parentMilestoneIds
                                                                 ];
                
                Map<Id, Milestone1_Milestone__c> parentMilestonesMap = new Map<Id, Milestone1_Milestone__c>();
                for(Milestone1_Milestone__c parent : parentMilestones){
                    parentMilestonesMap.put(parent.Id, parent);
                }
                
                for(Milestone1_Milestone__c rec : recs){
                    // Check parent sharing permissions              
                    
                    if(rec.Parent_Milestone__c != null){
                        // Parent milestone not accessible 
                        if(parentMilestonesMap.get(rec.Parent_Milestone__c).Parent_Milestone__c != null){
                            rec.Parent_Milestone__c.addError(system.label.Milestone1_SubMilestonesCanOnlyGoOneLevelDeep);
                        } else {
                            //rec.Project__c = parentMilestonesMap.get(rec.Parent_Milestone__c).Project__c;
                        }
                    }
                }
            }
            
            //query for list of child milestones that are NOT part of the recs collection
            List<Milestone1_Milestone__c> extraChildren = new List<Milestone1_Milestone__c>();
            if(recMapById != null && recMapById.size() > 0){
                extraChildren = [SELECT Id,
                                 Name,
                                 Parent_Milestone__c,
                                 Parent_Milestone__r.Name,
                                 Hours_Budget__c,
                                 Expense_Budget__c,
                                 Total_Actual_Hours__c,
                                 Total_Actual_Expense__c,
                                 Total_Estimated_Hours__c,
                                 Total_Estimated_Expense__c,
                                 Total_Open_Tasks__c,
                                 Total_Late_Tasks__c,
                                 Total_Complete_Tasks__c,
                                 Total_Blocked_Tasks__c
                                 FROM Milestone1_Milestone__c
                                 WHERE Parent_Milestone__c IN :recMapById.keySet()
                                 AND Id NOT IN :recMapById.keySet()
                                ];
            }
            
            //map children by their parent milestone ID
            Map<Id, List<Milestone1_Milestone__c>> extraChildrenMap = new Map<Id, List<Milestone1_Milestone__c>>();
            for(Milestone1_Milestone__c extraChild : extraChildren){
                System.debug('*** extra child found: ' + extraChild.Name + ', parent is ' + extraChild.Parent_Milestone__r.Name);
                System.debug('*** child is: ' + extraChild);
                if(extraChildrenMap.get(extraChild.Parent_Milestone__c) == null){
                    extraChildrenMap.put(extraChild.Parent_Milestone__c, new List<Milestone1_Milestone__c>());
                }
                extraChildrenMap.get(extraChild.Parent_Milestone__c).add(extraChild);
            }
            
            //query for late tasks
            //TODO do we need this here? Is there a better way to handle this?
            List<Milestone1_Task__c> lateTasks = new List<Milestone1_Task__c>();
            if(recMapById != null && recMapById.size() > 0){
                lateTasks = [SELECT Id,
                             Project_Milestone__c
                             FROM Milestone1_Task__c
                             WHERE Project_Milestone__c IN :recMapById.keySet()
                             AND Complete__c = false
                             AND Due_Date__c < :Date.today()
                            ];
            }
            
            //map late tasks by parent milestone
            Map<Id, List<Milestone1_Task__c>> lateTasksByMilestoneId = new Map<Id, List<Milestone1_Task__c>>();
            for(Milestone1_Task__c lateTask : lateTasks){
                if(lateTasksByMilestoneId.get(lateTask.Project_Milestone__c) == null){
                    lateTasksByMilestoneId.put(lateTask.Project_Milestone__c, new List<Milestone1_Task__c>());
                }
                lateTasksByMilestoneId.get(lateTask.Project_Milestone__c).add(lateTask);
            }
            
            //instantiate sets of value helpers, to track new field values
            Map<Id, Milestone1_Milestone_Values_Helper> parentHelpers = new Map<Id, Milestone1_Milestone_Values_Helper>();
            List<Milestone1_Milestone_Values_Helper> selfHelpers = new List<Milestone1_Milestone_Values_Helper>();
            
            //while there are still records in recs, pull out those that are NOT the parent to
            //any other record in recs (in other words, the bottom-most records) and process them
            while(recs.size() > 0){
                List<Milestone1_Milestone__c> topChildren = new List<Milestone1_Milestone__c>();
                List<Milestone1_Milestone__c> bottomChildren = new List<Milestone1_Milestone__c>();
                recMapByParentId = refreshRecordMapByParent(recs);
                
                for(Milestone1_Milestone__c rec : recs){
                    if(recMapByParentId.get(rec.Id) == null){
                        //record is not the parent to any other records in our set
                        bottomChildren.add(rec);
                    } else {
                        //record is the parent to another record in our set
                        topChildren.add(rec);
                    }
                }
                recs = topChildren;
                
                for(Milestone1_Milestone__c rec : bottomChildren){
                    
                    //update number of late tasks from tasks
                    if(lateTasksByMilestoneId.get(rec.Id) == null){
                        rec.Late_Tasks_in_Tasks__c = 0;
                    } else {
                        rec.Late_Tasks_in_Tasks__c = lateTasksByMilestoneId.get(rec.Id).size();
                    }
                    
                    if(rec.Parent_Milestone__c != null){
                        if(recMapById!=null&&recMapById.get(rec.Parent_Milestone__c) != null){
                            //record has parent and parent is in our recs list
                            //create helper for parent and add our values to it
                            if(parentHelpers.get(rec.Parent_Milestone__c) == null){
                                parentHelpers.put(rec.Parent_Milestone__c, new Milestone1_Milestone_Values_Helper(recMapById.get(rec.Parent_Milestone__c)));
                            }
                            parentHelpers.get(rec.Parent_Milestone__c).addValuesFromChild(rec);
                        } else {
                            //record has parent, but parent is not in our recs list
                            //create self-helper
                            selfHelpers.add(new Milestone1_Milestone_Values_Helper(rec));
                        }
                    } else {
                        //record does not have parent milestone
                        //create self-helper
                        selfHelpers.add(new Milestone1_Milestone_Values_Helper(rec));
                    }
                }
            }
            
            List<Milestone1_Milestone_Values_Helper> allHelpers = selfHelpers.clone();
            allHelpers.addAll(parentHelpers.values());
            
            for(Milestone1_Milestone_Values_Helper helper : allHelpers){
                //if the record is the parent to milestones outside of the set we're updating, add their values
                List<Milestone1_Milestone__c> recChildren = extraChildrenMap.get(helper.oldRecord.Id);
                if(recChildren != null){
                    for(Milestone1_Milestone__c extraChild : recChildren){
                        helper.addValuesFromChild(extraChild);
                    }
                }
                
                //overwrite old values with new
                helper.updateOldWithNew();
            }
        }
    }
    
    public static void handleMilestoneAfterTrigger(Map<Id, Milestone1_Milestone__c> recs){
        updateParents(recs);
    }
    
    private static void updateParents(Map<Id, Milestone1_Milestone__c> recMapById){
        Set<Id> milestoneUpdateSet = new Set<Id>();
        Set<Id> projectUpdateSet = new Set<Id>();
        
        for(Milestone1_Milestone__c rec : recMapById.values()){
            if(rec.Parent_Milestone__c != null){
                if(recMapById.get(rec.Parent_Milestone__c) != null){
                    //record has parent and parent is in our recs list
                    //do nothing, as the parent has already been updated
                }
                else {
                    //record has parent, but parent is not in our recs list
                    //mark parent milestone to be updated
                    milestoneUpdateSet.add(rec.Parent_Milestone__c);
                }
            }
            else {
                //record does not have parent milestone
                //mark parent project to be updated
                projectUpdateSet.add(rec.Project__c);
            }
        }
        
        if(milestoneUpdateSet.size() > 0 && !alreadyMadeParent){
            updateMilestones(milestoneUpdateSet);
        }
        //TODO force projects to go out and true themselves up, top down style
        if(projectUpdateSet.size() > 0){
            updateProjects(projectUpdateSet);
        }
    }
    
    //create a map of records by parent milestone ID
    private static Map<Id, List<Milestone1_Milestone__c>> refreshRecordMapByParent(List<Milestone1_Milestone__c> recs){
        Map<Id, List<Milestone1_Milestone__c>> recMapByParentId = new Map<Id, List<Milestone1_Milestone__c>>();
        for(Milestone1_Milestone__c rec : recs){
            if(rec.Parent_Milestone__c != null){
                if(recMapByParentId.get(rec.Parent_Milestone__c) == null){
                    recMapByParentId.put(rec.Parent_Milestone__c, new List<Milestone1_Milestone__c>());
                }
                recMapByParentId.get(rec.Parent_Milestone__c).add(rec);
            }
        }
        return recMapByParentId;
    }
    
    
    //call an update to any parent milestones that weren't part of our trigger set
    @TestVisible
    private static void updateMilestones(Set<Id> idSet) {
        if( idSet.size() + Limits.getDMLRows() > Limits.getLimitDmlRows() ){
            batchUpdateMilestones(idSet);
        }
        else{
            update [SELECT Id FROM Milestone1_Milestone__c WHERE Id IN :idSet];
        }
    }
    
    /**
* Batch update milestones
*
* @param idSet Set of milestone ids
*/
    @TestVisible
    private static void batchUpdateMilestones( Set<Id> idSet ){
        if( idSet.size() > 0 ){
            Database.executeBatch( new Milestone1_Milestone_Batch_Update(idSet) );
        }
    }
    
    //call an update to any parent projects
    @TestVisible
    private static void updateProjects(Set<Id> idSet) {
        if( idSet.size() + Limits.getDMLRows() > Limits.getLimitDmlRows() ){
            batchUpdateProjects(idSet);
        }
        else{
            update [SELECT Id FROM Milestone1_Project__c WHERE Id IN :idSet];
        }
    }
    
    /**
* Batch update projects
*
* @param idSet Set of project ids
*/
    @TestVisible
    private static void batchUpdateProjects( Set<Id> idSet ){
        if( idSet.size() > 0 ){
            Database.executeBatch( new Milestone1_Project_Batch_Update(idSet) );
        }
    }
    
    
    
    
    /**
* Check if the User have privileges over current Object
* getting a Name field permissions
* @params ObjectName
* @return boolean
*/
    public static Boolean milestonePermissions( String objectName ) {
        if( objectName != null ) {
            Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            Schema.DescribeSObjectResult descRes = schemaMap.get( objectName ).getDescribe();
            return descRes.isCreateable();
        }
        return false; 
    }
    
    /**
*   Check access right to references of Milestones such as Parent_Milestone__c and Project__c, if
*   the user is not a sysadmin.
*/
    private static Boolean checkAccessRightLookUpFields(List<Milestone1_Milestone__c> milestones){
        Boolean hasPermission = Milestone1_General_Utility.isSysAdmin();
        if(!hasPermission){
            //check the permission over Project__c field for new milestones
            if(Trigger.isinsert){
                hasPermission = checkAccessRightReferences(milestones, 'Project__c', 'Milestone1_Project__Share',Userinfo.getUserId(),
                                                           INSUFFICIENT_PRIVILEGES_TO_ACCESS_PROJECT); 
            }
            //check the permission over Parent_Milestone__c for updates
            hasPermission = checkAccessRightReferences(milestones, 'Parent_Milestone__c','Milestone1_Milestone__Share',Userinfo.getUserId(),
                                                       INSUFFICIENT_PRIVILEGES_TO_ACCESS_PARENT_MILESTONE);
        }
        return hasPermission; 
    }
    
    /**
*   Given a list of sobjects, a reference field, a user,
*   check the permission to Read in the share objects for the references objects.
*/
    @TestVisible
    private static Boolean checkAccessRightReferences(List<Sobject> sobjectList, String reference,String sharedObjectName,String userId,String errorMessage){
        String query = 'SELECT UserOrGroupId,AccessLevel,ParentId FROM $1 WHERE UserOrGroupId = \'$3\' ';
        Sobjecttype milestoneShareSObjectType = Schema.getGlobalDescribe().get(sharedObjectName);
        Boolean hasPermission = true;
        
        if(milestoneShareSObjectType != null){
            List<String> referenceObjects = new List<String>(); 
            String referenceObjectId;
            for(Sobject myObject : sobjectList){
                referenceObjectId = String.valueOf(myObject.get(reference));
                if(referenceObjectId != null){
                    referenceObjects.add(referenceObjectId);
                }
            }
            String querySharedObjects = query.replace('$1',sharedObjectName);
            querySharedObjects = querySharedObjects.replace('$3',userId);
            Sobject sharedObjectFound;
            List<Sobject> sharedObjects = Database.query(querySharedObjects);
            for(Sobject myObject : sobjectList){
                sharedObjectFound = null;
                if(myObject.get(reference) != null){
                    for(Sobject sharedObject : sharedObjects){
                        if(myObject.get(reference) == sharedObject.get('ParentId')){
                            sharedObjectFound = sharedObject;
                            break;
                        }
                    }
                    if(sharedObjectFound == null || sharedObjectFound.get('AccessLevel') == 'Read'){
                        myObject.addError(errorMessage);
                        //hasPermission = false;
                    }   
                }   
            }       
        }
        return hasPermission;
    }
    
    /* Update the Project current milestone field when milestone is completed */
    public static void UpdateCurrentMilestoneOnProject(Map<Id,Milestone1_Milestone__c> oldMap , Map<Id,Milestone1_Milestone__c> newMap){
        List<Milestone1_Project__c> Projectlist = new List<Milestone1_Project__c>();
        Set<Id> projectId = new Set<Id>();
        
        for(Milestone1_Milestone__c newMSRec : newMap.values()) {
            Milestone1_Milestone__c oldMSRec = oldMap.get(newMSRec.Id);
            
            if(oldMSRec.Complete__c == false && newMSRec.Complete__c == true) {
                projectId.add(newMSRec.Project__c);
            }
        }
        
        if(projectId.size() > 0) {
            Map<Id, Milestone1_Project__c> projectMap = new  Map<Id, Milestone1_Project__c>([SELECT id, Quality_Check_Status__c, Current_Milestone__c, Survey_Status__c,KYC_Completed__c,
                                                                                             X3D_Shell_Designer_Assigned__c, Survey_Completed__c FROM 
                                                                                             Milestone1_Project__c WHERE Id IN:projectId]);
            
            for(Milestone1_Milestone__c newMSRec : newMap.values()) {
                Milestone1_Milestone__c oldMSRec = oldMap.get(newMSRec.Id);
                Milestone1_Project__c projectRec = projectMap.get(newMSRec.Project__c);
                
                if(oldMSRec.Complete__c == false && newMSRec.Complete__c == true) {
                    if(newMSRec.Type__c == 'Customer Onboarding') {
                        projectRec.Current_Milestone__c ='Onboarding';
                    }
                    else if(newMSRec.Type__c == 'KYC') {
                        projectRec.Current_Milestone__c ='KYC'; 
                        projectRec.KYC_Completed__c = true;
                    }
                    else if(newMSRec.Type__c == 'First Cut Presentation') {
                        projectRec.Current_Milestone__c ='First Cut Presentation'; 
                    }
                    else if(newMSRec.Type__c == 'Detailed Design Finalization') {
                        projectRec.Current_Milestone__c ='Design Finalized'; 
                    }
                    else if(newMSRec.Type__c == 'Kick-off Meeting Revision') {
                        projectRec.Quality_Check_Status__c ='Submitted for Quality Check'; 
                    }
                    else if(newMSRec.Type__c == '3D Presentation') {
                        projectRec.Current_Milestone__c ='3D Presentation';
                    }
                    else if(newMSRec.Type__c == 'Design Sign-off from Customer') {
                        projectRec.Current_Milestone__c ='Design Signoff';
                    }
                    else if(newMSRec.Type__c == 'Site Survey') {
                        projectRec.Survey_Status__c ='Survey Completed';
                        projectRec.Survey_Completed__c = true;
                        projectRec.X3D_Shell_Designer_Assigned__c = 'Request Outstanding';
                    }
                    
                    Projectlist.add(projectRec);
                }
            }
            
            if(Projectlist.size() > 0) {
                try {
                    update Projectlist;
                }
                catch(Exception e) {
                    System.debug('^^^ e=' + e);                
                }
            }
        }
    }
    
    public static void UpdateCurrentMilestoneStageOnProject(Map<Id,Milestone1_Milestone__c> oldMap , Map<Id,Milestone1_Milestone__c> newMap){
        Set<Id> projectId = new Set<Id>();
        List<Milestone1_Project__c> Projectlist = new List<Milestone1_Project__c>();
        
        for(Milestone1_Milestone__c newMSRec : newMap.values()) {
            Milestone1_Milestone__c oldMSRec = oldMap.get(newMSRec.Id);
            
            if(oldMSRec.Complete__c == false && newMSRec.Complete__c == true) {
                projectId.add(newMSRec.Project__c);
            }
        }
        
        if(projectId.size() > 0) {
            Map<Id,Milestone1_Project__c> projectMap = new  Map<Id,Milestone1_Project__c>([SELECT id, Quality_Check_Status__c, X3D_Designer_Assigned__c, 
                                                                                           Current_Milestone__c FROM Milestone1_Project__c WHERE id IN:projectId]);
            
            for(Milestone1_Milestone__c newMSRec : newMap.values()) {
                Milestone1_Milestone__c oldMSRec = oldMap.get(newMSRec.Id);
                Milestone1_Project__c projectRec = projectMap.get(newMSRec.Project__c);
                
                if(oldMSRec.Complete__c == false && newMSRec.Complete__c == true) {
                    if(newMSRec.Type__c == 'Customer Onboarding') {
                        projectRec.Current_Milestone_stage__c ='Customer Onboarding'; 
                    }
                    else if(newMSRec.Type__c == 'KYC'){
                        projectRec.Current_Milestone_stage__c ='KYC'; 
                    }
                    else if(newMSRec.Type__c == 'First Cut Presentation'){
                        projectRec.Current_Milestone_stage__c ='First Cut Presentation'; 
                    }
                    else if(newMSRec.Type__c == 'Detailed Design Finalization'){
                        projectRec.Current_Milestone_stage__c ='Detailed Design Finalization'; 
                    }
                    else if(newMSRec.Type__c == 'Kick-off Meeting Revision') {
                        projectRec.Current_Milestone_stage__c ='Kick-off Meeting Revision'; 
                    }
                    else if(newMSRec.Type__c == '3D Presentation'){
                        projectRec.Current_Milestone_stage__c ='3D Presentation';
                    }
                    else if(newMSRec.Type__c == 'Design Finalization') {
                        projectRec.Current_Milestone_stage__c ='Design Finalization';
                        projectRec.X3D_Designer_Assigned__c = 'Request Outstanding';
                    }
                    else if(newMSRec.Type__c == 'GFC'){
                        projectRec.Current_Milestone_stage__c ='GFC';
                    }
                    else if(newMSRec.Type__c == 'Kickoff Meeting with PM'){
                        projectRec.Current_Milestone_stage__c ='Kickoff Meeting with PM';
                    }
                    else if(newMSRec.Type__c == 'Site Survey'){
                        projectRec.Current_Milestone_stage__c ='Site Survey';
                    }
                    else if(newMSRec.Type__c == 'QC'){
                        projectRec.Current_Milestone_stage__c ='QC';
                    }
                    else if(newMSRec.Type__c == 'Build 3D Designs'){
                        projectRec.Current_Milestone_stage__c ='Build 3D Designs';
                    }
                    else if(newMSRec.Type__c == 'Design Sign-off from Customer'){
                        projectRec.Current_Milestone_stage__c ='Design Sign-off from Customer';
                    }
                    
                    Projectlist.add(projectRec);
                }
            }
            
            if(Projectlist.size() > 0) {
                try {
                    update Projectlist;
                }
                catch(Exception e){
                    System.debug('^^^ e=' + e);                
                }
            }
        }
    }
    /* update the project manager assigned? field on project to  Request Outstanding when Design Revisions Milestone is completed */
    public static void markProjectManagerAssigned(Map<Id,Milestone1_Milestone__c> oldMap,Map<Id,Milestone1_Milestone__c> newMap){
        Set<Id> projectId = new Set<Id>();
        List<Milestone1_Project__c> Projectlist = new List<Milestone1_Project__c>();
        for(Milestone1_Milestone__c newMSRec : newMap.values()) {
            if(newMSRec.Type__c == 'Detailed Design Finalization'){
                projectId.add(newMSRec.Project__c);
            }
        }
        
        if(projectId.size() > 0) {
            Map<Id, Milestone1_Project__c> projectMap = new  Map<Id,Milestone1_Project__c>([SELECT id, Project_Manager_Assigned__c 
                                                                                            FROM Milestone1_Project__c WHERE id IN:projectId]);
            
            for(Milestone1_Milestone__c newMSRec : newMap.values()) {
                Milestone1_Milestone__c oldMSRec = oldMap.get(newMSRec.Id);
                if(oldMSRec.Complete__c == false && newMSRec.Complete__c == true && projectMap.containsKey(newMSRec.Project__c) ){
                    Milestone1_Project__c projectRec = projectMap.get(newMSRec.Project__c);
                    projectRec.Project_Manager_Assigned__c ='Request Outstanding';
                    Projectlist.add(projectRec);
                }
            }
            if(Projectlist.size() > 0) {
                try {
                    update Projectlist;
                }
                catch(Exception e){
                    System.debug('^^^ e=' + e);                
                }
            }
        }
    }
    //create feedback records
    public static void createFeedback(Map<Id, Milestone1_Milestone__c> newMap,Map<Id, Milestone1_Milestone__c> oldMap){
        /*List<Feedback__c> feedbackList = new List<Feedback__c>();
for(Milestone1_Milestone__c mActivity : newMap.values()){
Milestone1_Milestone__c mOld = oldMap.get(mActivity.id);
if((mActivity.Complete__c == true && mOld.Complete__c == false) && 
(mActivity.Type__c =='KYC' || mActivity.Type__c =='First Cut Presentation' || mActivity.Type__c =='3D Presentation' || mActivity.Type__c =='Kickoff Meeting with PM')){
Feedback__c fcRec = new Feedback__c();  
fcRec.Project__c = mActivity.Project__c;
fcRec.Is_Accepted_by_Customer__c ='Awaiting Confirmation';
if(mActivity.Type__c =='KYC'){
fcRec.Name = 'KYC MOM';
fcRec.Minutes_of_Meeting__c = mActivity.MOM__c;
fcRec.recordtypeId = Schema.SObjectType.Feedback__c.getRecordTypeInfosByName().get('KYC MOM Details').getRecordTypeId();  
}
if(mActivity.Type__c =='First Cut Presentation'){
fcRec.Name = 'First Cut Presentation MOM';
fcRec.Minutes_of_Meeting__c = mActivity.MOM__c;
fcRec.recordtypeId = Schema.SObjectType.Feedback__c.getRecordTypeInfosByName().get('First Cut Presentation MOM Details').getRecordTypeId();  
}
if(mActivity.Type__c =='3D Presentation'){
fcRec.Name = '3D Presentation MOM';
fcRec.Minutes_of_Meeting__c = mActivity.MOM__c;
fcRec.recordtypeId = Schema.SObjectType.Feedback__c.getRecordTypeInfosByName().get('3D Presentation MOM Details').getRecordTypeId();  
}
if(mActivity.Type__c =='Kickoff Meeting with PM'){
fcRec.Name = 'Kick Off Meeting MOM';
fcRec.Minutes_of_Meeting__c = mActivity.MOM__c;
fcRec.recordtypeId = Schema.SObjectType.Feedback__c.getRecordTypeInfosByName().get('Kick Off Meeting MOM Details').getRecordTypeId();  
}
fcRec.Project_Activity__c = mActivity.id;
fcRec.Customer__c = mActivity.customer__c;
feedbackList.add(fcRec);
}
}
if(feedbackList.size()>0){
insert feedbackList;
}*/
    }
    
    //mark actual complition date
    public static void markActualComplitiondate(Map<Id, Milestone1_Milestone__c> oldMap,Map<Id, Milestone1_Milestone__c> newMap){
        for(Milestone1_Milestone__c  mrec: newMap.values()){
            if(mrec.Complete__c == true && oldMap.get(mrec.id).Complete__c == false){
                mrec.Actual_Completion_Date__c = Datetime.now();
            }
        }
    }
    
    //Create Invoice on Milestone when Is_Pre_payment_Milestone__c IS true
    public static void createInvoiceOnMilestone(Map<Id, Milestone1_Milestone__c> newmap, Map<Id, Milestone1_Milestone__c> oldMap) {
        Set<ID> lMilestoneIDSet = new Set<ID>();
        List<Invoice__c> invoiceList = new List<Invoice__c>();
        Incentive_Amount__c objSgst = Incentive_Amount__c.getValues('SGST');
        Incentive_Amount__c objAmount = Incentive_Amount__c.getValues('CGST');
        Incentive_Amount__c objIGST = Incentive_Amount__c.getValues('IGST');
        
        for(Milestone1_Milestone__c newRec : newmap.values()) {
            Milestone1_Milestone__c lOldRec = oldMap.get(newRec.id);
            
            if(lOldRec != null && newRec.Is_Pre_payment_Milestone__c == true && newRec.Successor_Milestone__c != null && 
               newRec.Complete__c != lOldRec.Complete__c && newRec.Complete__c == true) {
                   lMilestoneIDSet.add(newRec.id);
               }
        }
        
        if(lMilestoneIDSet.size() > 0) {
            for(Milestone1_Milestone__c newRec : [SELECT id, Project__c, Successor_Milestone__c, Project__r.Customer__c,Customer__r.BillingState,Customer__r.ShippingState, Is_Pre_payment_Milestone__c,
                                                  Successor_Milestone__r.Actual_Amount_Due_for_Reporting__c, Complete__c FROM Milestone1_Milestone__c WHERE Id IN:lMilestoneIDSet]) {
                                                      
                                                      Milestone1_Milestone__c lOldRec = oldMap.get(newRec.id);
                                                      
                                                      if(lOldRec != null && newRec.Is_Pre_payment_Milestone__c == true && newRec.Successor_Milestone__c != null && 
                                                         newRec.Complete__c != lOldRec.Complete__c && newRec.Complete__c == true && newRec.Successor_Milestone__r.Actual_Amount_Due_for_Reporting__c > 0) {
                                                             Invoice__c invObj=new Invoice__c();
                                                             invObj.Invoice_Date__c = Date.today();
                                                             invObj.Milestone__c = newRec.Successor_Milestone__c;
                                                             invObj.Customer__c = newRec.Project__r.Customer__c;
                                                             invObj.Project__c = newRec.Project__c;
                                                             invObj.Total_Amount__c = newRec.Successor_Milestone__r.Actual_Amount_Due_for_Reporting__c;
                                                             system.debug('state : '  + newRec.Customer__r.BillingState + ' :: ' + newRec.Customer__r.ShippingState);
                                                            // if(newRec.Customer__r.BillingState == newRec.Customer__r.ShippingState){
                                                                 invObj.CGST__c = (newRec.Successor_Milestone__r.Actual_Amount_Due_for_Reporting__c * objAmount.CGST__c) / 100;
                                                                 invObj.SGST__c = (newRec.Successor_Milestone__r.Actual_Amount_Due_for_Reporting__c * objSgst.SGST__c) / 100;
                                                                 invObj.Total_Tax_Amount__c = ((newRec.Successor_Milestone__r.Actual_Amount_Due_for_Reporting__c * (objSgst.SGST__c+objAmount.CGST__c)) / 100);
                                                                 invObj.Amount__c = newRec.Successor_Milestone__r.Actual_Amount_Due_for_Reporting__c - ((newRec.Successor_Milestone__r.Actual_Amount_Due_for_Reporting__c * (objSgst.SGST__c + objAmount.CGST__c)) / 100);  
                                                                 invoiceList.add(invObj);  
                                                             /*}
                                                             else{
                                                                 invObj.IGST18__c = (newRec.Successor_Milestone__r.Actual_Amount_Due_for_Reporting__c * objIGST.IGST__c) / 100;
                                                                 invObj.Total_Tax_Amount__c = ((newRec.Successor_Milestone__r.Actual_Amount_Due_for_Reporting__c * (objIGST.IGST__c)) / 100);
                                                                 invObj.Amount__c = newRec.Successor_Milestone__r.Actual_Amount_Due_for_Reporting__c - ((newRec.Successor_Milestone__r.Actual_Amount_Due_for_Reporting__c * (objIGST.IGST__c)) / 100);
                                                                 invoiceList.add(invObj); 
                                                             }*/
                                                             
                                                             
                                                         }
                                                  }
            
            if(invoiceList.size() > 0) {
                insert invoiceList;
            }
        }
    }
    public static void updateCHMEmailInsert(List<Milestone1_Milestone__c> listofmilestone){
        system.debug('inside chm insert'+listofmilestone);
        set<Id> Projectids = new set<Id>();
        for(Milestone1_Milestone__c milestone : listofmilestone){
            if(milestone != Null){
                Projectids.add(milestone.Project__c); 
                
            }
            
        }
        system.debug('projectids-->>'+Projectids);
        map<Id, Milestone1_project__c> mapofproject = new map<Id, Milestone1_project__c>([select id,CHM__c ,Designer__r.email, CHM__r.email, CHM__r.name from Milestone1_project__c where id IN : Projectids]);
        system.debug('mapofproject-->>'+mapofproject);
        for(Id proId: mapofproject.keySet()){
            System.debug('CHM__c:' +mapofproject.get(proId).CHM__c);
            System.debug('Designer__r.email:' +mapofproject.get(proId).Designer__r.email);
            System.debug('CHM__r.emai:' +mapofproject.get(proId).CHM__r.email);
        }
        for(Milestone1_Milestone__c singleMilestone : listofmilestone){
            system.debug('INSIDE FOR');
            if(singleMilestone.Project__c !=Null && mapofproject.containsKey(singleMilestone.Project__c) && mapofproject.get(singleMilestone.Project__c).CHM__r.email != Null && mapofproject.get(singleMilestone.Project__c).Designer__r.email != Null ){
                system.debug('INSIDE IF');
                singleMilestone.CHM_Email__c = mapofproject.get(singleMilestone.Project__c).CHM__r.email;
                singleMilestone.Designer_Email__c  = mapofproject.get(singleMilestone.Project__c).Designer__r.email;
                system.debug('CHM_Email__c-->'+singleMilestone.CHM_Email__c);
                
            }
        }
    }
    
    
    
}