@isTest
public class quickcilverOauth_Test {
    @isTest
    public static void testBearerToken() { // method to test BearerToken creation
        User u = [SELECT Id, Name FROM user WHERE profile.Name = 'System Administrator' 
            AND IsActive = true LIMIT 1];
        System.runAs(u){
            // quickcilver__c	qc = quickcilver__c.getvalues('quickcilver details');
            quickcilver__c  cusSet1 = new quickcilver__c();
            cusSet1.Name = 'quickcilver details';
            cusSet1.Consumer_Key__c = 'hhh';
            cusSet1.UserName__c = 'jjh';
            cusSet1.Password__c = 'hjhl';

            /* cusSet1.Consumer_Key__c = qc.Consumer_Key__c;
            cusSet1.UserName__c = qc.UserName__c;
            cusSet1.Password__c = qc.Password__c; */
            insert cusSet1;

            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new quickcilverOauth_Mockup());
            quickcilverOauth.BearerToken();
            Test.stopTest();
        }
    }
}