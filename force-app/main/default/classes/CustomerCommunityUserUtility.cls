Public class CustomerCommunityUserUtility{
    /**
     * Create Community user when we add project.
     * @param projectList list of Milestone1_Project__c object
     * @author Ranveer
     */
    public static void createUser(list<Account> TriggerNew){
        set<Account> accountList = new set<Account>();
        for(Account accObj : TriggerNew){
            if(accObj.IsPersonAccount) {
                accountList.add(accObj);
            }
        }
        Application_Settings__c portalProfile = Application_Settings__c.getValues('CUSTOMER_COMMUNITY_PROFILEID'); 
        String portalProfileValue='';
        if(portalProfile != Null){
            portalProfileValue=portalProfile.Value__c;
        }
        else{
            portalProfileValue = [SELECT Id FROM Profile WHERE Name='Customer Community Login User' Limit 1].id;
            
        }
      //  Profile portalProfile = [SELECT Id FROM Profile WHERE Name='Customer Community User' Limit 1];
        
        if(accountList.size() > 0) {
            for(Account acc : accountList) {
                createUserFuture(portalProfileValue,acc.firstName,acc.LastName,acc.PersonEmail,acc.PersonContactId,acc.ownerId);
            }
        }
    }
    /**
     * Create Community user when we add project.
     * @author Ranveer
     */
    @future
    public static void createUserFuture(String profileId,String firstName,String LastName,String PersonEmail,String PersonContactId,String ownerId) {
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
        Database.insert(userObj, false);
		
		if(String.isNotBlank(userObj.id)) {
            PermissionSet myPermissionSet = [select id from PermissionSet where name = 'Customer_Community_Permission'];
            PermissionSetAssignment psa = new PermissionSetAssignment (PermissionSetId = myPermissionSet.id, AssigneeId = userObj.id);
            insert psa;
        }
    }
    
    public static void sendCommunityUserWelcomeEmail(User aUser) {
        User lUser = [SELECT id, Name, Profile.Name FROM User WHERE id=:aUser.id];
        
        if(!lUser.Profile.Name.containsIgnoreCase('community')) {
            return;
        }
        
        OrgWideEmailAddress [] lOrgWideAddresses = [SELECT id, Address FROM OrgWideEmailAddress WHERE DisplayName='No Reply'];
        EmailTemplate et = [Select id from EmailTemplate where DeveloperName = 'DC_Customer_Community_Welcome_Email' limit 1];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setTargetObjectId(aUser.id);
        
        if(lOrgWideAddresses.size() > 0) {
            mail.setOrgWideEmailAddressId(lOrgWideAddresses[0].id);
        }
        else {
            mail.setSenderDisplayName('Design Cafe (no-reply)');
        }
        
        mail.setTemplateId(et.id);
        mail.setSaveAsActivity(false);
        CustomerCommunityUserCredsController.setPassword(aUser.id);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}