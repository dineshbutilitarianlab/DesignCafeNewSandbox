public class OpportunityRequirementUXclass {
  //---- All field data in one method-----// 
     @AuraEnabled 
    Public static string Opppicklistvalues(String recordId){
       Map<String,List<String>> pickoptions = new Map<String,List<String>>();
        pickoptions.put('Home_Type__c',getHomeType());
        pickoptions.put('Scope_Of_Work__c',getScopeOfWork());
        pickoptions.put('Interior_work_needed_for__c',getInteriorworkneededfor());
        pickoptions.put('Property_Usage__c',getPropertyUsage());
        pickoptions.put('Requirement_Details__c',getRequirementDetails());
        pickoptions.put('Civil_Work__c',new list<string>{'true','false'});
        pickoptions.put('OppRecord',new List<String>{JSON.serialize(Oppdata(recordId))});
        return json.serialize(pickoptions);
    }
   
    //-- Seperate picklist values----// 
    @AuraEnabled 
    public static List<String> getHomeType(){
        Map<String,String> options = new Map<String, String>();
        Schema.DescribeFieldResult fieldResult = Opportunity.Home_Type__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            options.put(p.getValue(), p.getLabel());
        }
        return options.values();
    }
    
    @AuraEnabled 
    public static List<String> getScopeOfWork(){
        Map<String, String> options = new Map<String, String>();
        Schema.DescribeFieldResult fieldResult = Opportunity.Scope_Of_Work__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            options.put(p.getValue(), p.getLabel());
        }
        return options.values();
    }
    
    @AuraEnabled 
    public static List<String> getInteriorworkneededfor(){
        Map<String, String> options = new Map<String, String>();
        Schema.DescribeFieldResult fieldResult = Opportunity.Interior_work_needed_for__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            options.put(p.getValue(), p.getLabel());
        }
        return options.values();
    }
    
    @AuraEnabled 
    public static List<String> getPropertyUsage(){
        Map<String, String> options = new Map<String, String>();
        Schema.DescribeFieldResult fieldResult = Opportunity.Property_Usage__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            options.put(p.getValue(), p.getLabel());
        }
        return options.values();
    } 
    
    @AuraEnabled 
    public static List<String> getRequirementDetails(){
        Map<String, String> options = new Map<String, String>();
        Schema.DescribeFieldResult fieldResult = Opportunity.Requirement_Details__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            options.put(p.getValue(), p.getLabel());
        }
        return options.values();
    } 
    //---- Update Edited Field values ----//
    @AuraEnabled 
    Public static String UpdateOpportunityRec(String oppoRec){
        try{
           Opportunity opp = (Opportunity)JSON.deserialize(OppoRec, Opportunity.class);
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
    public static Opportunity Oppdata(Id recordId) {
        Opportunity op = [Select Id,Floor_Area__c,Home_Type__c, Scope_Of_Work__c, Civil_Work__c,Interior_work_needed_for__c,Property_Usage__c,
                          Requirement_Details__c,Move_in__c from Opportunity where Id=:recordId LIMIT 1];
        return op;
    }
}