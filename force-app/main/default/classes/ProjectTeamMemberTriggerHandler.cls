//TODO: Comments need to be updated 
public Without Sharing class ProjectTeamMemberTriggerHandler {
    
    //add By Jai Kumar
    public static void handlePTMInsertUpdateManagerCustomer(List<Project_Team_Member__c> tms){ 
        ProjectTeamMemberHandler.updateManagerAndCustomerOnPTMInsert(tms);
    }
    public static void handlePTMUpdateManagerCustomer(List<Project_Team_Member__c> tms,Map<Id,Project_Team_Member__c> objPtmMap){ 
        ProjectTeamMemberHandler.updateManagerAndCustomerOnPTMUpdate(tms,objPtmMap);
    }
    public static void handleUpdateCHMonProjectPTMInsert(List<Project_Team_Member__c> tms){ 
        ProjectTeamMemberHandler.updateCHMonProjectPTMInsert(tms);
    }
    public static void handleUpdateCHMonProjectPTMUpdate(List<Project_Team_Member__c> tms,Map<Id,Project_Team_Member__c> objPtmMap){ 
        ProjectTeamMemberHandler.updateCHMonProjectPTMUpdate(tms,objPtmMap);
    }
    public static void handleShareRecorddefaultProjectGroup(List<Project_Team_Member__c> tms){ 
        ProjectTeamMemberHandler.shareRecorddefaultProjectGroup(tms);
    }
    public static void handleshareRecordDefaultProjectGroupUpdate(List<Project_Team_Member__c> tms,Map<Id,Project_Team_Member__c> objPtmMap){ 
        ProjectTeamMemberHandler.shareRecordDefaultProjectGroupUpdate(tms,objPtmMap);
    }
    
    public static void handlePTMInsertTrigger( List<Project_Team_Member__c> tms){ 
        //UpdateTask(tms);
        //UpdateMileStoneOwner(tms);
        updateDesignerOnProject(tms);
        
    }   
    
    public static void handlePTMUpsertTrigger( List<Project_Team_Member__c> tms){ 
        //UpdateTask(tms);
        // UpdateMileStoneOwner(tms);
        updateDesignerOnProject(tms);
    }
    
    public static void UpdateMileStoneOwner(List<Project_Team_Member__c> tms){
        
        Set<ID> projIds = new Set<ID>();
        for(Project_Team_Member__c tm : tms)
        {
            projIds.add(tm.Project__c);   
        }
        
        
        if(projIds!= null && projIds.size()>0){
            List<Milestone1_Milestone__c> projectActivity = [select id,Assign_To__c,Project__c,Assign_To_Role__c from Milestone1_Milestone__c where Project__c IN : projIds];
            List<Milestone1_Milestone__c> projectActivityUpdate = new List<Milestone1_Milestone__c>();
            System.debug('projectActivity>>'+projectActivity);
            
            if(projectActivity!= null && projectActivity.size()>0){
                for(Project_Team_Member__c tm : tms){
                    for(Milestone1_Milestone__c taskRec : projectActivity)  
                    {
                        if(taskRec.Project__c == tm.Project__c && taskRec.Assign_To_Role__c == tm.Role__c){
                            taskRec.Assign_To__c = tm.User__c;   
                            projectActivityUpdate.add(taskRec);
                        }
                    } 
                    
                    
                }
                System.debug('projectActivityUpdate--'+projectActivityUpdate);
                Update projectActivityUpdate;
                System.debug('projectActivityUpdateAfter--'+projectActivityUpdate);
            }
            
        }
    }
    /*static void UpdateTask(List<Project_Team_Member__c> tms){

Set<ID> projIds = new Set<ID>();
for(Project_Team_Member__c tm : tms)
projIds.add(tm.Project__c);            

System.debug('projIds>>'+projIds);

if(projIds!= null && projIds.size()>0){
List<Milestone1_Task__c> Tasks = [select id, Assigned_To_Role__c,Project_Milestone__r.Project__c, Assigned_To__c from Milestone1_Task__c where Project_Milestone__r.Project__c IN : projIds];

System.debug('TasksIDS>>'+Tasks);

if(Tasks!= null && Tasks.size()>0)
for(Project_Team_Member__c tm : tms)
for(Milestone1_Task__c task : Tasks)  
//What if Task is already assigned to Someone.
if(task.Project_Milestone__r.Project__c == tm.Project__c && task.Assigned_To_Role__c == tm.Role__c)
task.Assigned_To__c = tm.User__c;             

Update Tasks;
}
}  */
    
    
    //--
    static void updateDesignerOnProject(List<Project_Team_Member__c> tms){
        /*    Map<ID , Id> projIdToDesignerMap = new Map<ID , Id> ();

MAP<String,String> mapOfProjectToRoleAssignmentCheckFields = new MAP<String,String>(); // < Role On PTM , Project Field API > 
mapOfProjectToRoleAssignmentCheckFields.put('3D Designer' , 'X3D_Designer_Assigned__c' );
mapOfProjectToRoleAssignmentCheckFields.put( 'Project Manager' , 'Project_Manager_Assigned__c' );

MAP<Id, List<String>> projToAssgnCheckMap = new  MAP<Id, List<String>>(); 
LIST<String> lstOfFieldsToCheck = new LIST<String>();
SET<STring> allProjectIds = new SET<String>();
for(Project_Team_Member__c tm : tms){
if(tm.Role__c == 'Primary Designer'){
projIdToDesignerMap.put(tm.Project__c , tm.User__c);
}
allProjectIds.add(tm.Project__c);
for(String eachRole : mapOfProjectToRoleAssignmentCheckFields.keySet()){
if(tm.Role__c == eachRole){
lstOfFieldsToCheck = new LIST<String>();
if(projToAssgnCheckMap.containskey(tm.Project__c) && projToAssgnCheckMap.get(tm.Project__c) != null){ 
lstOfFieldsToCheck = projToAssgnCheckMap.get(tm.Project__c);
}
lstOfFieldsToCheck.add(mapOfProjectToRoleAssignmentCheckFields.get(eachRole));
projToAssgnCheckMap.put(tm.Project__c ,lstOfFieldsToCheck );
}
}
}

system.debug(projToAssgnCheckMap);
if(allProjectIds != null && allProjectIds.size() > 0 ){

MAP<Id,User> allUsersMap = new MAP<Id,User>([select id,name,Team__c,UserRoleName__c from User where id IN: projIdToDesignerMap.values()]);
LIST<Milestone1_Project__c> allProjects = [select id,name,Designer__c,Designer_Team__c,Design_Team_Name__c,X3D_Designer_Assigned__c,Is_Project_Good_for_Construction__c,Project_Manager_Assigned__c from Milestone1_Project__c where id IN: allProjectIds];

for(Milestone1_Project__c each : allProjects){
if(projIdToDesignerMap != null && projIdToDesignerMap.containsKey(each.Id) && projIdToDesignerMap.get(each.Id) != null ){ 
each.Designer__c          = projIdToDesignerMap.get(each.Id);
each.Designer_Team__c     = String.valueOf(allUsersMap.get(projIdToDesignerMap.get(each.Id)).Team__c);
each.Design_Team_Name__c  = String.valueOf(allUsersMap.get(projIdToDesignerMap.get(each.Id)).Team__c);
}

system.debug('INNNN');
if(projToAssgnCheckMap.containskey(each.Id) && projToAssgnCheckMap.get(each.Id) != null){
for(String eachFieldToCheck : projToAssgnCheckMap.get(each.Id)){
system.debug('eachFieldToCheck-->'+eachFieldToCheck);
each.put(eachFieldToCheck , true);
}
}
}
system.debug(allProjects);
update allProjects;
} */
    } 
    
    
    public class ProjectToAssignmentCheckWrapper{
        public String fieldAPI;
        public Boolean checkBoxValue;
        
        public ProjectToAssignmentCheckWrapper(String fieldAPI , Boolean checkBoxValue){
            this.fieldAPI           = fieldAPI;
            this.checkBoxValue      = checkBoxValue;
        }
        
    }
    @Future
    // Access to Sharing Rules to Team members
    public static void projectSharingMethod(Set<Id> tmsIds){
        List<Project_Team_Member__c> tms = [Select Id,Project_Group_Name__c,Role__c,User__c from Project_Team_Member__c 
                                            where Id in :tmsIds];
        Set<String> projectNumberSet = New Set<String>();
        Map<String,Group> mapOfGroup = New Map<String,Group>();
        List<GroupMember> listOfGroupMembers = New List<GroupMember>();
        Set<String> groupNameset = New Set<String>();
        Set<Id> setOfPrimarydesigners = New Set<Id>();
        For(Project_Team_Member__c projectTeamObj:tms){
            projectNumberSet.add(projectTeamObj.Project_Group_Name__c);
            If(projectTeamObj.Role__c.equalsIgnoreCase('Primary Designer')){
                setOfPrimarydesigners.add(projectTeamObj.User__c);
            }
        }
        For(User userObj:[Select id,region__c,team__c from user where id in :setOfPrimarydesigners]){
            IF(userObj.region__c!=Null){
                groupNameset.addall(userObj.region__c.split(';'));
            }
            IF(userObj.team__c!=Null){
                groupNameset.addall(userObj.team__c.split(';'));
            }
        }
        For(Group groupObj:[Select Id,Name from group where name in : projectNumberSet or name in :groupNameset]){
            mapOfGroup.put(groupObj.Name,groupObj);
        }
        System.debug('mapOfGroup'+mapOfGroup);
        For(Project_Team_Member__c projectTeamObj:tms){
            System.debug('projectTeamObj.Project_Group_Name__c'+projectTeamObj.Project_Group_Name__c);
            If(mapOfGroup.containskey(projectTeamObj.Project_Group_Name__c)){
                GroupMember groupMemberObj = New GroupMember();
                groupMemberObj.GroupId = mapOfGroup.get(projectTeamObj.Project_Group_Name__c).Id;
                groupMemberObj.UserOrGroupId = projectTeamObj.User__c;
                listOfGroupMembers.add(groupMemberObj);
            }
            For(String groupName:groupNameset){
                If(mapOfGroup.containskey(projectTeamObj.Project_Group_Name__c) && mapOfGroup.containskey(groupName)){
                    GroupMember groupMemberObj = New GroupMember();
                    groupMemberObj.GroupId = mapOfGroup.get(projectTeamObj.Project_Group_Name__c).id;
                    groupMemberObj.UserOrGroupId = mapOfGroup.get(groupName).Id;
                    listOfGroupMembers.add(groupMemberObj);
                } 
            }
        }
        IF(listOfGroupMembers.size()>0){
            System.debug('listOfGroupMembers'+listOfGroupMembers);
            database.saveresult[] sv =Database.insert(listOfGroupMembers,false);
            System.debug('sv'+sv);
        }
        
    }
    
    // There can be only one primary Designer 
    public static void onlyPrimaryDesigner(List<Project_Team_Member__c> tms){
        Set<Id> projectIdSet = New Set<Id>();
        For(Project_Team_Member__c objTeamMem:tms){
            projectIdSet.add(objTeamMem.Project__c);
        }
        Map<Id,Milestone1_Project__c> mapOfProjectandTeamMembers = New Map<Id,Milestone1_Project__c>([Select id,(Select Id from Project_Team_Members__r where Role__c='Primary Designer') 
                                                                                                      from Milestone1_Project__c where id in :projectIdSet]);
        For(Project_Team_Member__c oTeamMem:tms){
            If(oTeamMem.Role__c.equalsIgnoreCase('Designer')){
                IF(mapOfProjectandTeamMembers.containskey(oTeamMem.Project__c) && mapOfProjectandTeamMembers.get(oTeamMem.Project__c).Project_Team_Members__r.size()==0){
                    oTeamMem.addError('Project Needs to have a Primary Designer');
                }
            }
            If(oTeamMem.Role__c.equalsIgnoreCase('Primary Designer')){
                IF(mapOfProjectandTeamMembers.containskey(oTeamMem.Project__c) && mapOfProjectandTeamMembers.get(oTeamMem.Project__c).Project_Team_Members__r.size()>1){
                    oTeamMem.addError('Project can have only one Primary Designer');
                }
            }
        }    
        
    }
    //Update project 
    public static void updateAssigedDesinerOnproject(Map<Id,Project_Team_Member__c> newtms,Map<Id,Project_Team_Member__c> oldtms){
        Set<Id> projectId = new Set<Id>();
        Map<Id,Id> pTmToproject = new  Map<Id,Id>();
        List<Milestone1_Project__c> prjToUpdate = new List<Milestone1_Project__c>();
        
        For(Project_Team_Member__c ptm : newtms.values()) {
            projectId.add(ptm.Project__c);
            pTmToproject.put(ptm.id,ptm.Project__c);
        }
        
        Map<Id,Milestone1_Project__c> projectMap= new Map<Id,Milestone1_Project__c>([SELECT id, Is_Designer_Assigned__c, Survey_Status__c
                                                                                     FROM Milestone1_Project__c where id IN:projectId]);
        
        for(Project_Team_Member__c ptm : newtms.values()) {
            Milestone1_Project__c projectrec= new Milestone1_Project__c();
            
            if(oldtms.get(ptm.id).user__c != ptm.user__c) {
                if(ptm.Role__c == 'Primary Designer' && projectMap.get(pTmToproject.get(ptm.id)).Is_Designer_Assigned__c == 'No') {
                    projectrec.id= pTmToproject.get(ptm.id);
                    projectrec.Is_Designer_Assigned__c ='Yes';
                    prjToUpdate.add(projectrec); 
                }
                else if(ptm.Role__c =='Survey Manager' && projectrec.Survey_Status__c == 'Survey Executive Assignment Pending') {
                    projectrec.id= pTmToproject.get(ptm.id);
                    projectrec.Survey_Status__c ='Survey Executive Assigned, Survey Due for Completion';
                    prjToUpdate.add(projectrec);
                }
            }
        }
        
        if(prjToUpdate.size() > 0) {
            update prjToUpdate;
        }
    }
    
    public static void update3dAndPMDesinerOnproject(Map<Id, Project_Team_Member__c> newtms) {
        Map<ID, Milestone1_Project__c> prjToUpdateMap = new Map<ID, Milestone1_Project__c>();
        
        for(Project_Team_Member__c ptm : newtms.values()) {
            Milestone1_Project__c projectrec = prjToUpdateMap.get(ptm.Project__c);
            
            if(projectrec == null) {
                projectrec = new Milestone1_Project__c(id=ptm.Project__c);
            }
            
            if(ptm.user__c != null) {
                if(ptm.Role__c =='3D Designer') {
                    projectrec.X3D_Designer_Assigned__c = 'Yes';
                    prjToUpdateMap.put(projectrec.id, projectrec);
                }
                
                if(ptm.Role__c =='3D Shell Designer') {
                    projectrec.X3D_Shell_Designer_Assigned__c = 'Yes';
                    prjToUpdateMap.put(projectrec.id, projectrec);
                }
                
                if(ptm.Role__c =='Project Manager') {
                    projectrec.Project_Manager_Assigned__c = 'Yes';
                    prjToUpdateMap.put(projectrec.id, projectrec);
                }
                
                if(ptm.Role__c =='Survey Manager') {
                    projectrec.Survey_Status__c = 'Survey Executive Assigned, Survey Due for Completion';
                    prjToUpdateMap.put(projectrec.id, projectrec);
                }
            }
        }
        
        if(prjToUpdateMap.size() > 0) {
            update prjToUpdateMap.values();
        }
    }
    
    public static void updateCHMandDesignerEmail(List<Project_Team_Member__c> listoftm) {
        system.debug('inside chm insert'+listoftm);
        set<Id> userIds = new set<Id>();
        for(Project_Team_Member__c teamMember : listoftm){
            if(teamMember != Null){
                userIds.add(teamMember.User__c); 
                
            }
            
        }
        system.debug('projectids-->>'+userIds);
        map<Id, User> mapofuser = new map<Id, User>([select id, Email from User where id IN : userIds]);
        system.debug('mapofproject-->>'+mapofuser);
        for(Project_Team_Member__c singleteamMember : listoftm){
            system.debug('INSIDE FOR');
            if(singleteamMember.User__c !=Null && mapofuser.containsKey(singleteamMember.User__c) && mapofuser.get(singleteamMember.User__c).email != Null ){
                system.debug('INSIDE IF');
                if(singleteamMember.Role__c == 'Primary Designer'){
                    singleteamMember.Designer_Email__c = mapofuser.get(singleteamMember.User__c).email;
                    system.debug('Designer_Email__c' +singleteamMember.Designer_Email__c );
                    
                }
                else if(singleteamMember.Role__c == 'Customer Happiness Manager'){
                    singleteamMember.CHM_Email__c = mapofuser.get(singleteamMember.User__c).email; 
                    system.debug('CHM_Email__c' +singleteamMember.CHM_Email__c);
                }
            }
        }
        
    }
    
    public static void updateCHMandDesignerEmailupdate(List<Project_Team_Member__c> listoftm, map<id,Project_Team_Member__c> newValues , map<id,Project_Team_Member__c> oldValues ) {
        set<Id> userIds = new set<Id>();
        for(Project_Team_Member__c teamMember : listoftm){
            if(teamMember != Null){
                userIds.add(teamMember.User__c); 
                
            }
            
        }
        map<Id, User> mapofuser = new map<Id, User>([select id, Email from User where id IN : userIds]);
        system.debug('mapofproject-->>'+mapofuser);
        for(Project_Team_Member__c singleteamMember : listoftm){
            system.debug('INSIDE FOR');
            if(newValues.get(singleteamMember.Id).user__c != oldValues.get(singleteamMember.Id).user__c){
                if(singleteamMember.User__c !=Null && mapofuser.containsKey(singleteamMember.User__c) && mapofuser.get(singleteamMember.User__c).email != Null ){
                    system.debug('INSIDE IF');
                    if(singleteamMember.Role__c == 'Primary Designer'){
                        singleteamMember.Designer_Email__c = mapofuser.get(singleteamMember.User__c).email;
                        system.debug('Designer_Email__c' +singleteamMember.Designer_Email__c );
                        
                    }
                    else if(singleteamMember.Role__c == 'Customer Happiness Manager'){
                        singleteamMember.CHM_Email__c = mapofuser.get(singleteamMember.User__c).email; 
                        system.debug('CHM_Email__c' +singleteamMember.CHM_Email__c);
                    }
                }
            }
        }
    }
    
}