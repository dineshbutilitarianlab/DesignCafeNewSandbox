@istest
public class LeadTraceValidationLeadBatchTest {
    @testSetup
    static void setup() {
        UserRole TestRole = [SELECT Id FROM UserRole WHERE Name='Call Center Agent']; 
        
        User TestUser = new User(
            ProfileId = [Select Id from profile where Name='System Administrator'].Id,
            LastName = 'TestingUser5493',
            Email = 'puser000@amamama.com',
            Username = 'test5493@ama.com',
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            Region__c='Bengaluru',
            userroleid=TestRole.id,
            Team__c='Sales MGDC_1'
        );
        
        System.runAs(new User(id=UserInfo.getUserId())) {
            //insert TestUser;
        }

        Lead lead1 = new Lead(LastName='Francis222',Meeting_Venue__c='MGDC',Meeting_Type__c='EC',Willingness_For_Meeting__c= date.today().addDays(5), 
                              Region__c='Bengaluru', City='Bengaluru' ,Channel__c = 'Online', Source__c = 'Direct', Follow_Up_Count__c=0, Status='Prospect', 
                              Email='sjaiswal1@huronconsultinggroup.com',MobilePhone='9999007879',Follow_Up_Date_Time__c=System.today() + 5);
        lead1.Property_Possession_Date__c=date.today();
        lead1.DC_Lead_Status__c='Qualified';
        insert lead1;
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
   	}
    
    @isTest
    public static void Lead1() {

        Lead lLead = [SELECT id, (SELECT id FROM Lead_Traces__r) FROM Lead];
        lLead.DC_Lead_Status__c = 'Meeting Scheduled';
        update lLead;
		
		insert new Lead_Trace__c(Lead__c=lLead.id, Status__c='Meeting Scheduled', Tmestamp__c=Date.today());
        
        lLead = [SELECT id, (SELECT id FROM Lead_Traces__r) FROM Lead];
        System.assertEquals(2, lLead.Lead_Traces__r.size());
        Test.startTest();
        Database.executeBatch(new LeadTraceValidationLeadBatch());
		Test.stopTest();
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
    }
    
    @isTest
    public static void Lead2() {
      
        Lead lLead = [SELECT id, (SELECT id FROM Lead_Traces__r) FROM Lead];
        lLead.DC_Lead_Status__c = 'Meeting Scheduled';
        update lLead;
		
        lLead.Designer__c = UserInfo.getUserId();
        lLead.DC_Lead_Status__c = 'Meeting Done';
        update lLead;
        
        insert new Lead_Trace__c(Lead__c=lLead.id, Status__c='Meeting Scheduled', Tmestamp__c=Date.today());
        insert new Lead_Trace__c(Lead__c=lLead.id, Status__c='Meeting Done', Tmestamp__c=Date.today());
        
        lLead = [SELECT id, (SELECT id FROM Lead_Traces__r) FROM Lead];
        System.assertEquals(3, lLead.Lead_Traces__r.size());
        Test.startTest();
        Database.executeBatch(new LeadTraceValidationLeadBatch());
		Test.stopTest();
      
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
    }
    
    @isTest
    public static void Lead3() {
         
        List<ID> lUserId = new List<ID> {UserInfo.getUserId()};
        User [] lUser = [SELECT id FROM User WHERE id NOT IN:lUserId AND Profile.Name='System Administrator' AND IsActive=true];
        Lead lLead = [SELECT id, (SELECT id FROM Lead_Traces__r) FROM Lead];
        lLead.DC_Lead_Status__c = 'Meeting Scheduled';
        lLead.OwnerId=lUser[0].id;
        update lLead;
		
        lLead.Designer__c = UserInfo.getUserId();
        lLead.DC_Lead_Status__c = 'Meeting Done';
        update lLead;
        
        insert new Lead_Trace__c(Lead__c=lLead.id, Status__c='Meeting Scheduled', Tmestamp__c=Date.today());
        insert new Lead_Trace__c(Lead__c=lLead.id, Status__c='Meeting Done', Tmestamp__c=Date.today());
        
        lLead = [SELECT id, (SELECT id FROM Lead_Traces__r) FROM Lead];
        System.assertEquals(3, lLead.Lead_Traces__r.size());
        Test.startTest();
        Database.executeBatch(new LeadTraceValidationLeadBatch());
		Test.stopTest();
        
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
    }
}