/*
*Created By     : 
*Created Date   : 09/12/2019
*Description    : Test Coverage For "CustomerCommunityUserUtility"
*Class Name     : CustomerCommunityUserUtility
Modification History :
============================================================================================
V.No    Date            By                  Description
============================================================================================
*/
@IsTest
public class CustomerCommunityUserUtility_Test{
    @IsTest 
    static void testCustomerCommunityUserUtility() {
          // Create PersonAccount
          Application_Settings__c porprofile = new Application_Settings__c();
        	porprofile.Name = 'CUSTOMER_COMMUNITY_PROFILEID';
        	porprofile.Value__c='00e2v000002Ce2u';
        	insert porprofile;
          Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
            Account acc = new Account(FirstName = 'test',LastName = 'test',PersonEmail = 'test@gmail.com',RecordTypeId  = devRecordTypeId);
            insert acc;
            
            // Create project
            Milestone1_Project__c project = new Milestone1_Project__c(Name = 'test',Customer__c = acc.Id);
            insert project;
         
     }     
 }