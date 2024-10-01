public class SMSTriggeringEventsQueableClass implements Queueable, Database.AllowsCallouts {  
    private Set<Id> setOfRecIds = new Set<Id>();
    private String objectName = ''; 
    private Boolean dateChangedEvent = false;
    private Queueable mChildToSpawn = null;
    
    public SMSTriggeringEventsQueableClass(String objectName, Set<Id> setOfRecIds, Boolean dateChangedEvent) { 
        this.objectName             = objectName;  
        this.setOfRecIds            = setOfRecIds;
        this.dateChangedEvent       = dateChangedEvent;
    }
    
    public SMSTriggeringEventsQueableClass(String objectName, Set<Id> setOfRecIds, Boolean dateChangedEvent, Queueable aChildToSpawn) {
        this.objectName             = objectName;  
        this.setOfRecIds            = setOfRecIds;
        this.dateChangedEvent       = dateChangedEvent;
        mChildToSpawn = aChildToSpawn;
    }
    
    public void execute(QueueableContext qc) {
        try {
            SMSIntegration_Handler.calloutToSendSMSMainFunct(objectName, setOfRecIds, dateChangedEvent);
        }
        catch(Exception e) {
           
        }
        if(!Test.isRunningTest()) {
            if(mChildToSpawn != null) {
                System.enqueueJob(mChildToSpawn);
            }
        }
   }
}