public with sharing class RequestPaymentCreateProject {
    public static projectDataWrap createProjectOnOdooRequest(String recId){
        Opportunity opp = [select id,Account.Name, Meeting_Venue__c, Account.ShippingAddress, Account.BillingAddress, Account.ShippingPostalCode, Account.BillingPostalCode, 
                           Account.ShippingCountry, Account.BillingCountry, Account.ShippingCity, Account.BillingCity, Account.ShippingStreet, Account.BillingStreet,
                           Account.ShippingState, Account.BillingState, Account.PersonEmail, Account.PersonMobilePhone, Account.Referee_Code_DC__c,
                           Modular_discount__c, StageName, Opportunity_status__c, Customer_ID__c, Signup_Amount__c,  
                           Site_Services_Amount_Dis_Incl_GST__c, Modular_Amount_Dis_Incl_GST__c, Civil_discount__c,Modular_Milestone_Type__c, Design_User__r.Name,
                           Design_User__r.Designer_Team__c, DesignerEmail__c, SalesManagerName__c, SalesManagerEmail__c, Channel__c, Amount from Opportunity Where id=: recId limit 1];
        
        projectDataWrap pdw = new projectDataWrap();
        pdw.projectName ='DC-'+opp.Account.Name+'-'+opp.Customer_ID__c+'-'+opp.Meeting_Venue__c;//projectName = DC-auth test1-DC-35832-WDC
        pdw.opportunityID = opp.ID;
        pdw.clientId = opp.Customer_ID__c;
        pdw.SFCustomerID = opp.Account.ID; 
        pdw.projectId=opp.Customer_ID__c;
        pdw.projectValue = HelperClass.getInteger(opp.Amount);
        pdw.projectStatus = opp.StageName;//Opportunity_status__c;
        pdw.modularValue = HelperClass.getInteger(opp.Modular_Amount_Dis_Incl_GST__c);
        pdw.siteServicesValue = HelperClass.getInteger(opp.Site_Services_Amount_Dis_Incl_GST__c);
        pdw.modularDiscount = opp.Modular_discount__c;
        pdw.siteServicesDiscount = opp.Civil_discount__c;
        pdw.shippingAddressCountry = opp.Account.ShippingCountry; 
        pdw.shippingAddressStreet = opp.Account.ShippingStreet; 
        pdw.shippingAddressCity = opp.Account.ShippingCity; 
        pdw.shippingAddressZipOrPostalCode = opp.Account.ShippingPostalCode; 
        pdw.shippingAddressShippingState = opp.Account.ShippingState;
        pdw.customerName = opp.Account.Name; 
        pdw.customerEmail = opp.Account.PersonEmail; 
        pdw.customerPhone = opp.Account.PersonMobilePhone; 
        pdw.referalId = opp.Account.Referee_Code_DC__c;
        
        if (opp.Channel__c == 'Referral') {
            pdw.projectReferal = true;
        }
        else {
            pdw.projectReferal = false;
        }
        
        if(opp.Channel__c == 'Referral'){
            pdw.projectReferalType = 'Customer';
        }
        else{
            pdw.projectReferalType = null;
        }
        
        pdw.mileStoneType = opp.Modular_Milestone_Type__c;
        pdw.signupAmount=HelperClass.getInteger(opp.Signup_Amount__c);
        pdw.signupState=opp.Account.ShippingState;
        pdw.signupCity=opp.Account.ShippingCity;
        pdw.salesforceDbId= opp.AccountId;
        pdw.studioName=opp.Design_User__r.Designer_Team__c;
        pdw.experienceCenter=opp.Meeting_Venue__c;  
        pdw.ECCity = opp.Account.ShippingCity;
        pdw.isSalesForceMigratedData=false;
        pdw.salesManagerName =  opp.SalesManagerName__c;
        pdw.salesManagerEmail = opp.SalesManagerEmail__c;
        pdw.designerEmail =  opp.DesignerEmail__c; 
        pdw.designerName = opp.Design_User__r.Name;
        return pdw;
    }
    public static CreateProjectResponse createProjectRequest(String recId){     
        //Calling authentication API
        MicroservicesAuthentication.ResponseDataOfAuth MicroAuthResp = new MicroservicesAuthentication.ResponseDataOfAuth();
        //Calling MicroserviceAuthentication API
        MicroAuthResp = MicroservicesAuthentication.AuthApi();
  		CreateProjectResponse createProjRes;
        
        if (MicroAuthResp.accessToken != null) {
            projectDataWrap CreateProjectBody = new projectDataWrap();
            CreateProjectBody = createProjectOnOdooRequest(recId);
            
			//Calling create project API            
            HttpRequest request = new HttpRequest();   
            String endpoint = System.label.CreateProjectRequestAPIURL;
            system.debug('endPoint:'+ endpoint);
            request.setTimeout(90000);
            request.setEndpoint(endpoint);
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Authorization', MicroAuthResp.accessToken);
            System.debug('--2i---'+JSON.serialize(CreateProjectBody));
            String jsonBody = JSON.serialize(CreateProjectBody);
            System.debug('---3---'+jsonBody);
            request.setBody(jsonBody);
            Http http = new Http();
            HttpResponse response = http.send(request);
            System.debug('---4---'+response.getBody());
            createProjRes = (CreateProjectResponse) JSON.deserialize(response.getBody(), CreateProjectResponse.class);
            //Calling ApiCallLogger class
            ApiCallLogger.method(recID, request.getEndpoint(), jsonBody, response.getBody(), 'out');
            if((createProjRes != null) && (createProjRes.data != null)) {
                System.debug('respData.data : '+createProjRes.data);
            }
            else {
                system.Debug('AddCustomer: SendAddCustomer: Null Response!');
                createProjRes.code='400';
            }  
        }
        else {
            system.debug('Authentication: Customer Authentication: Null Response! ');
            createProjRes = new CreateProjectResponse();
            createProjRes.code = MicroAuthResp.code;
            createProjRes.message = MicroAuthResp.message;
        }
        return createProjRes;
    }
    
    
  //If the project is Update on Oddo 
    @future(callout=true)
    public static void updateProjectOnOddo(String recId){
        
        //Calling authentication API
        MicroservicesAuthentication.ResponseDataOfAuth MicroAuthResp = new MicroservicesAuthentication.ResponseDataOfAuth();
        //Calling MicroserviceAuthentication API
        MicroAuthResp = MicroservicesAuthentication.AuthApi();
        CreateProjectResponse createProjRes;
        
        if (MicroAuthResp.accessToken != null) {
            projectDataWrap CreateProjectBody = new projectDataWrap();
            CreateProjectBody = createProjectOnOdooRequest(recId);
            
           //Calling update project API       
            HttpRequest request = new HttpRequest();   
            String endpoint = System.label.UpdateProjectRequestAPIURL;
            system.debug('endPoint:'+ endpoint);
            request.setTimeout(90000);
            request.setEndpoint(endpoint);
            request.setMethod('PUT');
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Authorization', MicroAuthResp.accessToken);
            System.debug('--UpdProj---'+JSON.serialize(CreateProjectBody));
            String jsonBody = JSON.serialize(CreateProjectBody);
            System.debug('---UpdProj---'+jsonBody);
            request.setBody(jsonBody);
            Http http = new Http();
            HttpResponse response = http.send(request);
            System.debug('---UpdProj---'+response.getBody());
            createProjRes = (CreateProjectResponse) JSON.deserialize(response.getBody(), CreateProjectResponse.class);
            //Calling ApiCallLogger class
            ApiCallLogger.method(recID, request.getEndpoint(), jsonBody, response.getBody(), 'out');
            if((createProjRes != null) && (createProjRes.data != null)) {
                System.debug('respData.data : '+createProjRes.data);
            }
            else {
                system.Debug('Project Update: Null Response!');
                createProjRes.code='400';
            }
        }
        else {
            system.debug('Authentication: Customer Authentication: Null Response! ');
            createProjRes = new CreateProjectResponse();
			createProjRes.code = MicroAuthResp.code;
            createProjRes.message = MicroAuthResp.message;
        }
        //return createProjRes;
    }
    public class projectDataWrap{
        @AuraEnabled
        public String projectName{get;set;}
        @AuraEnabled
        public String projectID{get;set;}
        @AuraEnabled
        public String dcProjectId{get;set;}
        @AuraEnabled
        public Decimal projectValue{get;set;}
        @AuraEnabled
        public String projectStatus{get;set;}
        @AuraEnabled
        public Decimal modularValue{get;set;}
        @AuraEnabled
        public Decimal siteServicesValue{get;set;}
        @AuraEnabled
        public Decimal modularDiscount{get;set;}
        @AuraEnabled
        public Decimal siteServicesDiscount{get;set;}
        @AuraEnabled
        public cSAdd cSAdd{get;set;}
        @AuraEnabled
        public String shippingAddressCountry{get;set;} 
        @AuraEnabled
        public String shippingAddressStreet{get;set;} 
        @AuraEnabled
        public String shippingAddressCity{get;set;} 
        @AuraEnabled
        public String shippingAddressZipOrPostalCode{get;set;} 
        @AuraEnabled
        public String shippingAddressShippingState{get;set;}
        @AuraEnabled
        public String customerName{get;set;} 
        @AuraEnabled
        public String customerEmail{get;set;} 
        @AuraEnabled
        public String customerPhone{get;set;} 
        @AuraEnabled
        public String clientId{get;set;} 
        @AuraEnabled
        public String SFCustomerID{get;set;}
        @AuraEnabled
        public String referalId{get;set;}
        @AuraEnabled
        public Decimal signupAmount{get;set;}
        @AuraEnabled
        public String invoiceDate{get;set;} 
        @AuraEnabled
        public String signupState{get;set;}
        @AuraEnabled
        public String signupCity{get;set;}
        @AuraEnabled
        public String salesforceDbId{get;set;}
        @AuraEnabled
        public String studioName{get;set;}
        @AuraEnabled
        public String experienceCenter{get;set;}
        @AuraEnabled
        public boolean isSalesForceMigratedData{get;set;}
        @AuraEnabled
        public boolean projectReferal{get;set;}
        @AuraEnabled
        public String projectReferalType{get;set;}
        @AuraEnabled
        public String mileStoneType{get;set;}
        @AuraEnabled
        public String ECCity{get;set;}
        @AuraEnabled
        public String salesManagerName{get;set;}
        @AuraEnabled
        public String salesManagerEmail{get;set;}
        @AuraEnabled
        public String designerEmail{get;set;}
        @AuraEnabled
        public String designerName{get;set;}
        @AuraEnabled
        public String opportunityID{get;set;}
        
    }
    public class cSAdd{
        @AuraEnabled
        public String country{get;set;} 
        @AuraEnabled
        public String street{get;set;} 
        @AuraEnabled
        public String city{get;set;} 
        @AuraEnabled
        public String zipOrPostalCode{get;set;} 
        @AuraEnabled
        public String shippingState{get;set;} 
    }
    
    Public class CreateProjectResponse{
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
        public string requestId;
    }
    
    public class Authwrap{
        @AuraEnabled
        public string clientId {get;set;}   
    }
    
}