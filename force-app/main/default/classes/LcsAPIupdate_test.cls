@isTest
public class LcsAPIupdate_test {
    public static testmethod void testLead(){
        Opportunity Opp = new Opportunity();
        Opp.Approx_Budget__c = '2L to 3L';
        Opp.Home_Type__c='villa';
       //Opp.Property_Possession_Date__c=system.today();
        Opp.Project_Name__c='Awdhesh test';
        Opp.Home_Type__c='0';
       //Opp.Email__c='imtiaz@designcafe.com';
        Opp.Phone__c='9001101111';
       // Opp.Designer__c='';
      //OPP.designerName='';
     // Opp.Mobile__c='9001233334';
        Opp.Meeting_Venue__c='MGDC';
       // Opp.Design_User_Name__c='';
        Opp.Meeting_Type__c='EC';
        Opp.Channel__c = 'Online';
        Opp.Source__c = '';
        Opp.Region__c = 'Mumbai';
        Opp.Meeting_Type__c='EC';
        Opp.Meeting_Venue__c='MGDC';
        opp.StageName='Meeting done';
        opp.CloseDate=System.today()+2;
        Opp.Interior_work_needed_for__c='Living Room';
        Opp.Requirement_Details__c='Wardrobes';
        Opp.Knew_about_Design_Cafe_Because__c ='';
        Opp.LeadSource='';
        Opp.Name = 'test';
        Opp.Description='test';
        Opp.Phone__c = '+910000000000';
        insert OPP;
        Test.startTest();
       // Test.setMock(HttpCalloutMock.class, new LcsupdateMockup());
        LcsAPIupdate.LcscallServer(Opp.id);
        Test.stopTest();
        
    }
}