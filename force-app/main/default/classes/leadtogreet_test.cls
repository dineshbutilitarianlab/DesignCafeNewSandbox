@isTest(SeeAllData=true)


public class leadtogreet_test {
    public static void Testclass(){
        
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
        SRR__c SRROMRCH = new SRR__c();
        SRROMRCH.Name = 'OMRCH';
        SRROMRCH.index__c = 0;
        insert SRROMRCH;
        
        SRR__c SRRHRBRBLR = new SRR__c();
        SRRHRBRBLR.Name = 'HRBRBLR';
        SRRHRBRBLR.index__c = 0;
        insert SRRHRBRBLR; 
        
        SRR__c Coimb = new SRR__C();
        Coimb.Name = 'Coimbatore';
        Coimb.index__c = 0;
        insert Coimb;
        
        SRR__c rsp = new SRR__C();
        rsp.Name = 'RSPCO';
        rsp.index__c = 0;
        insert rsp;

        
        
        Lead_Number__c lnumbCust =new Lead_Number__c();
        lnumbCust.Chennai_User_Count__c =3;  
        lnumbCust.Lead_Number_Chennai__c=52;
        lnumbCust.Lead_Number_Pune__c=16;
        lnumbCust.Pune_User_Count__c=2;
        lnumbCust.Lead_Number_Bangalore__c  =2;
        lnumbCust.Bangalore_User_Count__c=11;
        lnumbCust.Lead_Number_Hyderabad__c=3;  
        lnumbCust.Hyderabad_User_Count__c=6;
        lnumbCust.Lead_Number_Mumbai_Thane__c=7;  
        lnumbCust.Mumbai_Thane_User_Count__c  =5;
        lnumbCust.Lead_Number_Navi_Mumbai__c = 4;
        lnumbCust.Navi_Mumbai_User_Count__c = 2;
        insert lnumbCust; 
        
          Profile pf = [SELECT Id FROM Profile WHERE Name = 'Sales Executive'];
       
        UserRole ur = new UserRole(Name = 'RSPCO Sales Manager');
        insert ur;
        
        UserRole ur1 = new UserRole(Name = 'Finance Approver');
        insert ur1;
        User use = new User(firstname = 'fName',
                                lastName = 'lName',
                                email = 'Test@gmail.com',
                                Username = 'UserTest@gmail.com',
                                EmailEncodingKey = 'ISO-8859-1',
                                Alias = 'abc',
                                TimeZoneSidKey = 'America/Los_Angeles',
                                LocaleSidKey = 'en_US',
                                LanguageLocaleKey = 'en_US',
                                ProfileId = pf.Id,
                                UserRoleId = ur.Id );
        insert use;
        
        
        Lead Leadins = new Lead();
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
        Leadins.LastName = 'Pankaj Pawar';
        Leadins.MobilePhone = '7897889123';
        Leadins.Email = 'test@test.com';
        Leadins.Willingness_For_Meeting__c = date.today().addDays(+5);
        Leadins.Meeting_Venue__c = 'Hyderabad DC';
        Leadins.Meeting_Type__c = 'EC';
        Leadins.Civil_Work__c = true;
        //Leadins.CreatedDate = system.today().addDays(-7);
        //  Leadins.Whatsapp_Opt_IN__c = 'Accepted'; 
        insert Leadins;
        
        /*Lead Leadins1 = new Lead();
        Leadins1.Approx_Budget__c = '2L to 3L';
        Leadins1.IsConverted = false;
        Leadins1.Status ='New';
        Leadins1.Call_Stage__c ='Undialed';
        Leadins1.Follow_Up_Date_Time__c = system.today().addDays(10);
        Leadins1.DC_Lead_Status__c='Undialed';
        Leadins1.Project_Name__c = 'TestProject';
        Leadins1.Channel__c = 'Offline';
        Leadins1.Source__c = 'Direct';
        Leadins1.City = 'Mumbai';
        Leadins1.How_did_you_hear_about_us__c =null;
        Leadins1.Campagin__c ='';
        Leadins1.Knew_about_Design_Cafe_Because__c ='';
        Leadins1.Source_Journey__c='';
        Leadins1.LastName = 'Pankaj Pawar';
        Leadins1.MobilePhone = '7897889123';
        Leadins1.Email = 'test@test.com';
        Leadins1.Willingness_For_Meeting__c = date.today().addDays(+5);
        Leadins1.Meeting_Venue__c = 'Hyderabad DC';
        Leadins1.Meeting_Type__c = 'EC';
        Leadins1.Civil_Work__c = true;
        Leadins1.LARR__c = true;
        Leadins1.CreatedDate = system.today().addDays(-7);
        //  Leadins.Whatsapp_Opt_IN__c = 'Accepted'; 
        insert Leadins1;*/
    }
    /*@isTest
    public static void CallCenterTrigger1(){
        Lead Leadins1 = new Lead();
        Leadins1.Approx_Budget__c = '3L to 5L';
        Leadins1.IsConverted = false;
        Leadins1.Status ='New';
        Leadins1.Call_Stage__c ='Undialed';
        Leadins1.Follow_Up_Date_Time__c = system.today().addDays(10);
        Leadins1.DC_Lead_Status__c='Undialed';
        Leadins1.Project_Name__c = 'TestProject';
        Leadins1.Channel__c = 'Offline';
        Leadins1.Source__c = 'DSA';
        Leadins1.City = 'Mumbai';
        Leadins1.How_did_you_hear_about_us__c =null;
        Leadins1.Campagin__c ='';
        Leadins1.Knew_about_Design_Cafe_Because__c ='';
        Leadins1.Source_Journey__c='';
        Leadins1.LastName = 'Vik Nez';
        Leadins1.MobilePhone = '7897889333';
        Leadins1.Email = 'vik@nez.com';
        Leadins1.Willingness_For_Meeting__c = date.today().addDays(+5);
        Leadins1.Meeting_Venue__c = 'Hyderabad DC';
        Leadins1.Meeting_Type__c = 'EC';
        Leadins1.Civil_Work__c = true;
        Leadins1.CreatedDate = system.today().addDays(-7);
        Leadins1.Is_MS__c = true;
        //  Leadins.Whatsapp_Opt_IN__c = 'Accepted'; 
        INSERT Leadins1;
        
    }
    */
    
