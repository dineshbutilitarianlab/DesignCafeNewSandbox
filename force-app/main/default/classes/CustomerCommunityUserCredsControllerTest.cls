@IsTest
public class CustomerCommunityUserCredsControllerTest {
    @TestSetup
    private static void dataSetup() {
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()]; 
        UserRole r = [SELECT Id FROM UserRole WHERE Name='CHM'];
        System.runAs (thisUser) { 
            User u = new User(
                             ProfileId = [Select Id from profile where Name='System Administrator'].Id,
                             LastName = 'last',
                             Email = 'puser000@amamama.com',
                             Username = 'puser000@amamama.com' + System.currentTimeMillis(),
                             CompanyName = 'TEST',
                             Title = 'title',
                             Alias = 'alias',
                             TimeZoneSidKey = 'America/Los_Angeles',
                             EmailEncodingKey = 'UTF-8',
                             LanguageLocaleKey = 'en_US',
                             LocaleSidKey = 'en_US',
                             Region__c='Bengaluru',
                             userroleid=r.id
                             );
            insert u;
        }
    }
    
    @IsTest
    private static void test1() {
        CustomerCommunityUserCredsController lCont = new CustomerCommunityUserCredsController();
        ID lUserID = [SELECT id, Name FROM User WHERE Username LIKE 'puser000%'].id;
        CustomerCommunityUserCredsController.setPassword(lUserID);
        lCont.setmUserId(lUserID);
        lCont.getmUserId();
        lCont.getmUserName();
        lCont.getmPassword();
    }
}