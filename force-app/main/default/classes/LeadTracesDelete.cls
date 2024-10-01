/**
* @author : Manas Ranjan
* @date : 06/05/2020
* @description : Lead Traces Record Delete when Lead or Opportunity Record Delete
*/
public class LeadTracesDelete{
    public static void LeadTraceRecordDeleteFMLead(Map<Id,Lead> objLeadMap){
        List<Lead_Trace__c> objLeadTrace = [Select Id,Lead__c from Lead_Trace__c where Lead__c IN : objLeadMap.keySet()];
        delete objLeadTrace;
    }
    public static void LeadTraceRecordDeleteFMOpportunity(Map<Id,Opportunity> objOppMap){
        List<Lead_Trace__c> objLeadTrace = [Select Id,Lead__c from Lead_Trace__c where Opportunity__c IN : objOppMap.keySet()];
        delete objLeadTrace;
    }
}