public without sharing class QuickCaseController {
    @AuraEnabled
    public static Milestone1_Project__c getProject(Id projectId) {
        //TODO :: Perform isAccessible() checks here
        return [SELECT Id, Name, Customer__c FROM Milestone1_Project__c WHERE Id = :projectId];
    }
    
    public class Response {
        @AuraEnabled public String status_code;
        @AuraEnabled public String status_message;
        @AuraEnabled public String case_id;
        
        private Response(String aStatusCode, String aStatusMsg) {
            status_code = aStatusCode;
            status_message = aStatusMsg;
        }
    }
    
    @AuraEnabled
    public static Response saveCaseWithProject(Case case1, Milestone1_Project__c project) {
        Response lResponse = new Response('200', 'Success');
        
        //TODO :: Perform isAccessible() and isUpdateable() checks here     
        try {
            Project_Team_Member__c [] lDesigner = [SELECT Id, User__c, Project__r.Customer__r.PersonContactId FROM Project_Team_Member__c where Role__c = 'Primary Designer' AND Project__c = :project.Id limit 1];
            Project_Team_Member__c [] lCHM = [SELECT Id, User__c, Project__r.Customer__r.PersonContactId FROM Project_Team_Member__c where Role__c = 'Customer Happiness Manager' AND Project__c = :project.Id limit 1];
            
            if(lDesigner.size() > 0 || lCHM.size() > 0) {
                ID lCaseOwner = (lCHM.size() > 0 && lCHM[0].User__c != null ? lCHM[0].User__c : (lDesigner.size() > 0 ? lDesigner[0].User__c : null));
                
                if(lCaseOwner != null) {
                    case1.OwnerId = lCaseOwner;
                    case1.Project__c = project.Id;       
                    case1.Status = 'New';
                    case1.Origin = 'Web'; 
                    case1.Priority = 'Medium'; 
                    case1.AccountId = project.Customer__c;
                    case1.ContactId = (lCHM.size() > 0 && lCHM[0].User__c != null ? lCHM[0].Project__r.Customer__r.PersonContactId : 
                                       (lDesigner.size() > 0 ? lDesigner[0].Project__r.Customer__r.PersonContactId : null));
                    upsert case1;
                }
            }
        }
        catch(Exception ex) {
            System.debug('^^^ ' + ex.getMessage());
            lResponse = new Response('500', 'Unable to create case. ' + ex.getMessage());
        }
        
        return lResponse;
    }
}