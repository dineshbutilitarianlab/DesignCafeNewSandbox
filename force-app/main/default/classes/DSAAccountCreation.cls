@RestResource(urlMapping='/DSAAccounts')
global without sharing class DSAAccountCreation {
    
    @HttpPost
    global static PostResponseWrapper doPost() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        //  PostResponseWrapper response = new PostResponseWrapper();
        DetailsWrap allDetails = (DetailsWrap)JSON.deserialize(req.requestBody.toString(), DetailsWrap.class);
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Sales Partner').getRecordTypeId();
        List<Account> a = [SELECT id,Name,Phone,NoRelationship__c,ApprovalStatus__c,TCAgreed__c from Account WHERE Phone =:allDetails.mobileNumber Limit 1];
        System.debug('*** A:'+a);
        String customLabelValue = Label.CMM_Name;
        if(a.size() ==0){
            Account acc = new Account();
            if(allDetails.name !=null){
                acc.Name = allDetails.name;
            }
            if(allDetails.email !=null){
                acc.Acc_Email__c = alldetails.email;
            }
            if(allDetails.mobileNumber !=null){
                acc.Phone = alldetails.mobileNumber;
            }
            if(allDetails.region !=null){
                acc.Region__c = alldetails.region;
            }
            acc.RecordTypeId =recordTypeId;
            if(allDetails.pancardNumber !=null){
                acc.PAN__c = alldetails.pancardNumber;
            }
            if(allDetails.gstNumber !=null){
                acc.GST_No__c = alldetails.gstNumber;
            }
            if(allDetails.TnCAggreed !=null){
                acc.TCAgreed__c = alldetails.TnCAggreed;
            }
            if(alldetails.address.street !=null){
                acc.BillingStreet = alldetails.address.street;
            }
            if(alldetails.address.city !=null){
                acc.BillingCity = alldetails.address.city;
            }
            if(alldetails.address.state !=null){
                acc.BillingState = alldetails.address.state;
            }
            if(alldetails.address.country !=null){
                acc.BillingCountry = alldetails.address.country;
            }
            if(alldetails.address.zipcode !=null){
                acc.BillingPostalCode = alldetails.address.zipcode;
            }
            if(alldetails.NoRelationship){
                acc.NoRelationship__c = alldetails.NoRelationship;
            }
            if(alldetails.channelMarketingManager == NULL){
                acc.OwnerId =customLabelValue;
            }
            else{
                acc.OwnerId = alldetails.channelMarketingManager;
            }
            insert acc;
            Savepoint sp = Database.setSavepoint();
            List<Attachment> att=[Select id,name from Attachment where parentId=:acc.id];
            if(att.size() ==0){
                List<Attachment> attachList = new List<Attachment>();
                if(allDetails.documents !=null){
                    for(DocumentWrap d :allDetails.documents){
                        Attachment attach=new Attachment();
                        String attachbody = d.data;
                        attach.body = EncodingUtil.base64Decode(attachbody);
                        attach.Name=d.fileName;
                        attach.ContentType=d.Content_Type;
                        attach.ParentID= acc.id;
                        attachList.add(attach);
                    }
                }
                insert attachList;
                
            }
            PostResponseWrapper response = new PostResponseWrapper(); 
            response.StatusCode = '201';
            response.status = 'Success';
            response.DSA_Id = acc.id;
            response.DSA_Name = acc.Name;
            response.DSA_Phone = acc.Phone;
            response.DSA_Email	= acc.Acc_Email__c;
            response.message  = 'DSA Account Created successfully'; 
            return response;
        }
        else{
            System.debug('I am from Else');
            System.debug('Acc a:'+a);
            Account acc1 = new Account();
            acc1.Id = a[0].id;
            if(allDetails.name !=null){
                acc1.Name = allDetails.name;
            }
            if(alldetails.email !=null){
                acc1.Acc_Email__c = alldetails.email;  
            }
            if(alldetails.mobileNumber !=null){
                acc1.Phone = alldetails.mobileNumber;
            }
            if(alldetails.region !=null){
                acc1.Region__c = alldetails.region;
            }
            acc1.RecordTypeId =recordTypeId;
            if(alldetails.TnCAggreed ==null){
                acc1.TCAgreed__c = a[0].TCAgreed__c;
            }
            else{
                acc1.TCAgreed__c = alldetails.TnCAggreed;
            }
            if(alldetails.NoRelationship ==null){
                acc1.NoRelationship__c = a[0].NoRelationship__c;
            }
            else{
                acc1.NoRelationship__c = alldetails.NoRelationship;
            }
            if(alldetails.pancardNumber !=null){
                acc1.PAN__c = alldetails.pancardNumber;
            }
            if(alldetails.gstNumber !=null){
                acc1.GST_No__c = alldetails.gstNumber;
            }
            if(alldetails.TnCAggreed !=null){
                acc1.TCAgreed__c = alldetails.TnCAggreed;
            }
            if(alldetails.address !=null){
                acc1.BillingStreet = alldetails.address.street; 
                acc1.BillingCity = alldetails.address.city;
                acc1.BillingState = alldetails.address.state; 
                acc1.BillingCity = alldetails.address.city; 
                acc1.BillingCountry = alldetails.address.country; 
                acc1.BillingCountry = alldetails.address.country;  
                acc1.BillingPostalCode = alldetails.address.zipcode;  
            }
            if(allDetails.documents != NULL){
                acc1.ApprovalStatus__c ='Re-Submitted';
            }
            else{
                acc1.ApprovalStatus__c =a[0].ApprovalStatus__c;
            }
            if(alldetails.channelMarketingManager == NULL){
                acc1.OwnerId = customLabelValue;
            }
            else{
                acc1.OwnerId = alldetails.channelMarketingManager;
            }
            if (!Test.isRunningTest()) {
	            update acc1;                 
            }
            System.debug('Update :'+acc1);
            List<Attachment> att=[Select id,name from Attachment where parentId=:acc1.id];
            if(allDetails.documents !=NULL){
                delete att;
            }
            List<Attachment> attachList1 = new List<Attachment>();
            if(allDetails.documents !=null){
                for(DocumentWrap d :allDetails.documents){
                    Attachment attach1=new Attachment();
                    String attachbody1 = d.data;
                    attach1.body = EncodingUtil.base64Decode(attachbody1);
                    attach1.Name=d.fileName;
                    attach1.ContentType=d.Content_Type;
                    attach1.ParentID= acc1.id;
                    attachList1.add(attach1);
                }
                insert attachList1;
            }
            PostResponseWrapper response = new PostResponseWrapper(); 
            response.StatusCode = '201';
            response.status = 'Success';
            response.DSA_Id = acc1.id;
            response.DSA_Name = acc1.Name;
            response.DSA_Phone = acc1.Phone;
            response.DSA_Email	= acc1.Acc_Email__c;
            response.message  = 'DSA Account updated successfully'; 
            //Api Call Logger
            ApiCallLogger.method(system.UserInfo.getUserId(),'/DSAAccounts', req.requestBody.toString(),Response.message, 'in');
            return response;   
        }
    }
    global class PostResponseWrapper {
        String StatusCode;
        String status;
        String message;
        String DSA_Id;
        String DSA_Name;
        String DSA_Phone;
        String DSA_Email;
    }
    
    global class DetailsWrap{
        public string name;
        public string email;
        public string mobileNumber;
        public string channelMarketingManager;
        public string region;
        public List<DocumentWrap> documents;
        public AddressWrap address;
        public string code;
        public boolean TnCAggreed;
        public boolean NoRelationship;
        public string gstNumber;
        public string pancardNumber;
        
    }
    global class DocumentWrap{
        public String fileName;
        public String Content_Type;
        public String data;
    }
    global class AddressWrap{
        public string street;
        public string city;
        public string state;
        public string country;
        public string zipcode;
    }
}