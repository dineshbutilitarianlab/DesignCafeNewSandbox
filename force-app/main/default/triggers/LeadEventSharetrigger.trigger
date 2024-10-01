trigger LeadEventSharetrigger on LeadChangeEvent (after insert) {
    //LeadSharingClass.addLeadSharingRuleForCallCenterAgent(Trigger.new);
    Set<Id> LeadIds = New Set<Id>();
    List<LeadShare> leadShareList = New List<LeadShare>();
    
    For(LeadChangeEvent lc : Trigger.New) {
        List<Id> recordIds  = lc.ChangeEventHeader.getRecordIds();
        LeadIds.addAll(recordIds);
    }
    
    for(Lead LeadObj:[Select Id,ownerId,owner.UserRole.Name,call_center_agent__c,call_center_agent__r.UserRole.Name from Lead 
                      where id in :LeadIds]){
        If(LeadObj.call_center_agent__c != Null && LeadObj.owner.UserRole.Name!=Null && 
           LeadObj.owner.UserRole.Name.equalsIgnoreCase('Internal Sales Agent')){
            LeadShare leadShareObj = New LeadShare();
            leadShareObj.LeadId =   LeadObj.Id;
            leadShareObj.UserOrGroupId =  LeadObj.Call_Center_Agent__c;
            leadShareObj.LeadAccessLevel = 'Read';
               leadShareObj.rowcause = Schema.leadshare.rowcause.Manual;
            leadShareList.add(leadShareObj);   
        }
    }
    
    if(leadShareList.size() > 0) {
        System.debug('In insert');
        Database.insert(leadShareList, false);
    }
}