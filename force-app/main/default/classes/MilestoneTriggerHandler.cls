/*
Developer : Jai Kumar  
Created Date :  28 Dec 2019
Description : Creating an Milestone Artifact at the time of creating a Milestone Record Except the type of 'KYC'.     
*/
public with sharing class MilestoneTriggerHandler {
    public static Boolean skipTriggerLogic = false;
    
    public static void createArtifact(List<Milestone1_Milestone__c>  objMilestoneList) {
        Application_Settings__c lSetting1 = Application_Settings__c.getValues('AUTOMATIC_ARTIFACT_CREATION');
		
        if(lSetting1 == null || String.isBlank(lSetting1.Value__c) || lSetting1.Value__c.equalsIgnoreCase('true')) {
            List<Project_Artifact__c> proArtiList = new List<Project_Artifact__c>();
            
            for (Milestone1_Milestone__c milestone : objMilestoneList) {
                if(milestone.Type__c != 'KYC') {
                    Project_Artifact__c artifact = new Project_Artifact__c();
                    artifact.Project__c = milestone.Project__c;
                    artifact.Status__c = 'Draft';
                    artifact.Project_Milestone__c = milestone.Id;
                    proArtiList.add(artifact);
                }
            }
            
            database.insert(proArtiList, false);
        }
    }
}