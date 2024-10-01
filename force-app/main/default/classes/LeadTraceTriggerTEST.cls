@istest
public class LeadTraceTriggerTEST {
     
    @testSetup static void setup() {
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        insert r;
        User usr = new User(
             ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
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
             UserRoleId = r.Id
        );
        insert usr;   
        
        User usr2 = new User(
             ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
             LastName = 'last1',
             Email = 'puser001@amamama.com',
             Username = 'puser100@amamama.com' + System.currentTimeMillis(),
             CompanyName = 'TEST',
             Title = 'title',
             Alias = 'alias1',
             TimeZoneSidKey = 'America/Los_Angeles',
             EmailEncodingKey = 'UTF-8',
             LanguageLocaleKey = 'en_US',
             LocaleSidKey = 'en_US',
             UserRoleId = r.Id
        );
        insert usr2;  
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
      
    }
      
    
    static testMethod void leadTrace3() {
        User u1 = [select id,name from User where LastName = 'last' limit 1];
        User u2 = [select id,name from User where LastName = 'last1' limit 1];  
        /*Lead lead123 = new Lead(LastName='Francis222',Meeting_Venue__c='MGDC',Meeting_Type__c='EC',Willingness_For_Meeting__c= date.today().addDays(5), 
                              Region__c='Bengaluru', City='Bengaluru' ,Channel__c = 'Online', Source__c = 'Direct', Follow_Up_Count__c=0, Status='Prospect', 
                              Email='sjaiswal1@huronconsultinggroup.com',MobilePhone='9999007879');
        lead123.Property_Possession_Date__c=date.today();
        lead123.DC_Lead_Status__c='Qualified';
        lead123.isconverted=false;
        lead123.DC_Lead_Status__c='Meeting Done';
        lead123.Follow_Up_Date_Time__c = system.now();
        insert lead123;
        */
        
        Opportunity opty = new Opportunity(Name = 'Opp');
        opty.OwnerId = u1.Id;
        opty.stagename = 'Meeting Done';
        opty.Amount = 999;
        opty.Wohoo_Card__c = '567';
        opty.Signup_Amount__c = 88788;
        opty.Client_s_Budget__c = 8989;
        opty.Probability = 100;
        opty.X1st_Meeting_Person__c = '0052v00000bZuLL';
        opty.X1st_Meeting_Date__c = system.today();
        opty.Meeting_Type__c = 'EC';
        opty.region__C = 'Bengaluru';
        opty.CloseDate = system.today();
        insert opty;
        system.debug(opty);
        
        Opportunityshare CS     = new Opportunityshare();
        CS.OpportunityId             = opty.Id;
        CS.UserOrGroupId        = u2.Id;
        CS.RowCause             = Schema.Opportunityshare.rowcause.Manual;
        CS.OpportunityAccessLevel          = 'Read';
        insert CS; 
               
      //  Test.StartTest() ;
            Lead_Trace__c lt    = new Lead_Trace__c();
            lt.Opportunity__c   = opty.Id;
            lt.Tmestamp__c      = system.today();
            lt.Status__c        = 'Signed-up';
            insert lt; 
            Delete opty; 
           
            Lead leadRec = new Lead(LastName='Francis222',Meeting_Venue__c='MGDC',Meeting_Type__c='EC',Willingness_For_Meeting__c= date.today().addDays(5), 
                              Region__c='Bengaluru', City='Bengaluru' ,Channel__c = 'Online', Source__c = 'Direct', Follow_Up_Count__c=0, Status='Prospect', 
                              Email='sjaiswal1@huronconsultinggroup.com',MobilePhone='9999007879');
            insert leadRec;
            Lead_Trace__c ltLead    = new Lead_Trace__c();
            ltLead.Lead__c            = leadRec.Id;
            ltLead.Tmestamp__c      = system.today();
            ltLead.Status__c        = 'Signed-up';
            insert ltLead;  
           // Delete leadRec;  
            
        
      //  Test.StopTest();
        test.starttest();
        Test.setMock(HttpCalloutMock.class, new CCMockUp()); 
		test.stopTest();
        
        //Test.StartTest() ;
       // lt.Status__c      = 'Signed-up';     
        //update lt;
        
        //Test.StopTest();
        //InsertLeadTraceForAllLeadsCls.insertLeadTrace();
    }

}