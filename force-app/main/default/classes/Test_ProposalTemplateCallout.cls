@istest
public class Test_ProposalTemplateCallout {
 
    @istest
    static void ProposalCallout_1(){

        YM_Invoice_Proposal_Template_Notify__c cuset = new YM_Invoice_Proposal_Template_Notify__c();
        cuset.Name = 'hardcodedfileds';
        cuset.bot__c = 'test';
        cuset.code__c = 'code';
        cuset.name__c = 'testing';
        cuset.namespace__c = 'test';
        cuset.ttl__c = '1234';
        cuset.type__c = 'test';
        cuset.policy__c = 'test';
        cuset.x_auth_token__c = 'tset';
        insert cuset;  
        
        YM_Invoice_Proposal_Template_Notify__c cuset1 = new YM_Invoice_Proposal_Template_Notify__c();
        cuset1.Name = 'proposalinteriorpdftemplate';
        cuset1.bot__c = 'test';
        cuset1.code__c = 'code';
        cuset1.name__c = 'testing';
        cuset1.namespace__c = 'test';
        cuset1.ttl__c = '1234';
        cuset1.type__c = 'test';
        cuset1.policy__c = 'test';
        cuset1.x_auth_token__c = 'tset';
        insert cuset1;  
        
        YM_Invoice_Proposal_Template_Notify__c cuset2 = new YM_Invoice_Proposal_Template_Notify__c();
        cuset2.Name = 'proposalcivilpdftemplate';
        cuset2.bot__c = 'test';
        cuset2.code__c = 'code';
        cuset2.name__c = 'testing';
        cuset2.namespace__c = 'test';
        cuset2.ttl__c = '1234';
        cuset2.type__c = 'test';
        cuset2.policy__c = 'test';
        cuset2.x_auth_token__c = 'tset';
        insert cuset2;
        
        YM_Invoice_Proposal_Template_Notify__c cuset3 = new YM_Invoice_Proposal_Template_Notify__c();
        cuset3.Name = 'proposalpptpdftemplate';
        cuset3.bot__c = 'test';
        cuset3.code__c = 'code';
        cuset3.name__c = 'testing';
        cuset3.namespace__c = 'test';
        cuset3.ttl__c = '1234';
        cuset3.type__c = 'test';
        cuset3.policy__c = 'test';
        cuset3.x_auth_token__c = 'tset';
        insert cuset3;
        
        String myJSON = '{"Mobile":"0000000000","otpverified":"yes","Channel_Type":"Online","Status":"Junk","Call_Stage__c":"Undialed"}';
        RestRequest request = new RestRequest();
        request.requestUri ='https://uat-designcafe.cs112.force.com/services/apexrest/dcleads';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueof(myJSON); 
        RestContext.request = request;
        RestResponse RestResponse = New RestResponse();
        RestResponse.statusCode = 200;
        RestContext.response = RestResponse;
        
        User thisUser = [select Id from User where Id = :UserInfo.getUserId()];
        
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Account ac = new Account();
        ac.RecordTypeId  = devRecordTypeId;
        ac.Lastname = 'APJ';
        ac.personMobilephone = '9381612129';
        ac.PersonEmail = 'test@gmail.com';
        ac.BillingStreet = 'Pylon Colony';
        ac.BillingCity = 'Vijayapuri Town';
        ac.BillingState = 'Maharashtra';
        ac.BillingCountry = 'INDIA';
        ac.BillingPostalCode = '400062';
        ac.Whatsapp_Opt_IN__c = true;
        insert ac;
        
        opportunity op = new opportunity();
        op.name = 'APJ~';
        op.AccountId = ac.Id;
        op.Amount = 500000;
        op.Signup_Amount__c = 90000;
        op.Client_s_Budget__c = 500000;
        op.Proposed_Budget__c = 500000;
        op.CloseDate = system.today()+5;
        op.Designer__c = thisUser.Id;
        op.Project_Name__c = 'Munna Villas';
        op.Region__c = 'Mumbai';
        op.StageName = 'Hot Prospect';
        op.Wohoo_Card__c = '87654345678';
        insert op;
        
        contentversion cv = new contentversion();
        cv.Title = 'Interior proposal';
        cv.WhatsApp_Int_Proposal__c = true;
        cv.WhatsApp_Civil_Proposal__c = false;
        cv.Whatsapp_PPT__c = false;
        cv.PathOnClient = '/' + cv.Title + '.pdf';
        Blob bodyBlob = Blob.valueOf('VersionData');
        cv.VersionData = bodyBlob;
        cv.origin = 'H';
        insert cv;
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.LinkedEntityId = op.id;
        cdl.ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id].ContentDocumentId;
        cdl.ShareType = 'V';
        insert cdl;
    }
    
    @istest
    static void ProposalCallout_2(){

        YM_Invoice_Proposal_Template_Notify__c cuset = new YM_Invoice_Proposal_Template_Notify__c();
        cuset.Name = 'hardcodedfileds';
        cuset.bot__c = 'test';
        cuset.code__c = 'code';
        cuset.name__c = 'testing';
        cuset.namespace__c = 'test';
        cuset.ttl__c = '1234';
        cuset.type__c = 'test';
        cuset.policy__c = 'test';
        cuset.x_auth_token__c = 'tset';
        insert cuset;  
        
        YM_Invoice_Proposal_Template_Notify__c cuset1 = new YM_Invoice_Proposal_Template_Notify__c();
        cuset1.Name = 'proposalinteriorpdftemplate';
        cuset1.bot__c = 'test';
        cuset1.code__c = 'code';
        cuset1.name__c = 'testing';
        cuset1.namespace__c = 'test';
        cuset1.ttl__c = '1234';
        cuset1.type__c = 'test';
        cuset1.policy__c = 'test';
        cuset1.x_auth_token__c = 'tset';
        insert cuset1;  
        
        YM_Invoice_Proposal_Template_Notify__c cuset2 = new YM_Invoice_Proposal_Template_Notify__c();
        cuset2.Name = 'proposalcivilpdftemplate';
        cuset2.bot__c = 'test';
        cuset2.code__c = 'code';
        cuset2.name__c = 'testing';
        cuset2.namespace__c = 'test';
        cuset2.ttl__c = '1234';
        cuset2.type__c = 'test';
        cuset2.policy__c = 'test';
        cuset2.x_auth_token__c = 'tset';
        insert cuset2;
        
        YM_Invoice_Proposal_Template_Notify__c cuset3 = new YM_Invoice_Proposal_Template_Notify__c();
        cuset3.Name = 'proposalpptpdftemplate';
        cuset3.bot__c = 'test';
        cuset3.code__c = 'code';
        cuset3.name__c = 'testing';
        cuset3.namespace__c = 'test';
        cuset3.ttl__c = '1234';
        cuset3.type__c = 'test';
        cuset3.policy__c = 'test';
        cuset3.x_auth_token__c = 'tset';
        insert cuset3;
        
        String myJSON = '{"Mobile":"0000000000","otpverified":"yes","Channel_Type":"Online","Status":"Junk","Call_Stage__c":"Undialed"}';
        RestRequest request = new RestRequest();
        request.requestUri ='https://uat-designcafe.cs112.force.com/services/apexrest/dcleads';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueof(myJSON); 
        RestContext.request = request;
        RestResponse RestResponse = New RestResponse();
        RestResponse.statusCode = 200;
        RestContext.response = RestResponse;
        
        User thisUser = [select Id from User where Id = :UserInfo.getUserId()];
        
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Account ac = new Account();
        ac.RecordTypeId  = devRecordTypeId;
        ac.Lastname = 'APJ';
        ac.personMobilephone = '9381612129';
        ac.PersonEmail = 'test@gmail.com';
        ac.BillingStreet = 'Pylon Colony';
        ac.BillingCity = 'Vijayapuri Town';
        ac.BillingState = 'Maharashtra';
        ac.BillingCountry = 'INDIA';
        ac.BillingPostalCode = '400062';
        ac.Whatsapp_Opt_IN__c = true;
        insert ac;
        
        opportunity op = new opportunity();
        op.name = 'APJ~';
        op.AccountId = ac.Id;
        op.Amount = 500000;
        op.Signup_Amount__c = 90000;
        op.Client_s_Budget__c = 500000;
        op.Proposed_Budget__c = 500000;
        op.CloseDate = system.today()+5;
        op.Designer__c = thisUser.Id;
        op.Project_Name__c = 'Munna Villas';
        op.Region__c = 'Mumbai';
        op.StageName = 'Hot Prospect';
        op.Wohoo_Card__c = '87654345678';
        insert op;
        
        contentversion cv = new contentversion();
        cv.Title = 'Interior proposal';
        cv.WhatsApp_Int_Proposal__c = false;
        cv.WhatsApp_Civil_Proposal__c = true;
        cv.Whatsapp_PPT__c = false;
        cv.PathOnClient = '/' + cv.Title + '.pdf';
        Blob bodyBlob = Blob.valueOf('VersionData');
        cv.VersionData = bodyBlob;
        cv.origin = 'H';
        insert cv;
        
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.LinkedEntityId = op.id;
        cdl.ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id].ContentDocumentId;
        cdl.ShareType = 'V';
        insert cdl;
    }
    
    @istest
    static void ProposalCallout_3(){

        YM_Invoice_Proposal_Template_Notify__c cuset = new YM_Invoice_Proposal_Template_Notify__c();
        cuset.Name = 'hardcodedfileds';
        cuset.bot__c = 'test';
        cuset.code__c = 'code';
        cuset.name__c = 'testing';
        cuset.namespace__c = 'test';
        cuset.ttl__c = '1234';
        cuset.type__c = 'test';
        cuset.policy__c = 'test';
        cuset.x_auth_token__c = 'tset';
        insert cuset;  
        
        YM_Invoice_Proposal_Template_Notify__c cuset1 = new YM_Invoice_Proposal_Template_Notify__c();
        cuset1.Name = 'proposalinteriorpdftemplate';
        cuset1.bot__c = 'test';
        cuset1.code__c = 'code';
        cuset1.name__c = 'testing';
        cuset1.namespace__c = 'test';
        cuset1.ttl__c = '1234';
        cuset1.type__c = 'test';
        cuset1.policy__c = 'test';
        cuset1.x_auth_token__c = 'tset';
        insert cuset1;  
        
        YM_Invoice_Proposal_Template_Notify__c cuset2 = new YM_Invoice_Proposal_Template_Notify__c();
        cuset2.Name = 'proposalcivilpdftemplate';
        cuset2.bot__c = 'test';
        cuset2.code__c = 'code';
        cuset2.name__c = 'testing';
        cuset2.namespace__c = 'test';
        cuset2.ttl__c = '1234';
        cuset2.type__c = 'test';
        cuset2.policy__c = 'test';
        cuset2.x_auth_token__c = 'tset';
        insert cuset2;
        
        YM_Invoice_Proposal_Template_Notify__c cuset3 = new YM_Invoice_Proposal_Template_Notify__c();
        cuset3.Name = 'proposalpptpdftemplate';
        cuset3.bot__c = 'test';
        cuset3.code__c = 'code';
        cuset3.name__c = 'testing';
        cuset3.namespace__c = 'test';
        cuset3.ttl__c = '1234';
        cuset3.type__c = 'test';
        cuset3.policy__c = 'test';
        cuset3.x_auth_token__c = 'tset';
        insert cuset3;
        
        String myJSON = '{"Mobile":"0000000000","otpverified":"yes","Channel_Type":"Online","Status":"Junk","Call_Stage__c":"Undialed"}';
        RestRequest request = new RestRequest();
        request.requestUri ='https://uat-designcafe.cs112.force.com/services/apexrest/dcleads';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueof(myJSON); 
        RestContext.request = request;
        RestResponse RestResponse = New RestResponse();
        RestResponse.statusCode = 200;
        RestContext.response = RestResponse;
        
        User thisUser = [select Id from User where Id = :UserInfo.getUserId()];
        
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Account ac = new Account();
        ac.RecordTypeId  = devRecordTypeId;
        ac.Lastname = 'APJ';
        ac.personMobilephone = '9381612129';
        ac.PersonEmail = 'test@gmail.com';
        ac.BillingStreet = 'Pylon Colony';
        ac.BillingCity = 'Vijayapuri Town';
        ac.BillingState = 'Maharashtra';
        ac.BillingCountry = 'INDIA';
        ac.BillingPostalCode = '400062';
        ac.Whatsapp_Opt_IN__c = true;
        insert ac;
        
        opportunity op = new opportunity();
        op.name = 'APJ~';
        op.AccountId = ac.Id;
        op.Amount = 500000;
        op.Signup_Amount__c = 90000;
        op.Client_s_Budget__c = 500000;
        op.Proposed_Budget__c = 500000;
        op.CloseDate = system.today()+5;
        op.Designer__c = thisUser.Id;
        op.Project_Name__c = 'Munna Villas';
        op.Region__c = 'Mumbai';
        op.StageName = 'Hot Prospect';
        op.Wohoo_Card__c = '87654345678';
        insert op;
        
        contentversion cv = new contentversion();
        cv.Title = 'Interior proposal';
        cv.WhatsApp_Int_Proposal__c = false;
        cv.WhatsApp_Civil_Proposal__c = false;
        cv.Whatsapp_PPT__c = true;
        cv.PathOnClient = '/' + cv.Title + '.pdf';
        Blob bodyBlob = Blob.valueOf('VersionData');
        cv.VersionData = bodyBlob;
        cv.origin = 'H';
        insert cv;

        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.LinkedEntityId = op.id;
        cdl.ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id].ContentDocumentId;
        cdl.ShareType = 'V';
        insert cdl;
    }  
}