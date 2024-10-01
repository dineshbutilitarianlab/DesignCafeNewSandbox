public class VDC_Accounthandler {

    // Remove \n from the billing street and shipping street
    public static void updateAddress(List<Account> NewAccounts){ 
        for (Account accountRec : NewAccounts) {
            if (String.isNotBlank(accountRec.BillingStreet)) {
                accountRec.BillingStreet = accountRec.BillingStreet.contains('\n') ? accountRec.BillingStreet.replaceAll('[\n]', ' '): accountRec.BillingStreet;
            }
            if (String.isNotBlank(accountRec.ShippingStreet)) {
                accountRec.ShippingStreet = accountRec.ShippingStreet.contains('\n') ? accountRec.ShippingStreet.replaceAll('[\n]', ' '): accountRec.ShippingStreet;
            }
        }
    }
    public static void AccountWFandPB(List<Account> NewAccounts){   
        Id AffiliateId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Affiliate').getRecordTypeId(); 
        Id SalesPartnerId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Sales Partner').getRecordTypeId();
        set<id> managerIds = new set<id>();
        for(Account Acc: NewAccounts){
            managerIds.add(Acc.Channel_Marketing_Manager__c);
        }
        list<user> userlist = [select Id,Name,Team__c from user where id =:managerIds];
        system.debug('userlist'+userlist);
        
        for(Account ac:NewAccounts){
            for(user u:userlist){
                if(ac.Channel_Marketing_Manager__c !=null && ac.Channel_Marketing_Manager__c == u.Id){
                    ac.CMM_Name__c =u.Name;
                /*    if(u.Team__c.contains('CMM Mumbai')){
                        ac.CMM_Team__c = 'CMM Mumbai';
                    }else if(u.Team__c.contains('CMM Hyderabad')){
                        ac.CMM_Team__c = 'CMM Hyderabad';
                    }else if (u.Team__c.contains('CMM Bangalore')){
                        ac.CMM_Team__c = 'CMM Bangalore';
                    }else{ */
                        ac.CMM_Team__c = u.Team__c;
                  //  }
                }
            }
            //====================== Workflow Logics           
            if(ac.Opportunity_Stage__c =='Closed Won'){
                ac.Acc_Email__c = ac.PersonEmail;
            }
            //=============================================================== 
            //===================== Process Builder Logics
            if(ac.RecordTypeId == SalesPartnerId && ac.ApprovalStatus__c == 'Submitted'){
                ac.NoRelationship__c = true;
                ac.TCAgreed__c = true;
            }
        }
    }     
}