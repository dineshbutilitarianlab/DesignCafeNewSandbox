// Just trial class ignore it
public class UserDetailsTriggerHandler3 {

static User_Details__c newUserDetail;
static User_Details__c oldUserDetail;
static Region_Group_Member__c rgToInsert =null;
static Region_Group_Member__c rgToDelete = null;
static EC_Members__c ecToInsert = null;
static EC_Members__c ecToDelete = null;

    public static void handleAfterInsertOrUpdate(List<User_Details__c> newUserDetails, Map<Id, User_Details__c> oldUserDetailsMap) {
        newUserDetail = newUserDetails[0];
        oldUserDetail = oldUserDetailsMap.get(newUserDetail.Id);
                
        dmlSetOperations();  // to set the variables declared in the begening of class
        dmlOperations();  // to insert/delete RG, EC
    }
    
    public static void dmlSetOperations(){
        
        //Logic 1 where Region and EC has changed
        if(newUserDetail.Region__c != null && newUserDetail.User_EC__c != null
            && newUserDetail.Region__c != oldUserDetail.Region__c && newUserDetail.User_EC__c != oldUserDetail.User_EC__c){
            //Logic to set the following variables
            rgToInsert = new Region_Group_Member__c(User_Details__c=newUserDetail.Id, 
                Region_Group__c=[Select Id, Name from Region_Group__c WHERE Name=: newUserDetail.Region__c limit 1].Id );
            
            rgToDelete = [Select Id from Region_Group_Member__c where 
                Region_Group__c=:[SELECT Id, Name FROM Region_Group__c WHERE Name=: oldUserDetail.Region__c limit 1].Id 
                    and User_Details__c=:oldUserDetail.Id limit 1];
            
            ecToInsert = new EC_Members__c(User_Details__c=newUserDetail.Id, 
                Meeting_Schedule_RR__c=[SELECT Id, Name FROM Meeting_Schedule_RR__c WHERE Name=: newUserDetail.User_EC__c limit 1].Id);
            
            
            ecToDelete = [Select Id from EC_Members__c where 
                Meeting_Schedule_RR__c=:[SELECT Id, Name FROM Meeting_Schedule_RR__c WHERE Name=: oldUserDetail.User_EC__c limit 1].Id 
                    and User_Details__c=:oldUserDetail.Id limit 1];
            
        }
        
        //Logic 2 where only Region has changed this logic cannot work as when region changes ec also has to change
        if(newUserDetail.Region__c != null && newUserDetail.Region__c != oldUserDetail.Region__c 
            && newUserDetail.User_EC__c == oldUserDetail.User_EC__c){
            //Logic to set the following variables
            //rgToInsert
            //rgToDelete
                   
        }
        
        //Logic 3 where only EC has changed
        if(newUserDetail.User_EC__c != null && newUserDetail.User_EC__c != oldUserDetail.User_EC__c
            && newUserDetail.Region__c == oldUserDetail.Region__c){
            //Logic to set the following variables
            
            ecToInsert = new EC_Members__c(User_Details__c=newUserDetail.Id, 
                Meeting_Schedule_RR__c=[SELECT Id, Name FROM Meeting_Schedule_RR__c WHERE Name=: newUserDetail.User_EC__c limit 1].Id);
            
            
            ecToDelete = [Select Id from EC_Members__c where 
                Meeting_Schedule_RR__c=:[SELECT Id, Name FROM Meeting_Schedule_RR__c WHERE Name=: oldUserDetail.User_EC__c limit 1].Id 
                    and User_Details__c=:oldUserDetail.Id limit 1];
        
        }
    
    }
    
    
    public static void dmlOperations(){
    
        if(rgToInsert !=null){
            //check here if already duplicate record exists b4 inserting
            insert rgToInsert;
        }
        
        if(rgToDelete !=null){
            delete rgToDelete;
        }
        
        if(ecToInsert !=null){
            //check here if already duplicate record exists b4 inserting
            insert ecToInsert;
        }
        
        if(ecToDelete !=null){
            delete ecToDelete;
        }
        
        
    }
 

}