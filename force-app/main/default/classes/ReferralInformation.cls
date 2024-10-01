public without sharing class  ReferralInformation {
    @AuraEnabled
     public static Lead getLeadInfo(string recordId){
        Lead leadObj;
        List<Lead> leadList = [SELECT Id, Referee_Code__c, Referee_Account__c, Referee_Name__c, Referee_Number__c, Referee_Email_ID__c,DC_Lead_Source__c
								FROM Lead WHERE Id =: recordId];
        if(leadList.size() > 0){
            leadObj = leadList[0];
        }                   
        return leadObj;                         
    }
    @AuraEnabled
    public static Opportunity getOpportunityInfo(string recordId){
        Opportunity oppObj;
        List<Opportunity> oppList = [SELECT Id, ST_Referee_Code__c, Referee_Account__c, ST_Referee_Name__c, ST_Referee_Number__c, Referee_Email_ID__c,DC_Lead_Source__c
								FROM Opportunity WHERE Id =: recordId];
        if(oppList.size() > 0){
            oppObj = oppList[0];
        }                   
        return oppObj;
    }
    @AuraEnabled
    public static Account refereeCode(String refereeCode, String refereeNumber){
    	System.debug('refereeCode ==> ' + refereeCode); 
        System.debug('refereeNumber ==> ' + refereeNumber); 
        if(String.isNotBlank(refereeNumber) && String.isNotBlank(refereeCode)){
       		return [SELECT Id, Name, PersonMobilePhone, PersonEmail, Referee_Code_DC__c FROM Account WHERE PersonMobilePhone =: refereeNumber AND Referee_Code_DC__c =: refereeCode LIMIT 1];     
        }else if(String.isNotBlank(refereeNumber)){
            return [SELECT Id, Name, PersonMobilePhone, PersonEmail, Referee_Code_DC__c FROM Account WHERE PersonMobilePhone =: refereeNumber LIMIT 1];
        }
        else if(String.isNotBlank(refereeCode)){
            return [SELECT Id, Name, PersonMobilePhone, PersonEmail, Referee_Code_DC__c FROM Account WHERE Referee_Code_DC__c =: refereeCode LIMIT 1];   
        }else{
        	return null;  
        }
    } 
    
    @AuraEnabled
    public static void updateRefereeDetails(String recordId, Account updatedRefereeDetails){
    	System.debug('recordId ==> ' + recordId);   
        System.debug('updatedRefereeDetails ==> ' + updatedRefereeDetails); 
        System.debug('Id ==> ' + updatedRefereeDetails.Id); 
        if(String.isNotBlank(recordId) && updatedRefereeDetails != null){
            String objectName = getObjectName(recordId);
            if(objectName != null && objectName == 'Lead'){
               //	Lead ldObj = [SELECT Id, Referee_Code__c, Referee_Account__c, Referee_Name__c, Referee_Number__c, Referee_Email_ID__c 
			//					FROM Lead WHERE Id =: recordId]; 
               // if(ldObj != null){
                    updateRefreeLead(recordId, updatedRefereeDetails);
               // }
            }
            else if(objectName != null && objectName == 'Opportunity'){
                Opportunity oppr = [SELECT Id, ST_Referee_Code__c, Referee_Account__c, ST_Referee_Name__c, ST_Referee_Number__c, Referee_Email_ID__c 
								FROM Opportunity WHERE Id =: recordId];
                if(oppr != null){
                    updateRefreeOpportunity(oppr, updatedRefereeDetails);
                }
            }
        }
    }

    public static String getObjectName(Id recordId) {
        if(recordId == null) {
            return null;
        }
        String objectName = String.valueOf(recordId.getSObjectType());
        return objectName;
    }
    public static void updateRefreeLead(Id LeadId, Account updatedRefereeDetails){
        	Lead ldObj = new Lead();
        	ldObj.Id = LeadId;
            ldObj.Referee_Code__c = updatedRefereeDetails.Referee_Code_DC__c;
            //ldObj.Referee_Account__c = updatedRefereeDetails.Id;
            ldObj.Referee_Name__c = updatedRefereeDetails.Name;
            ldObj.Referee_Number__c = updatedRefereeDetails.PersonMobilePhone;
            ldObj.Referee_Email_ID__c	= updatedRefereeDetails.PersonEmail;
            System.debug('ldObj ==> ' + ldObj);
            UPDATE ldObj;   
    }
    public static void updateRefreeOpportunity(Opportunity oppr,Account updatedRefereeDetails){
             oppr.ST_Referee_Code__c = updatedRefereeDetails.Referee_Code_DC__c;
            //ldObj.Referee_Account__c = updatedRefereeDetails.Id;
            oppr.ST_Referee_Name__c = updatedRefereeDetails.Name;
            oppr.ST_Referee_Number__c = updatedRefereeDetails.PersonMobilePhone;
            oppr.Referee_Email_ID__c	= updatedRefereeDetails.PersonEmail;
            System.debug('oppr ==> ' + oppr);
            UPDATE oppr;   
    }
}