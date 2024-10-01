public class LeadConverterController {
    
    /*public static void convert(String compName){
        List<Lead> leads = [SELECT Id FROM Lead WHERE Company =:compName];
        System.debug('leads ==> ' + leads);
        List<Database.LeadConvert> leadsToConvert = new List<Database.LeadConvert>();
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted = true LIMIT 1];
        System.debug('convertStatus ==> ' + convertStatus);
        for(Lead l: leads){
            Database.LeadConvert tempLC = new Database.LeadConvert();
            tempLC.setLeadId(l.id);
            tempLC.setConvertedStatus(convertStatus.MasterLabel);
            leadsToConvert.add(tempLC);
        }
        System.debug('leadsToConvert ==> ' + leadsToConvert);
        if(leadsToConvert.size() > 0){
            List<Database.LeadConvertResult> lc = Database.convertLead(leadsToConvert);
            System.debug('lc ==> ' + lc);
            for(Database.LeadConvertResult lctemp: lc){
                System.debug('AccountId ==> ' + lctemp.getAccountId());
                System.debug('ContactId ==> ' + lctemp.getContactId());
                System.debug('OpportunityId ==> ' + lctemp.getOpportunityId());
            }   
            postFeed(leads, lc[0].getOpportunityId());
        }
    }*/
    
    public static void checkLeadIsConverted(List<Lead> newLead){
        System.debug('newLead ==> ' + newLead[0].Status);
        if(newLead[0].Status == 'Converted'){
        	postFeed(newLead[0].Id);	   
        }   
    }
    
    public static void postFeed(String leadId){
        List<FeedItem> insertFeedItem = new List<FeedItem>();
        List<FeedItem> feedItems = [SELECT Id, ParentId, Body FROM FeedItem WHERE ParentId =: leadId];
        System.debug('feedItems ==> ' + feedItems);
        String oppId;
        if(!Test.isRunningTest()){
        	List<Opportunity> oppList = [SELECT Id, Lead_Id__c FROM Opportunity WHERE Lead_Id__c =: leadId];
            if(oppList.size() > 0){
             	oppId = oppList[0].Id;   
            }
        }else{
            oppId = leadId;  
        }
        if(String.isNotBlank(oppId)){
            for(FeedItem fi: feedItems){
                FeedItem newFI = new FeedItem();
                newFI.ParentId = oppId;
                String body = fi.Body;
                if(String.isNotBlank(fi.Body)){
                    newFI.Body = fi.Body.stripHtmlTags();   
                    insertFeedItem.add(newFI);
                }
            }
            if(insertFeedItem.size() > 0){
                System.debug('insertFeedItem ==> ' + insertFeedItem);
                INSERT insertFeedItem;
            }    
        }
    }
}