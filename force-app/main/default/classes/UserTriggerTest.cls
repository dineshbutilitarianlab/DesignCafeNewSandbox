@isTest
public class UserTriggerTest {
    @TestSetUp
    public static void setupdata(){
        Id SalesLeadRole   =[Select id from userrole where name ='Internal Sales Team Lead'].Id;
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name ='Sales Executive'].Id,
            LastName = 'last',
            Email = 'user000@example.com',
            Username = 'user000@example.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            team__c = 'Sales WDC',
            UserRoleId = SalesLeadRole
        );
        Id SalesGMRole   =[Select id from userrole where name ='Internal Sales Team Director'].Id;
        User u1 = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name ='Sales GM'].Id,
            LastName = 'last',
            Email = 'user000@example.com',
            Username = 'puser000@example.com1' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias2',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            Region__c='Mumbai',
            UserRoleId = SalesGMRole
        );
        System.runAs(thisUser) {
            
            insert u;
            insert u1;
        }
    }  
    @isTest
    public static void teamTest(){
        Map<Id,User> mapOfUSerToBeupdated = New Map<Id,User>();
        For(User userObj:[Select id,team__c,region__c from user]){
            If(userObj.team__c!=Null){
                userObj.team__c = 'Sales WDC';
                mapOfUSerToBeupdated.put(userObj.id,userObj);
            }
            If(userObj.region__c!=Null){
                userObj.region__c = 'Bengaluru';
                mapOfUSerToBeupdated.put(userObj.id,userObj);
            }
        }
        If(mapOfUSerToBeupdated.size()>0){
            update mapOfUSerToBeupdated.values();
        }
        
    }
}