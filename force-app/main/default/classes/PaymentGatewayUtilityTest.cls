@IsTest
public class PaymentGatewayUtilityTest {
    @TestSetup
    public static void setup() {
        Application_Settings__c [] lSettings = new List<Application_Settings__c> {
            new Application_Settings__c(Name='AES_KEY', Value__c='psD7pwTIAAvhEx2jy0CtBg=='),
			new Application_Settings__c(Name='PAYMENT_URL', Value__c='https://uat-designcafe.cs112.force.com/Customer/s/checkout?'),
			new Application_Settings__c(Name='RZRPAY_KEY', Value__c='rzp_test_bG19kIRBdiCipf'),
			new Application_Settings__c(Name='RZRPAY_TOKEN', Value__c='gMdBglrZZfqn8AEzHY2lTNwE')
        };
		
		insert lSettings;

        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();  
        Account acc = new Account(	LastName = 'DemoTest', PersonEmail = 'test@gmail.com', BillingStreet = 'A76New Ashok Nagar', BillingCity = 'Noida',
        							BillingState = 'Delhi', BillingPostalCode = '123123', GST_No__c = 'ABC123', PersonMobilePhone='6766554432', 
                                  	recordTypeId = RecordTypeIdAccount);

        insert acc;
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        UserRole r = [SELECT Id FROM UserRole WHERE Name='CHM'];
        
        System.runAs (thisUser) { 
            User u = new User(
                ProfileId = [Select Id from profile where Name='System Administrator'].Id,
                LastName = 'last',
                Email = 'puser000@amamama.com',
                Username = 'puser000@amamama.com' + System.currentTimeMillis(),
                CompanyName = 'TEST',
                Title = 'title',
                Alias = 'alias',
                TimeZoneSidKey = 'America/Los_Angeles',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                Region__c='Bengaluru',
                userroleid=r.id
            );
            
            Id recordTypeId =Schema.SObjectType.Milestone1_Project__c.getRecordTypeInfosByDeveloperName().get('Interior_Works_Project').getRecordTypeId();
           /*NEW COMMENT
            Milestone1_Project__c project = Milestone1_Test_Utility.sampleProject('My Test Project');
            project.Region__c='Bengaluru';
            project.recordTypeId=recordTypeId;
            project.Design_Team_Name__c='WDC_1';
            
            Test.StartTest(); 
            insert project;
            
            Milestone1_Milestone__c milestone = new Milestone1_Milestone__c(name='test', Project__c = project.id, 
                                                                            Type__c='Signup', EligibleAmountPercentage__c=5);
            insert milestone;
          NEW COMMENT  */
            
            Invoice__c inv = new Invoice__c();
           // inv.Project__c = project.id;
            inv.Amount__c = 1000;
			inv.CGST__c = 90;
            inv.IGST18__c =0;
            inv.SGST__c=90;
			inv.Total_Amount__c=1180;
            inv.Total_Tax_Amount__c=180;
           // inv.Milestone__c = milestone.Id;
            inv.Customer__c = acc.Id;
            inv.Designer_Email__c = 'abc@def.com';
            inv.CHM_Email__c = 'abc@def.com';
            insert inv;
        }
    }
    
    @IsTest
    public static void test1() {
        Invoice__c lInvoice = [SELECT id FROM Invoice__c LIMIT 1];
        String lURL = PaymentGatewayUtility.getPaymentLink(lInvoice.id);
        System.assert(lURL.startsWith('https://uat-designcafe.cs112.force.com/Customer/s/checkout?'));
        
        System.runAs(new User(id=UserInfo.getUserId())) {
            Test.setMock(HttpCalloutMock.class, new RazorpayMockAPI());
            Test.startTest();
            String lOrderID = PaymentGatewayUtility.generateOrderID(PaymentGatewayUtility.encrypt(lInvoice.id));
            Test.stopTest();
            System.assertEquals('order_DBJOWzybf0sJbb', lOrderID);
        }
    }
    @IsTest
    public static void DCPaymentPageControllerTest(){
        Invoice__c lInvoice = [SELECT id FROM Invoice__c LIMIT 1];
         String lURL = PaymentGatewayUtility.encrypt(lInvoice.id);
        String lOrderID = PaymentGatewayUtility.generateOrderID(PaymentGatewayUtility.encrypt(lInvoice.id));
        DCPaymentPageController.getPaymentInfo(lURL,lOrderID);
        DCPaymentPageController.getPaymentInfo('abc','xyz');
        DCPaymentPageController.saveTransaction(lURL,lOrderID,'123','1234');
      
    }
     @IsTest
    public static void PaymentPreviewCardControllerTest(){
         Invoice__c lInvoice = [SELECT id FROM Invoice__c LIMIT 1];
         String lURL = PaymentGatewayUtility.encrypt(lInvoice.id);
        String lOrderID = PaymentGatewayUtility.generateOrderID(PaymentGatewayUtility.encrypt(lInvoice.id));
        PaymentPreviewCardController.getPaymentInfo(lURL);
        PaymentPreviewCardController.getPaymentInfo('abz');
         PaymentPreviewCardController.generateOrderID(lURL);
         PaymentPreviewCardController.generateOrderID('xyz');
         PaymentPreviewCardController.saveOrderID(lURL,lOrderID);
         PaymentPreviewCardController.saveOrderID('pqr','stu');
    }
     @IsTest
    public static void PaymentGatewayUtilityTest(){
     Invoice__c lInvoice = [SELECT id FROM Invoice__c LIMIT 1];
                String lURL = PaymentGatewayUtility.encrypt(lInvoice.id);
        String lOrderID = PaymentGatewayUtility.generateOrderID(PaymentGatewayUtility.encrypt(lInvoice.id));
        Online_Transaction__c OT= new Online_Transaction__c();
            OT.Invoice__c = lInvoice.Id;
        	OT.Order_ID__c=lOrderID;
        	OT.Status__c='Payment Pending';
        insert OT;
         PaymentGatewayUtility.saveTransactionDetails(lURL,lOrderID,'abc','xyz'); 
    }
}