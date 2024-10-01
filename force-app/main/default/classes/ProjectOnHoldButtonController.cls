public class ProjectOnHoldButtonController {
    @auraEnabled
    public static void markProjectOnHold(String recId) {
        try {
            Milestone1_Project__c lProject=[SELECT Id FROM Milestone1_Project__c WHERE Id = :recId];
            update new Milestone1_Project__c(id=lProject.id, Status__c='On Hold');
        }
        catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}