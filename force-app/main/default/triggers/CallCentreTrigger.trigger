trigger CallCentreTrigger on Lead (after insert) {
 /*   if(Trigger.new[0].Is_Bulk_Upload__c ==FALSE && (Trigger.New[0].CreatedBy.Profile.Name !='Call Center Team Lead' || Trigger.New[0].CreatedBy.Profile.Name !='Call Center Agent'))
    {
        CallCenterAPI.basicAuthCallout(Trigger.New[0].id);
    }
*/
}