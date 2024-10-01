@isTest
public class LeadtoGenesys_test {
    public static void Testclass(){
         Leadtogenesys__c cuset1 = new Leadtogenesys__c();
        cuset1.Name = 'genesysapi';
        cuset1.url__c = 'http://dctest.greettech.com:8081/leadsTogreetTest.php';
        insert cuset1; 
        Lead l = new Lead();
        l.LastName = 'test';
      //  l.LastModifiedDate=system.today();
        l.City = 'Mumbai';
        l.MobilePhone='1234567890';
        l.Project_Name__c= 'DC';
        l.Email = 'imtiyaz@dc.com';
       // l.Status = 'new';
        //l.Channel__c = 'online';
        insert l;
        
        l.Whatsapp_Opt_IN__c = true;
        l.Willingness_For_Meeting__c = system.today();
        update l;
        
        Lead l1 = new Lead();
        l1.LastName = 'test1';
        l1.City = 'Mumbai';
        l1.MobilePhone='1234567891';
       // l1.LastModifiedDate=system.today();
        l1.Email = 'imtiyaz1@dc.com';
        l1.Whatsapp_Opt_IN__c = true;
        insert l1;
        
        l1.Status = 'new';
        l1.Channel__c = 'online';
        update l1; 
    }
    @isTest
    public static void CallCenterTrigger1(){
        TriggerControl__c cuset1 = new TriggerControl__c();
        cuset1.Name = 'LeadTrigger';
        cuset1.Run__c = true;
        insert cuset1; 
        Testclass();
        Lead l =[select id,Name,Email,MobilePhone,Source__c,Region__c,Channel__c,City,DC_Lead_Source__c,LastModifiedDate,Follow_Up_Date_Time__c,DC_Campaign_Source__c,DSA__c,DSAname__c,Lead_Owner_Name__c,CreatedBy.id,LastModifiedById,DC_Lead_Status__c,Status,Call_Stage__c,CreatedDate,Property_Possession_Date__c from Lead where lastname = 'test'];
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
        LeadtoGenesys.Callout(l.id);
    }
}