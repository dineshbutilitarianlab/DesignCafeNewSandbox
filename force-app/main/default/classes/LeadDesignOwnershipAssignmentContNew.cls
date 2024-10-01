public class LeadDesignOwnershipAssignmentContNew {
    @AuraEnabled
    public static String assignDesignOwnership(String aRecID) {
        return assignOwnershipBackToOriginalOwner(aRecID);
    }
    
    public static string assignOwnershipBackToOriginalOwner(String aRecID) {
        try {
            Lead lLead = [SELECT id, Designer__c, Has_Designer_Accepted__c FROM Lead WHERE id=:aRecID];
            system.debug('lLead'+lLead);
            system.debug('Has_Designer_Accepted__c'+lLead.Has_Designer_Accepted__c);
            if(lLead.Has_Designer_Accepted__c == 'Designer Accepted') {
                return Label.Designer_Accepted;
            }
            
            lLead.Has_Designer_Accepted__c = 'Designer Accepted';
            update lLead;
            return 'You are now the Design owner for this Lead.';
        }
        catch(Exception e) {
            return 'Error: ' + e;
        }
    }
    @AuraEnabled
    public static string designOwnershipRejected(String aRecID){
        try {
            Lead lLead = [SELECT id, Designer__c, Has_Designer_Accepted__c,designer__r.Manager.email FROM Lead WHERE id=:aRecID];
            if(lLead.Has_Designer_Accepted__c == 'Designer Rejected') {
                return Label.Designer_Rejected;
            }
            lLead.Has_Designer_Accepted__c = 'Designer Rejected';
            
            lLead.Designers_TL_Email__c=lLead.designer__r.Manager.email;
            
            update lLead;
            return 'You successfully Rejected this Lead.';
            
        }
        
        catch(Exception e) {
            return 'Error: ' + e;
        }
    }
    
    @AuraEnabled
    public static string checkDesignerStatus(String aRecID){
        try {
          Lead lLead = [SELECT id, Designer__c, Has_Designer_Accepted__c FROM Lead WHERE id=:aRecID];
            if(lLead.Designer__c != UserInfo.getUserId()) {
                return Label.Invalid_Designer;
            }
            if(lLead.Has_Designer_Accepted__c == 'Designer Accepted') {
                return Label.Designer_Accepted;
            }
            
            if(lLead.Has_Designer_Accepted__c == 'Designer Rejected') {
                return Label.Designer_Rejected;
            }
            
            if(lLead.Has_Designer_Accepted__c == 'Requested DM to assign Designer') {
                return Label.Designer_Rejected;
            }
            
            
            
            Return '';
            
        }
        
        catch(Exception e) {
            return 'Error: ' + e;
        }
    }
    
    @AuraEnabled
    public static string checkDesignerTLStatus(String aRecID){
        try {
            Lead lLead = [SELECT id, Designer__c, Has_Designer_Accepted__c,designer__r.Manager.Manager.email FROM Lead WHERE id=:aRecID];
            
            
            if(lLead.Has_Designer_Accepted__c == 'Requested DM to assign Designer') {
                return Label.Designer_TL_Rejected_Lead;
            }
            
            
            lLead.Has_Designer_Accepted__c = 'Requested DM to assign Designer';
            lLead.Designer_TL_s_Manager_Email__c=lLead.designer__r.Manager.Manager.email;
            update lLead;
            
            return 'You have successfully Requested DM to assign Designer';  
        }
        
        catch(Exception e) {
            return 'Error: ' + e;
        }
    }
}