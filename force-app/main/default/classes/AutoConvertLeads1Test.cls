@isTest
public class AutoConvertLeads1Test {
    @testSetup
    static void setup() {
        
        TriggerControl__c cuset1 = new TriggerControl__c();
        cuset1.Name = 'LeadTrigger';
        cuset1.Run__c = true;
        insert cuset1; 
        
        DCWebengage__c  cuset2= new DCWebengage__c();
        cuset2.Name = 'Dcwebengage';
        cuset2.BearerToken__c = '097a1996-03d2-4870-8bbc-339eb9e239b7';
        cuset2.url__c= 'https://api.webengage.com/v1/accounts/aa131ca9/users';
        insert cuset2; 
        
        Lead testLead1 = new Lead(
            FirstName = 'test 1',
            LastName = 'lead',
            MiddleName = 'middleLead',
            Company = 'Test Company 1',
            DC_Lead_Status__c = 'Junk',
            city = 'chennai',
            Status = 'Not Connected',
            Is_Customer_Created__c = true,
             Channel__c = 'Online',
            Source__c = 'Paid'
        );
        Lead testLead2 = new Lead(
            FirstName = 'test 2',
            LastName = 'lead',
            MiddleName = 'middleLead',
            Company = 'Test Company 2',
            DC_Lead_Status__c  = 'Followup',
            city = 'chennai',
            Status = 'Not Connected',
            Is_Customer_Created__c = true,
            Channel__c = 'Online',
            Source__c = 'Paid'
        );
        insert new List<Lead>{testLead1, testLead2};
    }
    

    @isTest
    static void testLeadConversion() {
        
        Account testAccount = new Account(
            Name = 'Test Account'
        );
        insert testAccount;
        
        Opportunity opty = new Opportunity();
        opty.Name = 'OppTest';
        opty.AccountId = testAccount.Id;
        opty.stagename = 'Meeting Done';
        opty.CloseDate = system.today();
        opty.Lead_Id__c = 'test 1';
        insert opty;
        
        Lead testLead1 = [SELECT Id, FirstName, LastName FROM Lead WHERE FirstName = 'test 1' LIMIT 1];
        Lead testLead2 = [SELECT Id, FirstName, LastName FROM Lead WHERE FirstName = 'test 2' LIMIT 1];

        List<AutoConvertLeads1.Requests> requestsList = new List<AutoConvertLeads1.Requests>();

       AutoConvertLeads1.Requests request1 = new AutoConvertLeads1.Requests();
        request1.LeadId = testLead1.Id;
        request1.AccountId = testAccount.Id;
        request1.FirstName = testLead1.FirstName;
        request1.MiddleName = testLead1.LastName;

         AutoConvertLeads1.Requests request2 = new AutoConvertLeads1.Requests();
        request2.LeadId = testLead2.Id;
        request2.AccountId = testAccount.Id;
        request2.FirstName = testLead2.FirstName;
        request2.LastName = testLead2.LastName;
        
        AutoConvertLeads1.Requests request3 = new AutoConvertLeads1.Requests();
        request3.LeadId = testLead2.Id;
        request3.AccountId = testAccount.Id;
        request3.MiddleName = testLead2.LastName;
        
        AutoConvertLeads1.Requests request4 = new AutoConvertLeads1.Requests();
        request3.LeadId = testLead2.Id;
        
        requestsList.add(request1);
        requestsList.add(request2);
        requestsList.add(request3);
        requestsList.add(request4);
		
        try{
            Test.startTest();
            Test.setMock(HttpCalloutMock.class,new AccessTokenMock());
            AutoConvertLeads1.LeadAssign(requestsList);
            Test.stopTest(); 
        }  catch (Exception e) {
            System.debug('Exception occurred: ' + e.getMessage());
        }
    }
}