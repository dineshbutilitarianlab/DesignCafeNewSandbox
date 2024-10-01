public without sharing class ProjectTriggerHandler {
  public static Boolean isFirstTime = true;
    
    public static void  createPublicGroup(List<Milestone1_Project__c> listOfProjects) {
        List<Group> ListOfGroupToBeInserted = New List<Group>();
        Map<String,Id> mapOfGroupNameProjectId = New Map<String,Id>();
        List<Milestone1_Project__Share> listOfProjectShare = New List<Milestone1_Project__Share>();
        
        For(Milestone1_Project__c projectObj:listOfProjects) {
            If(projectObj.Project_Number__c!=Null) {
                mapOfGroupNameProjectId.put('PRJ-'+projectObj.Project_Number__c,projectObj.Id);
                Group newGroup = new Group();
                newGroup.Name = 'PRJ-'+projectObj.Project_Number__c;
                newGroup.developerName = 'PRJ_'+projectObj.Project_Number__c.replace('-','_');
                ListOfGroupToBeInserted.add(newGroup);
            }
        }
        
        Database.insert(ListOfGroupToBeInserted,False);
        
        For(group groupOb:[Select id,name from group where name in :mapOfGroupNameProjectId.keyset()]) {
            IF(mapOfGroupNameProjectId.containskey(groupOb.name)) {
                Milestone1_Project__Share milestoneProjectObject = New Milestone1_Project__Share();
                milestoneProjectObject.UserOrGroupId = groupOb.Id;
                milestoneProjectObject.AccessLevel ='Edit';
                milestoneProjectObject.RowCause = Schema.Milestone1_Project__Share.RowCause.CustonSharing__c;
                milestoneProjectObject.ParentId = mapOfGroupNameProjectId.get(groupOb.name);
                listOfProjectShare.add(milestoneProjectObject);
            }
        }
        
        IF(listOfProjectShare.size()>0) {
            list<Database.SaveResult> sr = Database.insert(listOfProjectShare,false);
            system.debug(sr);
        }
    }
    
    //update Design_Team_Name on Project insert.
    public static void  updateDesignTeam(List<Milestone1_Project__c> listOfProjects,map<id,Milestone1_Project__c> oldMap){
        Set<Id> setOfOwnerId=new Set<Id> ();
        map<String,String> mapOfUserTeam=new map<String,String>();
        List<Milestone1_Project__c> listOfProjectUpdate = New List<Milestone1_Project__c>();
        
        For(Milestone1_Project__c projectObj: listOfProjects){
            if(projectObj.OwnerId !=oldMap.get(projectObj.id).OwnerId){
                setOfOwnerId.add(projectObj.OwnerId);
            }     
        }
        if(setOfOwnerId.size() > 0) {
            for(User usrObj:[select id,Team__c from User where id in:setOfOwnerId]){
                mapOfUserTeam.put(usrObj.id,usrObj.Team__c);
            }           
            for(Milestone1_Project__c projectObj :listOfProjects){             
                projectObj.Design_Team_Name__c=mapOfUserTeam.get(projectObj.OwnerId) ;
            }
        }
    }
    
    // share Project Record With Team Group when project insert 
    public static void  shareRecordWithTeam(List<Milestone1_Project__c> listOfProjects){    
        List<String> ListOfTeam = New List<String>();
        Map<String,Id> mapOfGroupNameProjectId = New Map<String,Id>();
        List<Milestone1_Project__Share> listOfProjectShare = New List<Milestone1_Project__Share>();
        
        for(Milestone1_Project__c projectObj : listOfProjects) {
            if(projectObj.Design_Team_Name__c != null){
                for(String str : projectObj.Design_Team_Name__c.split(',')) {
                    str = str.trim();
                    ListOfTeam.add( 'PRJ-' + str + '-TL');
                    mapOfGroupNameProjectId.put('PRJ-' + str + '-TL', projectObj.id);
                }
            }
        }
        
        if(ListOfTeam.size() > 0) {
            for(Group groupOb : [SELECT id, Name FROM Group WHERE Name IN:ListOfTeam]) {
                if(mapOfGroupNameProjectId.containskey(groupOb.name)) {
                    Milestone1_Project__Share milestoneProjectObject = New Milestone1_Project__Share();
                    milestoneProjectObject.UserOrGroupId = groupOb.Id;
                    milestoneProjectObject.AccessLevel ='Edit';
                    milestoneProjectObject.RowCause = Schema.Milestone1_Project__Share.RowCause.CustonSharing__c;
                    milestoneProjectObject.ParentId = mapOfGroupNameProjectId.get(groupOb.name);
                    listOfProjectShare.add(milestoneProjectObject);
                }
            }
            
            if(listOfProjectShare.size() > 0) {
                Database.insert(listOfProjectShare,False);
            }
        }
    }
    
    // share Project Record With Team Group when project owner Update.  
    public static void  shareRecordWithTeamUpdate(List<Milestone1_Project__c> listOfProjects,map<id,Milestone1_Project__c> oldMap){
    system.debug('INNN'+listOfProjects);    
        Set<Id> oldGroupId=new  Set<Id> ();
        List<String> ListOfTeam = New List<String>();
        List<String> ListOfTeamOld = New List<String>();
        LIST<String> listOfOldUserIds = new LIST<String>();
        Map<String, Id> mapOfGroupNameProjectId = New Map<String,Id>();
        List<Milestone1_Project__Share> listOfProjectShare = New List<Milestone1_Project__Share>();
        
        for(Milestone1_Project__c projectObj : listOfProjects) {
            if(projectObj.Design_Team_Name__c != null && projectObj.OwnerId != oldMap.get(projectObj.id).OwnerId) {
                for(String str : projectObj.Design_Team_Name__c.split(',')) {
                    ListOfTeam.add( 'PRJ-' + str + '-TL');
                    mapOfGroupNameProjectId.put('PRJ-' + str + '-TL', projectObj.id);
                    system.debug(mapOfGroupNameProjectId);
                }
                
                listOfOldUserIds.add(oldMap.get(projectObj.id).OwnerId);
                
                //system.debug(oldMap.get(projectObj.id));
                // if(oldMap.get(projectObj.id).Design_Team_Name__c != null) {
                //     for(String str : oldMap.get(projectObj.id).Design_Team_Name__c.split(',')) {
                //         ListOfTeamOld.add( 'PRJ-' + str + '-TL');
                        
                //     }
                // }
                // system.debug(ListOfTeamOld);
            }
        }
        system.debug(listOfOldUserIds);
        
        LIST<User> lstOldUsers = [select id,name,Team__c from User where id IN: listOfOldUserIds];
        if(lstOldUsers  != null){
            for(User eachUser : lstOldUsers){
                if(eachUser.Team__c != null){
                    for(String str : eachUser.Team__c.split(',')) {
                        ListOfTeamOld.add( 'PRJ-' + str + '-TL');
                    }
                }
            }
        }
        
        if(ListOfTeam.size() > 0) {
            for(Group groupOb : [SELECT id, Name FROM Group WHERE name IN:ListOfTeam]) {
                if(mapOfGroupNameProjectId.containskey(groupOb.name)) {
                    Milestone1_Project__Share milestoneProjectObject = new Milestone1_Project__Share();
                    milestoneProjectObject.UserOrGroupId = groupOb.Id;
                    milestoneProjectObject.AccessLevel ='Edit';
                    milestoneProjectObject.RowCause = Schema.Milestone1_Project__Share.RowCause.CustonSharing__c;
                    milestoneProjectObject.ParentId = mapOfGroupNameProjectId.get(groupOb.name);
                    listOfProjectShare.add(milestoneProjectObject);
                }
            }
            
            if(listOfProjectShare.size() > 0) {
                Database.insert(listOfProjectShare, false);
            }
        }
        
        if(ListOfTeamOld.size() > 0) {
            for(Group groupOb : [SELECT id, Name FROM Group WHERE Name IN:ListOfTeamOld]) {
                oldGroupId.add(groupOb.id);
            }
            
            List<Milestone1_Project__Share> milprojectShareList = [SELECT id FROM Milestone1_Project__Share WHERE UserOrGroupId IN:oldGroupId];
           
            if(milprojectShareList.size() > 0) {
                system.debug('$$$$$ : '+milprojectShareList);
                delete milprojectShareList;
            }
        }
    }
    
    // Link Virtual Account Numbers on Project insert.
    public static void  linkVANwithProject(List<Milestone1_Project__c> listOfProjects) { 
        Set<Id> setOfVANId = new Set<Id>(); 
        List<Virtual_Account_Number__c> ListOfVANObject=[SELECT id FROM Virtual_Account_Number__c WHERE Status__c='Available' ORDER BY CreatedDate DESC limit 1];        
        
        if(ListOfVANObject.size() == 0) {
            return;
        }
        
        List<Milestone1_Project__c> existingProjectVANList = [SELECT Id, Virtual_Account_Number__c FROM Milestone1_Project__c Where Virtual_Account_Number__c IN:ListOfVANObject];
        
        for(Milestone1_Project__c milProObj : listOfProjects) {
            if(existingProjectVANList.size() > 0) {
                // milProObj.adderror('Duplicate VAN found');
            }
            else {
                milProObj.Virtual_Account_Number__c=ListOfVANObject[0].Id ;          
            }
        }
    }
    
    // Update Virtual Account Numbers Status.
    public static void  updateVANStatus(List<Milestone1_Project__c> listOfProjects) { 
        Set<Id> setOfVANId=new Set<Id>();
        List<Virtual_Account_Number__c>  listOfVanUpdate=new  List<Virtual_Account_Number__c>();
        
        for(Milestone1_Project__c milProObj : listOfProjects) {
            if(milProObj.Virtual_Account_Number__c != null) {
                setOfVANId.add(milProObj.Virtual_Account_Number__c);
            }
        }
        
        for(Virtual_Account_Number__c vanObj : [Select id from Virtual_Account_Number__c where id in:setOfVANId]) {
            Virtual_Account_Number__c van=new Virtual_Account_Number__c();
            van.id = vanObj.id;
            van.Status__c='Assigned to Project';
            listOfVanUpdate.add(van);
        }
        
        if(listOfVanUpdate.size() > 0) {
            update listOfVanUpdate;
        }
    }
    
    public static void  updateSchedulesSection(List<Milestone1_Project__c> listOfProjects, Map<id, Milestone1_Project__c> oldMap) { 
        Set<Id> setOfProjectId = new Set<Id>();
        List<Milestone1_Milestone__c> updateMilstoneList = new List<Milestone1_Milestone__c>();
        
        if(ProjectTriggerRecursiveHandler.isFirstTime) {
            ProjectTriggerRecursiveHandler.isFirstTime = Test.isRunningTest() ? true : false;
            
            for(Milestone1_Project__c lProject : listOfProjects) {
                Integer scheduleChangeCount = 0;
                Milestone1_Project__c lOldProj = oldMap.get(lProject.id);
                
                if(lOldProj.Survey_Date__c != lProject.Survey_Date__c) {
                    scheduleChangeCount++;
                }
                
                if(lOldProj.KYC_Date__c != lProject.KYC_Date__c) { 
                    scheduleChangeCount++;
                }
                
                if(lOldProj.First_Cut_Presentation_Date__c != lProject.First_Cut_Presentation_Date__c) {
                    scheduleChangeCount++;
                }
                
                if(lOldProj.X3D_Presentation_Date__c != lProject.X3D_Presentation_Date__c) {
                    scheduleChangeCount++;
                }
                
                if(lOldProj.Kickoff_Meeting_Date__c != lProject.Kickoff_Meeting_Date__c) {
                    scheduleChangeCount++;
                }
                
                if(lOldProj.Design_Finalization_Date__c != lProject.Design_Finalization_Date__c) {
                    scheduleChangeCount++;
                }
                
                if(scheduleChangeCount > 0) {
                    setOfProjectId.add(lProject.id);
                }
            }
            
            if(setOfProjectId.size() == 0) {
                return;
            }
            
            Milestone1_Milestone__c [] lMilestones = [SELECT Id, Project__c, Project__r.Survey_Date__c,Project__r.KYC_Date__c, Project__r.First_Cut_Presentation_Date__c,
                                                        Project__r.X3D_Presentation_Date__c, Project__r.Kickoff_Meeting_Date__c, Project__r.Design_Finalization_Date__c,
                                                        Deadline__c, Type__c, Order__c FROM Milestone1_Milestone__c WHERE Project__c IN:setOfProjectId ORDER BY Order__c ASC]; 
            
            for(Milestone1_Milestone__c milstObj : lMilestones) {
                Milestone1_Project__c lOldProject = oldMap.get(milstObj.Project__c);
                
                if(milstObj.Project__r.Survey_Date__c != lOldProject.Survey_Date__c && 
                   milstObj.Project__r.Survey_Date__c > milstObj.Deadline__c && milstObj.Type__c== 'Site Survey') {
                       updateMilstoneList.add(new Milestone1_Milestone__c(id = milstObj.id, Deadline__c = Date.valueOf(milstObj.Project__r.Survey_Date__c)));
                   }
                else if(milstObj.Project__r.KYC_Date__c != lOldProject.KYC_Date__c && 
                        milstObj.Project__r.KYC_Date__c > milstObj.Deadline__c && 
                        milstObj.Type__c == 'KYC') {
                            updateMilstoneList.add(new Milestone1_Milestone__c(id = milstObj.id, Deadline__c = Date.valueOf(milstObj.Project__r.KYC_Date__c)));
                        }
                else if(milstObj.Project__r.First_Cut_Presentation_Date__c != lOldProject.First_Cut_Presentation_Date__c && 
                        milstObj.Project__r.First_Cut_Presentation_Date__c > milstObj.Deadline__c && milstObj.Type__c == 'First Cut Presentation') {
                            updateMilstoneList.add(new Milestone1_Milestone__c(id = milstObj.id, Deadline__c = Date.valueOf(milstObj.Project__r.First_Cut_Presentation_Date__c)));
                        }
                else if(milstObj.Project__r.X3D_Presentation_Date__c != lOldProject.X3D_Presentation_Date__c && 
                        milstObj.Project__r.X3D_Presentation_Date__c > milstObj.Deadline__c && milstObj.Type__c == '3D Presentation') {
                            updateMilstoneList.add(new Milestone1_Milestone__c(id = milstObj.id, Deadline__c = Date.valueOf(milstObj.Project__r.X3D_Presentation_Date__c)));
                        }
                else if(milstObj.Project__r.Kickoff_Meeting_Date__c != lOldProject.Kickoff_Meeting_Date__c && 
                        milstObj.Project__r.Kickoff_Meeting_Date__c > milstObj.Deadline__c && milstObj.Type__c == 'Kickoff Meeting with PM') {
                            updateMilstoneList.add(new Milestone1_Milestone__c(id = milstObj.id, Deadline__c = Date.valueOf(milstObj.Project__r.Kickoff_Meeting_Date__c)));
                        }
                else if(milstObj.Project__r.Design_Finalization_Date__c != lOldProject.Design_Finalization_Date__c && 
                        milstObj.Project__r.Design_Finalization_Date__c > milstObj.Deadline__c && milstObj.Type__c == 'Design Finalization') {
                            updateMilstoneList.add(new Milestone1_Milestone__c(id = milstObj.id, Deadline__c = Date.valueOf(milstObj.Project__r.Design_Finalization_Date__c)));
                        }
            }
            
            if(updateMilstoneList.size() > 0) {
                update updateMilstoneList;
            }
        }
    }
    
    public static void  updateOldFieldValues(List<Milestone1_Project__c> listOfProjects, Map<id, Milestone1_Project__c> newMap, Map<id, Milestone1_Project__c> oldMap) {               for(Milestone1_Project__c singleproject :listOfProjects ){            if(newMap.get(singleproject.Id).X3D_Presentation_Date__c!=NULL && newMap.get(singleproject.Id).X3D_Presentation_Date__c!=oldMap.get(singleproject.Id).X3D_Presentation_Date__c){                singleproject.Old_3D_Presentation_Date__c=oldMap.get(singleproject.Id).X3D_Presentation_Date__c;            }
            if(newMap.get(singleproject.Id).Design_Finalization_Date__c != NULL && 
               newMap.get(singleproject.Id).Design_Finalization_Date__c != oldMap.get(singleproject.Id).Design_Finalization_Date__c) {
                   singleproject.Old_Design_Finalization_Date__c = oldMap.get(singleproject.Id).Design_Finalization_Date__c;
               }

            if(newMap.get(singleproject.Id).First_Cut_Presentation_Date__c != NULL && 
               newMap.get(singleproject.Id).First_Cut_Presentation_Date__c != oldMap.get(singleproject.Id).First_Cut_Presentation_Date__c) {
                   singleproject.Old_First_Cut_Presentation_Date__c=oldMap.get(singleproject.Id).First_Cut_Presentation_Date__c;
               }

            if(newMap.get(singleproject.Id).Kickoff_Meeting_Date__c != NULL && 
               newMap.get(singleproject.Id).Kickoff_Meeting_Date__c != oldMap.get(singleproject.Id).Kickoff_Meeting_Date__c) {
                   singleproject.Old_Kickoff_Meeting_Date__c = oldMap.get(singleproject.Id).Kickoff_Meeting_Date__c;
               }

            if(newMap.get(singleproject.Id).KYC_Date__c != NULL && newMap.get(singleproject.Id).KYC_Date__c != oldMap.get(singleproject.Id).KYC_Date__c) {
                singleproject.Old_KYC_Date__c=oldMap.get(singleproject.Id).KYC_Date__c;
            }

            if(newMap.get(singleproject.Id).Survey_Date__c != NULL && newMap.get(singleproject.Id).Survey_Date__c != oldMap.get(singleproject.Id).Survey_Date__c) {
                singleproject.Old_Survey_Date__c=oldMap.get(singleproject.Id).Survey_Date__c;
            }
        }
    }
}