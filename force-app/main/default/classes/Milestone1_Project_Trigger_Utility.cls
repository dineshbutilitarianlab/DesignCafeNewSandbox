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
public with sharing class Milestone1_Project_Trigger_Utility {
    
    //TODO What happens if we don't do this?  Do projects get out of sync with the Milestones 
    //if the projects change or is that just when milestones change?
    //this is more of a general truing utility than something that needs to run
    //with every project update
    public static void handleProjectUpdateTrigger( List<Milestone1_Project__c> recs){
        
        //Milestone1_GoogleChartUtility googleChartUtility = new Milestone1_GoogleChartUtility();
        
        Map<Id, Milestone1_Project__c> projectsById = new Map<Id, Milestone1_Project__c>();
        
        
        
        for( Milestone1_Project__c rec : recs ){
            
            System.debug('*** Project "' + rec.Name + '" with Id ' + rec.Id + ' begin trigger');
            projectsById.put(rec.Id, rec);
            rec.Number_of_Incomplete_Top_Milestones__c = 0;
            rec.Number_of_Incomplete_Milestones__c = 0;
            rec.Next_Project_Top_Milestone_Due_Date__c = null;
            rec.Next_Project_Milestone_Due_Date__c = null;
            rec.Total_Hours_Incurred__c = 0;
            rec.Total_Hours_Estimate__c = 0;
            rec.Total_Expense_Incurred__c = 0;
            rec.Total_Expense_Estimate__c = 0;
            rec.Total_Hours_Budget_from_Milestones__c = 0;
            rec.Total_Expense_Budget_from_Milestones__c = 0;
            rec.Total_Complete_Task_Count__c = 0;
            rec.Total_Open_Task_Count__c = 0;
            rec.Total_Blocked_Task_Count__c = 0;
            rec.Total_Late_Task_Count__c = 0;
            //rec.GoogleGanntUrl__c = GoogleChartUtility.getGoogleGannt( rec ); //Was removed for bulkify issue, cant do Querys into loops.
        }
        
        //Here we calls GoogleChartUtility.getGoogleGanntList with a List of recs
        //recs = GoogleChartUtility.getGoogleGanntList( recs ); 
        
        System.debug('*** project key set: ' + projectsById.keySet());
        
        List<Milestone1_Milestone__c> milestones = [SELECT Id,
                                                    Name,
                                                    Project__c,
                                                    Parent_Milestone__c,
                                                    Complete__c,
                                                    Deadline__c,
                                                    Total_Actual_Hours__c,
                                                    Total_Estimated_Hours__c,
                                                    Total_Actual_Expense__c,
                                                    Total_Estimated_Expense__c,
                                                    Total_Hours_Budget__c,
                                                    Total_Expense_Budget__c,
                                                    Total_Complete_Tasks__c,
                                                    Total_Open_Tasks__c,
                                                    Total_Late_Tasks__c,
                                                    Total_Blocked_Tasks__c
                                                    FROM Milestone1_Milestone__c
                                                    WHERE Project__c IN :projectsById.keySet()
                                                   ];
        System.debug('*** milestones queried for projects: ' + milestones.size());
        
        for(Milestone1_Milestone__c ms : milestones){
            Milestone1_Project__c proj = projectsById.get(ms.Project__c);
            
            if(ms.Complete__c == false) {
                proj.Number_of_Incomplete_Milestones__c++;
                
                if(ms.Parent_Milestone__c == null){
                    proj.Number_of_Incomplete_Top_Milestones__c++;
                }
                
                if(ms.Deadline__c != null){
                    System.debug('*** Deadline found: ' + ms.Deadline__c);
                    if(proj.Next_Project_Milestone_Due_Date__c == null){
                        System.debug('*** adopting deadline as initial due date');
                        proj.Next_Project_Milestone_Due_Date__c = ms.Deadline__c;
                    } else if(ms.Deadline__c < proj.Next_Project_Milestone_Due_Date__c){
                        System.debug('*** adopting deadline as new due date');
                        proj.Next_Project_Milestone_Due_Date__c = ms.Deadline__c;
                    }
                    if(ms.Parent_Milestone__c == null){
                        System.debug('*** milestone is top');
                        if(proj.Next_Project_Top_Milestone_Due_Date__c == null){
                            System.debug('*** adopting deadline as initial top due date');
                            proj.Next_Project_Top_Milestone_Due_Date__c = ms.Deadline__c;
                        } else if(ms.Deadline__c < proj.Next_Project_Top_Milestone_Due_Date__c){
                            System.debug('*** adopting deadline as new top due date');
                            proj.Next_Project_Top_Milestone_Due_Date__c = ms.Deadline__c;
                        }
                    }
                }
            }
            if(ms.Parent_Milestone__c == null){
                proj.Total_Hours_Incurred__c += ms.Total_Actual_Hours__c;
                proj.Total_Hours_Estimate__c += ms.Total_Estimated_Hours__c;
                proj.Total_Expense_Incurred__c += ms.Total_Actual_Expense__c;
                proj.Total_Expense_Estimate__c += ms.Total_Estimated_Expense__c;
                proj.Total_Hours_Budget_from_Milestones__c += ms.Total_Hours_Budget__c;
                proj.Total_Expense_Budget_from_Milestones__c += ms.Total_Expense_Budget__c;
                proj.Total_Complete_Task_Count__c += ms.Total_Complete_Tasks__c;
                proj.Total_Open_Task_Count__c += ms.Total_Open_Tasks__c;
                proj.Total_Blocked_Task_Count__c += ms.Total_Blocked_Tasks__c;
                proj.Total_Late_Task_Count__c += ms.Total_Late_Tasks__c;
            }
            System.debug('*** New values: ' + proj);
        }
        
    }
    
    
    //cascade delete from Project to Milestones (which then goes to Tasks, Times, Expenses, etc.)
    public static void handleProjectDeleteTrigger(List<Milestone1_Project__c> recs){
        ID lProjTemplateRecTypeID = null;
        
        for(Schema.RecordTypeInfo lRecType : Milestone1_Project__c.SObjectType.getDescribe().getRecordTypeInfos()) {
            if(lRecType.getDeveloperName() == 'Project_Template') {
                lProjTemplateRecTypeID = lRecType.getRecordTypeId();
            }
        }
        
        Map<Id, Milestone1_Project__c> projectsById = new Map<Id, Milestone1_Project__c>();
        for(Milestone1_Project__c rec : recs){
            System.debug('*** Project: ' + rec.Name + ', with Id: ' + rec.Id + ', RecTypeID: ' + rec.RecordTypeId + ', lProjTemplateRecTypeID: ' + 
                         lProjTemplateRecTypeID + ' begin delete trigger');
            
            projectsById.put(rec.Id, rec);
            
            if(rec.RecordTypeId == lProjTemplateRecTypeID) {
                rec.addError('Project Template records are not allowed to be deleted from the system.');
            }
        }
        
        List<Milestone1_Milestone__c> milestones = [SELECT Id
                                                    FROM Milestone1_Milestone__c
                                                    WHERE Project__c IN :projectsById.keySet()
                                                   ];
        
        // Delete / Batch delete milestones
        if( milestones.size() > 0 ){
            if( milestones.size() + Limits.getDMLRows() > Limits.getLimitDmlRows() ){
                Database.executeBatch( new Milestone1_Milestone_Batch_Delete(milestones) );
            }
            else{
                DescribeSObjectResult dsr = Milestone1_Milestone__c.SObjectType.getDescribe();
                if (!dsr.isDeletable()) {
                    throw new Milestone1_Exception('Insufficient Privileges');
                }
                delete milestones;
            }
        }
    }
    
    
    /**
* Avoid duplicates names
* @param triggerList
*/
    public static void handleProjectInsertTrigger( List<Milestone1_Project__c> triggerList ){
        List<String> nameList = new List<String>();
        for( Milestone1_Project__c tm : triggerList ){ 
            nameList.add( tm.Name );
            
        }
        
        
        Integer projectCount = [SELECT count() FROM Milestone1_Project__c WHERE Name IN: nameList limit 1];
        
        //TODO Flesh out to be more specific -- right now this flags every project as problematic even if only one has a duplicate name
        if( projectCount > 0 ) {
            for( Milestone1_Project__c tm : triggerList ){ 
                tm.Name.addError( 'Project Name is already used.' );
            }
        }
        
    }
    
    public static void updateCustomersEmail( List<Milestone1_Project__c> triggerList ){
        Set<Id> projIds = new Set<Id>();
        Set<Id> custIds = new Set<Id>();
        
        for( Milestone1_Project__c tm : triggerList ){ 
            projIds.add( tm.Id );
            custIds.add( tm.Customer__c );
        }
        
        Map<Id,Account> mapofAccount = new Map<Id,Account>([select Id,PersonEmail from Account where Id IN :custIds ]);
        for(Milestone1_Project__c singleproject : triggerList){
            if( singleproject.Customer__c != Null && mapofAccount.containsKey(singleproject.Customer__c) ){
                singleproject.Customer_s_Email__c= mapofAccount.get(singleproject.Customer__c).PersonEmail != Null ? mapofAccount.get(singleproject.Customer__c).PersonEmail : Null;  
            }
        }
    }
    
    /**
* Avoid duplicates default Project (Template)
* @param triggerList
* @author
*/
    public static void handleDefaultProject(List<Milestone1_Project__c> triggerList){
        Integer projectCount = [SELECT count() FROM Milestone1_Project__c WHERE Default_Template_Project__c = true limit 1];
        
        if( projectCount > 0 ) {
            for( Milestone1_Project__c tm : triggerList ){ 
                /*if(tm.RecordTypeId == devRecordTypeId) {
tm.Default_Template_Project__c.addError( 'Duplicate Default Project');
}*/
            }
        }
    }
    
    public static void preventUpdatingProjectValue(Map<Id,Milestone1_Project__c> newValues, Map<Id,Milestone1_Project__c> oldValues){
        set<Id> projIds= new set<Id>();
        for(Id proj : newValues.keySet()){
            if(newValues.get(proj).Amount__c != oldValues.get(proj).Amount__c ){
                projIds.add(proj);
            }            
        }
        
        List<Milestone1_milestone__c> listofmilestones = new List<Milestone1_milestone__c>([SELECT Id, Type__c,Name, Project__c,Complete__c,Invoices_Count__c
                                                                                            FROM Milestone1_Milestone__c WHERE Project__c IN :projIds]);
        
        
        if(listofmilestones.size()>0){
            for(Milestone1_milestone__c milestone : listofmilestones){
                if(milestone.Type__c =='Design Finalization' || milestone.Type__c =='Design Sign-off from Customer' || milestone.Type__c=='Factory Dispatch'){
                    if(milestone.Complete__c != true && milestone.Invoices_Count__c != Null && milestone.Invoices_Count__c != 0  ){
                        newValues.get(milestone.Project__c).Amount__c.addError(system.label.Payment_milestone_Validation);
                        
                    }
                    
                }
                if(milestone.Type__c=='Factory Dispatch' && milestone.Complete__c == true){
                    newValues.get(milestone.Project__c).Amount__c.addError(system.label.Project_value_change_for_Factory_Dispatch);
                }
                
            }
            
        }
    }
}