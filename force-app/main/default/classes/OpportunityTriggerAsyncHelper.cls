public class OpportunityTriggerAsyncHelper implements Queueable {
    private Map<ID, Opportunity> mNewMap;
    private Map<ID, Opportunity> mOldMap;
        
    public OpportunityTriggerAsyncHelper(Map<ID, Opportunity> aNewMap, Map<ID, Opportunity> aOldMap) {
        mNewMap = aNewMap;
        mOldMap = aOldMap;
    }
    
	public void execute(QueueableContext context) {
        ProjectCreationStep1Async PCAsync;
        List<Opportunity> lOppForProjectCreation = new List<Opportunity>();
        IncentivesUtility.createOpportunityIncentive(mNewMap.values(), mOldMap);
       	
        for(Opportunity lOpp : mNewMap.values()) {
            Opportunity lOld = mOldMap.get(lOpp.id);
            
            if(lOpp.StageName != lOld.StageName && lOpp.StageName == 'Closed Won') {
                lOppForProjectCreation.add(lOpp);
            }
        }
        
        ProjectCreationStep1Async lPCAsync = null;
		
        if(lOppForProjectCreation.size() == 1) {
            Opportunity lOpportunity = [SELECT id, Amount, CloseDate, Signup_Amount__c FROM Opportunity WHERE Id=:lOppForProjectCreation[0].id];
            lPCAsync = new ProjectCreationStep1Async(lOpportunity.Id, lOpportunity.CloseDate, lOpportunity.Amount, lOpportunity.Signup_Amount__c);
        }
        
        if(!Test.isRunningTest()) {
            // Comment on 22 August 2024 by Muskan Jain, request by DD Team , will not being used in salesforce.
            //ID jobID = System.enqueueJob(new SMSTriggeringEventsQueableClass('Opportunity', mNewMap.keyset(), false, lPCAsync));
        }
    }
}