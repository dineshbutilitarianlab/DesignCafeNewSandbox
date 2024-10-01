trigger ContentversionTrigger on ContentVersion (After update, After insert) {
    if(trigger.isAfter){
        if (trigger.isInsert) {
            //ContentversionTriggerHelper.onAfterInsert(trigger.new);
        }
        if (trigger.isUpdate) {
            for(ContentVersion cv:trigger.new){
                // Comment on 22 August 2024 by Muskan Jain, request by DD Team , will not being used in salesforce.
                //ProposalTemplateCallout.sendProposalTemplateCalloutREST(cv.Id);  
            }
        }

    }
}