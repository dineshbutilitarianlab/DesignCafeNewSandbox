/*
*Created By     : Ranveer
*Created Date   : 07/01/2020
*Description    : Test Coverage For "CreateCommunityUserController"
*Class Name     : CreateCommunityUserController
Modification History :
============================================================================================
V.No    Date            By                  Description
============================================================================================
*/
@IsTest
public class CreateCommunityUserControllerTest {
    @isTest
    static void testCreateCommunityUserControllerTest() {
         // Create PersonAccount
          //Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
          Account a = new Account(FirstName = 'Rathi',LastName = 'RathiAcct',PersonEmail = 'RathiAcct123@gmail.com');  
          insert a;
          account acc=[select id, IsPersonAccount from account where id=:a.id];
          system.debug('@@@@@----acc---'+acc);      
          User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()]; 
          System.runAs (thisUser) {  
       
            CreateCommunityUserController.createUser(a.id);
          
      }
    }
}