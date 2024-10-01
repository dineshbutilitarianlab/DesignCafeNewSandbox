public class SiteConditionUX {

      @AuraEnabled 
    Public static string cbvalues(String recordId){
        Map<String,List<String>> cboptions = new Map<String,List<String>>();
        cboptions.put('OpportunityRecord',new List<String>{JSON.serialize(OppdataSite(recordId))});
        return json.serialize(cboptions);
    }
     //---- Update Edited Field values ----//
    @AuraEnabled 
    Public static String UpdateOpportunitySite(String oppRec){
        try{
            Opportunity opp = (Opportunity)JSON.deserialize(OppRec, Opportunity.class);
            update opp; 
            return 'success';
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
        finally {
        }
    }
  //---- Displaying Existed Data -----//  
    @AuraEnabled
    public static Opportunity OppdataSite(Id recordId) {
        Opportunity op = [Select Id,Frames_for_all_external_Doors_Windows__c,All_walls_are_completed_Required__c, Floors_are_levelled_out_prepped_Basic__c,
                          The_Doors_Windows_are_installed_Requir__c,Putty_and_1_coat_of_plastering_Required__c,Flooring_is_completed_Required__c,
                          If_the_required_part_is_checked_the_co__c,Notes__c from Opportunity where Id=:recordId LIMIT 1];
        return op;
    }   
}