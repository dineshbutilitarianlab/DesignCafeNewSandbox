public class CreateCommunityUserController {
    @auraEnabled
    public static ResponseWrapper createUser(String accId){
        Account acc = [select id,firstName,LastName,PersonEmail,PersonContactId,ownerId,IsPersonAccount from account where id=:accId];
        Profile portalProfile = [SELECT Id FROM Profile WHERE Name='Customer Community User' Limit 1];
        user userObj = createUser(portalProfile.id,acc.firstName,acc.LastName,acc.PersonEmail,acc.PersonContactId,acc.ownerId);
        ResponseWrapper response = new ResponseWrapper();
        Database.SaveResult saveResult = database.insert(userObj,false);
        if(saveResult.isSuccess()){
            PermissionSet myPermissionSet = [select id from PermissionSet where name = 'Customer_Community_Permission'];
            PermissionSetAssignment psa = new PermissionSetAssignment
                (PermissionSetId = myPermissionSet.id, AssigneeId = userObj.id);
            insert psa;
        }else{
            response.code = 400;
            response.message = saveResult.getErrors()[0].getMessage();
            return response;
        }
        
        response.code = 200;
        response.message = 'User was Created succssfully';
        return response;
    }
    private static user createUser(String profileId,String firstName,String LastName,String PersonEmail,String PersonContactId,String ownerId){
        User userObj = new User();
        userObj.UserName = PersonEmail;
        userObj.FirstName = FirstName;  
        userObj.LastName = LastName;
        userObj.email = PersonEmail;
        userObj.Alias = (LastName.length() > 8 ? LastName.substring(0, 8) : LastName);
        userObj.ContactId = PersonContactId;
        userObj.ProfileId = profileId;
        userObj.CommunityNickname = FirstName+' '+LastName;
        userObj.EmailEncodingKey = 'UTF-8';
        userObj.TimeZoneSidKey = 'Asia/Kolkata';
        userObj.LocaleSidKey = 'en_IN';
        userObj.LanguageLocaleKey = 'en_US';
        return userObj;
    }
    public class ResponseWrapper{
        @auraEnabled public integer code;
        @auraEnabled public String message;
    }
}