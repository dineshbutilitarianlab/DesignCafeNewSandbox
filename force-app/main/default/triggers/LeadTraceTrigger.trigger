trigger LeadTraceTrigger on Lead_Trace__c (after insert , after Update) { 
    public static boolean isAfterExecutedLT = false;
    
    if(isAfterExecutedLT == false) {
        if(!System.isBatch() && !System.isFuture()) {
        	LeadTraceTrigger_Handler.leadTraceShareAccess(trigger.newMap.keyset()); 
        }
        
        isAfterExecutedLT = true;
    }
}