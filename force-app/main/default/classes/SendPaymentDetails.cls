public class SendPaymentDetails {
   public class PaymentDataWrap{
       @AuraEnabled
       public String projectId{get;set;} 
       @AuraEnabled
       public String projectName{get;set;} 
       @AuraEnabled
       public String invoiceNumber{get;set;} 
       @AuraEnabled
       public String paymentId{get;set;} 
       @AuraEnabled
       public Decimal amountPaid{get;set;} 
       @AuraEnabled
       public String paymentReceivedDate{get;set;}
       @AuraEnabled
       public String transactionId{get;set;} 
       @AuraEnabled
       public String paymentMode{get;set;} 
       @AuraEnabled
       public String customerPhone{get;set;} 
       @AuraEnabled
       public String paymentReceipt{get;set;} 
       @AuraEnabled
       public String sfId{get;set;}
       @AuraEnabled
       public designerDetailsWrap designerDetails{get;set;}
       @AuraEnabled
       public salesManagerDetailsWrap salesManagerDetails{get;set;}
    }
    public class designerDetailsWrap{
        @AuraEnabled
        public String designerName{get;set;} 
        @AuraEnabled
        public String designerEmail{get;set;} 
    }
    public class salesManagerDetailsWrap{
        @AuraEnabled
        public String salesManagerName{get;set;} 
        @AuraEnabled
        public String salesManagerEmail{get;set;} 
    }
   @future(callout=true)
     @AuraEnabled
    public static void callServer(String payId){
        system.debug('oppId '+payId); 
        Invoice_Payment__c pay = [select id,Name,Customer_Id__c,Opportunity_Name__c,Opportunity_Name__r.Design_User_Name__c,
                                  Opportunity_Name__r.DesignerEmail__c,Opportunity_Name__r.SalesManagerName__c,Opportunity_Name__r.SalesManagerEmail__c,
                                  Pyament_Receipt__c,Project_Name__c,RP_Recipt_ID__c,Invoice_Number__c,Receipt_Amount__c,Date_of_Payment__c,
                                  Mode_of_Receipt__c,Customer_Phone__c from Invoice_Payment__c where id =: payId limit 1];
        String du1 = pay.Opportunity_Name__r.Design_User_Name__c;
        String due2 = pay.Opportunity_Name__r.DesignerEmail__c;
        String sn1 = pay.Opportunity_Name__r.SalesManagerName__c;
        String se2 = pay.Opportunity_Name__r.SalesManagerEmail__c;
      //  Opportunity opp = [select id,Name,Design_User_Name__c,DesignerEmail__c,SalesManagerName__c,SalesManagerEmail__c from Opportunity where id =: payId];
        PaymentDataWrap manualpayment = new PaymentDataWrap();
        if(pay.Opportunity_Name__c !=null){
        manualpayment.projectId = pay.Opportunity_Name__c;
        }
        if(pay.Project_Name__c !=null){
        manualpayment.projectName = pay.Project_Name__c;
        }
        if(pay.Customer_Id__c !=null){
           manualpayment.sfId = pay.Customer_Id__c;
        }
        if(pay.Invoice_Number__c !=null){
        manualpayment.invoiceNumber = pay.Invoice_Number__c;
        }
        if(pay.RP_Recipt_ID__c !=null){
        manualpayment.paymentId = pay.RP_Recipt_ID__c;
        }
        if(pay.Receipt_Amount__c !=null){
        manualpayment.amountPaid = pay.Receipt_Amount__c;
        }
      /* if(du1 !=null){
         manualpayment.designerName = du1;  
        }
        if(due2 !=null){
         manualpayment.designerEmail = due2;  
        }
        if(sn1 !=null){
         manualpayment.salesManagerName = sn1;  
        }
        if(se2 !=null){
         manualpayment.salesManagerEmail = se2;  
        } */ 
        designerDetailsWrap dd = new designerDetailsWrap();
        dd.designerName = pay.Opportunity_Name__r.Design_User_Name__c;
        dd.designerEmail = pay.Opportunity_Name__r.DesignerEmail__c;
        
        manualpayment.designerDetails = dd;
        
		
        salesManagerDetailsWrap smd = new salesManagerDetailsWrap();
        smd.salesManagerName = pay.Opportunity_Name__r.SalesManagerName__c;
        smd.salesManagerEmail = pay.Opportunity_Name__r.SalesManagerEmail__c;
        
        manualpayment.salesManagerDetails = smd;
        
        String inputDate = pay.Date_of_Payment__c.format();
        System.debug('Datedddd**** :'+inputDate);
        manualpayment.paymentReceivedDate = inputDate;
        if(pay.RP_Recipt_ID__c !=null){
        manualpayment.transactionId = pay.RP_Recipt_ID__c;
        }
        if(pay.Mode_of_Receipt__c !=null){
        manualpayment.paymentMode = pay.Mode_of_Receipt__c;
        }
        if(pay.Customer_Phone__c !=null){
        manualpayment.customerPhone = pay.Customer_Phone__c;
        }
     //   String attachbody = pay.Pyament_Receipt__c;
        if(pay.Pyament_Receipt__c !=null){
        manualpayment.paymentReceipt = pay.Pyament_Receipt__c;
        }
        String customLabelValue = Label.sendPaymentDetails;
        system.debug('Json Serialize : '+JSON.serialize(manualpayment));
        HttpRequest request = new HttpRequest();
        request.setEndpoint(customLabelValue);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        String jsonBody = JSON.serialize(manualpayment);
        system.debug('JSON BODY : '+jsonBody);
        request.setBody(jsonBody);
        Http http = new Http();
        if(!test.isRunningTest()){
        HttpResponse response = http.send(request);
        system.debug('get response :'+response.getBody());
        system.debug('get response :'+response.getStatusCode());
        Response rd = (response)JSON.deserialize(response.getBody(), response.class);
        System.debug('Response paylink :'+rd);
        Opportunity_Invoice__c oppinv =[Select id,Name,RP_Invoice_Number__c from Opportunity_Invoice__c where RP_Invoice_Number__c =:manualpayment.invoiceNumber];
        Opportunity_Invoice__c inv = new Opportunity_Invoice__c();
        inv.id = oppinv.id;
        inv.Payment_Link__c = rd.data.updatedPaymentLink;
        update inv;
        }
    }
    Public class response{
        public string statusCode;
        public string code;
        public string message;
        public responsedata data;
    }
     public class responsedata{
        public string updatedPaymentLink;
    }
}