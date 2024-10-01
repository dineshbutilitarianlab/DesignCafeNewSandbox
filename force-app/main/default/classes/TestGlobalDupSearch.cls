@istest
public class TestGlobalDupSearch { 
    @istest 
    Static void globaldup(){
        
        Account ac= new account();
        ac.Name = 'testdup';
        insert ac;
        
        account acc= new account();
        acc.LastName='personacc';
        acc.PersonMobilePhone='+918106333333';
        insert acc;
        
        contact con = new contact();
        con.LastName = 'testdup';
        con.AccountId=ac.Id;
        con.MobilePhone = '+918106333333';
        con.Email='duptest@gmail.com';
        insert con;
        
        lead ld = new lead();
        ld.lastname='leadinsert';
        ld.LeadSource='walkin';
        ld.Status='New';
        ld.MobilePhone='+918106333333';
        ld.City ='Bengaluru';
        ld.DUP_Update_Owner__c = true;
        insert ld;
        list<lead> Ldlist =[select id,name from lead];
        opportunity opp = new opportunity();
        opp.Name='opp1';
        opp.AccountId=acc.Id;
        opp.CloseDate=system.today();
        opp.StageName='Qualified';
        insert opp; 
        
        ApexPages.StandardsetController sc = new ApexPages.StandardsetController(Ldlist);
        GlobalDupSearch1 gb= new GlobalDupSearch1(sc);
        gb.PE='+918106333333';
        gb.search();
        gb.save();
        gb.createLead();
        gb.PE='';
        gb.search();
        gb.PE='+919876543210';
        gb.search();
        
        lead ld1 = new lead();
        ld1.lastname='leadinsert';
        ld1.LeadSource='walkin';
        ld1.Status='Prospect';
        ld1.MobilePhone='+918106333334';
        ld1.City ='Bengaluru';
        insert ld1;
        
        gb.PE='+918106333334';
        test.starttest();
        Test.setMock(HttpCalloutMock.class, new CCMockUp()); 
		gb.search();
        gb.save();
        test.stopTest();
        
    }
   
}