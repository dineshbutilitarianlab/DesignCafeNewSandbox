@istest
public class Test_OpportunityRequirementUX {
    @istest
    public static void opptyReq(){
        Account ac = new Account();
        ac.LastName = 'Azar';
        ac.PersonMobilePhone = '9381612129';
        insert ac;
        Design_User__c du = new Design_User__c();
        du.Name = 'Munna';
        du.Email__c = 'Munna@gmail.com';
        du.Role__c = 'Design Partner';
        du.Designer_Dashboard_ID__c ='Munna9876545678';
        insert du;
        Opportunity op = new Opportunity();
        op.AccountId = ac.id;
        op.Name = ac.LastName;
        op.Amount = 500000;
        op.Approx_Budget__c = '5L to 7L';
        op.Client_s_Budget__c = 500000;
        op.Proposed_Budget__c = 500000;
        op.CloseDate = system.today();
        op.StageName = 'Meeting Done';
        op.Region__c= 'Bengaluru';
        op.X1st_Meeting_Date__c=Date.today();
        op.Meeting_Type__c = 'EC';
        op.Design_User__c = du.id;
        insert op;
        String oppoRec;
        OpportunityRequirementUXclass.Opppicklistvalues(op.id);
        OpportunityRequirementUXclass.Oppdata(op.id);
        Test.startTest();
        try
        {
            String errorRelease = OpportunityRequirementUXclass.UpdateOpportunityRec(oppoRec);
        }
        catch(exception e){
        }     
        Test.stopTest();
    }
    
    @istest
    public static void opptyReq1(){ 
        Account ac = new Account();
        ac.LastName = 'Azar';
        ac.PersonMobilePhone = '9381612129';
        insert ac;
        Design_User__c du = new Design_User__c();
        du.Name = 'Munna';
        du.Email__c = 'Munna@gmail.com';
        du.Role__c = 'Design Partner';
        du.Designer_Dashboard_ID__c ='Munna9876545678';
        insert du;
        Opportunity op = new Opportunity();
        op.AccountId = ac.id;
        op.Name = ac.LastName;
        op.Amount = 500000;
        op.Approx_Budget__c = '5L to 7L';
        op.Client_s_Budget__c = 500000;
        op.Proposed_Budget__c = 500000;
        op.CloseDate = system.today();
        op.StageName = 'Meeting Done';
        op.Region__c= 'Bengaluru';
        op.X1st_Meeting_Date__c=Date.today();
        op.Meeting_Type__c = 'EC';
        op.Design_User__c = du.id;
        insert op;
        String oppRec;
        SiteConditionUX.cbvalues(op.id);
        SiteConditionUX.OppdataSite(op.id);
        Test.startTest();
        try
        {
            String errorRelease = SiteConditionUX.UpdateOpportunitySite(oppRec);
        }
        catch(exception e){
        }     
        Test.stopTest();
    }
}