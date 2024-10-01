@isTest 
public class RequestPaymentCreateProject_Test {
    
  @isTest public static void createProject(){
        
        
          
        DCWebengage__c cuset2= new DCWebengage__c();
        cuset2.Name = 'Dcwebengage';
        cuset2.BearerToken__c = '097a1996-03d2-4870-8bbc-339eb9e239b7';
        cuset2.url__c= 'https://api.webengage.com/v1/accounts/aa131ca9/users';
        
        insert cuset2;
        
        Account acc =new Account();
      	acc.Converted_Lead_ID__c='ASDF45678ASD';
        acc.Name='TestAccount';
        acc.BillingPostalCode='430056';
        acc.BillingStreet='Mahatma Gandhi Road';
        acc.GST_No__c='06BZAHM6385P6Z2';
        acc.PAN__c='ASDFG1234M';
        acc.ShippingState='Karnataka';
        acc.BillingCountry='India';
        acc.BillingState='Karnataka';
        acc.ShippingPostalCode='430056';
        acc.ShippingCountry='India';
        acc.ShippingState='Karnataka';
        acc.ShippingStreet='Mahatma Gandhi Road';
        acc.BillingCity='Bengaluru';
        acc.ShippingCity='Bengaluru';
       
        insert acc;
       
    
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
        opty.StageName = 'Meeting Done';
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
        opty.Is_Pm_Site__c=True;
        opty.Meeting_Venue__c='Mumbai Dc';
        opty.Modular_Milestone_Type__c='3 Stage';
    	opty.Lead_Id__c='ASD45678HHH';
       // opty.Client_s_Budget__c=200;
        opty.Requirement_Details__c='Wardrobes';
        opty.Flooring_is_completed_Required__c=true;
        opty.Civil_discount__c=5;
        opty.Modular_Amount_Dis_Incl_GST__c=10000;
        opty.Site_Services_Amount_Dis_Incl_GST__c=10000;
        opty.Modular_discount__c=10;
        insert opty; 
        
        
        
        RequestPaymentCreateProject.projectDataWrap projWrp =new  RequestPaymentCreateProject.projectDataWrap();
        projWrp.projectName='TestProject';
        projWrp.clientId= 'DC-35736';
        projWrp.SFCustomerID= acc.ID; 
        projWrp.projectId='DC-35736';
        projWrp.projectValue=opty.Signup_Amount__c;
        projWrp.projectStatus=opty.StageName;
        projWrp.modularValue=opty.Modular_Amount_Dis_Incl_GST__c;
        projWrp.siteServicesValue=opty.Site_Services_Amount_Dis_Incl_GST__c;
        projWrp.modularDiscount=opty.Modular_discount__c;
        projWrp.siteServicesDiscount=opty.Civil_discount__c;
        projWrp.shippingAddressCountry=acc.ShippingCountry; 
        projWrp.shippingAddressStreet=acc.ShippingStreet; 
        projWrp.shippingAddressCity=acc.ShippingCity; 
        projWrp.shippingAddressZipOrPostalCode=acc.ShippingPostalCode; 
        projWrp.shippingAddressShippingState=acc.ShippingState;
        projWrp.customerName=acc.Name; 
        projWrp.customerEmail=acc.PersonEmail; 
        projWrp.customerPhone=acc.PersonMobilePhone; 
        projWrp.referalId='DCREF-0032694'; 
        projWrp.projectReferal = true;
        projWrp.projectReferalType = 'Customer';
        projWrp.mileStoneType = opty.Modular_Milestone_Type__c;
        projWrp.signupAmount=opty.Signup_Amount__c;
        projWrp.signupState=acc.ShippingState;
        projWrp.signupCity=acc.ShippingCity;
        projWrp.salesforceDbId= acc.Id;
        projWrp.studioName=Design.Name;
        projWrp.experienceCenter=opty.Meeting_Venue__c;  //todo
        projWrp.ECCity =acc.ShippingCity;
        projWrp.isSalesForceMigratedData=false;
        projWrp.salesManagerName ='SalesManager';
        projWrp.salesManagerEmail = 'SalesManager@gmail.com';
        projWrp.designerEmail = Design.Email__c; 
        projWrp.designerName = Design.Name;
        
        Test.startTest();
       // Test.setMock(HttpCalloutMock.class, new GenerateNewInvoiceControllerMockTest());
       Test.setMock(HttpCalloutMock.class,new AccessTokenMock());
       RequestPaymentCreateProject.createProjectRequest(opty.id);
      RequestPaymentCreateProject.updateProjectOnOddo(Opty.id);
        Test.stopTest();
        
        
    }

}