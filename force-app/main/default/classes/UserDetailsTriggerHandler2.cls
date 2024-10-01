public class UserDetailsTriggerHandler2 {

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
            //rgToInsert
            //rgToDelete
            //ecToInsert
            //ecToDelete
            
        }
        
        //Logic 2 where only Region has changed
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
            //ecToInsert
            //ecToDelete
        
        }
    
    }
    
    
    public static void dmlOperations(){
    
        if(rgToInsert !=null){
            insert rgToInsert;
        }
        
        if(rgToDelete !=null){
            delete rgToDelete;
        }
        
        if(ecToInsert !=null){
            insert ecToInsert;
        }
        
        if(ecToDelete !=null){
            delete ecToDelete;
        }
        
        
    }
 

}