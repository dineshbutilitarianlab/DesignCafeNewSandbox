@isTest
public class InvoiceTriggerTest {
    @isTest
    public static void testSample() {
        User thisUser = [select Id from User where Id = :UserInfo.getUserId()];
        EmailTemplate et = new EmailTemplate(); 
        et.isActive = true; 
        et.Name = 'testTemplate'; 
        et.DeveloperName = 'testTemplate' + System.now().getTime(); 
        et.TemplateType = 'text'; 
        et.FolderId = UserInfo.getUserId(); 
        et.Body = ''; 

        System.runAs(thisUser){
            insert et;
        }
        
        Incentive_Amount__c objAmount = new Incentive_Amount__c();
        objAmount.CGST__c = 9;
        objAmount.Name = 'CGST';
        Insert objAmount;
        
        Incentive_Amount__c objAmount1 = new Incentive_Amount__c();
        objAmount1.SGST__c = 8;
        objAmount1.Name = 'SGST';
        Insert objAmount1;
        
        Account acc = new Account(FirstName = 'test',LastName = 'test',PersonEmail = 'test@gmail.com');
        insert acc;
        Contact con = new Contact();
        con.FirstName = 'Raja';
        con.LastName = 'Sangram';
        Insert con;
        
        // Create project
        Milestone1_Project__c project = Milestone1_Test_Utility.sampleProject('My Project');
        project.Region__c='Bengaluru';
        insert project;
        
        Milestone1_Milestone__c parentmilestone = new Milestone1_Milestone__c(name='test', Project__c = project.id,Type__c='KYC',EligibleAmountPercentage__c = 2);
        insert parentmilestone;
        
        Milestone1_Milestone__c milestone = new Milestone1_Milestone__c(name='test', Project__c = project.id,Type__c='KYC',Successor_Milestone__c =parentmilestone.id );
        insert milestone;
        System.debug('milestone::'+milestone.Is_Pre_payment_Milestone__c);
    }
}