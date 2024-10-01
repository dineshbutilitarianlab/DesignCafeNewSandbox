@isTest
public class getLeadFiles_Test {
    public static testmethod void getLead(){
        DCWebengage__c  cuset2= new DCWebengage__c();
        cuset2.Name = 'Dcwebengage';
        cuset2.BearerToken__c = '097a1996-03d2-4870-8bbc-339eb9e239b7';
        cuset2.url__c= 'https://api.webengage.com/v1/accounts/aa131ca9/users';
        insert cuset2; 
        
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
        TriggerControl__c tc = new TriggerControl__c();
        tc.Run__c = true;
        tc.name = 'LeadTrigger';
        insert tc;
        Lead Leadins = new lead();
        Leadins.Approx_Budget__c = '2L to 3L';
        Leadins.Status ='Junk';
        Leadins.Call_Stage__c='Undialed';
        Leadins.DC_Lead_Status__c ='Recontacted';
        Leadins.Channel__c = 'Online';
        Leadins.Source__c = '';
        Leadins.City = 'Mumbai';
        Leadins.How_did_you_hear_about_us__c ='Online';
        Leadins.Campagin__c ='';
        Leadins.Knew_about_Design_Cafe_Because__c ='';
        Leadins.Source_Journey__c='';
        Leadins.LastName = 'test';
        Leadins.MobilePhone = '+910000000000';
        insert Leadins;        
        ContentVersion attach=new ContentVersion();
        attach.ContentLocation ='S';
        attach.Title = 'fileName';
        attach.PathOnClient = 'fileName';
        attach.VersionData  = EncodingUtil.base64Decode('JVBERi0xLjcKCjQgMCBvYmoKKElkZW50aXR5KQplbmRvYmoKNSAwIG9iagooQWRvYmUpCmVuZG9iago4IDAgb2JqCjw8Ci9GaWx0ZXIgL0ZsYXRlRGVjb2RlCi9MZW5ndGggMTgxMzMyCi9MZW5ndGgxIDU0MTU1MgovVHlwZSAvU3RyZWFtCj4');
        insert attach;
        getLeadFiles.filesWrap fw = new getLeadFiles.filesWrap();
        fw.leadId = Leadins.id;
     //   fw.CreatedDate = dt;
        fw.filebody = attach.VersionData;
        fw.fileName = attach.Title;
        string Versid =[SELECT Id, ContentDocumentId FROM ContentVersion where id=: attach.id].ContentDocumentId;
        
        ContentDocumentLink DocLink = new ContentDocumentLink();
        DocLink.ContentDocumentId = Versid;
        docLink.ShareType='V';
        DocLink.LinkedEntityId = Leadins.id;
        DocLink.Visibility='AllUsers';
        insert DocLink;
        
        RestRequest request = new RestRequest();
        request.httpMethod = 'GET';
        request.addHeader('Content-Type', 'application/json');
        request.addParameter('LeadId', Leadins.id);
        RestContext.request = request;
        RestResponse RestResponse = New RestResponse();
        RestResponse.statusCode = 200;
        RestContext.response = RestResponse;
        Test.startTest();
        getLeadFiles.retrieve();
        Test.stopTest();
        
    }
    
}