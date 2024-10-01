@isTest public class ValidationOnPayMI_Test {

    @isTest public static void validationTest(){
         
           try{
        test.startTest();
          Test.setMock(HttpCalloutMock.class,new AccessTokenMock()); 
        DCWebengage__c cuset2= new DCWebengage__c();
        cuset2.Name = 'Dcwebengage';
        cuset2.BearerToken__c = '097a1996-03d2-4870-8bbc-339eb9e239b7';
        cuset2.url__c= 'https://api.webengage.com/v1/accounts/aa131ca9/users';
        insert cuset2;
        
        
     
  id RecordTypeAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        
       Account acc =new Account();
        acc.FirstName='Test';
        acc.LastName='Account';
        acc.BillingPostalCode='430056';
        acc.BillingStreet='Mahatma Gandhi Road';
        acc.ShippingState='Karnataka';
        acc.BillingCountry='India';
        acc.BillingState='Karnataka';
        acc.ShippingPostalCode='430056';
        acc.ShippingCountry='';
        acc.ShippingState='';
        acc.ShippingStreet='Mahatma Gandhi Road';
        acc.BillingCity='';
        acc.ShippingCity='';
        acc.PAN__c = '';
        acc.Customer_type__c = 'B2B';
        acc.Converted_Lead_ID__c='ASDFG45676GFD';
        acc.GST_No__c='';
        insert acc;
         acc.Customer_type__c ='';           
        Design_User__c Design= new Design_User__c();
        Design.Name='Test Designer';
        Design.Designer_Dashboard_ID__c='QA-1234';
        Design.Email__c='design@yopmail.com';
        Design.Mobile__c='9066078981';
        Design.Region__c='Bengaluru';
        Design.Experience_Center__c='Mumbai Dc';
        Design.Role__c='Inhouse Designer';
        Design.Active__c=True;
        
        insert Design;
        
        opportunity opty=new opportunity();
        opty.Name='TestOpp';
        opty.AccountId=acc.Id;
        opty.stagename = 'Meeting Done';
        opty.Amount = 999;
        opty.Wohoo_Card__c = '567';
        opty.Signup_Amount__c = 88788;
        opty.Client_s_Budget__c = 8989;
        opty.Probability = 100;
        opty.X1st_Meeting_Person__c = '0052v00000bZuLL';
        opty.X1st_Meeting_Date__c = system.today();
        opty.Meeting_Type__c = 'EC';
        opty.region__C = 'Bengaluru';
        opty.CloseDate = system.today();
        opty.Amount=3124;
        opty.OwnerId =userinfo.getUserId();
        opty.Design_User__c = design.Id;
        opty.Is_Pm_Site__c=true;
        opty.Meeting_Venue__c='Mumbai Dc';
        opty.Modular_Milestone_Type__c='';
        opty.Client_s_Budget__c=200;
        opty.Requirement_Details__c='Wardrobes';
        opty.Flooring_is_completed_Required__c=true;
        opty.Site_Services_Amount_Dis_Incl_GST__c=2000;
        opty.Modular_Amount_Dis_Incl_GST__c=0;
        opty.IsNewPaymentProject__c =true;
        opty.Lead_Id__c='ASDF456789HJK';
        insert opty;
      	opty.Project_Created_On_Odoo__c=true;
        update opty; 
              ValidationOnPaymi.validationMethod(opty.id);
             Test.stopTest();
        }catch(Exception e)
        {
            
        }
        ValidationOnPaymi.ResponseToBeSentToAura wrp =new ValidationOnPaymi.ResponseToBeSentToAura();
        wrp.errorMessage='Test Description';
        wrp.invoiceType='';
        wrp.validationPass=true;
     
    }
      
        
}