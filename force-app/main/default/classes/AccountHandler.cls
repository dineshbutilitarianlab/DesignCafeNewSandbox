Public class AccountHandler{
     /**
    * Fatch all account based on account id which have no community user
    * @param accIds set of ids
    * @author Ranveer
    */
     public static list<Account> getPersonAccountbyIdsNotCommunityUser(set<String> accIds){
         if(!accIds.isEmpty()){
             Map<string,Account> mapOfContactIdWithAccount = new map<string,Account>();
             for(Account acc : [select id,firstName,LastName,PersonEmail,PersonContactId,ownerId from account where id in: accIds and IsPersonAccount=true]){
                 mapOfContactIdWithAccount.put(acc.PersonContactId,acc);
             }
             for(user usr: [select id,contactId from user where contactId in:mapOfContactIdWithAccount.keyset()]){
                 mapOfContactIdWithAccount.remove(usr.contactId);
             }
             return mapOfContactIdWithAccount.values();
         }
             
         return new List<Account>();
     }
     
     // For Updation of Email on Project and Milestone, whenever the email on Account is changed.
     
     public static void updateProjectEmail(list<Account>accList,map<id,Account> oldMap){
     set<Id> accId=new set<Id>();
     set<Id> PrId=new set<Id>();
     List<Milestone1_Project__c> listUpdateProject=new List<Milestone1_Project__c>();
     List<Milestone1_Milestone__c> listUpdateProjectMilstone=new List<Milestone1_Milestone__c>();
         for(Account acc :accList){
             if(acc.PersonEmail!=oldMap.get(acc.id).PersonEmail && acc.PersonEmail!=null){
               accId.add(acc.id);
             }        
         }
        if(accId.size()>0){
            for(Milestone1_Project__c project :[Select id,Customer__r.PersonEmail ,(select id from Project_Milestones__r) from Milestone1_Project__c where Customer__c in:accId ]){
                Milestone1_Project__c proj=new Milestone1_Project__c();
                proj.id=project.id;
                proj.Customer_s_Email__c=project.Customer__r.PersonEmail;
                listUpdateProject.add(proj);
                if(project.Project_Milestones__r.size()>0){
                    for(Milestone1_Milestone__c proMil :project.Project_Milestones__r){
                        Milestone1_Milestone__c mil =new Milestone1_Milestone__c();
                        mil.id=proMil.id;
                        mil.Customer_s_Email__c=project.Customer__r.PersonEmail;
                        listUpdateProjectMilstone.add(mil);
                    }
               }
             } 
         }    
         if(listUpdateProject.size()>0){
            update listUpdateProject;
         } 
          if(listUpdateProjectMilstone.size()>0){
            update listUpdateProjectMilstone;
         } 
     }
}