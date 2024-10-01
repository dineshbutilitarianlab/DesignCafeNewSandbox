trigger AccountTrigger on Account (before insert, before update, after insert, after update) {
    list<Account> acc = trigger.new;
    if (trigger.isUpdate) {
        Account oldAcc = trigger.oldmap.get(acc[0].id);
        // Do NOT call the trigger functions if only the flag : "Customer_created_on_odoo" has changed.
        if(oldAcc.Customer_created_on_Odoo__c != acc[0].Customer_created_on_Odoo__c) {
            return;
        }
        if (oldAcc.Customer_Type__c != acc[0].Customer_Type__c) {
            List<Opportunity> opplist = [select StageName from Opportunity where AccountId = : acc[0].ID];
            // If any of the opportunities is 'Closed won', then don't allow Customer_Type to be changed.
            for (opportunity opp : opplist) {
                if (opp.StageName == 'Closed Won') {
                    acc[0].Customer_Type__c.addError('Cannot change Customer Type when a corresponding Opportunity is Closed Won');
                }
            }
        }
    }
    if(trigger.isAfter && Trigger.isInsert){
        CustomerCommunityUserUtility.createUser(trigger.new);
        updateCustomerSFID_GraphQL.UpdateCustomer(trigger.new[0].id);
        UpdateCustomer_GraphQL.UpdateCustomer(trigger.new[0].Id);
    }
    if(trigger.isAfter && Trigger.isUpdate){
        AccountHandler.updateProjectEmail(trigger.new,trigger.oldMap); 
    }  
    if(trigger.isBefore &&(trigger.isInsert || trigger.isUpdate)){
        //VDC_Accounthandler.updateAddress(trigger.new);
        VDC_Accounthandler.AccountWFandPB(trigger.new);
    } 
    //Calling Update customer and Update project api.
    if (Trigger.isafter && Trigger.isupdate) {			
        if (trigger.new != null) {
            for (Account newAcc : trigger.new) {
                /* Call the updateQuote API when Discounts are updated. */
                Account oldAcc = trigger.OldMap.get(newAcc.id);
                if (//newAcc.Name != oldAcc.Name ||
                    newAcc.PersonEmail != oldAcc.PersonEmail ||
                    newAcc.PersonMobilePhone != oldAcc.PersonMobilePhone ||
                    newAcc.BillingCountry != oldAcc.BillingCountry ||
                    newAcc.BillingState != oldAcc.BillingState ||
                    newAcc.BillingCity != oldAcc.BillingCity ||
                    newAcc.BillingStreet != oldAcc.BillingStreet ||
                    newAcc.BillingPostalCode != oldAcc.BillingPostalCode ||
                    newAcc.GST_No__c != oldAcc.GST_No__c ||
                    newAcc.PAN__c != oldAcc.PAN__c ||
                    newAcc.Customer_Type__c != oldAcc.Customer_Type__c ||
                    newAcc.ShippingStreet != oldAcc.ShippingStreet ||
                    newAcc.ShippingCity != oldAcc.ShippingCity ||
                    newAcc.ShippingCountry != oldAcc.ShippingCountry ||
                    newAcc.ShippingPostalCode != oldAcc.ShippingPostalCode ||
                    newAcc.ShippingState != oldAcc.ShippingState ||
                    //Added for Country code 
                    //newAcc.Country_Code__c != oldAcc.Country_Code__c ||
                    //newAcc.Name != oldAcc.Name ||
                    newAcc.ID != oldAcc.ID ||
                    newAcc.PersonEmail != oldAcc.PersonEmail ||
                    newAcc.PersonMobilePhone != oldAcc.PersonMobilePhone ||
                    newAcc.Referee_Code_DC__c != oldAcc.Referee_Code_DC__c ||
                    newAcc.FirstName != oldAcc.FirstName ||
                    newAcc.LastName != oldAcc.LastName) {
                        System.debug('Calling the Update Customer ');
                        UpdateCustomer_GraphQL.UpdateCustomer(newAcc.Id);
                    }
            }
        }
    }
}