    @isTest
    public static void CalloutOnUpdate_Test(){
        TriggerControl__c cuset11 = new TriggerControl__c();
        cuset11.Name = 'LeadTriggerTest';
        cuset11.Run__c = true;
        insert cuset11; 
        Leadtogreet.leadDataWrap leadWrp = new Leadtogreet.leadDataWrap();
        Lead l =[select id,LARR__c, Name,Email,MobilePhone,Source__c,Region__c,Channel__c,City,DC_Lead_Source__c,
                 LastModifiedDate,Follow_Up_Date_Time__c,DC_Campaign_Source__c,
                 DSA__c,DSAname__c,Lead_Owner_Name__c,CreatedBy.id,LastModifiedById,DC_Lead_Status__c,
                 Status,Call_Stage__c,CreatedDate,Property_Possession_Date__c from Lead 
                 where LastName = 'Pankaj Pawar' LIMIT 1];
        l.LARR__c = false;
        UPDAtE l;
        system.debug('l' + l);
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
        system.debug('from test: ' + l.id);
        List<String> lstAccIds = new List<String>();
        lstAccIds.add(l.Id);
        leadtogreet.Callout(lstAccIds);
        leadtogreet.CalloutOnUpdate(lstAccIds);
        
       
    }
    testMethod static void insertResponse_Test(){
        Map<Id, String> responseMap = new Map<Id, String>();
        Map<Id, String> requestBodyMap = new Map<Id, String>();
        Lead ld = [SELECT Id FROM Lead LIMIT 1];
        responseMap.put(ld.Id, 'System.HttpResponse[Status=OK, StatusCode=200]');
        requestBodyMap.put(ld.Id, '{"status":"Success","sales_user_number":null,"sales_user":null,"recordId":"00Q9H000004vn4wUAA","MS_DateTime":null,"message":"Submitted Successfully"}    ');
        Leadtogreet.insertResponse(responseMap, requestBodyMap);
        Intergration_Request__c ir = new Intergration_Request__c();
        ir.LeadId__c =ld.Id;
        INSERT ir;
        Leadtogreet.insertResponse(responseMap, requestBodyMap);
    }
    testMethod static void notinsertResponse_Test(){
        Map<Id, String> responseMap = new Map<Id, String>();
        Map<Id, String> requestBodyMap = new Map<Id, String>();
        Lead ld = [SELECT Id FROM Lead LIMIT 1];
        responseMap.put(ld.Id, 'System.HttpResponse[Status=OK, StatusCode=200]');
        requestBodyMap.put(ld.Id, '{"status":"Success","sales_user_number":null,"sales_user":null,"recordId":"00Q9H000004vn4wUAA","MS_DateTime":null,"message":"Submitted Successfully"}    ');
        //Leadtogreet.insertResponse(responseMap, requestBodyMap);
        List<Intergration_Request__c> irList = [SELECT Id, LeadId__c, Responce__c, Request_Body__c  FROM Intergration_Request__c WHERE LeadId__c IN: responseMap.keySet()];
        DELETE irList;
        Leadtogreet.insertResponse(responseMap, requestBodyMap);
    }
    
}