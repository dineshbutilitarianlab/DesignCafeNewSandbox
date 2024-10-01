public without sharing class CustomerProjectArtifactController {
    //Method will handle action from 'Customer Project Artifact' lightning component's button.  
    @auraEnabled
    public static void feedbackResponse(String recId, String comments, String response,String projectId){
       try{
            Id FeedbackRecTypeId = Schema.SObjectType.Project_Artifact__c.getRecordTypeInfosByDeveloperName().get('Project_Artifact_Closed').getRecordTypeId();  
            
            // Status to hide Accept/reject button
            String status = '';
            if(response =='Yes'){
                status = 'Published';
            }else{
                status = 'Rejected by Designer';
                Milestone1_Milestone__c  miles = new Milestone1_Milestone__c();
                miles.Id = projectId;
                miles.Complete__c = false;
                update miles;
                
            }
            
            Project_Artifact__c  feedback = new Project_Artifact__c (Id = recId, Status__c = status, Review_Feedback__c = comments,recordTypeId = FeedbackRecTypeId);          
            update feedback;          
        }catch(exception e){
            throw new AuraHandledException('Error ' + e.getMessage());
        }
    }
}