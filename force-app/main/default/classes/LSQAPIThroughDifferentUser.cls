public class LSQAPIThroughDifferentUser {
@InvocableMethod(callout=true)
   public static void Callout(List<String> leadIdSet){
        try{
            List<Lead> updatedLeadList = new List<Lead>();
            List<Lead> leadList = [SELECT Id, Name, Email, MobilePhone, APIMOBILE__c, Source__c,
                             Project_Name__c, Region__c, Channel__c, Model_of_Business__c, City, DC_Lead_Source__c,
                             LastModifiedDate, Follow_Up_Date_Time__c, LastModifiedBy__c, 
                             DC_Campaign_Source__c, DSA__c, DSAname__c, Lead_Owner_Name__c, 
                             CreatedBy.id, DC_Lead_Status__c, Status, Call_Stage__c, CreatedDate,
                             Property_Possession_Date__c,LARR__c,OwnerId,GuestUserUpdated__c
                             FROM Lead WHERE Id IN: leadIdSet
                             AND LastModifiedBy__c = 'Site Guest User'];
            for(Lead leadRecord : leadList){  
                leadRecord.GuestUserUpdated__c = true;
                updatedLeadList.add(leadRecord);
                
            }
            if(updatedLeadList != null && updatedLeadList.size() > 0){
                update updatedLeadList  ; 
            }
        }
        catch(Exception exc){
            system.debug('Exception in LSQAPIThroughDifferentUser: ' + exc.getMessage());
        }
    }
}