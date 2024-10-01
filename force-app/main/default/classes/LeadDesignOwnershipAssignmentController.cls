public class LeadDesignOwnershipAssignmentController {
    @AuraEnabled
    public static String assignDesignOwnership(String aRecID) {
        return assignOwnershipBackToOriginalOwner(aRecID);
    }
    
    public static string assignOwnershipBackToOriginalOwner(String aRecID) {
        try {
            Lead lLead = [SELECT id, Designer__c, Has_Designer_Accepted__c FROM Lead WHERE id=:aRecID];
            
            if(lLead.Designer__c != UserInfo.getUserId()) {
                return 'You cannot claim Design ownership on this Lead. You are currently not assigned as a Designer on this Lead.';
            }
            
            if(lLead.Has_Designer_Accepted__c == 'Designer Accepted') {
                return 'No action performed. Design Ownership on this Lead is already accepted.';
            }
            
            lLead.Has_Designer_Accepted__c = 'Designer Accepted';
            update lLead;
			return 'You are now the Design owner for this Lead.';
        }
        catch(Exception e) {
            return 'Error: ' + e;
        }
    }
}