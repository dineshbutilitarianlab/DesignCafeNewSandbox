@istest
public class Test_LeadRequirementUX {
    @istest
    public static void leadreq(){
        
        
                SRR__c SRRmum = new SRR__c();
        SRRmum.Name = 'Mumbai';
        SRRmum.index__c = 0;
        insert SRRmum;
        SRR__c SRRWDC = new SRR__c();
        SRRWDC.Name = 'WDC';
        SRRWDC.index__c = 0;
        insert SRRWDC;
        SRR__c SRRHyd = new SRR__c();
        SRRHyd.Name = 'Hyderabad';
        SRRHyd.index__c = 0;
        insert SRRHyd;
        SRR__c SRRMGDC = new SRR__c();
        SRRMGDC.Name = 'MGDC';
        SRRMGDC.index__c = 0;
        insert SRRMGDC;
        SRR__c SRRHSR = new SRR__c();
        SRRHSR.Name = 'HSR';
        SRRHSR.index__c = 0;
        insert SRRHSR;
        SRR__c SRRCHE = new SRR__c();
        SRRCHE.Name = 'Chennai';
        SRRCHE.index__c = 0;
        insert SRRCHE;
        SRR__c SRRjpdc = new SRR__c();
        SRRjpdc.Name = 'JPDC';
        SRRjpdc.index__c = 0;
        insert SRRjpdc;
        SRR__c SRRthane = new SRR__c();
        SRRthane.Name = 'Thane DC';
        SRRthane.index__c = 0;
        insert SRRthane;
        SRR__c SRRKDRMYS = new SRR__c();
        SRRKDRMYS.Name = 'KDRMYS';
        SRRKDRMYS.index__c = 0;
        insert SRRKDRMYS;
        SRR__c SRRYERPUN = new SRR__c();
        SRRYERPUN.Name = 'YERPUN';
        SRRYERPUN.index__c = 0;
        insert SRRYERPUN;
        SRR__c SRRBHHYD = new SRR__c();
        SRRBHHYD.Name = 'BHHYD';
        SRRBHHYD.index__c = 0;
        insert SRRBHHYD;       
        SRR__c SRRSJPBLR = new SRR__c();
        SRRSJPBLR.Name = 'SJPBLR';
        SRRSJPBLR.index__c = 0;
        insert SRRSJPBLR;   
        SRR__c SRRKHMUM = new SRR__c();
        SRRKHMUM.Name = 'KHMUM';
        SRRKHMUM.index__c = 0;
        insert SRRKHMUM;
        SRR__c SRRWLMUM = new SRR__c();
        SRRWLMUM.Name = 'WLMUM';
        SRRWLMUM.index__c = 0;
        insert SRRWLMUM;
         
        TriggerControl__c tc = new TriggerControl__c();
        tc.Name = 'LeadTrigger';
        tc.Run__c = true;
        insert tc; 
        
        Lead ld = new Lead();
        ld.LastName = 'test';
        ld.City = 'Bengaluru';
        ld.IsConverted = false;
        ld.Follow_Up_Date_Time__c = system.today()+5;
        ld.Property_Possession_Date__c=date.today();
        ld.Region__c = ld.City;
        ld.Approx_Budget__c = '2L to 3L';
        ld.Meeting_Venue__c='MGDC';
        ld.Meeting_Type__c='EC';
        ld.Willingness_For_Meeting__c = date.today().addDays(5);
        ld.Status = 'Prospect';
        ld.DC_Lead_Status__c = 'Meeting Scheduled';
        ld.Email = 'test@gmail.com';
        insert ld;
        
        String leadRec;
        RequirementsUX.picklistvalues(ld.id);
        RequirementsUX.Leaddata(ld.id);
        
        Test.startTest();
              
        try
        {
            String errorRelease = RequirementsUX.Updatelead(leadRec);
        }
        catch(exception e){
        }     
        Test.stopTest();     
    }
}