@isTest
public class UserDetailsTriggerTest {

    @isTest
    static void testAfterInsert() {
        User_Details__c newUserDetail = new User_Details__c(
            Region__c = 'Bengaluru',
            User_EC__c = 'HSRDC',
            Role__c = 'Administrator',
            Email__c = 'test@gmail.com'
        );

        Test.startTest();
        insert newUserDetail;
        Test.stopTest();
    }

    @isTest
    static void testAfterUpdate() {
         User_Details__c newUserDetail = new User_Details__c(
            Region__c = 'Bengaluru',
            User_EC__c = 'HSRDC',
            Role__c = 'Administrator',
            Email__c = 'test@gmail.com'
        );

        insert newUserDetail;

        newUserDetail.Name = 'Updated Test User';

        Test.startTest();
        update newUserDetail;
        Test.stopTest();
    }
}