public class PostOpportunityToDesignerDashboard {
    public class OpportunityDataWrap{    
        public String id{get;set;}
        public Double amount{get;set;}
        public Datetime closeDate{get;set;}
        public String convertedLeadId{get;set;}
        public Datetime createdDate{get;set;}
        public String email{get;set;}
        public String mobileNumber{get;set;}
        public String name{get;set;}
        public String region{get;set;}
        public String stageName{get;set;}
        public String Approx_Budget{get;set;}
        public Double Client_s_Budget{get;set;}
        public String Designer_user{get;set;}
        public Double ExpectedRevenue{get;set;} 
        public Double Initial_Payment_Amount{get;set;}
        public String interiorWorkNeededFor{get;set;}
        // public String scopeOfWork{get;set;}
        public boolean IsClosed{get;set;}
        public boolean IsWon{get;set;}
        public string ownerEmail{get;set;}
        public String meetingType{get;set;}
        public String meetingVenue{get;set;}
        public String projectName{get;set;}
        public String propertyAddress{get;set;}
        public Double proposedBudget{get;set;}
        public String homeType{get;set;}
        public String requirmentDetails{get;set;}
        public Double signupAmount{get;set;}
        public String customerId{get;set;}
        public String sfId{get;set;}
        public boolean basicFrameofExternalDoorsWindows{get;set;}
        public boolean basicAllWallsCompleted{get;set;}
        public boolean basicFloorsleveledOut{get;set;}
        public boolean reqdDoorsWindowsInstalled{get;set;}
        public boolean reqdPuttyCoatofplasteringonWalls{get;set;}
        public boolean reqdFlooringCompleted{get;set;}
        public string basicAutoCheckedifReq{get;set;}
        public string notes{get;set;}
        public string dsaRefCode{get;set;}
        public double decorAmountWithGST{get;set;}
        public double modularAmountWithGST{get;set;}
        public double civilAmountWithGST{get;set;}
        public double modularDiscount{get;set;}
        public double civilDiscount{get;set;}
        Public BillingAddressWrap billingaddress{get;set;}
        Public ShippingAddressWrap shippingaddress{get;set;}
        public String offerandDiscount{get;set;}
        public String description{get;set;} 
        public Double initialPayment{get;set;}
        public date signUpDate{get;set;}
        public String opportunityOwner{get;set;}
        public date proposalsentDate{get;set;}
        public String ModularMilestoneStage{get;set;}
        public boolean includedPM_DesignFee{get;set;}
        public boolean IsNewPaymentProject{get;set;}
    }
    public class ShippingAddressWrap{
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
    public class BillingAddressWrap{
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
    
