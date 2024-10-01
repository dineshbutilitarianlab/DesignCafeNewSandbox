trigger DesignUserTrigger on Design_User__c (after insert , after update) {
	if(Trigger.isAfter && Trigger.isInsert){
        List<String> designUserIdSet = new List<String>();
        for(Design_User__c designUserRecord : Trigger.New){
            designUserIdSet.add(designUserRecord.Id);
        }   
        LSQ_SendDesignUsertoLSQ.createandUpdateDesignUserData(designUserIdSet);
    }
    
}