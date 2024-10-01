@isTest
public class DesignUserTriggerTest {

    @isTest
    static void testAfterInsertTrigger() {
        List<Design_User__c> designUsers = new List<Design_User__c>();
        
        designUsers.add(new Design_User__c(
            Name = 'Test Design User 1',
            Designer_Dashboard_ID__c = '355',
            Role__c= 'Inhouse Designer',
            Email__c = 'test@gmail.com',
            Mobile__c = '7834764321',
            Region__c = 'Bengaluru',
            Experience_Center__c = 'MGDC'
            
        ));
        
        designUsers.add(new Design_User__c(
            Name = 'Test Design User 2',
            Designer_Dashboard_ID__c = '356',
            Role__c= 'Inhouse Designer',
            Email__c = 'test1@gmail.com',
            Mobile__c = '7835761211',
            Region__c = 'Bengaluru',
            Experience_Center__c = 'HSRDC'
            
        ));
        
        insert designUsers;
        
    }
}