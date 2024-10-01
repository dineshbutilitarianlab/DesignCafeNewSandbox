public class leadAttachment {
  @AuraEnabled(cacheable=true)
       public static list<Lead> fetchLeads(String recId){
      
       return new List<Lead>{ [SELECT Id,File_Name__c,File_Url__c FROM Lead Where Id =:recId]};
    } 
   
}