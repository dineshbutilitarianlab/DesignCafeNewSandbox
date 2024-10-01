public class GenerateInvoicenewflow_GraphQL {
    public static list<Opportunity_Invoice__c> OppInvList = new List<Opportunity_Invoice__c>();
    
    public static double baseAmountFromInvoiceAmount(double invoiceAmount, boolean is_pm_and_site)
    {
        double baseAmount = (invoiceAmount * 100) / 118;
        //double baseAmount1 = baseAmount.setScale(2);
        return baseAmount ;
    }
    @AuraEnabled
    public static string showbutton(String oppId){
         List<Opportunity> oppList= [select id, Initial_Payment_Amount__c,Account.Ownerid,Ownerid, RUP_Signup_Amount__c from Opportunity where id =: oppId]; 
     	Integer invoiceDiscount = Integer.valueOf(System.Label.Discount_Invoice);
        List<Opportunity_Invoice__c> invList = [select id, Opportunity__r.Initial_Payment_Amount__c, Opportunity__r.RUP_Signup_Amount__c from Opportunity_Invoice__c where Opportunity__c =: oppId]; 
        if(oppList[0].Ownerid != oppList[0].Account.Ownerid ){   
             return 'DisableAcc';
        }
         else if(invList.size() == 0 && oppList[0].RUP_Signup_Amount__c < (oppList[0].Initial_Payment_Amount__c - invoiceDiscount)){
             return 'DisAmount';
        }
        else if(invList.size() == 0 && oppList[0].RUP_Signup_Amount__c > (oppList[0].Initial_Payment_Amount__c - invoiceDiscount)){
            return 'Enabled';
        }
       
        else{
            return 'Disabled';
        }
    }
    
    @AuraEnabled
    public static List<ResponseToBeSentToAura> generateNewInvoice(String oppId) {
        
        List <Opportunity> oppList = [SELECT id, name, Amount, Customer_ID__c, First_SiteService_Milestone_Pct__c, First_Modular_Milestone_Percentage__c,
                                      Modular_Milestone_Type__c, Modular_Amount_Dis_Incl_GST__c, Site_Services_Amount_Dis_Incl_GST__c, Decor_Amount_Incl_GST__c,
                                      Is_Pm_Site__c, Region__c, Account.BillingCountry, Account.BillingState, Account.BillingCity,Account.BillingStreet, Account.BillingPostalCode,
                                      Account.ShippingCountry, Account.ShippingState, Account.ShippingCity,Account.ShippingStreet, Account.ShippingPostalCode,
                                      Account.GST_No__c, Account.PAN__c,Account.Customer_type__c, AccountId, Account.Customer_created_on_Odoo__c, 
                                      Project_Created_On_Odoo__c,IsNewPaymentProject__c, IsInvoiceGenerated__c FROM Opportunity WHERE id = :oppId limit 1];
        
        /*List <Opportunity> oppList = [SELECT id, Customer_ID__c, Modular_Amount_Dis_Incl_GST__c, Site_Services_Amount_Dis_Incl_GST__c,
First_Modular_Milestone_Percentage__c, First_SiteService_Milestone_Pct__c, Amount 
FROM Opportunity WHERE id = :oppId];*/
        List<ResponseToBeSentToAura> responsesToBeSentToAura = new List<ResponseToBeSentToAura>();
        Opportunity opp;
        if (oppList.size() > 0)
            opp = oppList[0];
        else
            return null;
        // Prepare the Modular and SiteService bodies.
        invoiceData modularInvoice = new invoiceData();
        invoiceData siteInvoice = new invoiceData();
        Double modularAmount5pct = 0, siteAmount5pct = 0;
        
        modularInvoice.milestone = String.valueof(opp.First_Modular_Milestone_Percentage__c) + '%';
        siteInvoice.milestone = String.valueof(opp.First_SiteService_Milestone_Pct__c) + '%';
        modularInvoice.clientID = siteInvoice.clientId = opp.Customer_ID__c;
        modularInvoice.currentProjectValue = siteInvoice.currentProjectValue = (opp.Amount == null)? 0 : opp.Amount;
        modularInvoice.category = System.Label.Modular_Category;
        siteInvoice.category = System.Label.SiteServices_Category;
        modularInvoice.currentModularValue = siteInvoice.currentModularValue = 
            (opp.Modular_Amount_Dis_Incl_GST__c == null)? 0 : opp.Modular_Amount_Dis_Incl_GST__c;
        modularInvoice.currentSiteServicesValue = siteInvoice.currentSiteServicesValue = 
            (opp.Site_Services_Amount_Dis_Incl_GST__c == null)? 0 : opp.Site_Services_Amount_Dis_Incl_GST__c;
        modularInvoice.additionalCharge = siteInvoice.additionalCharge = 0;
        modularAmount5pct = (modularInvoice.currentModularValue * opp.First_Modular_Milestone_Percentage__c)/100;
        siteAmount5pct = (siteInvoice.currentSiteServicesValue * opp.First_SiteService_Milestone_Pct__c)/100;
        modularInvoice.baseAmount = baseAmountFromInvoiceAmount(modularAmount5pct, opp.Is_Pm_Site__c);
        siteInvoice.baseAmount = baseAmountFromInvoiceAmount(siteAmount5pct, opp.Is_Pm_Site__c);
        siteInvoice.status = modularInvoice.status = System.Label.Status_Draft;
        
        ResponseToBeSentToAura errorResponseToBeSentToAura = new ResponseToBeSentToAura();
        ResponseToBeSentToAura siteResponseToBeSentToAura = new ResponseToBeSentToAura();
        ResponseToBeSentToAura modularResponseToBeSentToAura = new ResponseToBeSentToAura();
        //Calling validation API
        ValidationOnPaymi.ResponseToBeSentToAura ValidationMessage = new ValidationOnPaymi.ResponseToBeSentToAura();
        ValidationMessage = ValidationOnPaymi.validationMethod(oppId);
        errorResponseToBeSentToAura.errorMessage = ValidationMessage.errorMessage;
        responsesToBeSentToAura.add(errorResponseToBeSentToAura);
        system.debug('ValidationMessage.validationPass::'+ ValidationMessage.validationPass);
        system.debug('siteAmount5pct::' + siteAmount5pct);
        
        siteResponseToBeSentToAura.invoiceType = 'SiteServices';
        if ((siteInvoice.currentSiteServicesValue > 0) && (!oppList.isEmpty()) && (ValidationMessage.validationPass)) {
            InvoiceWrapper siteResponse;
            system.debug('Calling Site Invoice: Obj: ' + siteInvoice);
            try {
                system.debug('siteResp::'+siteResponse);
                siteResponse = callInvAPI(siteInvoice, opp);
                system.debug('siteResponse::' + siteResponse);
                if ((siteResponse != null) && (siteResponse.OppInvoice != null)) {
                    system.debug('Opportunity site invoice : ' +siteResponse.OppInvoice);
                    system.debug('Opportunity site invoice : ' +siteResponse.APIResp);
                    siteResponse.OppInvoice.category__c = 'Site Services';
                    OppInvList.add(siteResponse.OppInvoice);
                }
                siteResponseToBeSentToAura.APIresptoAura = siteResponse.APIResp;
                siteResponseToBeSentToAura.APIcodetoAura = siteResponse.APICode;
            }
            catch (Exception Ex) {
                system.debug('GenerateInvoiceNewflow_GraphQL : Exception occured at line number :' + Ex.getLineNumber() + ' in API call. Message : ' + Ex.getMessage());
                siteResponseToBeSentToAura.status = 500;
                siteResponseToBeSentToAura.errorMessage = Ex.getMessage();
            }
        }
        responsesToBeSentToAura.add(siteResponseToBeSentToAura);
        modularResponseToBeSentToAura.invoiceType = 'Modular';
        if ( (!oppList.isEmpty()) && (ValidationMessage.validationPass))
        {
            try{
                InvoiceWrapper modularResponse;
                system.debug('Calling Modular Invoice: Obj: ' + modularInvoice);
                modularResponse = callInvAPI(modularInvoice, opp);
                if ((modularResponse != null) && (modularResponse.OppInvoice != null)) {
                    system.debug('Opportunity modular invoice : ' + modularResponse.OppInvoice);
                    system.debug('Opportunity modular invoice : ' +modularResponse.APIResp);
                    modularResponse.OppInvoice.category__c = 'Modular';
                    OppInvList.add(modularResponse.OppInvoice);
                }
                modularResponseToBeSentToAura.APIresptoAura = modularResponse.APIResp;
                modularResponseToBeSentToAura.APIcodetoAura = modularResponse.APICode;
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
        if (OppInvList != NULL) {
            insert OppInvList;
        }
        Account acc = new Account(); 
        if ((siteResponseToBeSentToAura.APIcodetoAura == '200') || (modularResponseToBeSentToAura.APIcodetoAura == '200')) {
            opp.IsInvoiceGenerated__c = true;
       //     acc.IsInvoiceGenerated__c = true;
        }
      /*  if ((modularResponseToBeSentToAura.APIcodetoAura == '200') || (siteResponseToBeSentToAura.APIcodetoAura == '200')) {
            acc.Id = opp.AccountId;
            update acc;
        }*/
        if ((modularResponseToBeSentToAura.APIcodetoAura == '200') || (siteResponseToBeSentToAura.APIcodetoAura == '200')) {
            update opp;
        }
        System.debug('Return response list' + responsesToBeSentToAura);
        return responsesToBeSentToAura;
    }
    @AuraEnabled
    public static InvoiceWrapper callInvAPI(invoiceData InvDtWrp, Opportunity opp) {
        Map<String,Object> responseMap = new Map<String,Object>();
        Map<String, Object> dataMAP = new Map<String, Object>(); 
        Map<String, Object> invoiceMAP = new Map<String, Object>(); 
        Object data;
        Object Invoice;
        InvoiceWrapper InvWrap = new InvoiceWrapper();
        
        try {
            AuthenticationToken_GraphQL.ResponseDataOfAuth GraphQLAuth = new AuthenticationToken_GraphQL.ResponseDataOfAuth();
            if (!Test.isRunningTest()) {
                GraphQLAuth = AuthenticationToken_GraphQL.authorization();
            }
            else {
                GraphQLAuth.accessToken = 'Test';
            }
            system.debug('GraAuth::' +GraphQLAuth);
            if (GraphQLAuth.accessToken != null) {
                GraphQLNode GenerateNewInvoiceNode = new GraphQLNode('GenerateInvoicenewflow')
                    .withArgument('invoiceData',InvDtWrp)
                    .withField('code')
                    .withField('message')
                    .withField('data');
                
                GraphQLMutationNode GenerateNewInvoiceMutation = new GraphQLMutationNode('GenerateInvoicenewflow', GenerateNewInvoiceNode);
                GraphQLRequest request = GenerateNewInvoiceMutation.buildRequest()
                    .withHeader('Authorization', GraphQLAuth.accessToken);
                GraphQLHttpClient client = new GraphQLHttpClient(System.label.GraphQLURL);
                GraphQLResponse response = client.send(request);
                system.debug('Request: ' + request);
                system.debug('Response in invoice flow: ' + response);
                System.debug(response.hasErrors());
                System.debug(response.hasData());
                
                if (response.hasData()) {
                    Object dataAsMap = response.getDataNode('GenerateInvoicenewflow');
                    system.debug('dataAsMap object::' + dataAsMap);
                    if (dataAsMap != null) {
                        System.debug('dataAsMap: '+dataAsMap);
                        responseMap = (Map<String,Object>)JSON.deserializeUntyped(JSON.serialize(dataAsMap));
                        if (responseMap != null) {
                            System.debug('responseMap: '+responseMap);
                            if (responseMap.get('message') != null && responseMap.get('code') != null) {
                                System.debug('responseMap Element:: '+responseMap.get('message'));
                                InvWrap.APIResp = String.valueOf(responseMap.get('message'));
                                InvWrap.APICode = String.valueOf(responseMap.get('code'));
                                system.debug('API response :' +InvWrap.APIResp);
                                system.debug('API code :' +InvWrap.APICode);
                                data = responseMap ?.get('data');
                                if (data !=null){
                                   dataMAP = (Map<String,Object>)JSON.deserializeUntyped(JSON.serialize(data));
                                   system.debug('VALUE::' +dataMAP.get('invoice')); 
                                }
                                Invoice = dataMAP ?.get('invoice');
                                if (Invoice !=null){
                                  invoiceMAP = (Map<String,Object>)JSON.deserializeUntyped(JSON.serialize(Invoice));
                                   system.debug('INVOICE_VALUE::' +invoiceMAP.get('CGST'));
                                }
                            }
                            else {
                                InvWrap.APIResp = String.valueOf('API Error : dataAsMap was Null');
                                InvWrap.APICode = String.valueOf(400);
                            }
                        }
                    }
                    else {
                        InvWrap.APIResp = String.valueOf('API Error : message Or Code was Null');
                        InvWrap.APICode = String.valueOf(400);
                    }
                    
                    Opportunity_Invoice__c inv = new Opportunity_Invoice__c();
                    inv.Opportunity__c = opp.id;
                    
                    if ((responseMap != null) && (data != null) && (invoice != null)){
                        System.debug('data assigning');
                        Date d = Date.ValueOf(String.ValueOf(invoiceMAP.get('invoiceDate')));
                        String dateStr = d.year() + '-' + d.month() + '-' + d.day();
                        system.debug('datae::'+ dateStr);
                        inv.Invoice_Id__c = String.valueOf(dataMAP.get('invoiceId'));
                        inv.RP_Invoice_Number__c = String.valueOf(invoiceMAP.get('invoiceNumber'));
                        inv.Invoice_PDF_Link__c = String.valueOf(invoiceMAP.get('invoicePdf'));
                        inv.SGST__c = Integer.ValueOf(invoiceMAP.get('SGST'));
                        inv.CGST__c = Integer.ValueOf(invoiceMAP.get('CGST'));
                        inv.IGST__c = Integer.ValueOf(invoiceMAP.get('IGST'));
                        inv.Total_Tax_Value__c = Integer.ValueOf(invoiceMAP.get('CGST'));
                        inv.Invoice_Amount__c = Integer.ValueOf(invoiceMAP.get('invoiceAmount'));
                        inv.Status__c = String.valueOf(invoiceMAP.get('posted'));
                        inv.Odoo_Invoice_Id__c = Integer.valueOf(invoiceMAP.get('odooInvoiceId'));
                        inv.Invoice_Date__c = Date.valueOf(dateStr);
                        
                        
                        InvWrap.OppInvoice = inv;
                        InvWrap.APIResp = String.valueOf(responseMap.get('message'));
                        InvWrap.APICode = String.valueOf(responseMap.get('code'));
                        System.debug('InvWrap.OppInvoice::' + InvWrap.OppInvoice);
                    }
                    else {
                        InvWrap.APIResp = (InvWrap.APIResp != null) ? InvWrap.APIResp : String.valueOf('API Error : Null response');
                        InvWrap.APICode = String.valueOf(400);
                    }
                    return InvWrap;
                }
                else if (response.hasErrors()) {
                    System.debug('Has Error');
                    if (responseMap.get('message') != null && responseMap.get('code') != null) {
                        InvWrap.APIResp = String.valueOf(responseMap.get('message'));
                        InvWrap.APICode = String.valueOf(responseMap.get('code'));
                    }
                }
            }
            else if (GraphQLAuth.accessToken == null) {
                system.debug('Authentication: Customer Authentication: Null Response! ');
                //AuthenticationToBeSentToAura.AuthenticationMsg = 'Authentication Failed(API issue)';
                //AuthenticationToBeSentToAura.AuthenticationCode = '400';
                InvWrap.APIResp = 'Authentication Failed(API issue)';
            }
        }
        catch (Exception ex) {
            InvWrap.APIResp = 'Error in API call: ' + ex.getMessage();
            System.debug('error at line number:: '+ex.getLineNumber());
            InvWrap.APICode = String.valueOf(400);
        }
        system.debug('API response :' +InvWrap.APIResp);
        system.debug('API code :' +InvWrap.APICode);
        return InvWrap;
    }
    
    public class ResponseData {
        public String statusCode;
        public String code;
        public String message;
        public String invoiceId;
        public invoicedata data;
        public string accessToken;        
    }
    public class invoiceData{
        public String milestone;    //15%
        public Double currentProjectValue;  //0
        public String category; //Modular
        public Double currentModularValue;  //51411.824
        public Double currentSiteServicesValue; //0
        public Double baseAmount;   //0
        public Double additionalCharge; //0
        public String status;   //Active
        public String clientID; //DC-44392 
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
        
    }
    public class InvoiceWrapper {
        public Opportunity_Invoice__c OppInvoice;
        public String APIResp;
        public String APICode;
    }
}