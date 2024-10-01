@isTest
public class updategenesyslead_test {
    @istest
    static void Leadtest(){
        TriggerControl__c cuset1 = new TriggerControl__c();
        cuset1.Name = 'LeadTrigger';
        cuset1.Run__c = true;
        insert cuset1;
        Leadtogenesys__c cuset = new Leadtogenesys__c();
        cuset.Name = 'genesysapi';
        cuset.url__c = 'http://dctest.greettech.com:8081/leadsTogreetTest.php';
        insert cuset;
        DCWebengage__c  cuset2= new DCWebengage__c();
        cuset2.Name = 'Dcwebengage';
        cuset2.BearerToken__c = '097a1996-03d2-4870-8bbc-339eb9e239b7';
        cuset2.url__c= 'https://api.webengage.com/v1/accounts/aa131ca9/users';
        insert cuset2; 
        
        CPPortal__c cpp = new CPPortal__c();
		cpp.name = 'cpportalupdate';
        cpp.url__c = 'http://testurl.com';
        insert cpp;
    
        Design_User__c des = new Design_User__c();
        des.Name = 'testdesigner';
        des.Email__c = 'testdesigner@test.com';
        des.Designer_Dashboard_ID__c = 'ID';
        des.Role__c = 'Studio Manager';
        insert des;
        
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
        
        SRR__c SRRMysore = new SRR__c();
        SRRMysore.Name = 'KDRMYS';
        SRRMysore.index__c = 0;
        insert SRRMysore;    
        SRR__c SRRPune = new SRR__c();
        SRRPune.Name = 'YERPUN';
        SRRPune.index__c = 0;
		insert SRRPune;
        SRR__c SRRBHHyd = new SRR__c();
        SRRBHHyd.Name = 'BHHYD';
        SRRBHHyd.index__c = 0;
        insert SRRBHHyd;    
        SRR__c SRRSJP = new SRR__c();
        SRRSJP.Name = 'SJPBLR';
        SRRSJP.index__c = 0;
        insert SRRSJP; 
        
        SRR__c SRRKHM = new SRR__c();
        SRRKHM.Name ='KHMUM';
        SRRKHM.index__c = 0;
        insert SRRKHM;    
        
        
        
        Lead l = new Lead();
        l.LastName = 'test';
        l.City = 'Mumbai';
        l.MobilePhone='1234567890';
        l.Email = 'imtiyaz@dc.com';
        l.Region__c = 'Bengaluru';
        l.Channel__c = 'Online';
        l.Source__c='Paid';
        l.Status ='New';
        // l.DC_Lead_Source__c='Paid';
        l.Callrecording__c='test';
        l.DC_Lead_Status__c ='Undialed';
        l.DC_Lead_Source__c ='Direct';
        l.Campagin__c ='Direct'; 
        insert l;
        
        List<Lead> listlead=[SELECT id,Region__c,Channel__c,Status,DC_Lead_Status__c,DC_Lead_Source__c,Campagin__c,createddate,APIMOBILE__c FROM Lead Where APIMOBILE__c =:l.APIMOBILE__c];
        if(listlead.size() !=0){
            Lead l1 = new Lead();
            l1.id = listlead[0].id;
            l1.LastName = 'test';
            l1.City = 'Mumbai';
            l1.MobilePhone='1234567890';
            l1.Email = 'imtiyaz@dc.com';
            l1.Region__c = 'Bengaluru';
            l1.DC_Lead_Source__c='Paid';
             l1.Callrecording__c='test';
            l1.Channel__c = 'Online';
            l1.Status ='New';
            l1.DC_Lead_Status__c ='Undialed';
            l1.DC_Lead_Source__c ='Direct';
            l1.Campagin__c ='Direct';
           // update 11;
        }  
        String myJSON = '{"PHONE":"1234567890","RECORD_ID":"1234","Callrecording":"test","NAME":"test","MAIL_ID":"imtiyaz@dc.com","SOURCE":"Online","region":"Bengaluru","CHANNEL":"Online"}';
        RestRequest request = new RestRequest();
        request.requestUri ='https://uat-dcafe.cs74.force.com/services/apexrest/updatelead';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueof(myJSON);
        RestContext.request = request;
        RestResponse RestResponse = New RestResponse();
        RestResponse.statusCode = 200;
        RestContext.response = RestResponse;
        
        test.startTest();
        Updategenesyslead.doPost();  
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
        test.stopTest();
    }    
}