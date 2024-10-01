public class RequestPaymentFlow  {
    @AuraEnabled
    public static RequestPaymentFlow.ResponseWrapper paymentFlow(List<Request_Payment__c> paymentReqList){   
        // Comment on 22 August 2024 by Muskan Jain, request by DD Team , will not being used in salesforce.
        /*CreateCustomer.CreateCustomerResponse custResp = new CreateCustomer.CreateCustomerResponse();
        RequestPaymentCreateProject.CreateProjectResponse createProjResp = new RequestPaymentCreateProject.CreateProjectResponse();
        RequestPaymentHandler.Response PaymentReqResponse = new  RequestPaymentHandler.Response();
        List<RequestPaymentHandler.Response> PaymentReqResponseList = new List<RequestPaymentHandler.Response>();
        Request_Payment__c rp;*/
		 RequestPaymentFlow.ResponseWrapper responseWrap = new RequestPaymentFlow.ResponseWrapper();
        /*List<Request_Payment__c> rpList = new List<Request_Payment__c>();
    	if(paymentReqList.size()>0)
        {   //Create Customer
       		 custResp = CreateCustomer.addCustomer(paymentReqList[0].Opportunity__c); 
			 responseWrap.customerResp = custResp;
        }      
        
        //Create Project
        if(custResp.statusCode=='200'){
            createProjResp = RequestPaymentCreateProject.createProjectRequest(paymentReqList[0].Opportunity__c);
			responseWrap.projectResp = createProjResp;
        }
       
        //Payment Request
        if(createProjResp !=null){            
            if(createProjResp.statusCode == '200' && paymentReqList.size()>0){
                for(Request_Payment__c reqPay : paymentReqList){
                    String Category =reqPay.Category__c;
                    Decimal requestAmount =HelperClass.getInteger(reqPay.Request_Amount__c);
                    String Description =reqPay.Description__c;
                    String ClientID=reqPay.Client_ID__c;
                    String Status='Pending';
                    Id OpportunityId=reqPay.Opportunity__c;
                    rp = new Request_Payment__c(); 
                    rp.Category__c = Category;
                    rp.Request_Amount__c = requestAmount;
                    rp.Description__c = Description;
                    rp.Client_ID__c = ClientId;
                    rp.Opportunity__c =OpportunityId;	
                    rp.Status__c = Status; 
                    
                    PaymentReqResponse= RequestPaymentHandler.sendRequestPayment(Category, requestAmount, Description, ClientID,Status, OpportunityId);
                    System.debug('PaymentReqResponse:: '+PaymentReqResponse);
                    if(PaymentReqResponse.data.requestId !=null){
                        rp.Request_Id__c = PaymentReqResponse.data.requestId;
                        rpList.add(rp);
                    }
                    PaymentReqResponseList.add(PaymentReqResponse);
                }
             responseWrap.paymentResp = PaymentReqResponseList;
            }
            if(rpList.size()>0){
               insert rpList; 
            }
           if(rpList.size() >0 && paymentReqList[0].Opportunity__c !=null){
                Account acc= new Account ();
            	Opportunity oppt =[Select Id, Name,AccountId,Account.Customer_created_on_Odoo__c From Opportunity where Id =: paymentReqList[0].Opportunity__c LIMIT 1];
                acc.Id = oppt.AccountId;
                acc.Customer_created_on_Odoo__c =true;
                update acc;
            }
              if(rpList.size() >0 && paymentReqList[0].Opportunity__c !=null){
            
            	Opportunity oppt =[Select Id, Name, AccountId, Project_Created_On_Odoo__c, IsNewPaymentProject__c From Opportunity where Id =: paymentReqList[0].Opportunity__c LIMIT 1];
                
              	oppt.Project_Created_On_Odoo__c = true;
                oppt.IsNewPaymentProject__c = true;
                update oppt;
                
            }
            
        }*/
        
      return responseWrap; 
    }
    
  public class ResponseWrapper{
	  @AuraEnabled public CreateCustomer.CreateCustomerResponse customerResp;
      // Comment on 22 August 2024 by Muskan Jain, request by DD Team , will not being used in salesforce.
      //@AuraEnabled public RequestPaymentCreateProject.CreateProjectResponse projectResp;
	  @AuraEnabled public List<RequestPaymentHandler.Response> paymentResp;
  }  
   
}