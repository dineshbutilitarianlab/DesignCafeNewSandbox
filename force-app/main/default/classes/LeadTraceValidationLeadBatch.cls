public class LeadTraceValidationLeadBatch implements Database.Batchable<SObject> {
    public Database.querylocator start(Database.BatchableContext aContext) {
        return Database.getQueryLocator([SELECT id,Status,DC_Lead_Status__c,Willingness_For_Meeting__c FROM Lead WHERE DC_Lead_Status__c IN ('Meeting Scheduled', 'Meeting Done') OR (Status IN ('Junk') AND Willingness_For_Meeting__c != NULL)]);
    }

	public void execute(Database.BatchableContext BC, List<Lead> aScope) {
        Savepoint sp = Database.setSavepoint();
        
        try {
            processRecords(aScope);
        }
        catch(Exception e) {
            Database.rollback(sp);
            throw new CustomException(e.getMessage());
        }
    }
    
    private void processRecords(Lead [] aScope) {
        Set<ID> lLeadIDSet = new Set<ID>();
        
        for(Lead lLead : aScope) {
            lLeadIDSet.add(lLead.id);
        }
        
        Set<ID> lTraceIdForSharingDeletion = new Set<ID>();
        Lead_Trace__c [] lTracesToInsert = new List<Lead_Trace__c>();
        Lead_Trace__c [] lTracesForUpdation = new List<Lead_Trace__c>();
        Lead_Trace__c [] lDuplicatesToDelete = new List<Lead_Trace__c>();
        
        for(Lead lLead : [SELECT id, OwnerId, DC_Lead_Status__c, Status, LastModifiedDate, Owner.ProfileId, Owner.Profile.Name,
                          	(SELECT id, OwnerId, Status__c, Lead__c FROM Lead_Traces__r WHERE 
							Status__c IN ('Meeting Scheduled', 'Meeting Done') ORDER BY CreatedDate ASC) FROM Lead WHERE id IN:lLeadIDSet]) {
            Boolean lMSTraceRecordPresent = false;
            Boolean lMDTraceRecordPresent = false;
            
			for(Lead_Trace__c lTrace : lLead.Lead_Traces__r) {
                if(lTrace.Status__c == 'Meeting Scheduled') {
                    if(lMSTraceRecordPresent) {
                        lDuplicatesToDelete.add(lTrace);
                        continue;
                    }
                    
                    if(lTrace.OwnerId != lLead.OwnerId) {
                        lTraceIdForSharingDeletion.add(lTrace.id);
                        lTracesForUpdation.add(new Lead_Trace__c(id=lTrace.id, OwnerId=lLead.OwnerId));
                    }
                    
                    lMSTraceRecordPresent = true;
                }
                else if(lTrace.Status__c == 'Meeting Done') {
                    if(lMDTraceRecordPresent) {
                        lDuplicatesToDelete.add(lTrace);
                        continue;
                    }
                    
                    if(lTrace.OwnerId != lLead.OwnerId) {
                        lTraceIdForSharingDeletion.add(lTrace.id);
                        lTracesForUpdation.add(new Lead_Trace__c(id=lTrace.id, OwnerId=lLead.OwnerId));
                    }
                    
                    lMDTraceRecordPresent = true;
                }
            }
                                          
			if((lLead.DC_Lead_Status__c == 'Meeting Scheduled' || lLead.DC_Lead_Status__c == 'Meeting Done') && lMSTraceRecordPresent == false) {
                lTracesToInsert.add(new Lead_Trace__c(OwnerId=lLead.OwnerId, Lead__c=lLead.id, Status__c='Meeting Scheduled', Tmestamp__c=Date.today()));
            }
                                          
			if(lLead.DC_Lead_Status__c == 'Meeting Done' && lMDTraceRecordPresent == false) {
                lTracesToInsert.add(new Lead_Trace__c(OwnerId=lLead.OwnerId, Lead__c=lLead.id, Status__c='Meeting Done', Tmestamp__c=Date.today()));
            }
            if(lLead.Status == 'Junk' && lMSTraceRecordPresent == false) {
                lTracesToInsert.add(new Lead_Trace__c(OwnerId=lLead.OwnerId, Lead__c=lLead.id, Status__c='Meeting Scheduled', Tmestamp__c=Date.today()));
            }
            if(lLead.Status == 'Junk' && lMDTraceRecordPresent == false) {
                lTracesToInsert.add(new Lead_Trace__c(OwnerId=lLead.OwnerId, Lead__c=lLead.id, Status__c='Meeting Done', Tmestamp__c=Date.today()));
            }                    
        }

		if(!lDuplicatesToDelete.isEmpty()) {
        	delete lDuplicatesToDelete;
        } 
        
        if(!lTraceIdForSharingDeletion.isEmpty()) {
        	delete [SELECT id FROM Lead_Trace__share WHERE ParentId IN:lTraceIdForSharingDeletion AND RowCause='Manual'];
        }
        
        Lead_Trace__c [] lCombined = new List<Lead_Trace__c>();
        lCombined.addAll(lTracesForUpdation);
        lCombined.addAll(lTracesToInsert);
        
        if(!lCombined.isEmpty()) {
        	Database.upsert(lCombined, false);
        }
        
        Set<ID> lLeadTraceIDSetForRecalculation = new Set<ID>();
        
        for(Lead_Trace__c lTrace : lCombined) {
            lLeadTraceIDSetForRecalculation.add(lTrace.id);
        }
        
        try {
        	LeadTraceTrigger_Handler.leadTraceShareAccessSync(lLeadTraceIDSetForRecalculation);
        }
        catch(Exception e) {
            
        }
    }

	public void finish(Database.BatchableContext aContext) {
        
    }
}