    @future(callout=true)
    @AuraEnabled
    public static void callServer(String id){
        List<Opportunity> opp =[Select Id,Amount,CloseDate,Owner.Email,DSA_Code__c,Lead_Id__c,Initial_Payment_Amount__c,CreatedDate,Email__c,Mobile__c,Name,StageName,Approx_Budget__c,
                          Client_s_Budget__c,Design_User_Name__c,Home_Type__c,ExpectedRevenue,Initial_Payment__c,Interior_work_needed_for__c,IsClosed,
                          IsWon,Meeting_Type__c,Civil_discount__c,Modular_discount__c,Decor_Amount_Incl_GST__c,Modular_Amount_Dis_Incl_GST__c,Site_Services_Amount_Dis_Incl_GST__c,Meeting_Venue__c,Account.ShippingAddress,Account.BillingAddress,Project_Name__c,Property_Address__c,Proposed_Budget__c,Region__c,
                          account.BillingStreet,account.BillingCity,account.BillingState,account.BillingCountry,account.BillingPostalCode,Owner.name,
                          account.ShippingStreet,account.ShippingCity,account.ShippingState,account.ShippingCountry,account.ShippingPostalCode,
                          Requirement_Details__c,Design_User__c,Frames_for_all_external_Doors_Windows__c,Floors_are_levelled_out_prepped_Basic__c,
                          All_walls_are_completed_Required__c,If_the_required_part_is_checked_the_co__c,Notes__c,Putty_and_1_coat_of_plastering_Required__c,Flooring_is_completed_Required__c,
                          The_Doors_Windows_are_installed_Requir__c,Signup_Amount__c,Description,account.name,Customer_ID__c,Offer_and_discounts__c, Is_Pm_Site__c, Modular_Milestone_Type__c,
                           Proposal_Sent_Date__c, IsNewPaymentProject__c from Opportunity where id=: id limit 1];
        IF(opp.size() != 0){
        OpportunityDataWrap oppdata = new OpportunityDataWrap();
        oppdata.id = opp[0].id;
        if(opp[0].Amount !=null){
            oppdata.amount = opp[0].Amount;
        }
        if(opp[0].CloseDate !=null){
            oppdata.closeDate = opp[0].CloseDate;
        }
        if(opp[0].Lead_Id__c !=null){
            oppdata.convertedLeadId = opp[0].Lead_Id__c;
        }
        if(opp[0].CreatedDate !=null){
            oppdata.createdDate = opp[0].CreatedDate;
        }
        if(opp[0].CloseDate !=null){
            oppdata.signUpDate = opp[0].CloseDate;
        }
        if(opp[0].Email__c !=null){
            oppdata.email = opp[0].Email__c;
        }
        if(opp[0].Mobile__c !=null){
            oppdata.mobileNumber = opp[0].Mobile__c;
        }
        if(opp[0].Name !=null){
            oppdata.name = opp[0].Name;
        }
        if(opp[0].Region__c !=null){
            oppdata.region = opp[0].Region__c;
        }
        if(opp[0].StageName !=null){
            oppdata.stageName = opp[0].StageName;
        }
        if(opp[0].ExpectedRevenue !=null){
            oppdata.ExpectedRevenue = opp[0].ExpectedRevenue;
        }
        if(opp[0].IsClosed !=null){
            oppdata.IsClosed = opp[0].IsClosed;
        }
        if(opp[0].IsWon !=null){
            oppdata.IsWon = opp[0].IsWon;
        }
        if(opp[0].Description !=null){
            oppdata.description = opp[0].Description;
        }
        if(opp[0].Home_Type__c !=null){
            oppdata.homeType = opp[0].Home_Type__c;
        }
        if(opp[0].Customer_ID__c !=null){
            oppdata.customerId = opp[0].Customer_ID__c;
        }
         if(opp[0].AccountId !=null){
            oppdata.sfId = opp[0].AccountId;
        }
        if(opp[0].Decor_Amount_Incl_GST__c !=null){
            oppdata.decorAmountWithGST = opp[0].Decor_Amount_Incl_GST__c;
        }
        if(opp[0].Modular_Amount_Dis_Incl_GST__c !=null){
            oppdata.modularAmountWithGST = opp[0].Modular_Amount_Dis_Incl_GST__c;
        }
        if(opp[0].Site_Services_Amount_Dis_Incl_GST__c !=null){
            oppdata.civilAmountWithGST = opp[0].Site_Services_Amount_Dis_Incl_GST__c;
        }
        if(opp[0].Civil_discount__c !=null){
            oppdata.civilDiscount = opp[0].Civil_discount__c;
        }
        if(opp[0].Modular_discount__c !=null){
            oppdata.modularDiscount = opp[0].Modular_discount__c;
        }
        if(opp[0].Client_s_Budget__c !=null){
            oppdata.Client_s_Budget = opp[0].Client_s_Budget__c;
        }
        if(opp[0].Account.ShippingAddress !=null){
            ShippingAddressWrap cc = new ShippingAddressWrap();
            cc.country = opp[0].Account.ShippingCountry;
            cc.street = opp[0].Account.ShippingStreet;
            cc.city = opp[0].Account.ShippingCity;
            cc.zipOrPostalCode = opp[0].Account.ShippingPostalCode;
            cc.shippingState = opp[0].Account.ShippingState;
            oppdata.ShippingAddress = cc;
        }
        
        if(opp[0].Account.BillingAddress !=null){
            BillingAddressWrap cb = new BillingAddressWrap();
            cb.country = opp[0].Account.BillingCountry;
            cb.street = opp[0].Account.BillingStreet;
            cb.city = opp[0].Account.BillingCity;
            cb.zipOrPostalCode = opp[0].Account.BillingPostalCode;
            cb.shippingState = opp[0].Account.BillingState; 
            oppdata.BillingAddress = cb;
        }
        if(opp[0].Signup_Amount__c !=null){
            oppdata.signupAmount = opp[0].Signup_Amount__c;
        }
        if(opp[0].Offer_and_discounts__c !=null){
            oppdata.offerandDiscount = opp[0].Offer_and_discounts__c;
        }
        if(opp[0].Owner.Email !=null)
            oppdata.ownerEmail = opp[0].Owner.Email;
        if(opp[0].Proposed_Budget__c !=null){
            oppdata.proposedBudget = opp[0].Proposed_Budget__c;
        }
        if(opp[0].Initial_Payment_Amount__c !=null){
            oppdata.Initial_Payment_Amount = opp[0].Initial_Payment_Amount__c;
        }
        if(opp[0].Approx_Budget__c !=null){
            oppdata.Approx_Budget = opp[0].Approx_Budget__c;
        }
        if(opp[0].Initial_Payment__c !=null){
            oppdata.initialPayment = opp[0].Amount;    
        }
        if(opp[0].Interior_work_needed_for__c !=null){
            oppdata.interiorWorkNeededFor = opp[0].Interior_work_needed_for__c;
        }
        if(opp[0].Meeting_Type__c !=null){
            oppdata.meetingType = opp[0].Meeting_Type__c;
        }
        if(opp[0].Meeting_Venue__c !=null){
            oppdata.meetingVenue = opp[0].Meeting_Venue__c;
        }
        if(opp[0].Project_Name__c !=null){
            oppdata.projectName = opp[0].Project_Name__c;
        }
        if(opp[0].Property_Address__c !=null){
            oppdata.propertyAddress = opp[0].Property_Address__c;
        }
        if(opp[0].Requirement_Details__c !=null){
            oppdata.requirmentDetails = opp[0].Requirement_Details__c;
        }
        if(opp[0].Design_User__c !=null){
            oppdata.Designer_user = opp[0].Design_User__c;
        }
        if(opp[0].Frames_for_all_external_Doors_Windows__c !=null){
            oppdata.basicFrameofExternalDoorsWindows = opp[0].Frames_for_all_external_Doors_Windows__c;
        }
        if(opp[0].All_walls_are_completed_Required__c !=null){
            oppdata.basicAllWallsCompleted = opp[0].All_walls_are_completed_Required__c; 
        }
        if(opp[0].Floors_are_levelled_out_prepped_Basic__c !=null){
            oppdata.basicFloorsleveledOut = opp[0].Floors_are_levelled_out_prepped_Basic__c;
        }
        if(opp[0].The_Doors_Windows_are_installed_Requir__c !=null){
            oppdata.reqdDoorsWindowsInstalled = opp[0].The_Doors_Windows_are_installed_Requir__c;
        }
        if(opp[0].Putty_and_1_coat_of_plastering_Required__c !=null){
            oppdata.reqdPuttyCoatofplasteringonWalls = opp[0].Putty_and_1_coat_of_plastering_Required__c;
        }
        if(opp[0].Flooring_is_completed_Required__c !=null){
            oppdata.reqdFlooringCompleted = opp[0].Flooring_is_completed_Required__c;
        }
        if(opp[0].If_the_required_part_is_checked_the_co__c !=null){
            oppdata.basicAutoCheckedifReq = opp[0].If_the_required_part_is_checked_the_co__c;
        }
        if(opp[0].Notes__c !=null){
            oppdata.notes = opp[0].Notes__c;
        }
        if(opp[0].DSA_Code__c !=null){
            oppdata.dsaRefCode = opp[0].DSA_Code__c;
        }
        if(opp[0].Owner.name !=null){
            oppdata.opportunityOwner = opp[0].Owner.name;
        }
        if(opp[0].Is_Pm_Site__c !=null){
            oppdata.includedPM_DesignFee = opp[0].Is_Pm_Site__c;
        }
        if(opp[0].Modular_Milestone_Type__c !=null){
            oppdata.ModularMilestoneStage = opp[0].Modular_Milestone_Type__c;
        }
        if(opp[0].IsNewPaymentProject__c !=null){
            oppdata.IsNewPaymentProject = opp[0].IsNewPaymentProject__c;
        }
            
        String customLabelValue = Label.PostOpportunityToDD;
        system.debug('Json Serialize : '+JSON.serialize(oppdata));
        HttpRequest request = new HttpRequest();
        request.setEndpoint(customLabelValue);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        String jsonBody = JSON.serialize(oppdata);
        system.debug('JSON BODY : '+jsonBody);
        request.setBody(jsonBody);
        Http http = new Http();
            if(!test.isRunningTest()){
             	HttpResponse response = http.send(request);
                system.debug('get request :'+request); 
            	system.debug('get response :'+response);   
            }
           
        }
    }
}