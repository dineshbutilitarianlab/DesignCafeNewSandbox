@RestResource(urlMapping='/DC_BookingForm')
global without sharing class DC_BookingForm {
    
    @HttpPost
    global static PostResponseWrapper doPost() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        PostResponseWrapper response = new PostResponseWrapper();
        OppDetailsWrap allDetails = (OppDetailsWrap)JSON.deserialize(req.requestBody.toString(),OppDetailsWrap.class);
        system.debug('opportunity id '+allDetails.OpportunityId);
        try{
            List<Opportunity> opp = [Select id,AccountId,account.PAN__c,account.GST_No__c,Account.ShippingAddress,Account.BillingAddress,
                                     Account.ShippingPostalCode,Account.BillingPostalCode,Account.ShippingCountry,Account.BillingCountry,
                                     Account.ShippingCity,Account.BillingCity,Account.ShippingStreet,Account.BillingStreet,
                                     Account.ShippingState,Account.BillingState,Account.PersonEmail,Account.PersonMobilePhone,
                                     Property_Address__c, Update_Booking_Form__c from Opportunity Where id=: allDetails.OpportunityId limit 1];
            IF(opp.size() != 0){
                if(allDetails.Property_Address!=null)
                    opp[0].Property_Address__c= allDetails.Property_Address;
                if(allDetails.Bookingform_Signed!=null)
                    opp[0].Update_Booking_Form__c= allDetails.Bookingform_Signed; 
                
                Update opp[0];
                
                account acc = new account();
                acc.id = opp[0].AccountID;
                if(acc!= null){
                    if(allDetails.GST_Number != null){
                        acc.GST_No__c = allDetails.GST_Number;    
                    }
                    if(allDetails.PAN_Number != null){
                        acc.PAN__c = allDetails.PAN_Number;    
                    }
                    
                    customerShippingAddressWrap cc = new customerShippingAddressWrap();
                    if(allDetails.customerShippingAddress!= null){
                        cc = allDetails.customerShippingAddress;    
                    }
                    if(cc!= null){
                        if(cc.country !=null)
                            acc.ShippingCountry = cc.country;
                        if(cc.street != null)
                            acc.ShippingStreet = cc.street;
                        if(cc.city!= null)
                            acc.ShippingCity = cc.city;
                        if(cc.zipOrPostalCode!= null)
                            acc.ShippingPostalCode = cc.zipOrPostalCode;
                        if(cc.shippingState!= null)
                            acc.ShippingState = cc.shippingState;  
                    }
                    
                    customerBillingAddressWrap cb = new customerBillingAddressWrap();
                    if(allDetails.customerBillingAddress != null){
                        cb = allDetails.customerBillingAddress;    
                    }
                    if(cb!=null){
                        if(Cb.country!=null)
                            acc.BillingCountry = cb.country;
                        if(cb.street !=null)
                            acc.BillingStreet = cb.street;
                        if(cb.city!= null)
                            acc.BillingCity = cb.city;
                        if(cb.ziporpostalcode!=null)
                            acc.BillingPostalCode = cb.zipOrPostalCode;
                        if(cb.shippingstate!=null)
                            acc.BillingState = cb.shippingState;    
                    }
                    
                }  
                if(acc!=null){
                    update acc;    
                }
                response.StatusCode = '200';
                response.status = 'Success';
                response.message = 'Booking Form Data Updated Successfully';
            }
        }catch(Exception exc){
            response.StatusCode = '400';
            response.status = 'Error';
            response.message = 'Your request failed with the following error: '+ exc.getMessage();
        }
        //Calling ApiCallLogger class
        ApiCallLogger.method(system.UserInfo.getUserId(), '/DC_BookingForm', Null, response.message, 'in');
        return response;
    }
    global class OppDetailsWrap{
        public string OpportunityId;
        public string PAN_Number;
        public string GST_Number;
        public string Property_Address;
        public Boolean Bookingform_Signed;
        public customerShippingAddressWrap customerShippingAddress{get;set;}
        public customerBillingAddressWrap customerBillingAddress{get;set;}
    }
    public class customerShippingAddressWrap{
        public String country{get;set;} 
        public String street{get;set;} 
        public String city{get;set;} 
        public String zipOrPostalCode{get;set;} 
        public String shippingState{get;set;} 
    }
    public class customerBillingAddressWrap{
        public String country{get;set;} 
        public String street{get;set;} 
        public String city{get;set;} 
        public String zipOrPostalCode{get;set;} 
        public String shippingState{get;set;} 
    }
    global class PostResponseWrapper {
        String status;
        String message;
        String StatusCode;    
    }
}