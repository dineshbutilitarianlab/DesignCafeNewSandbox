public class RevisitSharingOnProjectCls {
	@AuraEnabled
    public static void sharingOnProjectforDesigner(String projID){
        List<Milestone1_Project__c> listOfProjects = [select id,name,Project_Number__c,Design_Team_Name__c from Milestone1_Project__c where id =: projID];
        ProjectTriggerHandler.createPublicGroup(listOfProjects);
        ProjectTriggerHandler.shareRecordWithTeam(listOfProjects);
    }
    
    
    @AuraEnabled
    public static void deleteOldTLGroup(String projID){
         List<Milestone1_Project__c> listOfProjects = [select id,name,Project_Number__c,Design_Team_Name__c from Milestone1_Project__c where id =: projID];
         SET<String> oldGroupId = new SET<String>();
         
         for(Group groupOb : [SELECT id, Name FROM Group WHERE Name Like '%-TL']) {
             oldGroupId.add(groupOb.id);
            /* for( GroupMember gpMem : [SELECT UserOrGroupId FROM GroupMember WHERE Group.Name =: 'PRJ-'+listOfProjects[0].Project_Number__c]){
                 if(gpMem.UserOrGroupId == groupOb.Id) {
                     delete gpMem;
                 }
             }*/
        }        
        system.debug(oldGroupId);
        List<Milestone1_Project__Share> milprojectShareList = [SELECT id,parentId,UserOrGroupId,UserOrGroup.Name FROM Milestone1_Project__Share WHERE UserOrGroupId IN: oldGroupId and parentID=:projID ];
        
        if(milprojectShareList.size() > 0) {
            system.debug('$$$$$ : '+milprojectShareList[0].UserOrGroup.Name);
            delete milprojectShareList;
        }
    }
}