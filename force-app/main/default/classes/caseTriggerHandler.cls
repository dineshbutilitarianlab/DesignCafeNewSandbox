public class caseTriggerHandler {
    public static void shareCaseWith(List<case> newCases) {
        set<Id> projIds = new set<Id>();
        for(case singleCase :newCases) {
            projIds.add(singleCase.Project__c);
        }
        
        Map<Id, List<Project_Team_Member__c>> mapofIdandTeamMember = new Map<Id, List <Project_Team_Member__c>>();
        List<Project_Team_Member__c> listofteamMembers= new List<Project_Team_Member__c>([SELECT Id,User__c, Role__c,Project__c FROM Project_Team_Member__c
                                                                                          WHERE ( Role__c='Primary Designer' OR Role__c='Customer Happiness Manager')
                                                                                          AND Project__c IN:projIds]);
        
        for(Project_Team_Member__c teammembers : listofteamMembers) {
            if(mapofIdandTeamMember.containsKey(teammembers.Project__c)) {
                mapofIdandTeamMember.get(teammembers.Project__c).add(teammembers);
            }
            else {
                List<Project_Team_Member__c> tempList = new List<Project_Team_Member__c>();
                tempList.add(teammembers);
                mapofIdandTeamMember.put(teammembers.Project__c,tempList);
            }
        }
        
        Map<String, Id> caseTeamRoleMap= new Map<String, Id>();
        
        for(CaseTeamRole singleRole : [SELECT Id, Name FROM CaseTeamRole]) {
            caseTeamRoleMap.put(singleRole.Name,SingleRole.Id);
        }
        
        List<CaseTeamMember> listOfMembersNeedTOBeAdded= new List<CaseTeamMember>();
        
        for(Case singleCase : newCases) {			
            if(singleCase.Project__c != null) {
                if(mapofIdandTeamMember.containsKey(singleCase.Project__c ) && mapofIdandTeamMember.get(singleCase.Project__c) != null ) {
                    for(Project_Team_Member__c singlePTM : mapofIdandTeamMember.get(singleCase.Project__c)) {
                        if(singlePTM.User__c != null) {
                            CaseTeamMember temp= new CaseTeamMember();
                            temp.ParentId= singleCase.Id;
                            temp.MemberId= singlePTM.User__c; 
                            temp.TeamRoleId=caseTeamRoleMap.get(singlePTM.Role__c);
                            listOfMembersNeedTOBeAdded.add(temp);
                        }
                    }
                }           
            }
        }
        
        Database.insert(listOfMembersNeedTOBeAdded, false);
    }
    public static void updateCHMEmailInsert(List<case> newlists){
        system.debug('inside chm update'+newlists);
        set<Id> Projectids = new set<Id>();
        for(case c : newlists){
            if(c != Null){
                Projectids.add(c.Project__c); 
            }
            
        }
        map<Id, Milestone1_project__c> mapofproject = new map<Id, Milestone1_project__c>([select id,CHM__c ,Designer__r.name, CHM__r.email,Designer__r.Email, CHM__r.name from Milestone1_project__c where id IN : Projectids]);
        for(case LOc : newlists){
            system.debug('INSIDE FOR');
            if(LOc.Project__c !=Null && mapofproject.containsKey(LOc.Project__c) && mapofproject.get(LOc.Project__c).CHM__r.email != Null ){
                system.debug('INSIDE IF');
                LOc.CHM_Email__c = mapofproject.get(LOc.Project__c).CHM__r.email;
                LOc.CHM_Name__c = mapofproject.get(LOc.Project__c).CHM__r.name;
              LOc.Designer_Name__c = mapofproject.get(LOc.Project__c).Designer__r.name;
                LOc.Designer_Email__c = mapofproject.get(LOc.Project__c).Designer__r.Email;
                system.debug('CHM_Email__c-->'+LOc.CHM_Email__c);
                
            }
        }
    }
    public static void updateCHMEmailupdate(List<case> newlists, Map<id,case> newmap , Map<id,case> oldMap ){
        set<Id> Projectids = new set<Id>();
        for(case c : newlists){
            if(c != Null){ Projectids.add(c.Project__c); 
            }
        }
        map<Id, Milestone1_project__c> mapofproject = new map<Id, Milestone1_project__c>([select id,CHM__c , CHM__r.email, CHM__r.name from Milestone1_project__c where id IN : Projectids]);
        for(case LOc : newlists){
            if(newmap.get(LOc.Project__c) != oldMap.get(LOc.Project__c)){
                if(LOc.Project__c !=Null && mapofproject.containsKey(LOc.Project__c) && mapofproject.get(LOc.Project__c).CHM__r.email != Null ){
                LOc.CHM_Email__c = mapofproject.get(LOc.Project__c).CHM__r.email;
                    LOc.CHM_Name__c = mapofproject.get(LOc.Project__c).CHM__r.name;
               }   
            }
        }  
    }
}