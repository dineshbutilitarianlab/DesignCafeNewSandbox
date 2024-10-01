public with sharing class OpportunityStageHandler {
    
    // Do not allow Opportunity stage to change to 'closed won' if there is no invoice created.
    // 
    // Make a set of All incoming Opp.IDs
    // Query from Opportunity_Invoice__c to make a set of IDs among these which have invoice created; 
    // 
    // Diff of these sets will give the IDs without any invoices.
    // 
    public static void OpportunityStageWon (List<Opportunity> OppList, Map<Id,Opportunity> OldOpp) {
        Set<Id> OppId = new Set<Id>();	
        Set<Id> oppIdStageProposalSent = new Set<Id>();
        
        for (Opportunity opp: OppList) {
            if (opp.StageName == 'Closed Won') {	// We're only concerned about 'closed won' opportunities.
	            OppId.add(opp.Id);                       
            }
        }
        if (OppId.size() > 0) {
            for (Opportunity_Invoice__c OppInv : [Select Opportunity__c From Opportunity_Invoice__c Where Opportunity__c IN : oppId]) {		
                OppId.remove(OppInv.Opportunity__c);   
            }
        }
        // Now, OppId contains only those opportunities which DO NOT have any invoice. Throw error if stage changed to closed won
        for (Opportunity oppt: OppList) {            
            if ((oppt.StageName == 'Closed Won') && (OppId.contains(oppt.Id)) && (oppt.StageName != oldOpp.get(oppt.Id).StageName)) {
               // oppt.StageName.addError('Please create an invoice before setting the Opportunity Stage as "Closed Won"');
            }
        }
        
        System.debug('OppList ==> ' + OppList);
        Set<String> stageName = new Set<String>{'Proposal Sent', 'Follow Up', 'Discussion', 'Awaiting Closure', 'Closed Won', 'Closed Lost'};
        for(Opportunity oppt: OppList){
            if(stageName.contains(oppt.StageName)){
            	oppIdStageProposalSent.add(oppt.Id);     
            }
        }
        System.debug('oppIdStageProposalSent ==> ' + oppIdStageProposalSent);
        if(oppIdStageProposalSent.size() > 0){
            Map<Id, Quote> quoteMap = new Map<Id, Quote>();
            for(Quote qt: [SELECT Id, Status, OpportunityId FROM Quote WHERE OpportunityId IN: oppIdStageProposalSent AND Status IN ('Approved','Rejected','Presented','Accepted','Denied')]){
            	quoteMap.put(qt.OpportunityId, qt);    
            }
            System.debug('quoteMap ==> ' + quoteMap);
            for(Opportunity oppt: OppList){
                if(!quoteMap.containsKey(oppt.Id)){
                //	if(!Test.isRunningTest())
                   // 	oppt.addError('No any quote is approved.');	    
                }
            }    
        }
    }
}