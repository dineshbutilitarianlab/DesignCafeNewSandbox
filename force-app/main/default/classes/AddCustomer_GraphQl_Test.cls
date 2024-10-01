@isTest 
public class AddCustomer_GraphQl_Test {
    
    @isTest public static void leadAddCustomer(){
       Test.setMock(HttpCalloutMock.class, new AuthorizationTokenMock());
        DCWebengage__c cuset2= new DCWebengage__c();
        cuset2.Name = 'Dcwebengage';
        cuset2.BearerToken__c = '097a1996-03d2-4870-8bbc-339eb9e239b7';
        cuset2.url__c= 'https://api.webengage.com/v1/accounts/aa131ca9/users';
        insert cuset2;
        
        Leadtogenesys__c cuset1 = new Leadtogenesys__c();
        cuset1.Name = 'genesysapi';
        cuset1.url__c = 'http://dctest.greettech.com:8081/leadsTogreetTest.php';
        insert cuset1; 
        Lead l = new Lead();
        
        TriggerControl__c cuset3 = new TriggerControl__c();
        cuset3.Name = 'LeadTrigger';
        cuset3.Run__c = true;
        insert cuset3;
        
        List<SRR__c> SRRList = new List<SRR__c>();
        
        
        SRR__c SRRmum = new SRR__c();
        SRRmum.Name = 'Mumbai';
        SRRmum.index__c = 0;
        SRRList.add(SRRmum);
        SRR__c SRRWDC = new SRR__c();
        SRRWDC.Name = 'WDC';
        SRRWDC.index__c = 0;
        SRRList.add(SRRWDC);
        SRR__c SRRHyd = new SRR__c();
        SRRHyd.Name = 'Hyderabad';
        SRRHyd.index__c = 0;
        SRRList.add(SRRHyd);
        SRR__c SRRMGDC = new SRR__c();
        SRRMGDC.Name = 'MGDC';
        SRRMGDC.index__c = 0;
        SRRList.add(SRRMGDC);
        SRR__c SRRHSR = new SRR__c();
        SRRHSR.Name = 'HSR';
        SRRHSR.index__c = 0;
        SRRList.add(SRRHSR);
        SRR__c SRRCHE = new SRR__c();
        SRRCHE.Name = 'Chennai';
        SRRCHE.index__c = 0;
        SRRList.add(SRRCHE);
        SRR__c SRRjpdc = new SRR__c();
        SRRjpdc.Name = 'JPDC';
        SRRjpdc.index__c = 0;
        SRRList.add(SRRjpdc);
        SRR__c SRRthane = new SRR__c();
        SRRthane.Name = 'Thane DC';
        SRRthane.index__c = 0;
        SRRList.add(SRRthane);
        SRR__c SRRKDRMYS = new SRR__c();
        SRRKDRMYS.Name = 'KDRMYS';
        SRRKDRMYS.index__c = 0;
        SRRList.add(SRRKDRMYS);
        SRR__c SRRYERPUN = new SRR__c();
        SRRYERPUN.Name = 'YERPUN';
        SRRYERPUN.index__c = 0;
        SRRList.add(SRRYERPUN);
        SRR__c SRRBHHYD = new SRR__c();
        SRRBHHYD.Name = 'BHHYD';
        SRRBHHYD.index__c = 0;
        SRRList.add(SRRBHHYD);
        SRR__c SRRSJPBLR = new SRR__c();
        SRRSJPBLR.Name = 'SJPBLR';
        SRRSJPBLR.index__c = 0;
        SRRList.add(SRRSJPBLR);
        SRR__c SRRKHMUM = new SRR__c();
        SRRKHMUM.Name = 'KHMUM';
        SRRKHMUM.index__c = 0;
        SRRList.add(SRRKHMUM);
        SRR__c SRRWLMUM = new SRR__c();
        SRRWLMUM.Name = 'WLMUM';
        SRRWLMUM.index__c = 0;
        SRRList.add(SRRWLMUM);
        SRR__c SRROMRCH = new SRR__c();
        SRROMRCH.Name = 'OMRCH';
        SRROMRCH.index__c = 0;
        SRRList.add(SRROMRCH);
        
        
        
        
        SRR__c SRRHRBRBLR = new SRR__c();
        SRRHRBRBLR.Name = 'HRBRBLR';
        SRRHRBRBLR.index__c = 0;
        SRRList.add(SRRHRBRBLR);
        
        SRR__c SRRHRRSPCO = new SRR__c();
        SRRHRRSPCO.Name = 'RSPCO';
        SRRHRRSPCO.index__c = 0;
        SRRList.add(SRRHRRSPCO);
        SRR__c SRRHRDNVIZ = new SRR__c();
        SRRHRDNVIZ.Name = 'DNVIZ';
        SRRHRDNVIZ.index__c = 0;
        SRRList.add(SRRHRDNVIZ);
        
        if(SRRList.size()> 0){
               Insert SRRList; 
        }
     
        /*   Lead_Number__c lnumbCust =new Lead_Number__c();
lnumbCust.Chennai_User_Count__c =3;	
lnumbCust.Lead_Number_Chennai__c=52;
lnumbCust.Lead_Number_Pune__c=16;
lnumbCust.Pune_User_Count__c=2;
lnumbCust.Lead_Number_Bangalore__c	=2;
lnumbCust.Bangalore_User_Count__c=11;
lnumbCust.Lead_Number_Hyderabad__c=3;	
lnumbCust.Hyderabad_User_Count__c=6;
lnumbCust.Lead_Number_Mumbai_Thane__c=7;	
lnumbCust.Mumbai_Thane_User_Count__c	=5;
lnumbCust.Lead_Number_Navi_Mumbai__c = 4;
lnumbCust.Navi_Mumbai_User_Count__c = 2;
insert lnumbCust;  */
        
        
        
        List<Id> leadID =new List<Id>();
        Lead Leadins = new lead();
        Leadins.Approx_Budget__c = '2L to 3L';
        Leadins.IsConverted = false;
        Leadins.Status ='New';
        Leadins.Call_Stage__c ='Undialed';
        Leadins.Follow_Up_Date_Time__c = system.today().addDays(10);
        Leadins.DC_Lead_Status__c='Undialed';
        Leadins.Project_Name__c = 'TestProject';
        Leadins.Channel__c = 'Offline';
        Leadins.Source__c = 'Direct';
        Leadins.City = 'Mumbai';
        Leadins.How_did_you_hear_about_us__c =null;
        Leadins.Campagin__c ='';
        Leadins.Knew_about_Design_Cafe_Because__c ='';
        Leadins.Source_Journey__c='';
        Leadins.LastName = 'test';
        Leadins.MobilePhone = '7897889123';
        Leadins.Email = 'test@test.com';
        Leadins.Willingness_For_Meeting__c = date.today().addDays(+5);
        Leadins.Meeting_Venue__c = 'Hyderabad DC';
        Leadins.Meeting_Type__c = 'EC';
        Leadins.Civil_Work__c = true;
        //newcomment//Leadins.CreatedDate = system.today().addDays(-7);
        //RecursiveTriggerHandler.isFirstTime = true;
        //Leadins.Whatsapp_Opt_IN__c = 'Accepted'; 
        insert Leadins;
        RecursiveTriggerHandler.isFirstTime = true;
        update Leadins;
        leadID.add(Leadins.id);
        
        
        
        Test.startTest();
       
        
        //  Test.setMock(HttpCalloutMock.class, new  GenerateNewInvoiceControllerMockTest());
        List<List<Id>> ids = new List<List<Id>>();
        ids.add(new List<Id>());
        ids[0] = leadID;
        //AddCustomers_GraphQL.addCustomers(ids);
        Test.stopTest();
        
    }
}