public class DC_BookingFormAPI {
    public class OppDataWrap{
        
        @AuraEnabled
        public String opportunityId{get;set;}
        @AuraEnabled
        public String dcCode{get;set;} 
        @AuraEnabled
        public Date closeDate{get;set;}
        @AuraEnabled
        public String clientName{get;set;}
        @AuraEnabled
        public String phoneNumber{get;set;}
        @AuraEnabled
        public String emailId{get;set;}
        @AuraEnabled
        public String projectType{get;set;}
        @AuraEnabled
        public String scopeOfWork{get;set;}
        @AuraEnabled
        public Boolean civilWorkRequired{get;set;}
        @AuraEnabled
        public Double proposedValue{get;set;}
        @AuraEnabled
        public Double signupValue{get;set;}
        @AuraEnabled
        public Double modularDiscount{get;set;}
        @AuraEnabled
        public Double modularAmount{get;set;}
        @AuraEnabled
        public Double siteServicesDiscount{get;set;}
        @AuraEnabled
        public Double siteServicesAmount{get;set;}
        @AuraEnabled
        public Double decorAmount{get;set;}
        @AuraEnabled
        public Double fivePercentageProjectValue{get;set;}
        @AuraEnabled
        public Double signupAmount{get;set;}
        @AuraEnabled
        public Boolean basicFramesofExternalDoorsAndWindows{get;set;}
        @AuraEnabled
        public Boolean reqdDoorsAndWindowsInstalled{get;set;}
        @AuraEnabled
        public Boolean basicAllWallsCompleted{get;set;}
        @AuraEnabled
        public Boolean reqdPuttyCoatOfPlasteringOnWalls{get;set;}
        @AuraEnabled
        public Boolean basicFloorsLeveledOutAndPrepped{get;set;}
        @AuraEnabled
        public Boolean reqdFlooringIsCompleted{get;set;}
        @AuraEnabled
        public String notes{get;set;}
        @AuraEnabled
        public String pan{get;set;}
        @AuraEnabled
        public String gst{get;set;}
        @AuraEnabled
        public String wohooCard{get;set;}
        @AuraEnabled
        public String remarkFromSales{get;set;}
        @AuraEnabled
        public String salesManagerName{get;set;}
        @AuraEnabled
        public String salesManagerMobile{get;set;}
        @AuraEnabled
        public String salesManagerEmail{get;set;}
        @AuraEnabled
        public customerShippingAddressWrap projectAddress{get;set;}
        @AuraEnabled
        public customerBillingAddressWrap currentAddress{get;set;}
    }
    public class customerShippingAddressWrap{
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
    public class customerBillingAddressWrap{
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
    public class responsedata{
        public string code;
        public string message;
        public string statusCode;
    }
    /*   public class warningWrap{
@AuraEnabled public opportunity opp;
}  */
    
