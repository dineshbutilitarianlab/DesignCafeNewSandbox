/*
Developer : Ankit Soni 
Created Date :  12 Dec 2019
Description : Controller to handle Action Buttons action on Feedback Object.     
*/
public without sharing class FeedbackActionController {
    
    //Method will handle action from 'CustomerFeedback' lightning component's button.  
    @auraEnabled
    public static void feedbackResponse(String recId, String comments, String response, String rating){
       try{
            //Record type for closed feedback record (to hide Accept/reject button)
            Id FeedbackRecTypeId = Schema.SObjectType.Feedback__c.getRecordTypeInfosByName().get('Customer Feedback Closed').getRecordTypeId();  
            Feedback__c feedback = new Feedback__c(Id=recId, Comments__c=comments, Is_Accepted_by_Customer__c = response, Rating__c = rating, RecordTypeId = FeedbackRecTypeId);          
            update feedback;          
        }catch(exception e){            
            throw new AuraHandledException('Error ' + e.getMessage());            
        }
    }
    
}