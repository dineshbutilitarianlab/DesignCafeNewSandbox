@isTest
public class Test_Unassignedleadtoqueue {
    @istest  
    static void Unassigned1(){
          Test.setMock(HttpCalloutMock.class, new CCMockUp());
        integer month=system.today().month();
        Lead l=new Lead();
        l.Approx_Budget__c='2L to 3L';  
        l.Status ='New';
        l.LastName ='priya';
        l.MobilePhone ='9874563211';
        l.City ='Bengaluru';
        insert l;
        
        Test.startTest();
        Unassignedleadtoqueue b=new Unassignedleadtoqueue();
        database.executeBatch(b,500);
        Test.stopTest();
       
    }  
    
}