public class InsertLeadTraceForAllLeadsCls {
    public static void insertLeadTrace(){
        LIST<Lead_Trace__c> listOfLeadTracesToInsert =  new LIST<Lead_Trace__c>();
        LIST<Lead> allLeads = [select id,name,Date_When_Meeting_is_Scheduled__c,Willingness_For_Meeting__c,DC_Lead_Status__c,convertedOpportunityId, convertedOpportunity.StageName,convertedOpportunity.CloseDate from Lead where (DC_Lead_Status__c = 'Meeting Scheduled' Or DC_Lead_Status__c = 'Meeting Done')];
        for(Lead eachLead : allLeads){
            system.debug(eachLead);
            if(eachLead.Date_When_Meeting_is_Scheduled__c != null && eachLead.Date_When_Meeting_is_Scheduled__c != null){
                Lead_Trace__c newLeadTrace =  new Lead_Trace__c(Lead__c = eachLead.Id ,Status__c = 'Meeting Scheduled' , Tmestamp__c = eachLead.Date_When_Meeting_is_Scheduled__c );
                listOfLeadTracesToInsert.add(newLeadTrace);
            }
            else{
                if(eachLead.Willingness_For_Meeting__c != null) {
                    Lead_Trace__c newLeadTrace =  new Lead_Trace__c(Lead__c = eachLead.Id ,Status__c = 'Meeting Scheduled' );
                    newLeadTrace.Tmestamp__c = eachLead.Willingness_For_Meeting__c.date();
                    listOfLeadTracesToInsert.add(newLeadTrace);
                }
            }
            if(eachLead.DC_Lead_Status__c == 'Meeting Done' && eachLead.Willingness_For_Meeting__c != null){
                Lead_Trace__c newLeadTrace =  new Lead_Trace__c(Lead__c = eachLead.Id ,Status__c = 'Meeting Done' , Tmestamp__c = eachLead.Willingness_For_Meeting__c.date() );
                listOfLeadTracesToInsert.add(newLeadTrace);
            }
            if(eachLead.convertedOpportunity.StageName == 'Closed Won' && eachLead.convertedOpportunity.CloseDate != null){
                Lead_Trace__c newLeadTrace =  new Lead_Trace__c(Lead__c = eachLead.Id ,Status__c = 'Signed-up' , Tmestamp__c = eachLead.convertedOpportunity.CloseDate , Opportunity__c = eachLead.convertedOpportunityId);
                listOfLeadTracesToInsert.add(newLeadTrace);
            }
        } 
        
        if(!listOfLeadTracesToInsert.isEmpty()){
            insert listOfLeadTracesToInsert;
        }
    }
}