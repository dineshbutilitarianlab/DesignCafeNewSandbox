@isTest
public class LeadAllocationBatchTest {
  /*  
    @testsetup
    public static void setUpData(){
        Design_Cafe_Settings__c dcsetting = New Design_Cafe_Settings__c(Content_Type__c='application/json',Msg91_Auth_Key__c='246302AsvW6lRq5be03212',Msg91_URL__c='https://api.msg91.com/api/v2/sendsms?country=91',Route__c='4',Sender_Name__c='DESNCF',Working_Hour_End_Time__c=18,Working_Hour_Start_Time__c=9);
        insert dcsetting;
        Group testGroup = new Group(Name='Unassigned', type='Queue');
        insert testGroup;
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs(thisUser){
            QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SobjectType = 'Lead');
            insert testQueue;
        }
        Lead_Allocation_Rule__c lRule = new Lead_Allocation_Rule__c(Agency_Group_Name__c='LTC-Bangalore-Online-GoogleAdwords-Team' , Channel__c = 'Online', Source__c = 'Direct',Region__c='Bengaluru',Campaign_Source__c='Direct');
        insert lRule;
        
        
        Lead leadA = new Lead(LastName='Francis',  Region__c='Bengaluru', City='Bengaluru' ,Channel__c = 'Online', Source__c = 'Direct',DC_Lead_Source__c ='Direct', Follow_Up_Count__c=0, Status='New', Email='sjaiswal@huronconsultinggroup.com',MobilePhone='9999999999');
        insert leadA;
        leadA.OwnerId = testGroup.id;
        update leadA; 
    }
*/
    @isTest
    public static void LeadAllocation1(){
        Test.startTest();
        LeadAllocationSchedule sh1 = new LeadAllocationSchedule();
        String sch = '0 0 23 * * ?'; system.schedule('Test Territory Check', sch, sh1);
        For(Lead LeadObj:[Select Id,Name,Owner.Name From lead]){
            String a = LeadObj.Owner.Name;
            System.debug('a'+a);
        }
        Test.stopTest();
        Test.setMock(HttpCalloutMock.class, new CCMockUp());
    }
}