    @AuraEnabled
    public static OppDataWrap fetchDetails(String OppId){
        Opportunity op = [Select id,Customer_ID__c,Name,AccountId,CloseDate,account.name,account.PersonMobilePhone,account.PersonEmail,
                          Home_Type__c,Scope_Of_Work__c,Civil_Work__c,Proposed_Budget__c,Signup_Amount__c,Amount,Modular_discount__c,
                          Modular_Amount_Dis_Incl_GST__c,Civil_discount__c,Site_Services_Amount_Dis_Incl_GST__c,Decor_Amount_Incl_GST__c,
                          Initial_Payment_Amount__c,Frames_for_all_external_Doors_Windows__c,The_Doors_Windows_are_installed_Requir__c,
                          All_walls_are_completed_Required__c,Putty_and_1_coat_of_plastering_Required__c,Floors_are_levelled_out_prepped_Basic__c,
                          Flooring_is_completed_Required__c,Notes__c,account.PAN__c,account.GST_No__c,Wohoo_Card__c,
                          OwnerId,owner.name,owner.MobilePhone,owner.Email,account.BillingAddress,Remarks_For_Marketing__c,
                          account.ShippingStreet, account.ShippingCity, account.ShippingState, account.ShippingCountry, account.ShippingPostalCode, 
                          account.BillingStreet, account.BillingCity, account.BillingState, account.BillingCountry, account.BillingPostalCode
                          from Opportunity Where id=: Oppid limit 1];
        
        OppDataWrap Oppdata = new oppDataWrap();
        
        Oppdata.opportunityId = op.id;
        Oppdata.dcCode = op.Customer_ID__c;
        Oppdata.closeDate = op.CloseDate;
        Oppdata.clientName = op.account.name;
        Oppdata.phoneNumber = op.account.PersonMobilePhone;
        Oppdata.emailId = op.account.PersonEmail;
        Oppdata.projectType = op.Home_Type__c;
        Oppdata.scopeOfWork = op.Scope_Of_Work__c;
        Oppdata.civilWorkRequired = op.Civil_Work__c;
        Oppdata.proposedValue = op.Proposed_Budget__c;
        Oppdata.signupValue = op.Amount;
        Oppdata.modularDiscount = op.Modular_discount__c;
        Oppdata.modularAmount = op.Modular_Amount_Dis_Incl_GST__c;
        Oppdata.siteServicesDiscount = op.Civil_discount__c;
        Oppdata.siteServicesAmount = op.Site_Services_Amount_Dis_Incl_GST__c;
        Oppdata.decorAmount = op.Decor_Amount_Incl_GST__c;
        Oppdata.fivePercentageProjectValue = op.Initial_Payment_Amount__c;
        Oppdata.signupAmount = op.Signup_Amount__c;
        Oppdata.basicFramesofExternalDoorsAndWindows = op.Frames_for_all_external_Doors_Windows__c;
        Oppdata.reqdDoorsAndWindowsInstalled = op.The_Doors_Windows_are_installed_Requir__c;
        Oppdata.basicAllWallsCompleted = op.All_walls_are_completed_Required__c;
        Oppdata.reqdPuttyCoatOfPlasteringOnWalls = op.Putty_and_1_coat_of_plastering_Required__c;
        Oppdata.basicFloorsLeveledOutAndPrepped = op.Floors_are_levelled_out_prepped_Basic__c;
        Oppdata.reqdFlooringIsCompleted = op.Flooring_is_completed_Required__c;
        Oppdata.notes = op.Notes__c;
        Oppdata.pan = op.account.PAN__c;
        Oppdata.gst = op.account.GST_No__c;
        Oppdata.wohooCard = op.Wohoo_Card__c;
        Oppdata.remarkFromSales = op.Remarks_For_Marketing__c;
        Oppdata.salesManagerName = op.owner.name;
        Oppdata.salesManagerMobile = op.owner.MobilePhone;
        Oppdata.salesManagerEmail = op.owner.Email;
        
        customerShippingAddressWrap cc = new customerShippingAddressWrap();
        cc.country = op.account.ShippingCountry;
        cc.street = op.account.ShippingStreet;
        cc.city = op.account.ShippingCity;
        cc.zipOrPostalCode = op.account.ShippingPostalCode;
        cc.shippingState = op.account.ShippingState;
        Oppdata.projectAddress = cc;
        
        customerBillingAddressWrap cb = new customerBillingAddressWrap();
        cb.country = op.account.BillingCountry;
        cb.street = op.account.BillingStreet;
        cb.city = op.account.BillingCity;
        cb.zipOrPostalCode = op.account.BillingPostalCode;
        cb.shippingState = op.account.BillingState;
        Oppdata.currentAddress = cb;
        system.debug('Oppdata: '+Oppdata);
        
        return Oppdata;        
    }
    @AuraEnabled
    public static string showbutton(String recId){
        //Opportunity op = [select id,StageName, Update_Booking_Form__c  from Opportunity where id=: recId];
        List<opportunity> oppList = [select id,StageName, Update_Booking_Form__c  from opportunity where id =: recId limit 1]; 
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name; 
       if(oppList.size() != 0 && (oppList[0].StageName == 'Awaiting Closure' )){
               if(oppList[0].Update_Booking_Form__c == True && (profileName == 'Sales Executive' || profileName == 'Sales Team Lead' || profileName == 'FOFO')){
                         return 'Disabled';
                 }
                 else{
                          return 'Enabled';
                 }
          }
       else{
            return 'Disabled';
        }
    }
    @AuraEnabled
    public static void DC_BookingFormAPIServer(String Oppid){
        Opportunity opp = [SELECT id, Booking_Form_Status__c from opportunity where id =: Oppid];
        BookingFormAPI__c data1 = BookingFormAPI__c.getvalues('Bookapi');
        
        HttpRequest request = new HttpRequest();
        string jsonString = data1.url__c;
        request.setEndpoint(jsonString);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        String jsonBody = JSON.serialize(fetchDetails(OppId));
        system.debug('JSON BODY : '+jsonBody);
        request.setBody(jsonBody);
        
        /* No API call needed */
        if (opp.Booking_Form_Status__c == 'generated' || opp.Booking_Form_Status__c == 'updated') {
            opp.Booking_Form_Status__c = 'updated';
        }
        else {
            opp.Booking_Form_Status__c = 'generated';
        } 
        UpdateBookingFormStatus_GraphQL.UpdateBookingFormStatus(opp.Id);
        update opp;
        
        
        /*
Http http = new Http();
HttpResponse response = http.send(request); 
system.debug('Response Body:' + response.getBody());
Map<String,Object> responseData = new Map<String,Object>();
String code;
if (response.getBody() != null) {
responseData =  (Map<String,Object>)JSON.deserializeUntyped(response.getBody());
if (responseData != null){
system.debug('responseData In DC_BookingFormAPI::' + responseData.get('code'));
code = string.valueOf(responseData.get('code'));
if (code != null) {
if (opp.Booking_Form_Status__c == 'generated' || opp.Booking_Form_Status__c == 'updated') {
opp.Booking_Form_Status__c = 'updated';
}
else {
opp.Booking_Form_Status__c = 'generated';
} 
UpdateBookingFormStatus_GraphQL.UpdateBookingFormStatus(opp.Id);
update opp;
}
}

}
        //Calling ApiCallLogger class
        ApiCallLogger.method(OppId, request.getEndpoint(), jsonBody, response.getBody(), 'out');
*/
        
    }
}