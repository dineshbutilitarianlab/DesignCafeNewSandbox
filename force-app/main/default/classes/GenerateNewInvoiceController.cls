public class GenerateNewInvoiceController {
   public static list<Opportunity_Invoice__c> OppInvList = new List<Opportunity_Invoice__c>();
    
    public class invoiceDataWrap{
        @AuraEnabled
        public String milestone{get;set;}
        @AuraEnabled
        public decimal currentProjectValue{get;set;}
        @AuraEnabled
        public String clientID{get;set;}
        @AuraEnabled
        public String category{get;set;}
        @AuraEnabled
        public decimal currentModularValue{get;set;}
        @AuraEnabled
        public decimal currentSiteServicesValue{get;set;}
        @AuraEnabled
        public decimal baseAmount{get;set;}
        @AuraEnabled
        public decimal additionalCharge{get;set;}
        @AuraEnabled
        public String status{get;set;}
    }
    
    public class invoiceDataListWrap{
        public invoiceDataWrap invoiceData{get;set;}
    }
    
    public class ResponseToBeSentToAura{
        @AuraEnabled
        public integer status;
        @AuraEnabled
        public InvoiceWrapper invoice;
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
    
    Public class InvAuthwrap{
        @AuraEnabled
        Public string clientId {get;set;}   
    }
    
    public class ResponseWrapper{
        @AuraEnabled 
        public CreateCustomer.CreateCustomerResponse customerResp;
        /*@AuraEnabled 
        public RequestPaymentCreateProject.CreateProjectResponse projectResp;*/
    }
    
    @AuraEnabled
    public static double baseAmountFromInvoiceAmount(double invoiceAmount, boolean is_pm_and_site) {
        decimal baseAmount = (invoiceAmount * 100) / 118;
        return baseAmount;
    }
        
    @AuraEnabled
    public static string showbutton(String oppId){
        List<Opportunity_Invoice__c> invList = [select id from Opportunity_Invoice__c where Opportunity__c =: oppId]; 
        if(invList.size() == 0){
            return 'Enabled';
        }
        else{
            return 'Disabled';
        }
    }
    
    @AuraEnabled
    public static List<ResponseToBeSentToAura> generateInvoice(String oppId, Integer invType){
        // Integer invType : 
        //      0 : For generating both Site and modular inv.
        //      1 : For generating only SiteService Invoice.
        //      2 : For generating only Modular Invoice.
      //  Boolean IsNewPaymentChanged = false;
        system.debug('oppId '+oppId); 
        List<ResponseToBeSentToAura> responsesToBeSentToAura = new List<ResponseToBeSentToAura>();
        
        opportunity opp = [SELECT id, name, Amount, Customer_ID__c, First_SiteService_Milestone_Pct__c, First_Modular_Milestone_Percentage__c,
                           Modular_Milestone_Type__c, Modular_Amount_Dis_Incl_GST__c, Site_Services_Amount_Dis_Incl_GST__c, Decor_Amount_Incl_GST__c,
                           Is_Pm_Site__c, Region__c, Account.BillingCountry, Account.BillingState, Account.BillingCity,Account.BillingStreet, Account.BillingPostalCode,
                           Account.ShippingCountry, Account.ShippingState, Account.ShippingCity,Account.ShippingStreet, Account.ShippingPostalCode,
                           Account.GST_No__c, Account.PAN__c,Account.Customer_type__c, AccountId, Account.Customer_created_on_Odoo__c, 
                           Project_Created_On_Odoo__c,IsNewPaymentProject__c, IsInvoiceGenerated__c FROM Opportunity WHERE id = :oppId limit 1];
        
        List<Opportunity_Invoice__c> ExistingInvList = new List<Opportunity_Invoice__c>();
        ExistingInvList = [SELECT id, Opportunity__c FROM Opportunity_Invoice__c WHERE Opportunity__c = :oppId limit 1]; 
        
        system.debug('ExistingInvList : ' + ExistingInvList + '... Isempty? ' + ExistingInvList.isEmpty() + 'invType : ' + invType);
        // Return if the Opportunity already exists and the call has been made from aura.
        if ((!ExistingInvList.isEmpty()) && (invType == 0)) {
            ResponseToBeSentToAura errorResponseToBeSentToAura = new ResponseToBeSentToAura();
            errorResponseToBeSentToAura.errorMessage = 'Invoice already exists for the current Opportunity';
            responsesToBeSentToAura.add(errorResponseToBeSentToAura);
            errorResponseToBeSentToAura.invoiceType = 'Validation';
            return responsesToBeSentToAura;
        }
        
        CreateCustomer.CreateCustomerResponse custResp = new CreateCustomer.CreateCustomerResponse();
        ResponseToBeSentToAura siteResponseToBeSentToAura = new ResponseToBeSentToAura();
        ResponseToBeSentToAura modularResponseToBeSentToAura = new ResponseToBeSentToAura();
        // Comment on 22 August 2024 by Muskan Jain, request by DD Team , will not being used in salesforce.
        //RequestPaymentCreateProject.CreateProjectResponse createProjResp = new RequestPaymentCreateProject.CreateProjectResponse();
        ResponseToBeSentToAura OtherApisResp = new ResponseToBeSentToAura();
        
        ResponseWrapper responseWrap = new ResponseWrapper();
        Account acc = new Account();    
        // Create Customer API
        if ((opp.Account.Customer_created_on_Odoo__c == false) && (opp != null)) {
            system.debug('oppId 95:'); 
            custResp = CreateCustomer.addCustomer(oppId);
            responseWrap.customerResp = custResp;
            system.debug('Customer Response:' +custResp);
            // Set the flag "Customer created on oddo" to True, if the API returned success.
            if ((custResp != null) && (custResp.statusCode == '200')) {
                system.debug('oppId 100:'); 
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
        
        
        // Create Project API
        if ((opp.Project_Created_On_Odoo__c == false) && (opp != null) && ((acc.Customer_created_on_Odoo__c == True) || (opp.Account.Customer_created_on_Odoo__c == True))) {
            /*createProjResp = RequestPaymentCreateProject.createProjectRequest(oppId);
            responseWrap.projectResp = createProjResp;
            system.debug('Create Project Response:' +createProjResp);
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
            }*/
        }
        responsesToBeSentToAura.add(OtherApisResp);
        if ((opp.Project_Created_On_Odoo__c == True) && (oppId != null) && ((acc.Customer_created_on_Odoo__c == True) || (opp.Account.Customer_created_on_Odoo__c == True))) {
            system.debug('GenerateInvoice : callServer : Opportunity : ' + opp);
            invoiceDataWrap modularInvoice = new invoiceDataWrap();
            invoiceDataWrap siteInvoice = new invoiceDataWrap();

            
            if(opp != null) {
                modularInvoice.milestone = String.valueof(opp.First_Modular_Milestone_Percentage__c) + '%';
                siteInvoice.milestone = String.valueof(opp.First_SiteService_Milestone_Pct__c) + '%';
            }
            if(opp.Customer_ID__c != null) {
                modularInvoice.clientID = siteInvoice.clientId = opp.Customer_ID__c;
            }
            if(opp.Amount != null){
                modularInvoice.currentProjectValue = siteInvoice.currentProjectValue = HelperClass.getInteger(opp.Amount);
            }
            else {
                modularInvoice.currentProjectValue = siteInvoice.currentProjectValue = 0;
            }
            if(opp != null){
                modularInvoice.category = System.Label.Modular_Category;
                System.debug('MOdular cat' +System.Label.Modular_Category);
                siteInvoice.category = System.Label.SiteServices_Category;
                System.debug('siteservice cat' +System.Label.SiteServices_Category);
            }
            if(opp.Modular_Amount_Dis_Incl_GST__c != null){
                modularInvoice.currentModularValue = siteInvoice.currentModularValue = HelperClass.getInteger(opp.Modular_Amount_Dis_Incl_GST__c);
            }
            else {
                modularInvoice.currentModularValue = siteInvoice.currentModularValue = 0;
            }
            if(opp.Site_Services_Amount_Dis_Incl_GST__c  != null){
                modularInvoice.currentSiteServicesValue = siteInvoice.currentSiteServicesValue = HelperClass.getInteger(opp.Site_Services_Amount_Dis_Incl_GST__c);
            }
            else {
                modularInvoice.currentSiteServicesValue = siteInvoice.currentSiteServicesValue = 0;
            }
            // TODO: This param needs to be removed.
            modularInvoice.additionalCharge = siteInvoice.additionalCharge = 0;
            if(opp != null){
                Boolean is_pm_site_value_added = (opp.Is_Pm_Site__c);
                system.debug('PM Site Value Calculated : ' + is_pm_site_value_added + ' opp.Is_Pm_Site__c : ' + opp.Is_Pm_Site__c + ' opp.Region__c: ' + opp.Region__c);
                
                double modularAmount5pct = (modularInvoice.currentModularValue * opp.First_Modular_Milestone_Percentage__c)/100;
                double siteAmount5pct = (siteInvoice.currentSiteServicesValue * opp.First_SiteService_Milestone_Pct__c)/100;
                modularInvoice.baseAmount = HelperClass.getInteger(baseAmountFromInvoiceAmount(modularAmount5pct, is_pm_site_value_added));
                siteInvoice.baseAmount = HelperClass.getInteger(baseAmountFromInvoiceAmount(siteAmount5pct, is_pm_site_value_added));
            }
            if(opp != null){
                siteInvoice.status = modularInvoice.status = System.Label.Status_Draft;
            }
            
            system.debug('GenerateInvoice: MAIN : siteInvoice : ' + siteInvoice);
            system.debug('GenerateInvoice: MAIN : modularInvoice : ' + modularInvoice);
            ResponseToBeSentToAura errorResponseToBeSentToAura = new ResponseToBeSentToAura();
            //Calling validation API
            ValidationOnPaymi.ResponseToBeSentToAura ValidationMessage = new ValidationOnPaymi.ResponseToBeSentToAura();
            ValidationMessage = ValidationOnPaymi.validationMethod(oppId);
            errorResponseToBeSentToAura.errorMessage = ValidationMessage.errorMessage;
            responsesToBeSentToAura.add(errorResponseToBeSentToAura);
            
            system.debug('TEST opp:'+opp);
            system.debug('TEST is Validation pass:'+ValidationMessage.validationPass);
            system.debug('TEST Invoice:'+siteInvoice.currentSiteServicesValue);
            
            // Call the SiteService API if value > 0
            siteResponseToBeSentToAura.invoiceType = 'SiteServices';
            if ((opp != null) && ValidationMessage.validationPass && (siteInvoice.currentSiteServicesValue > 0) && (invType != 2))
            {
                system.debug('TEST Invoice:'+siteInvoice.currentSiteServicesValue);
                InvoiceWrapper siteInvWrap;
                invoiceDataListWrap siteInvoiceWrap = new invoiceDataListWrap();
                siteInvoiceWrap.invoiceData = siteInvoice;
                try {
                    siteInvWrap = callAPI(opp, siteInvoiceWrap);
                    if ((siteInvWrap != null) && (siteInvWrap.OppInvoice != null)) {
                        system.debug('Opportunity site invoice : ' +siteInvWrap.OppInvoice);
                        siteInvWrap.OppInvoice.category__c = 'Site Services';
                        OppInvList.add(siteInvWrap.OppInvoice);
                    }
                    siteResponseToBeSentToAura.APIresptoAura = siteInvWrap.APIResp;
                    siteResponseToBeSentToAura.APIcodetoAura = siteInvWrap.APICode;
                    system.debug('code:' + siteResponseToBeSentToAura.APIcodetoAura);
                    system.debug('message:' + siteInvWrap.APIResp);
                }
                catch (Exception Ex) {
                    system.debug('GenerateInvoiceNew : Exception occured at line number :' + Ex.getLineNumber() + ' in API call. Message : ' + Ex.getMessage());
                    
                    siteResponseToBeSentToAura.status = 500;
                    siteResponseToBeSentToAura.errorMessage = Ex.getMessage();
                }
            }
            
            responsesToBeSentToAura.add(siteResponseToBeSentToAura);
            
            // Call Modular Invoice API if modularvalue > 0
            modularResponseToBeSentToAura.invoiceType = 'Modular';
            if ((opp != null) && ValidationMessage.validationPass && (modularInvoice.currentModularValue > 0) && (invType != 1))
            {
                invoiceDataListWrap modularInvoiceWrap = new invoiceDataListWrap();
                modularInvoiceWrap.invoiceData = modularInvoice;
                InvoiceWrapper modularInvWrap;
                //system.debug('Opportunity modular invoice : ' + modularInvWrap.OppInvoice);
                try {
                    modularInvWrap = callAPI(opp, modularInvoiceWrap); 
                    
                    if ((modularInvWrap != null) && (modularInvWrap.OppInvoice != null)) {
                        system.debug('Opportunity modular invoice : ' + modularInvWrap.OppInvoice);
                        modularInvWrap.OppInvoice.category__c = 'Modular';
                        OppInvList.add(modularInvWrap.OppInvoice);
                    }
                    modularResponseToBeSentToAura.APIresptoAura = modularInvWrap.APIResp;
                    modularResponseToBeSentToAura.APIcodetoAura = modularInvWrap.APICode;
                }
                catch (Exception Ex) {
                    system.debug('GenerateInvoiceNew : Exception occured at line number :' + Ex.getLineNumber() + ' in API call. Message : ' + Ex.getMessage());
                    modularResponseToBeSentToAura.status = 500;
                    modularResponseToBeSentToAura.errorMessage = Ex.getMessage();
                }
            }
            
            else if ((opp != null) && ValidationMessage.validationPass && (modularInvoice.currentModularValue <= 0)) {
                modularResponseToBeSentToAura.errorMessage = 'Modular Amount in opportunity should be greater then 0';
            }
            responsesToBeSentToAura.add(modularResponseToBeSentToAura);
            system.debug('Opportunity Invoice list :' + OppInvList);
            if (OppInvList != NULL) {
                insert OppInvList;
            }
        }
        if ((siteResponseToBeSentToAura.APIcodetoAura == '200') || (modularResponseToBeSentToAura.APIcodetoAura == '200')) {
            opp.IsInvoiceGenerated__c = true;
            acc.IsInvoiceGenerated__c = true;
        }
        if ((custResp != null) && (custResp.statusCode == '200') || ((modularResponseToBeSentToAura.APIcodetoAura == '200') || (siteResponseToBeSentToAura.APIcodetoAura == '200'))) {
            acc.Id = opp.AccountId;
            update acc;
        }
        /*
        if (((createProjResp != null) && (createProjResp.statusCode == '200')) || ((modularResponseToBeSentToAura.APIcodetoAura == '200') || (siteResponseToBeSentToAura.APIcodetoAura == '200'))) {
            update opp;
        }*/
        return responsesToBeSentToAura;
    }
    @AuraEnabled
    public static InvoiceWrapper callAPI(Opportunity opp, invoiceDataListWrap InvoiceWrap){
        
        MicroservicesAuthentication.ResponseDataOfAuth MicroAuthResp = new MicroservicesAuthentication.ResponseDataOfAuth();
        //Calling MicroserviceAuthentication API
        MicroAuthResp = MicroservicesAuthentication.AuthApi();
        
        if (MicroAuthResp.accessToken != null) {
            system.debug('GenerateInvoice : callAPI : Json Serialize : '+JSON.serialize(InvoiceWrap));
            String customLabelValue = System.Label.GenerateNewInvoiceAPIURL;
            HttpRequest request = new HttpRequest();
            request.setEndpoint(customLabelValue);
            request.setTimeout(20000);
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Authorization', MicroAuthResp.accessToken);
            String jsonBody = JSON.serialize(InvoiceWrap);
            system.debug('JSON BODY : '+jsonBody);
            request.setBody(jsonBody);
            system.debug('GenerateInvoice : callAPI : get request :'+request);
            Http http = new Http();
            HttpResponse response = http.send(request);
            system.debug('GenerateInvoice : callAPI : get response :'+response);
            system.debug('GenerateInvoice : callAPI : get response body :'+response.getBody());
            ResponseData rd = (ResponseData)JSON.deserialize(response.getBody(), ResponseData.class);
              //Calling ApiCallLogger class
            ApiCallLogger.method(opp.id, request.getEndpoint(), jsonBody, response.getBody(), 'out');
            
            if ((rd != null) && (rd.data != null) && (rd.data.invoice != null)) {
                System.debug('GenerateInvoice : callAPI : Response Data rd :'+rd);
                System.debug('GenerateInvoice : callAPI : Response Data rd.data :'+rd.data);
                System.debug('GenerateInvoice : callAPI : Response Data rd.data.invoice :'+rd.data.invoice);
            }
            
            Opportunity_Invoice__c inv = new Opportunity_Invoice__c();
            inv.Opportunity__c = opp.id;
            System.debug('GenerateInvoice : callAPI : Response Data : '+response.getBody());
            System.debug('GenerateInvoice : callAPI : Response object : ' + rd);
            
            System.debug('data: ' +rd.data);
            System.debug('data: ' +rd.message);
            if (rd.data != null){
                inv.Invoice_Id__c = rd.data.invoice.invoiceID;
                inv.RP_Invoice_Number__c = rd.data.invoice.invoiceNumber;
                inv.Invoice_PDF_Link__c = rd.data.invoice.invoicePdf;
                inv.SGST__c = rd.data.invoice.SGST;
                inv.CGST__c = rd.data.invoice.CGST;
                inv.IGST__c = rd.data.invoice.IGST;
                inv.Total_Tax_Value__c = rd.data.invoice.totalTaxValue;
                inv.Invoice_Amount__c = rd.data.invoice.invoiceAmount;
                inv.Invoice_Date__c = rd.data.invoice.invoiceDate;
                inv.Status__c = rd.data.invoice.status;
                inv.Odoo_Invoice_Id__c = rd.data.invoice.odooInvoiceId;
                
                InvoiceWrapper InvWrap = new InvoiceWrapper();
                InvWrap.OppInvoice = inv;
                //InvoiceWrapper InvWrap = new InvoiceWrapper();
                InvWrap.APIResp = rd.message;
                InvWrap.APICode = rd.statusCode;
                system.debug('API response :' +InvWrap.APIResp);
                system.debug('API code :' +InvWrap.APICode);
                return InvWrap;
            }
            else {
                InvoiceWrapper InvWrap = new InvoiceWrapper();
                InvWrap.APIResp = rd.message;
                InvWrap.APICode = rd.statusCode;
                system.debug('API response :' +InvWrap.APIResp);
                system.debug('API code :' +InvWrap.APICode);
                return InvWrap;
            }
            
        }
        InvoiceWrapper InvWrap = new InvoiceWrapper();
        if (MicroAuthResp.accessToken == null) {
            InvWrap.APIResp = MicroAuthResp.message;
        }
        return InvWrap;
    }
    
    public class InvoiceWrapper {
        public Opportunity_Invoice__c OppInvoice;
        public String APIResp;
        public String APICode;
    }
    public class ResponseData {
        public String statusCode;
        public String code;
        public String message;
        public invoicedata data;
        public string accessToken;        
    }
    class invoicedata {
        public String invoiceId;    //INV-L4zUlyzIU
        public invoicevalue invoice;
    }
    
    class invoicevalue
    {
        public String invoiceID;    //INV-L4zUlyzIU
        public String invoiceNumber;    //29/01-22/01999
        public String invoicePdf;   //http:...
        public Double SGST; //3813.5600000000004
        public Double CGST; //3813.5600000000004
        public Double IGST;
        public Double totalTaxValue;    //7627.120000000001
        public Integer invoiceAmount;   //50000
        public String status;   //posted
        public date invoiceDate;    //2022-01-13
        public Integer odooInvoiceId;   //234607
    }

}