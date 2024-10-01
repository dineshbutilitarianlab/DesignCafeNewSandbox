public class FeedbackTriggerHelper {
    
    public static void updateActivityStatus(Map<Id,Feedback__c> fList,Map<Id,Feedback__c> oldfList){
        /*Set<id> pActivityId = new Set<id>();
List<Milestone1_Milestone__c> activityList = new List<Milestone1_Milestone__c>();

for(Feedback__c fc:fList.values()){
Milestone1_Milestone__c mRec = new Milestone1_Milestone__c(id=fc.Project_Activity__c);
if(oldfList.get(fc.id).Is_Accepted_by_Customer__c =='Awaiting Confirmation' && fc.Is_Accepted_by_Customer__c =='Yes'){
mRec.id=fc.Project_Activity__c;
mRec.Is_Accepted_by_Customer__c ='Yes';
mRec.Actual_Completion_Date__c = System.now();

}else if(oldfList.get(fc.id).Is_Accepted_by_Customer__c =='Awaiting Confirmation' && fc.Is_Accepted_by_Customer__c =='No'){
mRec.id=fc.Project_Activity__c;
mRec.Is_Accepted_by_Customer__c ='No';
mRec.Complete__c = false;
}
activityList.add(mRec);
}
if(activityList.size()>0){
update activityList;
}*/
    }
    
    /**
* Method use to insert Customer_Contact On Feedback (before insert).
* @author Ranveer
*/
    
    public static void insertCustomeOnFeedback(List<Feedback__c> feedbacklist){
        /*Set<Id> projectId = new Set<Id>();
        Map<String,String> mapOfProjectWithContactId=new Map<String,String> ();
        for(Feedback__c feedobj : feedbacklist){
            if(feedobj.Project__c!=null){
                projectId.add(feedobj.Project__c);
            }
            for(Milestone1_Project__c proObj : [select id,Customer__r.PersonContactId from Milestone1_Project__c where id in :projectId]){
                mapOfProjectWithContactId.put(proObj.id,proObj.Customer__r.PersonContactId);
            }
            for(Feedback__c feedObjt : feedbacklist){
                feedObjt.Customer_Contact__c=mapOfProjectWithContactId.get(feedObjt.Project__c);
            }
        }*/
    }
    
    
     public static void updateCHMandDesignerEmail(List<Feedback__c> listoffeedback){
        system.debug('inside chm insert'+listoffeedback);
        set<Id> Projectids = new set<Id>();
        for(Feedback__c feedback : listoffeedback){
            if(feedback != Null){
                Projectids.add(feedback.Project__c); 
            }
        }
    system.debug('projectids-->>'+Projectids);
        map<Id, Milestone1_project__c> mapofproject = new map<Id, Milestone1_project__c>([select id,CHM__c ,Designer__r.email, CHM__r.email, CHM__r.name from Milestone1_project__c where id IN : Projectids]);
      for(Feedback__c singlefeedback : listoffeedback){
            system.debug('INSIDE FOR');
            if(singlefeedback.Project__c !=Null && mapofproject.containsKey(singlefeedback.Project__c) && mapofproject.get(singlefeedback.Project__c).CHM__r.email != Null && mapofproject.get(singlefeedback.Project__c).Designer__r.email != Null ){
                system.debug('INSIDE IF');
                singlefeedback.CHM_Email__c = mapofproject.get(singlefeedback.Project__c).CHM__r.email;
                singlefeedback.Designer_Email__c  = mapofproject.get(singlefeedback.Project__c).Designer__r.email;
            }
        }
    }
}