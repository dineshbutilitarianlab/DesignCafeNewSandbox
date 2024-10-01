@IsTest
public class LeadEventTriggerTest {

@isTest static void testChangeEventTrigger() {
    // Enable all Change Data Capture entities for notifications.
    Test.enableChangeDataCapture();
    
    // Insert one or more test records
    // ...
            Design_Cafe_Settings__c dcsetting = New Design_Cafe_Settings__c(Content_Type__c='application/json',Msg91_Auth_Key__c='246302AsvW6lRq5be03212',Msg91_URL__c='https://api.msg91.com/api/v2/sendsms?country=91',Route__c='4',Sender_Name__c='DESNCF',Working_Hour_End_Time__c=18,Working_Hour_Start_Time__c=9);
        insert dcsetting;
            Lead leadA = new Lead(LastName='Francis',  Region__c='Bengaluru', City='Bengaluru' ,Channel__c = 'Online', Source__c = 'Direct',DC_Lead_Source__c='Direct', Follow_Up_Count__c=0, Status='New', Email='sjaiswal@huronconsultinggroup.com',MobilePhone='9999999999');
        insert leadA; 
    // Deliver test change events
    Test.getEventBus().deliver();
     Test.setMock(HttpCalloutMock.class, new CCMockUp());
    
    // Verify the change event trigger’s execution
    // ...
}   }