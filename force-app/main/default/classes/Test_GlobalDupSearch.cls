@istest
public class Test_GlobalDupSearch { 
    @istest 
    Static void globaldup(){
        TriggerControl__c cuset1 = new TriggerControl__c();
        cuset1.Name = 'LeadTrigger';
        cuset1.Run__c = true;
        insert cuset1;
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
        SRR__c SRRYERPUN = new SRR__c();
        SRRYERPUN.Name = 'YERPUN';
        SRRYERPUN.index__c = 0;
        insert SRRYERPUN; 
        SRR__c SRRKDRMYS = new SRR__c();
        SRRKDRMYS.Name = 'KDRMYS';
        SRRKDRMYS.index__c = 0;
        insert SRRKDRMYS;  
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
 
        
        DCWebengage__c  cuset2= new DCWebengage__c();
        cuset2.Name = 'Dcwebengage';
        cuset2.BearerToken__c = '097a1996-03d2-4870-8bbc-339eb9e239b7';
        cuset2.url__c= 'https://api.webengage.com/v1/accounts/aa131ca9/users';
        insert cuset2; 
        Account ac= new account();
        ac.Name = 'testdup';
        insert ac;
        
        account acc= new account();
        acc.LastName='personacc';
        acc.PersonMobilePhone='8106333333';
        insert acc;
        
        contact con = new contact();
        con.LastName = 'testdup';
        con.AccountId=ac.Id;
        con.MobilePhone = '8106333333';
        con.Email='duptest@gmail.com';
        insert con;
        

        list<lead> Ldlist =[select id,name from lead];

        ApexPages.StandardsetController sc = new ApexPages.StandardsetController(Ldlist);
        GlobalDupSearch1 gb= new GlobalDupSearch1(sc);
        gb.PE='+918106333333';
        gb.search();
        gb.save();
        gb.createLead();
        gb.PE='';
        gb.search();
        gb.PE='+919876543210';
        gb.search();
        
        lead ld1 = new lead();
        ld1.lastname='leadinsert';
        ld1.LeadSource='walkin';
        ld1.Status='Prospect';
        ld1.MobilePhone='+918106333334';
        ld1.City ='Bengaluru';
        insert ld1;
        
        gb.PE='+918106333334';
        test.starttest();
        Test.setMock(HttpCalloutMock.class, new CCMockUp()); 
        gb.search();
        gb.save();
        test.stopTest();
        
    }
    
    
    
    
     @istest 
    Static void globaldup1(){
        TriggerControl__c cuset1 = new TriggerControl__c();
        cuset1.Name = 'LeadTrigger';
        cuset1.Run__c = true;
        insert cuset1;
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
        SRR__c SRRYERPUN = new SRR__c();
        SRRYERPUN.Name = 'YERPUN';
        SRRYERPUN.index__c = 0;
        insert SRRYERPUN; 
        SRR__c SRRKDRMYS = new SRR__c();
        SRRKDRMYS.Name = 'KDRMYS';
        SRRKDRMYS.index__c = 0;
        insert SRRKDRMYS;  
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
        
        DCWebengage__c  cuset2= new DCWebengage__c();
        cuset2.Name = 'Dcwebengage';
        cuset2.BearerToken__c = '097a1996-03d2-4870-8bbc-339eb9e239b7';
        cuset2.url__c= 'https://api.webengage.com/v1/accounts/aa131ca9/users';
        insert cuset2; 

        account acc= new account();
        acc.LastName='personacc';
        acc.PersonMobilePhone='8106333333';
        insert acc;
        
       
  
        opportunity opp = new opportunity();
        opp.Name='opp1';
        opp.AccountId=acc.Id;
        opp.CloseDate=system.today();
        opp.StageName='Qualified';
        insert opp; 
          list<lead> Ldlist =[select id,name from lead];
        ApexPages.StandardsetController sc = new ApexPages.StandardsetController(Ldlist);
        GlobalDupSearch1 gb= new GlobalDupSearch1(sc);
        gb.PE='+918106333333';
        gb.search();
        gb.save();
        gb.createLead();
        gb.PE='';
        gb.search();
        gb.PE='+919876543210';
        gb.search();
        
        lead ld1 = new lead();
        ld1.lastname='leadinsert';
        ld1.LeadSource='walkin';
        ld1.Status='Prospect';
        ld1.MobilePhone='+918106333334';
        ld1.City ='Bengaluru';
        insert ld1;
        
        gb.PE='+918106333334';
        test.starttest();
        Test.setMock(HttpCalloutMock.class, new CCMockUp()); 
        gb.search();
        gb.save();
        test.stopTest();
        
    }   
    
    
}