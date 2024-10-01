@isTest
public class DC_WebnengageTaskTest {
     @istest
    Public static void web1(){

        TriggerControl__c tc = new TriggerControl__c();
        tc.Name = 'LeadTrigger';
        tc.Run__c = true;
        insert tc;
        
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
        
         SRR__c SRRChennai = new SRR__c();
        SRRChennai.Name = 'Chennai';
        SRRChennai.index__c = 0;
        insert SRRChennai;
        List<SRR__c> ssrRec = new List<SRR__c>();
        for(integer i = 0; i < = 11; i++){
             SRR__c ssrRecord = new SRR__c();
            if(i == 0)
              	 ssrRecord.Name = 'JPDC';
            if(i == 1)
         	 	 ssrRecord.Name = 'Thane DC';
     	    if(i == 2)
         	 	 ssrRecord.Name = 'KDRMYS';
            if(i == 3)
         	 	 ssrRecord.Name = 'YERPUN';
             if(i == 4)
          		 ssrRecord.Name = 'BHHYD';
             if(i == 5)
          		 ssrRecord.Name = 'SJPBLR';
             if(i == 6)
         		  ssrRecord.Name = 'KHMUM';
             if(i == 7)
        		   ssrRecord.Name = 'WLMUM';
             if(i == 8)
         		  ssrRecord.Name = 'OMRCH';
             if(i == 9)
         		  ssrRecord.Name = 'RSPCO';
            if(i == 10)
                 ssrRecord.Name = 'HRBRBLR';
               if(i == 11)
                 ssrRecord.Name = 'DNVIZ';
            
      	   ssrRecord.index__c = 0;
            ssrRec.add(ssrRecord);
        }
        	if(ssrRec.size() > 0)
                	insert ssrRec;
        
        Account acc =new Account();
        acc.Name='TestAccount1';
        insert acc;
        
        
    Lead leadRec = new Lead();
    leadRec.Approx_Budget__c = '3L to 5L';
    leadRec.DC_Campaign_Source__c = 'Direct';
    leadRec.Channel__c = 'Online';
    leadRec.Civil_Work__c = true;
    leadRec.Country_Code__c = '+91';
    leadRec.LastName = 'Test web';
    leadRec.Source__c = 'Direct';
    leadRec.Meeting_Type__c = 'EC';
    leadRec.Meeting_Venue__c = 'WDC';
    leadRec.Messaging_Source__c = 'Chat';
    leadRec.MobilePhone  = '8949963017';
    leadRec.Page_URL__c = 'https://www.designcafe.com';
    leadRec.Property_Possession_Date__c = date.parse('24/11/2022');
    leadRec.Property_Possession_Status__c = 'Property due - next month';
    leadRec.Property_Type_For_Interior__c = 'Flat';
    leadRec.Region__c = 'Bengaluru';
    leadRec.Scope_Of_Work__c = 'Renovation';
    leadRec.Source_Journey__c = 'https://www.designcafe.com';
    leadRec.Whatsapp_Opt_IN__c = false;
    leadRec.YMUrl__c = 'https://www.designcafe.com';
       leadRec.city =  'Bengaluru';
    insert leadRec;
        
        system.debug('leadRec'+leadRec);
    }
}