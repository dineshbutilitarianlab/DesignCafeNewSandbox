public with sharing class PaymentReceipt {
     
    @AuraEnabled
    public static createPaymentReceiptWrap createPaymentReceiptBody(String recId) {
        
        InvPayList = [Select Id, Name, RP_Recipt_ID__c, Received_amount__c, Mode_of_Receipt__c, Date_of_Payment__c, Request_Payment_Modular__c, Request_Payment_SiteService__c, 
                      Opportunity_Name__r.Customer_ID__c, paymentID__c, Modular_value__c,
                      Site_Service_value__c  From Invoice_Payment__c where Opportunity_Name__r.Id =:recId ORDER BY CreatedDate DESC];
        
        createPaymentReceiptWrap payWrp = new createPaymentReceiptWrap();
        payWrp.transactionId = InvPayList[0].RP_Recipt_ID__c;
        payWrp.projectID = InvPayList[0].Opportunity_Name__r.Customer_ID__c;
        payWrp.clientID = InvPayList[0].Opportunity_Name__r.Customer_ID__c;
        payWrp.receivedAmount = HelperClass.getInteger(InvPayList[0].Received_amount__c);
        payWrp.paymentMode = InvPayList[0].Mode_of_Receipt__c;
        payWrp.paymentReceivedDate = InvPayList[0].Date_of_Payment__c;
        payWrp.modularAmount = HelperClass.getInteger(InvPayList[0].Modular_value__c);
        payWrp.siteServicesAmount = HelperClass.getInteger(InvPayList[0].Site_Service_value__c);
        // Add the request payments to the list
        payWrp.paymentRequests = new List<string>();
        payWrp.paymentRequests.add(InvPayList[0].Request_Payment_Modular__c);
        payWrp.paymentRequests.add(InvPayList[0].Request_Payment_SiteService__c);
        return payWrp;
    }
    
    public static updatePaymentReceiptWrap updatePaymentReceiptBody(String recId) {
        
        InvPayList = [Select Id, Name, RP_Recipt_ID__c, Received_amount__c, Mode_of_Receipt__c, Date_of_Payment__c, Request_Payment_SiteService__c, Request_Payment_Modular__c,
                      Opportunity_Name__r.Customer_ID__c, PaymentID__c, LastModifiedDate, Modular_value__c, Site_Service_value__c 
                      From Invoice_Payment__c where Opportunity_Name__r.Id =:recId ORDER BY LastModifiedDate DESC ];
        
        // reqpList = [select Id,Request_Id__c,Category__c From Request_Payment__c where Opportunity__r.id =:recId ];
        system.debug('InvPayList:'+InvPayList);
        updatePaymentReceiptWrap payWrp = new updatePaymentReceiptWrap();
        
        payWrp.transactionId = InvPayList[0].RP_Recipt_ID__c;
        payWrp.projectID = InvPayList[0].Opportunity_Name__r.Customer_ID__c;
        payWrp.clientID = InvPayList[0].Opportunity_Name__r.Customer_ID__c;
        payWrp.receivedAmount = HelperClass.getInteger(InvPayList[0].Received_amount__c);
        payWrp.paymentMode = InvPayList[0].Mode_of_Receipt__c;
        payWrp.paymentReceivedDate = InvPayList[0].Date_of_Payment__c;
        payWrp.paymentId = InvPayList[0].paymentID__c;
        // Add the request payments to the list
        payWrp.paymentRequests = new List<string>();
        payWrp.paymentRequests.add(InvPayList[0].Request_Payment_Modular__c);
        payWrp.paymentRequests.add(InvPayList[0].Request_Payment_SiteService__c);
        payWrp.modularAmount = HelperClass.getInteger(InvPayList[0].Modular_value__c);
        payWrp.siteServicesAmount = HelperClass.getInteger(InvPayList[0].Site_Service_value__c);
        
        
        return payWrp;
    }
    
    public static list<Invoice_Payment__c> InvPayList {get;set;}
    @AuraEnabled
    public static List<ResponseToBeSentToAura> addPaymentReceipt(String recId) {
        List<ResponseToBeSentToAura> responsesToBeSentToAura = new List<ResponseToBeSentToAura>();
        
        Opportunity opp = [Select Id, Name, AccountId, Account.Customer_created_on_Odoo__c, Project_Created_On_Odoo__c, 
                           IsNewPaymentProject__c From Opportunity where Id =: recId LIMIT 1];
        
        InvPayList = [Select Id, paymentID__c From Invoice_Payment__c where Opportunity_Name__r.Id =:recId ORDER BY CreatedDate DESC];
        
        ResponseToBeSentToAura errorResponseToBeSentToAura = new ResponseToBeSentToAura();
        //Calling validation API
        ValidationOnPaymi.ResponseToBeSentToAura ValidationMessage = new ValidationOnPaymi.ResponseToBeSentToAura();
        ValidationMessage = ValidationOnPaymi.validationMethod(recId);
        errorResponseToBeSentToAura.errorMessage = ValidationMessage.errorMessage;
        responsesToBeSentToAura.add(errorResponseToBeSentToAura);
        System.debug('ValidationMessage '+ValidationMessage);
        System.debug('errorResponseToBeSentToAura.errorMessage '+errorResponseToBeSentToAura.errorMessage);
        System.debug('responsesToBeSentToAura '+responsesToBeSentToAura);
        if (ValidationMessage.validationPass) {}
            // Comment on 22 August 2024 by Muskan Jain, request by DD Team , will not being used in salesforce.
        	/*CreateCustomer.CreateCustomerResponse custResp = new CreateCustomer.CreateCustomerResponse();
            RequestPaymentCreateProject.CreateProjectResponse createProjResp = new RequestPaymentCreateProject.CreateProjectResponse();
            ResponseToBeSentToAura OtherApisResp = new ResponseToBeSentToAura();
            
            Account acc = new Account (); 
            ResponseWrapper responseWrap = new ResponseWrapper();
            // Create Customer API (If not already created)
            if ((opp.Account.Customer_created_on_Odoo__c == false) && (opp != null)) {
                custResp = CreateCustomer.addCustomer(recId);
                responseWrap.customerResp = custResp;
                // Set the flag "Customer created on oddo" to True, if the API returned success.
                if ((custResp != null) && (custResp.statusCode == '200')) {
                    acc.Id = opp.AccountId;
                    acc.Customer_created_on_Odoo__c = true;
                }
                else if((custResp != null) && (custResp.statusCode != '200')) {
                    OtherApisResp.CustomerRespToAuraMsg = custResp.message;
                    OtherApisResp.CustomerRespToAuraStatuscode = custResp.statusCode;
                }
                else {
                    OtherApisResp.CustomerRespToAuraMsg = 'Create Customer API failed';
                    OtherApisResp.CustomerRespToAuraStatuscode = '400';
                }
            }
            
            // Create Project API (If not already created)
            if (((opp.Project_Created_On_Odoo__c == false) && (opp != null)) && ((acc.Customer_created_on_Odoo__c == True) || 
				(opp.Account.Customer_created_on_Odoo__c == True))) {
                // Comment on 22 August 2024 by Muskan Jain, request by DD Team , will not being used in salesforce.
        		createProjResp = RequestPaymentCreateProject.createProjectRequest(recId);
                responseWrap.projectResp = createProjResp;
                // Set the flag "Project_Created_On_Odoo__c" to True, if the API returned success.
                if ((createProjResp != null) && (createProjResp.statusCode == '200')) {
                    opp.Project_Created_On_Odoo__c = true;
                    opp.IsNewPaymentProject__c = true;
                }
                else if((createProjResp != null) && (createProjResp.statusCode != '200')) {
                    OtherApisResp.ProjectRespToAuraMsg = createProjResp.message;
                    OtherApisResp.ProjectRespToAuraStatuscode = createProjResp.statusCode;
                }
                else {
                    OtherApisResp.ProjectRespToAuraMsg = 'Create Project API failed';
                    OtherApisResp.ProjectRespToAuraStatuscode = '400';
                }
            }
            responsesToBeSentToAura.add(OtherApisResp);
            
            // Now call the CreatePaymentReciept API : If the project has been created.
            // We need to query this, because we need to Delete the Payment Record in case of error with Project/Customer
            if ((opp.Project_Created_On_Odoo__c == True) && (recId != null) &&
				((acc.Customer_created_on_Odoo__c == True) || (opp.Account.Customer_created_on_Odoo__c == True))) {
                //Calling authentication API
                MicroservicesAuthentication.ResponseDataOfAuth MicroAuthResp = new MicroservicesAuthentication.ResponseDataOfAuth();
                //Calling MicroserviceAuthentication API
                MicroAuthResp = MicroservicesAuthentication.AuthApi();
                PaymentReceiptResponse respData;
                if(MicroAuthResp.accessToken != null){
                    createPaymentReceiptWrap createReceiptBody = new createPaymentReceiptWrap();
                    createReceiptBody = createPaymentReceiptBody(recId);
                    system.debug('TestrecId::'+createReceiptBody);
                    system.debug('Request payment:'+createReceiptBody.paymentRequests);
                    
                    // If PaymentID is Not Null, the payment is sent by backend; so don't call the API 
                    if(InvPayList[0].paymentID__c == null) {
                        HttpRequest request = new HttpRequest();
                        String endpoint = System.label.CreatePaymentReceiptAPIURL;
                        request.setEndpoint(endpoint);
                        request.setTimeout(90000);
                        request.setMethod('POST');
                        request.setHeader('Content-Type', 'application/json');
                        request.setHeader('Authorization', MicroAuthResp.accessToken);
                        String jsonBody = JSON.serialize(createReceiptBody);
                        System.debug('PaymentReceipt: SendPaymentReceiptReq: ---Insert--jsonBody----'+jsonBody);
                        request.setBody(jsonBody);
                        Http http = new Http();
                        System.debug('PaymentReceipt: SendPaymentReceiptReq: ---Insert--request----'+request);
                        HttpResponse response = http.send(request);
                        System.debug('PaymentReceipt: PaymentReceiptReq: ---Insert--response----'+response.getBody());
                        respData = (PaymentReceiptResponse)JSON.deserialize(response.getBody(), PaymentReceiptResponse.class);
                        System.debug('respData:: '+respData);
                        //Calling ApiCallLogger class
                        ApiCallLogger.method(recID, request.getEndpoint(), jsonBody, response.getBody(), 'out');
                        string StatusCode = respData.statusCode;
                        string ResponseMessage = respData.message;
                        system.debug('Stauscode:' +StatusCode);
                        system.debug('ResponseMessage:' +ResponseMessage);
                        ResponseToBeSentToAura PaymentRespToBeSentToAura = new ResponseToBeSentToAura();
                        if((respData != null) && (respData.data != null) && (respData.data.paymentID != null)) { 
                            PaymentRespToBeSentToAura.APIresptoAura = respData.message;
                            PaymentRespToBeSentToAura.APIcodetoAura = respData.statusCode;
                            system.debug('payment ID: ' +respData.data.paymentID);
                            InvPayList[0].paymentID__c = respData.data.paymentID;
                            update InvPayList[0];
                        }
                        //If the Create Payment Receipt Api Has Failed Then Delete Payment Record 
                        else if((respData == null) || (respData.statusCode != '200') || (respData.statusCode == null)) {
                            if(!Test.isRunningTest()) {
                                delete InvPayList[0];
                            }
                        }
                        PaymentRespToBeSentToAura.APIresptoAura = respData.message;
                        PaymentRespToBeSentToAura.APIcodetoAura = respData.statusCode;
                        system.Debug('PaymentReciept: PaymentReceiptReq: Null Response!');
                        respData.code='400'; 
                        responsesToBeSentToAura.add(PaymentRespToBeSentToAura);
                    } 
                } // IF : Authentication 
                else {
                    system.debug('Authentication: Customer Authentication: Null Response! ');
                    respData.code = MicroAuthResp.code;
                    respData.message = MicroAuthResp.message;
                }
            }	// IF : Issue with Project or Customer APIs
            else if ((InvPayList[0].paymentID__c == null) || ((custResp != null) && (custResp.statusCode != '200'))) {
                if (!Test.isRunningTest()) {
                    delete InvPayList[0];
                }
            }
            if ((custResp != null) && (custResp.statusCode == '200')) {
                update acc;
            }
            // Comment on 22 August 2024 by Muskan Jain, request by DD Team , will not being used in salesforce.
        	if (((createProjResp != null) && (createProjResp.statusCode == '200'))  && (!Test.isRunningTest())) {
                update opp;
            }
        } // IF: Validation Passed
        else if (!Test.isRunningTest()) {
            delete InvPayList[0];
        }*/
        // Comment on 22 August 2024 by Muskan Jain, request by DD Team , will not being used in salesforce.
        return responsesToBeSentToAura;
    }
    @future(callout = true)
    public static void UpdatePaymentReceipt(String recId, String oldId) {
        //Calling authentication API
        MicroservicesAuthentication.ResponseDataOfAuth MicroAuthResp = new MicroservicesAuthentication.ResponseDataOfAuth();
        //Calling MicroserviceAuthentication API
        MicroAuthResp = MicroservicesAuthentication.AuthApi();
        PaymentReceiptResponse respData;
        
        if (MicroAuthResp.accessToken != null) {
            updatePaymentReceiptWrap updateReceiptBody = new updatePaymentReceiptWrap();
            updateReceiptBody = updatePaymentReceiptBody(recId);
            
            system.debug('Data: ' +updateReceiptBody);
            if(updateReceiptBody.paymentId == oldId){
                HttpRequest request = new HttpRequest();
                String endpoint = System.label.UpdatePaymentReceiptAPIURL;
                request.setEndpoint(endpoint);
                request.setTimeout(90000);
                request.setMethod('PUT');
                request.setHeader('Content-Type', 'application/json');
                request.setHeader('Authorization', MicroAuthResp.accessToken);
                
                String jsonBody = JSON.serialize(updateReceiptBody);
                System.debug('PaymentReceipt: SendPaymentReceipt: ---Update--jsonBody----'+jsonBody);
                request.setBody(jsonBody);
                Http http = new Http();
                System.debug('PaymentReceipt: SendPaymentReceipt: ---Update--request----'+request);
                HttpResponse response = http.send(request);
                System.debug('PaymentReceipt: PaymentReceiptReq: ---Update--response----'+response.getBody());
                respData = (PaymentReceiptResponse)JSON.deserialize(response.getBody(), PaymentReceiptResponse.class);
                System.debug('respData:: '+respData);
                //Calling ApiCallLogger class
                ApiCallLogger.method(recID, request.getEndpoint(), jsonBody, response.getBody(), 'out');
                if((respData != null) && (respData.data != null) && (respData.data.paymentID != null)) {   
                    system.debug('payment ID: ' +respData.data.paymentID); 
                }
                else {
                    system.Debug('RequestPayment: SendPaymentReq: Null Response!');
                    respData.code='400';
                }
            }
        }
        // IF : Authentication
        if (MicroAuthResp.accessToken == null) {
            system.debug('Authentication: Customer Authentication: Null Response! ');
            system.debug('Rsponse-'+MicroAuthResp);
            if (MicroAuthResp.code != null) {
            	respData.code = MicroAuthResp.code;    
            }
            if (MicroAuthResp.message != null){
            	respData.message = MicroAuthResp.message;    
            }
        }
    }
    
    @future(callout = true)
    public static void DeletePaymentReceipt(String recId) {
        
        //Calling authentication API
        MicroservicesAuthentication.ResponseDataOfAuth MicroAuthResp = new MicroservicesAuthentication.ResponseDataOfAuth();
        //Calling MicroserviceAuthentication API
        MicroAuthResp = MicroservicesAuthentication.AuthApi();
        PaymentReceiptResponse respData;
        
        if(MicroAuthResp.accessToken != null) { 
            deletePaymentReceiptWrap deleteReceiptBody = new deletePaymentReceiptWrap();
            deleteReceiptBody.paymentId = recId;
            
            system.debug('Data: ' +deleteReceiptBody);
            
            HttpRequest request = new HttpRequest();
            String endpoint = System.label.DeletePaymentReceiptAPIURL;
            request.setEndpoint(endpoint);
            request.setTimeout(90000);
            request.setMethod('DELETE');
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Authorization', MicroAuthResp.accessToken);
            
            String jsonBody = JSON.serialize(deleteReceiptBody);
            System.debug('PaymentReceipt: SendPaymentReceiptReq: ---Insert--jsonBody----'+jsonBody);
            request.setBody(jsonBody);
            Http http = new Http();
            System.debug('PaymentReceipt: SendPaymentReceiptReq: ---Insert--request----'+request);
            HttpResponse response = http.send(request);
            System.debug('PaymentReceipt: PaymentReceiptReq: ---Insert--response----'+response.getBody());
            respData = (PaymentReceiptResponse)JSON.deserialize(response.getBody(), PaymentReceiptResponse.class);
            System.debug('respData:: '+respData);
            //Calling ApiCallLogger class
            ApiCallLogger.method(recID, request.getEndpoint(), jsonBody, response.getBody(), 'out');
            if((respData != null) && (respData.data != null) && (respData.data.paymentID != null)) {   
                system.debug('payment ID: ' +respData.data.paymentID);
            }
            else {
                system.Debug('RequestPayment: SendPaymentReq: Null Response!');
                respData.code='400';
            }    
        }	// IF: Authentication
        if (MicroAuthResp.accessToken == null) {
            system.debug('Authentication: Customer Authentication: Null Response! ');
            respData.code = MicroAuthResp.code;
            respData.message = MicroAuthResp.message;
        }
    }
    
        
  @AuraEnabled
    // File Attachment : Method to Attach Files to the payment record (docIdsToInsert).
    // 					: While adding new files, provision to deleted the previously uploaded files (docIdsToDelete).
    public static String insertAttachDetails(String invoiceId, List<String> docIdsToDelete, List<String> docIdsToInsert){
        List<ContentDocumentLink> contDocLinkList = new List<ContentDocumentLink>();
        try{
            if(docIdsToInsert.size()>0){
                for(String docId : docIdsToInsert){
                    ContentDocumentLink cd = new ContentDocumentLink();
                    cd.LinkedEntityId = invoiceId;
                    cd.ContentDocumentId =docId;
                    cd.ShareType ='V';
                    contDocLinkList.add(cd);
                }
            }
            if(contDocLinkList.size()>0){
                System.debug('contDocLinkList:: '+contDocLinkList);
                INSERT contDocLinkList;
                if(docIdsToDelete.size()>0){
                    DELETE[SELECT Id FROM ContentDocument WHERE Id IN : docIdsToDelete];
                }
                return 'success';         
            }
        }catch(DmlException e){
            System.debug('exception::'+e );
            System.debug('error during content doc insertion or del:: '+e.getMessage());
            System.debug('error at line number during content doc insertion or del:: '+e.getLineNumber());
			//return null;
        }
        return null;
    }
    
    @AuraEnabled
    // To Delete the files "uploaded" but not yet "attached" to the record.
    public static String deleteFileRecords(List<String>idsToBeDeleted){
        try{
            if(idsToBeDeleted.size()>0){
                DELETE[SELECT Id FROM ContentDocument WHERE Id IN : idsToBeDeleted];
                return 'success';
            } 
        }catch(DmlException e){
            System.debug('exception::'+e );
            System.debug('error during content doc Delete:: '+e.getMessage());
            System.debug('error at line number during Delete:: '+e.getLineNumber());
            //return null; 
        }
        return null;
        
    }

    
    public class createPaymentReceiptWrap{
        @AuraEnabled
        public String transactionId {get;set;}  //TR-1234
        @AuraEnabled
        public String projectID {get;set;}  //DC-35822
        @AuraEnabled
        public String clientID {get;set;}   //DC-35822
        @AuraEnabled
        public Decimal receivedAmount {get;set;}    //200
        @AuraEnabled
        public String paymentMode {get;set;}    //razorpay
        @AuraEnabled
        public Date paymentReceivedDate {get;set;}  //2022-01-03
        @AuraEnabled
        public List<string> paymentRequests {get;set;}
        @AuraEnabled
        public Decimal modularAmount {get;set;}
        @AuraEnabled
        public Decimal siteServicesAmount {get;set;} 
    }
    
    public class updatePaymentReceiptWrap{
        @AuraEnabled
        public String transactionId {get;set;}  //TR-1234
        @AuraEnabled
        public String projectID {get;set;}  //DC-35822
        @AuraEnabled
        public String clientID {get;set;}   //DC-35822
        @AuraEnabled
        public Decimal receivedAmount {get;set;}    //200
        @AuraEnabled
        public String paymentMode {get;set;}    //razorpay
        @AuraEnabled
        public Date paymentReceivedDate {get;set;}  //2022-01-03
        @AuraEnabled
        public List<string> paymentRequests {get;set;}
        @AuraEnabled
        public string paymentId {get;set;}
        @AuraEnabled
        public Decimal modularAmount {get;set;}
        @AuraEnabled
        public Decimal siteServicesAmount {get;set;} 
    }
    
    public class Authwrap{
        @AuraEnabled
        public string clientId {get;set;}   
    }
    public class deletePaymentReceiptWrap{
        @AuraEnabled
        public string paymentId {get;set;}
    }
    
    Public class PaymentReceiptResponse{
        @AuraEnabled
        public string statusCode;
        @AuraEnabled
        public string code;
        @AuraEnabled
        public string message;
        @AuraEnabled
        public responsedata data;
        @AuraEnabled
        public string accessToken;
    }
    public class responsedata{
        @AuraEnabled
        public string paymentID;
    }
    
    public class ResponseToBeSentToAura{
        @AuraEnabled
        public integer status;
        @AuraEnabled
        public String APIresptoAura;
        @AuraEnabled
        public String APIcodetoAura;
        @AuraEnabled
        public string errorMessage;
        @AuraEnabled
        public string invoiceType;
        @AuraEnabled
        public string accessToken;
        @AuraEnabled
        public string CustomerRespToAuraMsg;
        @AuraEnabled
        public string ProjectRespToAuraMsg;
        @AuraEnabled
        public string CustomerRespToAuraStatuscode;
        @AuraEnabled
        public string ProjectRespToAuraStatuscode;
    }
    
    public class ResponseWrapper{
        @AuraEnabled 
        public CreateCustomer.CreateCustomerResponse customerResp;
        // Comment on 22 August 2024 by Muskan Jain, request by DD Team , will not being used in salesforce.
        /*@AuraEnabled 
        public RequestPaymentCreateProject.CreateProjectResponse projectResp;*/
    }
	
}