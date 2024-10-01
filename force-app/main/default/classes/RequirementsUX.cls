public with sharing class RequirementsUX {
    //---- All field data in one method-----// 
    @AuraEnabled 
    Public static string picklistvalues(String recordId){
        Map<String,List<String>> pickoptions = new Map<String,List<String>>();
        pickoptions.put('Home_Type__c',getHomeType());
        pickoptions.put('Scope_Of_Work__c',getScopeOfWork());
        pickoptions.put('Interior_work_needed_for__c',getInteriorworkneededfor());
        pickoptions.put('Property_Usage__c',getPropertyUsage());
        pickoptions.put('Requirement_Details__c',getRequirementDetails());
        //pickoptions.put('Civil_Work__c',new list<string>{'true','false'});
        pickoptions.put('Eat__c',getEat());  
        pickoptions.put('Site_Service_Needed_for__c',getSiteServiceNeededfor());          
        pickoptions.put('Live__c',getLive());   
        pickoptions.put('Play__c',getPlay());  
        pickoptions.put('Who_will_be_staying_in_the_house__c',getWhowillbestayinginthehouse());  
        pickoptions.put('LeadRecord',new List<String>{JSON.serialize(Leaddata(recordId))});
        return json.serialize(pickoptions);
    }
    
    //-- Seperate picklist values----// 
    @AuraEnabled 
    public static List<String> getHomeType(){
        Map<String,String> options = new Map<String, String>();
        Schema.DescribeFieldResult fieldResult = Lead.Home_Type__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            options.put(p.getValue(), p.getLabel());
        }
        return options.values();
    }
    
    @AuraEnabled 
    public static List<String> getScopeOfWork(){
        Map<String, String> options = new Map<String, String>();
        Schema.DescribeFieldResult fieldResult = Lead.Scope_Of_Work__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            options.put(p.getValue(), p.getLabel());
        }
        return options.values();
    }
    
    @AuraEnabled 
    public static List<String> getInteriorworkneededfor(){
        Map<String, String> options = new Map<String, String>();
        Schema.DescribeFieldResult fieldResult = Lead.Interior_work_needed_for__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            options.put(p.getValue(), p.getLabel());
        }
        return options.values();
    }
    @AuraEnabled 
    public static List<String> getEat(){
        Map<String, String> options = new Map<String, String>();
        Schema.DescribeFieldResult fieldResult = Lead.Eat__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            options.put(p.getValue(), p.getLabel());
        }
        return options.values();
    }    
    
    @AuraEnabled 
    public static List<String> getSiteServiceNeededfor(){
        Map<String, String> options = new Map<String, String>();
        Schema.DescribeFieldResult fieldResult = Lead.Site_Service_Needed_for__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            options.put(p.getValue(), p.getLabel());
        }
        return options.values();
    }     
    
    
    @AuraEnabled 
    public static List<String> getWhowillbestayinginthehouse(){
        Map<String, String> options = new Map<String, String>();
        Schema.DescribeFieldResult fieldResult = Lead.Who_will_be_staying_in_the_house__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            options.put(p.getValue(), p.getLabel());
        }
        return options.values();
    }    
    
       
    @AuraEnabled 
    public static List<String> getPropertyUsage(){
        Map<String, String> options = new Map<String, String>();
        Schema.DescribeFieldResult fieldResult = Lead.Property_Usage__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            options.put(p.getValue(), p.getLabel());
        }
        return options.values();
    } 
    
     @AuraEnabled 
    public static List<String> getRequirementDetails(){
        Map<String, String> options = new Map<String, String>();
        Schema.DescribeFieldResult fieldResult = Lead.Requirement_Details__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            options.put(p.getValue(), p.getLabel());
        }
        return options.values();
    }  
    
    
    @AuraEnabled 
    public static List<String> getLive(){
        Map<String, String> options = new Map<String, String>();
        Schema.DescribeFieldResult fieldResult = Lead.Live__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            options.put(p.getValue(), p.getLabel());
        }
        return options.values();
    }   
    
    @AuraEnabled 
    public static List<String> getPlay(){
        Map<String, String> options = new Map<String, String>();
        Schema.DescribeFieldResult fieldResult = Lead.Play__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            options.put(p.getValue(), p.getLabel());
        }
        return options.values();
    }          
    
 @AuraEnabled 
    public static Map<String, String> getWhenwouldyouliketohavethehomeValue(){
        Map<String, String> options = new Map<String, String>();
        Schema.DescribeFieldResult fieldResult = Lead.When_would_you_like_to_have_the_home__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            options.put(p.getValue(), p.getLabel());
        }
        return options;
    }   
    
     @AuraEnabled 
    public static Map<String, String> getWorkValue(){
        Map<String, String> options = new Map<String, String>();
        Schema.DescribeFieldResult fieldResult = Lead.Work__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            options.put(p.getValue(), p.getLabel());
        }
        return options;
    }   
    
     @AuraEnabled 
    public static Map<String, String> getCabReqValue(){
        Map<String, String> options = new Map<String, String>();
        Schema.DescribeFieldResult fieldResult = Lead.Cab_Req__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            options.put(p.getValue(), p.getLabel());
        }
        return options;
    }   
    
    
    //---- Update Edited Field values ----//
    @AuraEnabled 
    Public static String Updatelead(String leadRec){
        try{
            Lead ld = (Lead)JSON.deserialize(LeadRec, Lead.class);
            update ld; 
            return 'success';
        }catch(Exception e){
            return e.getMessage();
        }
        finally {
        }
    }

    //---- Displaying Existed Data -----//  
    @AuraEnabled
    public static Lead Leaddata(Id recordId) {
        Lead ld = [Select Id,Area__c,Others_for_Live__c,Others_for_Play__c,Home_Type__c, Play__c,Scope_Of_Work__c, Civil_Work__c, Work__c,Live__c, Interior_work_needed_for__c, Eat__c,Property_Usage__c, 
                  Requirement_Details__c,Move_in__c,Property_Possession_Date__c,How_many_kids_do_you_have__c, Age_of_First_kid__c,	Gender_of_First_kid__c,Age_of_Second_kid__c,Gender_of_Second_kid__c, Age_of_Third_kid__c,Gender_of_Third_kid__c,
                   Age_of_Fourth_kid__c, Gender_of_Fourth_kid__c,Cab_Req__c, Do_you_have_pets__c, Who_will_be_staying_in_the_house__c, When_would_you_like_to_have_the_home__c, Where_are_you_currently_located__c, Which_language_are_you_most_comfortable__c, 
                   If_other_languages_please_specify__c,Designer_Team_Name__c,Site_Service_Needed_for__c	from Lead where Id=:recordId LIMIT 1];
        return ld;
    }  
}