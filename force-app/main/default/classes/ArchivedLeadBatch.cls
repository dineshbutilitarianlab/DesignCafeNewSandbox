global class ArchivedLeadBatch implements Database.Batchable<sObject>,Database.Stateful {
    Integer processedRecord = 0;
    global Database.QueryLocator start(Database.BatchableContext bc) {
        Date createdDate = Date.newInstance(2022, 01, 01);
        Date followupDatetime = Date.newInstance(2023, 01, 01);
        Date meetingScheduledDatetime = Date.newInstance(2022, 01, 01);
        Date propertyPossesionDate = Date.newInstance(2023, 01, 01);
        List<String> listOfStageName = new List<String>{'Awaiting Closure', 'Closed Lost', 'Discussion', 'Follow Up', 'Meeting Done', 'Proposal Sent', ''};
        
        return Database.getQueryLocator([SELECT Id, Name, Channel__c, Client_s_Budget__c, DSA__c, DSA_Code__c, Email, 
                                         FirstName, LastName, Status, DC_Lead_Status__c, MobilePhone, Call_Stage__c, 
                                         Referee_Account__c, Referee_Code__c, Source__c, Re_Contact_Date__c, Follow_Up_Date_Time__c,
                                         MS_Date_Time__c, ConvertedOpportunityId, ConvertedAccountId, ConvertedContactId,
                                         Referee_Name__c, Referee_Number__c, ConvertedOpportunity.Opportunity_status__c,
                                         ConvertedOpportunity.StageName, ConvertedOpportunity.Roll_up_of_payment__c, ConvertedOpportunity.Reason__c
                                         FROM Lead WHERE 
										 
                                         ((CreatedDate <=: createdDate AND Status != 'Converted') AND 
                                         ((Re_Contact_Date__c >= LAST_N_DAYS:60) OR 
                                         ((DC_Lead_Status__c = 'Prospect' AND Call_Stage__c = 'Possession Delayed' AND 
                                         Property_Possession_Date__c <: propertyPossesionDate)) OR 
                                         (Follow_Up_Date_Time__c <: followupDatetime OR MS_Date_Time__c <: meetingScheduledDatetime))) 
                                         OR
                                         ((CreatedDate <=: createdDate AND Status = 'Converted' AND 
                                         ConvertedOpportunity.StageName IN: listOfStageName) AND 
                                         ((Follow_Up_Date_Time__c <: followupDatetime AND Owner.IsActive = true) OR 
                                         (ConvertedOpportunity.Opportunity_status__c != 'Long term Followup' OR 
                                         ConvertedOpportunity.Roll_up_of_payment__c < 1 OR 
                                         ConvertedOpportunity.Roll_up_of_Invoice__c < 1 OR 
                                         ConvertedOpportunity.Reason__c = 'Sign-up with Qarpentri')))
                                        ]);
    }
    
    global void execute(Database.BatchableContext bc, List<Lead> archiveList) {
        List<Archieved_Leads__c> leadArchieveList = new List<Archieved_Leads__c>();
        List<Account> accountDeleteList = new List<Account>();
         
        System.debug('archiveList ==> ' + archiveList);
        for(Lead ld: archiveList){
            Archieved_Leads__c archieveObj = new Archieved_Leads__c();
            //archieveObj.Name = ld.Name;
            archieveObj.Channel__c = ld.Channel__c;
            archieveObj.Client_s_Budget__c = ld.Client_s_Budget__c;
            archieveObj.DSA__c = ld.DSA__c;
            archieveObj.DSA_Code__c = ld.DSA_Code__c;
            archieveObj.Email__c = ld.Email;
            archieveObj.First_Name__c = ld.FirstName;
            archieveObj.Last_Name__c = ld.LastName;
            archieveObj.Lead_Stage__c = ld.Status;
            archieveObj.Lead_Status__c = ld.DC_Lead_Status__c;
            archieveObj.MobilePhone__c = ld.MobilePhone;
            archieveObj.Reason__c = ld.Call_Stage__c;
            archieveObj.Referee_Account__c = ld.Referee_Account__c;
            archieveObj.Referee_Code__c = ld.Referee_Code__c;
            archieveObj.Source__c = ld.Source__c;
            archieveObj.Referee_Name__c = ld.Referee_Name__c;
            archieveObj.Referee_Number__c = ld.Referee_Number__c;
            archieveObj.Converted__c = ld.Status == 'Converted' ? ld.ConvertedOpportunity.StageName : '';   
            
            leadArchieveList.add(archieveObj);   
            if(ld.ConvertedAccountId != null){
                accountDeleteList.add(new Account(Id = ld.ConvertedAccountId));
            }
        }
        if(leadArchieveList.size() > 0){
            processedRecord += leadArchieveList.size();
            System.debug('leadArchieveList ==> ' + leadArchieveList);
            System.debug('processedRecord in execute ==> ' + processedRecord);
            List<Database.SaveResult> results = Database.Insert(leadArchieveList);
            System.debug('results ==> ' + results);
            for(Database.SaveResult result : results){
                if (result.success) {
                    System.debug('Records created successfully.');
                } else {
                    System.debug('Records creation failed with message: ' + result.errors[0].message);
                }
            }
            
            Database.DeleteResult[] drAccountList = Database.DELETE(accountDeleteList);
            System.debug('results ==> ' + drAccountList);
            for(Database.DeleteResult result : drAccountList){
                if (result.success) {
                    System.debug('Account Records deleted successfully.');
                } else {
                    System.debug('Account Records deletetion failed with message: ' + result.errors[0].message);
                }
            }
            
            Database.DeleteResult[] drLeadList = Database.DELETE(archiveList);
            System.debug('results ==> ' + drLeadList);
            for(Database.DeleteResult result : drLeadList){
                if (result.success) {
                    System.debug('Lead Records deleted successfully.');
                } else {
                    System.debug('Lead Records deletetion failed with message: ' + result.errors[0].message);
                }
            }
			
        }
    }
    
    global void finish(Database.BatchableContext bc) {
        system.debug('batch job id = '+bc.getJobId());
        System.debug('processedRecord in finish ==> ' + processedRecord);
    }
    
}