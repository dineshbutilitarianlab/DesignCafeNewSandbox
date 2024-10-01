/*
* Modified Date : 15 June 2022
* Modified By   : Kunal Kishor
*   - Modified the condition to call the PostLeadtoDD APIs.
Modified Date : 14 July 2022
* Modified By   : Rixyncs
*   - Commented the Yellow Messenger part from line no 227 to 242
*/ 

trigger LeadTrigger on Lead (after insert, after update, before insert, before update,before delete) {
    TriggerControl__c tc = TriggerControl__c.getvalues('LeadTrigger');
    System.debug('tc === >'+tc);
    if(tc.Run__c){
        if(Trigger.isUpdate && Trigger.isAfter){
            LeadConverterController.checkLeadIsConverted(Trigger.new);    
        }
        
        // Return IF only the validation bypass checkbox is updated.
        if (trigger.isUpdate) {
            List<Lead> newLeads = new List<Lead>();
            for (Lead newLead:trigger.new) {
                Lead oldLead = trigger.OldMap.get(newLead.id);
                if ((newLead.bypassSMleadOwnervalidation__c != oldLead.bypassSMleadOwnervalidation__c) &&
                    (newLead.bypassSMleadOwnervalidation__c == false))  {
                        //Do Not Continue IF the bypass flag is changed to false(it happened only from the future method: - resetValidationCheckboxToFALSE)
                        return;
                    }
            }
        }
        
        // ==================== If the Design_User has changed, it means the Designer has accepted the lead from DD. ========
        // NO need to call the APIs.
        
        //===================== Before Actions(Insert or Update or delete)  Starts ================================================//
        
        //==== Process Builder and workflow Start ====//
        //==== Owner change and Broadcast status ====//
        if(trigger.isBefore && (trigger.isInsert || trigger.isUpdate) && !test.isRunningTest()){
            System.debug('Current value of VDC_LeadProcesstoApex.firstRun '+VDC_LeadProcesstoApex.firstRun);
            if(VDC_LeadProcesstoApex.firstRun){
                VDC_LeadProcesstoApex.BroadcastAndOwnerChange(trigger.new);
            }
        }
        //==== Workflow and Process Builder updates ====//
        if (trigger.isBefore){
            if (trigger.isUpdate || trigger.isInsert){
                Lead_Workflowupdates.MSCheckneedtocheck(trigger.new);
                Lead_Workflowupdates.Leadstageconverted(trigger.new);                
            }
        }   
        //==== Sales RoundRobin ====//
        if (trigger.isBefore){
            if (trigger.isUpdate){
                //   system.debug('LeadRR::');
                //Lead_SalesRoundRobin.assignSalesuserByRR(trigger.new, trigger.oldmap);
            }
        }
        // Update the Validation bypass Checkbox back to FALSE
        if (trigger.isUpdate && trigger.isAfter) {
            System.debug('In After Update Block');
            List<String> leadIds = new List<String>();
            for(Lead ld: Trigger.new){
                if(ld.LARR__c == false && ld.Status == 'New'){
                    leadIds.add(ld.Id);
                }
            }
            System.debug('leadIds ==> ' + leadIds);
            if(leadIds.size() > 0){
                
               leadtogreet.Callout(leadIds);  //commented on 27-6-2024  //uncommented again on 8/8/2024
            }
            
            String leads = JSON.serialize(trigger.new);
            
            if(!System.isBatch() && !System.isFuture()){
                //Lead_SalesRoundRobin.resetValidationCheckboxToFALSE(leads);
            }
        }
        
        //==== Heron Major Code Start ====//      
        if(Trigger.isInsert || Trigger.isUpdate){
            if(!System.isBatch() && !System.isFuture()){
                TriggerFactory.createTriggerDispatcher(Lead.sObjectType);
            }
        }       
        if(Trigger.isDelete && Trigger.isBefore){
            LeadTracesDelete.LeadTraceRecordDeleteFMLead(Trigger.oldMap);
            
        }
        //==== Heron Major code End ====//  
        
        //===================== Before Actions(Insert or Update)  Ends ================================================// 
        ////==========================================================================================================////
        ////==========================================================================================================////      
        //===================== After Actions(Insert or Update)  Starts ================================================//
        
    
        if (Trigger.isAfter && Trigger.isUpdate) {
            Set<Id> leadIdSet = new Set<Id>();
            Map<Id, List<String>> leadIdToChangedFieldsMap = new Map<Id, List<String>>();
            
            for (Lead leadRecord : Trigger.new) {
                if(leadRecord.LastModifiedBy__c != 'Sain' && 
                   leadRecord.LastModifiedById != '0059H000002pqrRQAQ' 
                   && leadRecord.LastModifiedBy__c != '0059H000002pqrRQAQ' 
                   && leadRecord.LSQ_Lead_Related_ID__c != null){
                    Lead oldLeadRecord = Trigger.oldMap.get(leadRecord.Id);
                    List<String> changedFields = new List<String>();
                    
                    if (oldLeadRecord.Client_s_Budget__c != leadRecord.Client_s_Budget__c) {
                        changedFields.add('Client_s_Budget__c');
                    }
                    if (oldLeadRecord.Description != leadRecord.Description) {
                        changedFields.add('Description');
                    }
                    if (oldLeadRecord.Address != leadRecord.Address) {
                        changedFields.add('Address');
                    }
                    if (oldLeadRecord.AnnualRevenue != leadRecord.AnnualRevenue) {
                        changedFields.add('AnnualRevenue');
                    }
                    if (oldLeadRecord.ActionCadence != leadRecord.ActionCadence) {
                        changedFields.add('ActionCadence');
                    }
                    if (oldLeadRecord.ActionCadenceAssignee != leadRecord.ActionCadenceAssignee) {
                        changedFields.add('ActionCadenceAssignee');
                    }
                    /*if (oldLeadRecord.ScheduledResumeDateTime != leadRecord.ScheduledResumeDateTime) {
                        changedFields.add('ScheduledResumeDateTime');
                    }*/
                    if (oldLeadRecord.ActionCadenceState != leadRecord.ActionCadenceState) {
                        changedFields.add('ActionCadenceState');
                    }
                    if (oldLeadRecord.Campagin__c != leadRecord.Campagin__c) {
                        changedFields.add('Campagin__c');
                    }
                    if (oldLeadRecord.Company != leadRecord.Company) {
                        changedFields.add('Company');
                    }
                    if (oldLeadRecord.CreatedBy != leadRecord.CreatedBy) {
                        changedFields.add('CreatedBy');
                    }
                    if (oldLeadRecord.Jigsaw != leadRecord.Jigsaw) {
                        changedFields.add('Jigsaw');
                    }
                    if (oldLeadRecord.DoNotCall != leadRecord.DoNotCall) {
                        changedFields.add('DoNotCall');
                    }
                    if (oldLeadRecord.Email != leadRecord.Email) {
                        changedFields.add('Email');
                    }
                    if (oldLeadRecord.HasOptedOutOfEmail != leadRecord.HasOptedOutOfEmail) {
                        changedFields.add('HasOptedOutOfEmail');
                    }
                    if (oldLeadRecord.Fax != leadRecord.Fax) {
                        changedFields.add('Fax');
                    }
                    if (oldLeadRecord.HasOptedOutOfFax != leadRecord.HasOptedOutOfFax) {
                        changedFields.add('HasOptedOutOfFax');
                    }
                    if (oldLeadRecord.FirstCallDateTime != leadRecord.FirstCallDateTime) {
                        changedFields.add('FirstCallDateTime');
                    }
                    if (oldLeadRecord.FirstEmailDateTime != leadRecord.FirstEmailDateTime) {
                        changedFields.add('FirstEmailDateTime');
                    }
                    /*if (oldLeadRecord.GenderIdentity != leadRecord.GenderIdentity) {
                        changedFields.add('GenderIdentity');
                    }*/
                    if (oldLeadRecord.Industry != leadRecord.Industry) {
                        changedFields.add('Industry');
                    }
                    if (oldLeadRecord.LastModifiedBy != leadRecord.LastModifiedBy) {
                        changedFields.add('LastModifiedBy');
                    }
                    if (oldLeadRecord.LastTransferDate != leadRecord.LastTransferDate) {
                        changedFields.add('LastTransferDate');
                    }
                    if (oldLeadRecord.Owner != leadRecord.Owner) {
                        changedFields.add('Owner');
                    }
                    if (oldLeadRecord.RecordType != leadRecord.RecordType) {
                        changedFields.add('RecordType');
                    }
                    if (oldLeadRecord.LeadSource != leadRecord.LeadSource) {
                        changedFields.add('LeadSource');
                    }
                    if (oldLeadRecord.Status != leadRecord.Status) {
                        changedFields.add('Status');
                    }
                    if (oldLeadRecord.MobilePhone != leadRecord.MobilePhone) {
                        changedFields.add('MobilePhone');
                    }
                    if (oldLeadRecord.Name != leadRecord.Name) {
                        changedFields.add('Name');
                    }
                    if (oldLeadRecord.Salutation != leadRecord.Salutation) {
                        changedFields.add('Salutation');
                    }
                    if (oldLeadRecord.FirstName != leadRecord.FirstName) {
                        changedFields.add('FirstName ');
                    }
                    if (oldLeadRecord.LastName != leadRecord.LastName ) {
                        changedFields.add('LastName');
                    }
                    if (oldLeadRecord.MiddleName  != leadRecord.MiddleName) {
                        changedFields.add('MiddleName');
                    }
                    if (oldLeadRecord.Suffix != leadRecord.Suffix) {
                        changedFields.add('Suffix');
                    }
                    if (oldLeadRecord.NumberOfEmployees != leadRecord.NumberOfEmployees) {
                        changedFields.add('NumberOfEmployees');
                    }
                   // if (oldLeadRecord.PartnerAccount != leadRecord.PartnerAccount) {
                    //    changedFields.add('PartnerAccount');
                    //}
                    if (oldLeadRecord.Phone != leadRecord.Phone) {
                        changedFields.add('Phone');
                    }
                    /*if(oldLeadRecord.Pronouns != leadRecord.Pronouns){
                        changedFields.add('Pronouns');   
                    }
                    */
                    if (oldLeadRecord.Rating != leadRecord.Rating) {
                        changedFields.add('Rating');
                    }
                    if (oldLeadRecord.Title != leadRecord.Title) {
                        changedFields.add('Title');
                    }
                    if (oldLeadRecord.Website != leadRecord.Website) {
                        changedFields.add('Website');
                    }
                    /*if (oldLeadRecord.API_Name != leadRecord.API_Name) {
                        changedFields.add('API_Name');
                    }*/
                    if (oldLeadRecord.Actual_Lead_Response_Time_by_SM__c != leadRecord.Actual_Lead_Response_Time_by_SM__c) {
                        changedFields.add('Actual_Lead_Response_Time_by_SM__c');
                    }
                    if (oldLeadRecord.Ad_Group__c != leadRecord.Ad_Group__c) {
                        changedFields.add('Ad_Group__c');
                    }
                    if (oldLeadRecord.Ad_Group_ID__c != leadRecord.Ad_Group_ID__c) {
                        changedFields.add('Ad_Group_ID__c');
                    }
                    if (oldLeadRecord.Ad_Name__c != leadRecord.Ad_Name__c) {
                        changedFields.add('Ad_Name__c');
                    }
                    if (oldLeadRecord.Ad_Network__c != leadRecord.Ad_Network__c) {
                        changedFields.add('Ad_Network__c');
                    }
                    if (oldLeadRecord.AdWords_Mobile__c != leadRecord.AdWords_Mobile__c) {
                        changedFields.add('AdWords_Mobile__c');
                    }
                    if (oldLeadRecord.Affiliate_Name__c != leadRecord.Affiliate_Name__c) {
                        changedFields.add('Affiliate_Name__c');
                    }
                    if (oldLeadRecord.Age__c != leadRecord.Age__c) {
                        changedFields.add('Age__c');
                    }
                    if (oldLeadRecord.Agency__c != leadRecord.Agency__c) {
                        changedFields.add('Agency__c');
                    }
                    if (oldLeadRecord.Age_of_First_kid__c != leadRecord.Age_of_First_kid__c) {
                        changedFields.add('Age_of_First_kid__c');
                    }
                    if (oldLeadRecord.Age_of_Second_kid__c != leadRecord.Age_of_Second_kid__c) {
                        changedFields.add('Age_of_Second_kid__c');
                    }
                    if (oldLeadRecord.Age_of_Third_kid__c != leadRecord.Age_of_Third_kid__c) {
                        changedFields.add('Age_of_Third_kid__c');
                    }
                    if (oldLeadRecord.Age_of_Fourth_kid__c != leadRecord.Age_of_Fourth_kid__c) {
                        changedFields.add('Age_of_Fourth_kid__c');
                    }
                    if (oldLeadRecord.Alternate_Contact_Number__c != leadRecord.Alternate_Contact_Number__c) {
                        changedFields.add('Alternate_Contact_Number__c');
                    }
                    if (oldLeadRecord.APIMOBILE__c != leadRecord.APIMOBILE__c) {
                        changedFields.add('APIMOBILE__c');
                    }
                    if (oldLeadRecord.Approx_Budget__c != leadRecord.Approx_Budget__c) {
                        changedFields.add('Approx_Budget__c');
                    }
                    if (oldLeadRecord.Attempt_Count__c != leadRecord.Attempt_Count__c) {
                        changedFields.add('Attempt_Count__c');
                    }
                    if (oldLeadRecord.Bell_N1_Sent__c != leadRecord.Bell_N1_Sent__c) {
                        changedFields.add('Bell_N1_Sent__c');
                    }
                    if (oldLeadRecord.Bell_N2_Sent__c != leadRecord.Bell_N2_Sent__c) {
                        changedFields.add('Bell_N2_Sent__c');
                    }
                    if (oldLeadRecord.Bell_N3_Sent__c != leadRecord.Bell_N3_Sent__c) {
                        changedFields.add('Bell_N3_Sent__c');
                    }
                    if (oldLeadRecord.Broadcast_Status__c != leadRecord.Broadcast_Status__c) {
                        changedFields.add('Broadcast_Status__c');
                    }
                    if (oldLeadRecord.bypassSMleadOwnervalidation__c != leadRecord.bypassSMleadOwnervalidation__c) {
                        changedFields.add('bypassSMleadOwnervalidation__c');
                    }
                    if (oldLeadRecord.BypassTimebasedWorkflow__c != leadRecord.BypassTimebasedWorkflow__c) {
                        changedFields.add('BypassTimebasedWorkflow__c');
                    }
                    if (oldLeadRecord.Cab_Req__c != leadRecord.Cab_Req__c) {
                        changedFields.add('Cab_Req__c');
                    }
                    if (oldLeadRecord.Call_Center_Agency_Name__c != leadRecord.Call_Center_Agency_Name__c) {
                        changedFields.add('Call_Center_Agency_Name__c');
                    }
                    if (oldLeadRecord.Call_Center_Agent__c != leadRecord.Call_Center_Agent__c) {
                        changedFields.add('Call_Center_Agent__c');
                    }
                    if (oldLeadRecord.Call_Center_Agent_Region__c != leadRecord.Call_Center_Agent_Region__c) {
                        changedFields.add('Call_Center_Agent_Region__c');
                    }
                    if (oldLeadRecord.Call_Center_Agent_Team__c != leadRecord.Call_Center_Agent_Team__c) {
                        changedFields.add('Call_Center_Agent_Team__c');
                    }
                    if (oldLeadRecord.Call_Count__c != leadRecord.Call_Count__c) {
                        changedFields.add('Call_Count__c');
                    }
                    if (oldLeadRecord.Callrecording__c != leadRecord.Callrecording__c) {
                        changedFields.add('Callrecording__c');
                    }
                    if (oldLeadRecord.CallUniqueI__c != leadRecord.CallUniqueI__c) {
                        changedFields.add('CallUniqueI__c');
                    }
                    if (oldLeadRecord.Campagin__c != leadRecord.Campagin__c) {
                        changedFields.add('Campagin__c');
                    }
                    if (oldLeadRecord.Campaign_ID__c != leadRecord.Campaign_ID__c) {
                        changedFields.add('Campaign_ID__c');
                    }
                    if (oldLeadRecord.DC_Campaign_Source__c != leadRecord.DC_Campaign_Source__c) {
                        changedFields.add('DC_Campaign_Source__c');
                    }
                    if (oldLeadRecord.Channel__c != leadRecord.Channel__c) {
                        changedFields.add('Channel__c');
                    }
                    if (oldLeadRecord.Civil_Work__c != leadRecord.Civil_Work__c) {
                        changedFields.add('Civil_Work__c');
                    }
                    if (oldLeadRecord.Client_Site_visit__c != leadRecord.Client_Site_visit__c) {
                        changedFields.add('Client_Site_visit__c');
                    }
                    if (oldLeadRecord.CMM_Name__c != leadRecord.CMM_Name__c) {
                        changedFields.add('CMM_Name__c');
                    }
                    if (oldLeadRecord.CMM_Team__c != leadRecord.CMM_Team__c) {
                        changedFields.add('CMM_Team__c');
                    }
                    if (oldLeadRecord.Connected_TimeStamp__c != leadRecord.Connected_TimeStamp__c) {
                        changedFields.add('Connected_TimeStamp__c');
                    }
                    if (oldLeadRecord.Converted_TimeStamp__c != leadRecord.Converted_TimeStamp__c) {
                        changedFields.add('Converted_TimeStamp__c');
                    }
                    if (oldLeadRecord.Country_Code__c != leadRecord.Country_Code__c) {
                        changedFields.add('Country_Code__c');
                    }
                    if (oldLeadRecord.Created_Date_Time__c != leadRecord.Created_Date_Time__c) {
                        changedFields.add('Created_Date_Time__c');
                    }
                    if (oldLeadRecord.Created_Month__c != leadRecord.Created_Month__c) {
                        changedFields.add('Created_Month__c');
                    }
                    if (oldLeadRecord.Customer_Language_Preference__c != leadRecord.Customer_Language_Preference__c) {
                        changedFields.add('Customer_Language_Preference__c');
                    }
                    if (oldLeadRecord.Customer_Pincode__c != leadRecord.Customer_Pincode__c) {
                        changedFields.add('Customer_Pincode__c');
                    }
                    if (oldLeadRecord.Customer_WhatsApp_OptIN__c != leadRecord.Customer_WhatsApp_OptIN__c) {
                        changedFields.add('Customer_WhatsApp_OptIN__c');
                    }
                    if (oldLeadRecord.Custom_Lead_ID__c != leadRecord.Custom_Lead_ID__c) {
                        changedFields.add('Custom_Lead_ID__c');
                    }
                    if (oldLeadRecord.Date_When_Meeting_is_Scheduled__c != leadRecord.Date_When_Meeting_is_Scheduled__c) {
                        changedFields.add('Date_When_Meeting_is_Scheduled__c');
                    }
                    if (oldLeadRecord.Days_elapsed_after_Meeting_Scheduled__c != leadRecord.Days_elapsed_after_Meeting_Scheduled__c) {
                        changedFields.add('Days_elapsed_after_Meeting_Scheduled__c');
                    }
                    if (oldLeadRecord.DB_Created_Date_without_Time__c != leadRecord.DB_Created_Date_without_Time__c) {
                        changedFields.add('DB_Created_Date_without_Time__c');
                    }
                    if (oldLeadRecord.DB_Lead_Age__c != leadRecord.DB_Lead_Age__c) {
                        changedFields.add('DB_Lead_Age__c');
                    }
                    if (oldLeadRecord.DC_Home_Visit__c != leadRecord.DC_Home_Visit__c) {
                        changedFields.add('DC_Home_Visit__c');
                    }
                    if (oldLeadRecord.Delay_in_response__c != leadRecord.Delay_in_response__c) {
                        changedFields.add('Delay_in_response__c');
                    }
                    if (oldLeadRecord.Designer__c != leadRecord.Designer__c) {
                        changedFields.add('Designer__c');
                    }
                    if (oldLeadRecord.DesignerEmail__c != leadRecord.DesignerEmail__c) {
                        changedFields.add('DesignerEmail__c');
                    }
                    if (oldLeadRecord.Designer_ID_Portal__c != leadRecord.Designer_ID_Portal__c) {
                        changedFields.add('Designer_ID_Portal__c');
                    }
                    if (oldLeadRecord.DesignerMobile__c != leadRecord.DesignerMobile__c) {
                        changedFields.add('DesignerMobile__c');
                    }
                    if (oldLeadRecord.Designer_Name__c != leadRecord.Designer_Name__c) {
                        changedFields.add('Designer_Name__c');
                    }
                    if (oldLeadRecord.Designers_Email__c != leadRecord.Designers_Email__c) {
                        changedFields.add('Designers_Email__c');
                    }
                    if (oldLeadRecord.Designers_TL_Email__c != leadRecord.Designers_TL_Email__c) {
                        changedFields.add('Designers_TL_Email__c');
                    }
                    if (oldLeadRecord.Designer_Team_Name__c != leadRecord.Designer_Team_Name__c) {
                        changedFields.add('Designer_Team_Name__c');
                    }
                    if (oldLeadRecord.Designer_TL_s_Manager_Email__c != leadRecord.Designer_TL_s_Manager_Email__c) {
                        changedFields.add('Designer_TL_s_Manager_Email__c');
                    }
                    if (oldLeadRecord.Design_User__c != leadRecord.Design_User__c) {
                        changedFields.add('Design_User__c');
                    }
                    if (oldLeadRecord.Design_User_Name__c != leadRecord.Design_User_Name__c) {
                        changedFields.add('Design_User_Name__c');
                    }
                    if (oldLeadRecord.Device_Name__c != leadRecord.Device_Name__c) {
                        changedFields.add('Device_Name__c');
                    }
                    if (oldLeadRecord.Device_Type__c != leadRecord.Device_Type__c) {
                        changedFields.add('Device_Type__c');
                    }
                    if (oldLeadRecord.DialPad_Input_Knowlarity__c != leadRecord.DialPad_Input_Knowlarity__c) {
                        changedFields.add('DialPad_Input_Knowlarity__c');
                    }
                    if (oldLeadRecord.Do_you_have_pets__c != leadRecord.Do_you_have_pets__c) {
                        changedFields.add('Do_you_have_pets__c');
                    }
                    if (oldLeadRecord.DSA__c != leadRecord.DSA__c) {
                        changedFields.add('DSA__c');
                    }
                    if (oldLeadRecord.DSA_Category__c != leadRecord.DSA_Category__c) {
                        changedFields.add('DSA_Category__c');
                    }
                    if (oldLeadRecord.DSA_Code__c != leadRecord.DSA_Code__c) {
                        changedFields.add('DSA_Code__c');
                    }
                    if (oldLeadRecord.DSA_Email__c != leadRecord.DSA_Email__c) {
                        changedFields.add('DSA_Email__c');
                    }
                    if (oldLeadRecord.DSAname__c != leadRecord.DSAname__c) {
                        changedFields.add('DSAname__c');
                    }
                    
                    if (oldLeadRecord.DUP_Mobile__c != leadRecord.DUP_Mobile__c) {
                        changedFields.add('DUP_Mobile__c');
                    }
                    if (oldLeadRecord.DUP_Update_Owner__c != leadRecord.DUP_Update_Owner__c) {
                        changedFields.add('DUP_Update_Owner__c');
                    }
                    if (oldLeadRecord.Eat__c != leadRecord.Eat__c) {
                        changedFields.add('Eat__c');
                    }
                    if (oldLeadRecord.EC_Location__c != leadRecord.EC_Location__c) {
                        changedFields.add('EC_Location__c');
                    }
                    if (oldLeadRecord.EM4Hr__c != leadRecord.EM4Hr__c) {
                        changedFields.add('EM4Hr__c');
                    }
                    if (oldLeadRecord.Email_from_Data_Dump__c != leadRecord.Email_from_Data_Dump__c) {
                        changedFields.add('Email_from_Data_Dump__c');
                    }
                    if (oldLeadRecord.EmployeeCode__c != leadRecord.EmployeeCode__c) {
                        changedFields.add('EmployeeCode__c');
                    }
                    if (oldLeadRecord.Enquiry_ID__c != leadRecord.Enquiry_ID__c) {
                        changedFields.add('Enquiry_ID__c');
                    }
                    if (oldLeadRecord.Entry_Url__c != leadRecord.Entry_Url__c) {
                        changedFields.add('Entry_Url__c');
                    }
                    if (oldLeadRecord.FBCLID__c != leadRecord.FBCLID__c) {
                        changedFields.add('FBCLID__c');
                    }
                    if (oldLeadRecord.File_Name__c != leadRecord.File_Name__c) {
                        changedFields.add('File_Name__c');
                    }
                    if (oldLeadRecord.File_Url__c != leadRecord.File_Url__c) {
                        changedFields.add('File_Url__c');
                    }
                    if (oldLeadRecord.First_Date_of_Contact__c != leadRecord.First_Date_of_Contact__c) {
                        changedFields.add('First_Date_of_Contact__c');
                    }
                    if (oldLeadRecord.first_date_of_contact_to_Qualified_c__c != leadRecord.first_date_of_contact_to_Qualified_c__c) {
                        changedFields.add('first_date_of_contact_to_Qualified_c__c');
                    }
                    if (oldLeadRecord.First_Meeting_Date__c != leadRecord.First_Meeting_Date__c) {
                        changedFields.add('First_Meeting_Date__c');
                    }
                    if (oldLeadRecord.First_Response_Actual__c != leadRecord.First_Response_Actual__c) {
                        changedFields.add('First_Response_Actual__c');
                    }
                    if (oldLeadRecord.First_Response_Target__c != leadRecord.First_Response_Target__c) {
                        changedFields.add('First_Response_Target__c');
                    }
                    if (oldLeadRecord.First_Visit_Time__c != leadRecord.First_Visit_Time__c) {
                        changedFields.add('First_Visit_Time__c');
                    }
                    if (oldLeadRecord.floor_plan_attachment_id__c != leadRecord.floor_plan_attachment_id__c) {
                        changedFields.add('floor_plan_attachment_id__c');
                    }
                    if (oldLeadRecord.Area__c != leadRecord.Area__c) {
                        changedFields.add('Area__c');
                    }
                    if (oldLeadRecord.Floor_Area__c != leadRecord.Floor_Area__c) {
                        changedFields.add('Floor_Area__c');
                    }
                    if (oldLeadRecord.Floor_Plan_Link_from_Chatbot__c != leadRecord.Floor_Plan_Link_from_Chatbot__c) {
                        changedFields.add('Floor_Plan_Link_from_Chatbot__c');
                    }
                    if (oldLeadRecord.Follow_Up_Count__c != leadRecord.Follow_Up_Count__c) {
                        changedFields.add('Follow_Up_Count__c');
                    }
                    if (oldLeadRecord.Follow_Up_Date_Time__c != leadRecord.Follow_Up_Date_Time__c) {
                        changedFields.add('Follow_Up_Date_Time__c');
                    }
                    if (oldLeadRecord.FollowUp_Field_Update__c != leadRecord.FollowUp_Field_Update__c) {
                        changedFields.add('FollowUp_Field_Update__c');
                    }
                    if (oldLeadRecord.Fourth_Date_of_Contact__c != leadRecord.Fourth_Date_of_Contact__c) {
                        changedFields.add('Fourth_Date_of_Contact__c');
                    }
                    if (oldLeadRecord.GCLID__c != leadRecord.GCLID__c) {
                        changedFields.add('GCLID__c');
                    }
                    if (oldLeadRecord.Gender_of_First_kid__c != leadRecord.Gender_of_First_kid__c) {
                        changedFields.add('Gender_of_First_kid__c');
                    }
                    if (oldLeadRecord.Gender_of_Fourth_kid__c != leadRecord.Gender_of_Fourth_kid__c) {
                        changedFields.add('Gender_of_Fourth_kid__c');
                    }
                    if (oldLeadRecord.Gender_of_Second_kid__c != leadRecord.Gender_of_Second_kid__c) {
                        changedFields.add('Gender_of_Second_kid__c');
                    }
                    if (oldLeadRecord.Gender_of_Third_kid__c != leadRecord.Gender_of_Third_kid__c) {
                        changedFields.add('Gender_of_Third_kid__c');
                    }
                    if (oldLeadRecord.google_campaign_id__c != leadRecord.google_campaign_id__c) {
                        changedFields.add('google_campaign_id__c');
                    }
                    if (oldLeadRecord.google_form_id__c != leadRecord.google_form_id__c) {
                        changedFields.add('google_form_id__c');
                    }
                    if (oldLeadRecord.google_lead_id__c != leadRecord.google_lead_id__c) {
                        changedFields.add('google_lead_id__c');
                    }
                    if (oldLeadRecord.Has_Designer_Accepted__c != leadRecord.Has_Designer_Accepted__c) {
                        changedFields.add('Has_Designer_Accepted__c');
                    }
                    if (oldLeadRecord.Home_Type__c != leadRecord.Home_Type__c) {
                        changedFields.add('Home_Type__c');
                    }
                    if (oldLeadRecord.How_did_you_hear_about_us__c != leadRecord.How_did_you_hear_about_us__c) {
                        changedFields.add('How_did_you_hear_about_us__c');
                    }
                    if (oldLeadRecord.How_many_kids_do_you_have__c != leadRecord.How_many_kids_do_you_have__c) {
                        changedFields.add('How_many_kids_do_you_have__c');
                    }
                    if (oldLeadRecord.If_other_languages_please_specify__c != leadRecord.If_other_languages_please_specify__c) {
                        changedFields.add('If_other_languages_please_specify__c');
                    }
                    if (oldLeadRecord.Inbound_Call__c != leadRecord.Inbound_Call__c) {
                        changedFields.add('Inbound_Call__c');
                    }
                    if (oldLeadRecord.Initial_Call_Stage__c != leadRecord.Initial_Call_Stage__c) {
                        changedFields.add('Initial_Call_Stage__c');
                    }
                    if (oldLeadRecord.Interior_work_needed_for__c != leadRecord.Interior_work_needed_for__c) {
                        changedFields.add('Interior_work_needed_for__c');
                    }
                    if (oldLeadRecord.IPAddress__c != leadRecord.IPAddress__c) {
                        changedFields.add('IPAddress__c');
                    }
                    
                    if (oldLeadRecord.Is_Customer_Created__c != leadRecord.Is_Customer_Created__c) {
                        changedFields.add('Is_Customer_Created__c');
                    }
                    if (oldLeadRecord.Is_Bulk_Upload__c != leadRecord.Is_Bulk_Upload__c) {
                        changedFields.add('Is_Bulk_Upload__c');
                    }
                    if (oldLeadRecord.Is_Designer_Assigned__c != leadRecord.Is_Designer_Assigned__c) {
                        changedFields.add('Is_Designer_Assigned__c');
                    }
                    if (oldLeadRecord.Is_Designer_logged_In_for_Report__c != leadRecord.Is_Designer_logged_In_for_Report__c) {
                        changedFields.add('Is_Designer_logged_In_for_Report__c');
                    }
                    if (oldLeadRecord.Is_Follow_up_Outstanding__c != leadRecord.Is_Follow_up_Outstanding__c) {
                        changedFields.add('Is_Follow_up_Outstanding__c');
                    }
                    if (oldLeadRecord.Is_Lead_Update__c != leadRecord.Is_Lead_Update__c) {
                        changedFields.add('Is_Lead_Update__c');
                    }
                    if (oldLeadRecord.Is_MS__c != leadRecord.Is_MS__c) {
                        changedFields.add('Is_MS__c');
                    }
                    if (oldLeadRecord.Keyword__c != leadRecord.Keyword__c) {
                        changedFields.add('Keyword__c');
                    }
                    if (oldLeadRecord.Knew_about_Design_Cafe_Because__c != leadRecord.Knew_about_Design_Cafe_Because__c) {
                        changedFields.add('Knew_about_Design_Cafe_Because__c');
                    }
                    if (oldLeadRecord.LARR__c != leadRecord.LARR__c) {
                        changedFields.add('LARR__c');
                    }
                    if (oldLeadRecord.LastModifiedBy__c != leadRecord.LastModifiedBy__c) {
                        changedFields.add('LastModifiedBy__c');
                    }
                    if (oldLeadRecord.Last_Source__c != leadRecord.Last_Source__c) {
                        changedFields.add('Last_Source__c');
                    }
                    if (oldLeadRecord.Lead_Allocation_Time__c != leadRecord.Lead_Allocation_Time__c) {
                        changedFields.add('Lead_Allocation_Time__c');
                    }
                    if (oldLeadRecord.Lead_Allocation_time_to_SM__c != leadRecord.Lead_Allocation_time_to_SM__c) {
                        changedFields.add('Lead_Allocation_time_to_SM__c');
                    }
                    if (oldLeadRecord.Lead_Designer_is_Current_User__c != leadRecord.Lead_Designer_is_Current_User__c) {
                        changedFields.add('Lead_Designer_is_Current_User__c');
                    }
                    if (oldLeadRecord.Lead_Generator__c != leadRecord.Lead_Generator__c) {
                        changedFields.add('Lead_Generator__c');
                    }
                    if (oldLeadRecord.LeadNameAndPhone__c != leadRecord.LeadNameAndPhone__c) {
                        changedFields.add('LeadNameAndPhone__c');
                    }
                    if (oldLeadRecord.Lead_Owner_s_Phone__c != leadRecord.Lead_Owner_s_Phone__c) {
                        changedFields.add('Lead_Owner_s_Phone__c');
                    }
                    if (oldLeadRecord.Lead_owner_Email__c != leadRecord.Lead_owner_Email__c) {
                        changedFields.add('Lead_owner_Email__c');
                    }
                    if (oldLeadRecord.Lead_Owner_Mobile__c != leadRecord.Lead_Owner_Mobile__c) {
                        changedFields.add('Lead_Owner_Mobile__c');
                    }
                    if (oldLeadRecord.Lead_Owner_Name__c != leadRecord.Lead_Owner_Name__c) {
                        changedFields.add('Lead_Owner_Name__c');
                    }
                    if (oldLeadRecord.Lead_Owner_Profile__c != leadRecord.Lead_Owner_Profile__c) {
                        changedFields.add('Lead_Owner_Profile__c');
                    }
                    if (oldLeadRecord.Lead_Owner_Region__c != leadRecord.Lead_Owner_Region__c) {
                        changedFields.add('Lead_Owner_Region__c');
                    }
                    if (oldLeadRecord.Lead_Owner_Role__c != leadRecord.Lead_Owner_Role__c) {
                        changedFields.add('Lead_Owner_Role__c');
                    }
                    if (oldLeadRecord.Lead_Owner_Team__c != leadRecord.Lead_Owner_Team__c) {
                        changedFields.add('Lead_Owner_Team__c');
                    }
                    if (oldLeadRecord.Lead_Qualified_Date__c != leadRecord.Lead_Qualified_Date__c) {
                        changedFields.add('Lead_Qualified_Date__c');
                    }
                    if (oldLeadRecord.Lead_Qualified_for__c != leadRecord.Lead_Qualified_for__c) {
                        changedFields.add('Lead_Qualified_for__c');
                    }
                    if (oldLeadRecord.Lead_Response_Time_by_SM__c != leadRecord.Lead_Response_Time_by_SM__c) {
                        changedFields.add('Lead_Response_Time_by_SM__c');
                    }
                    if (oldLeadRecord.DC_Lead_Source__c != leadRecord.DC_Lead_Source__c) {
                        changedFields.add('DC_Lead_Source__c');
                    }
                    if (oldLeadRecord.Lead_Stage_And_Call_Stage__c != leadRecord.Lead_Stage_And_Call_Stage__c) {
                        changedFields.add('Lead_Stage_And_Call_Stage__c');
                    }
                    if (oldLeadRecord.DC_Lead_Status__c != leadRecord.DC_Lead_Status__c) {
                        changedFields.add('DC_Lead_Status__c');
                    }
                    if (oldLeadRecord.Live__c != leadRecord.Live__c) {
                        changedFields.add('Live__c');
                    }
                    if (oldLeadRecord.Lockdown_Survey__c != leadRecord.Lockdown_Survey__c) {
                        changedFields.add('Lockdown_Survey__c');
                    }
                    if (oldLeadRecord.Mass_email__c != leadRecord.Mass_email__c) {
                        changedFields.add('Mass_email__c');
                    }
                    if (oldLeadRecord.Match_Type__c != leadRecord.Match_Type__c) {
                        changedFields.add('Match_Type__c');
                    }
                    if (oldLeadRecord.MeetingConfirmed_TimeStamp__c != leadRecord.MeetingConfirmed_TimeStamp__c) {
                        changedFields.add('MeetingConfirmed_TimeStamp__c');
                    }
                    if (oldLeadRecord.Meeting_Scheduled_by__c != leadRecord.Meeting_Scheduled_by__c) {
                        changedFields.add('Meeting_Scheduled_by__c');
                    }
                    if (oldLeadRecord.Meeting_Scheduled_By_Name__c != leadRecord.Meeting_Scheduled_By_Name__c) {
                        changedFields.add('Meeting_Scheduled_By_Name__c');
                    }
                    if (oldLeadRecord.Willingness_For_Meeting__c != leadRecord.Willingness_For_Meeting__c) {
                        changedFields.add('Willingness_For_Meeting__c');
                    }
                    if (oldLeadRecord.Meeting_Scheduled_on_First_Call__c != leadRecord.Meeting_Scheduled_on_First_Call__c) {
                        changedFields.add('Meeting_Scheduled_on_First_Call__c');
                    }
                    if (oldLeadRecord.Meeting_Scheduled_Reminder__c != leadRecord.Meeting_Scheduled_Reminder__c) {
                        changedFields.add('Meeting_Scheduled_Reminder__c');
                    }
                    if (oldLeadRecord.MeetingScheduled_TimeStamp__c != leadRecord.MeetingScheduled_TimeStamp__c) {
                        changedFields.add('MeetingScheduled_TimeStamp__c');
                    }
                    if (oldLeadRecord.Meeting_Type__c != leadRecord.Meeting_Type__c) {
                        changedFields.add('Meeting_Type__c');
                    }
                    if (oldLeadRecord.Meeting_Venue__c != leadRecord.Meeting_Venue__c) {
                        changedFields.add('Meeting_Venue__c');
                    }
                    if (oldLeadRecord.Messaging_Source__c != leadRecord.Messaging_Source__c) {
                        changedFields.add('Messaging_Source__c');
                    }
                    if (oldLeadRecord.Mobile_Number_External_Field__c != leadRecord.Mobile_Number_External_Field__c) {
                        changedFields.add('Mobile_Number_External_Field__c');
                    }
                    if (oldLeadRecord.MobileYM__c != leadRecord.MobileYM__c) {
                        changedFields.add('MobileYM__c');
                    }
                    if (oldLeadRecord.Model_of_Business__c != leadRecord.Model_of_Business__c) {
                        changedFields.add('Model_of_Business__c');
                    }
                    if (oldLeadRecord.Moderator__c != leadRecord.Moderator__c) {
                        changedFields.add('Moderator__c');
                    }
                    if (oldLeadRecord.Move_in__c != leadRecord.Move_in__c) {
                        changedFields.add('Move_in__c');
                    }
                    if (oldLeadRecord.MS_5days__c != leadRecord.MS_5days__c) {
                        changedFields.add('MS_5days__c');
                    }
                    if (oldLeadRecord.MS_Date_Time__c != leadRecord.MS_Date_Time__c) {
                        changedFields.add('MS_Date_Time__c');
                    }
                    if (oldLeadRecord.MS_Delay_in_response__c != leadRecord.MS_Delay_in_response__c) {
                        changedFields.add('MS_Delay_in_response__c');
                    }
                    if (oldLeadRecord.MS_First_Response_Actual__c != leadRecord.MS_First_Response_Actual__c) {
                        changedFields.add('MS_First_Response_Actual__c');
                    }
                    if (oldLeadRecord.MS_First_Response_Target__c != leadRecord.MS_First_Response_Target__c) {
                        changedFields.add('MS_First_Response_Target__c');
                    }
                    if (oldLeadRecord.MS_Follow_Up_Count__c != leadRecord.MS_Follow_Up_Count__c) {
                        changedFields.add('MS_Follow_Up_Count__c');
                    }
                    if (oldLeadRecord.New_TimeStamp__c != leadRecord.New_TimeStamp__c) {
                        changedFields.add('New_TimeStamp__c');
                    }
                    if (oldLeadRecord.No_of_days_1st_to_qualified__c != leadRecord.No_of_days_1st_to_qualified__c) {
                        changedFields.add('No_of_days_1st_to_qualified__c');
                    }
                    if (oldLeadRecord.No_of_days_spent__c != leadRecord.No_of_days_spent__c) {
                        changedFields.add('No_of_days_spent__c');
                    }
                    if (oldLeadRecord.No_of_days_spent_Undialled__c != leadRecord.No_of_days_spent_Undialled__c) {
                        changedFields.add('No_of_days_spent_Undialled__c');
                    }
                    if (oldLeadRecord.NotConnected_TimeStamp__c != leadRecord.NotConnected_TimeStamp__c) {
                        changedFields.add('NotConnected_TimeStamp__c');
                    }
                    if (oldLeadRecord.Offer_of_the_Month__c != leadRecord.Offer_of_the_Month__c) {
                        changedFields.add('Offer_of_the_Month__c');
                    }
                    if (oldLeadRecord.Old_Source__c != leadRecord.Old_Source__c) {
                        changedFields.add('Old_Source__c');
                    }
                    if (oldLeadRecord.Others_for_Live__c != leadRecord.Others_for_Live__c) {
                        changedFields.add('Others_for_Live__c');
                    }
                    if (oldLeadRecord.Others_for_Play__c != leadRecord.Others_for_Play__c) {
                        changedFields.add('Others_for_Play__c');
                    }
                    if (oldLeadRecord.OTP_Verified__c != leadRecord.OTP_Verified__c) {
                        changedFields.add('OTP_Verified__c');
                    }
                    if (oldLeadRecord.Owner__c != leadRecord.Owner__c) {
                        changedFields.add('Owner__c');
                    }
                    if (oldLeadRecord.OwnerIsActive__c != leadRecord.OwnerIsActive__c) {
                        changedFields.add('OwnerIsActive__c');
                    }
                    if (oldLeadRecord.Page__c != leadRecord.Page__c) {
                        changedFields.add('Page__c');
                    }
                    if (oldLeadRecord.Page_URL__c != leadRecord.Page_URL__c) {
                        changedFields.add('Page_URL__c');
                    }
                    if (oldLeadRecord.PB_BS_0_or_2__c != leadRecord.PB_BS_0_or_2__c) {
                        changedFields.add('PB_BS_0_or_2__c');
                    }
                    if (oldLeadRecord.PB_BS_1_or_3_or_4__c != leadRecord.PB_BS_1_or_3_or_4__c) {
                        changedFields.add('PB_BS_1_or_3_or_4__c');
                    }
                    if (oldLeadRecord.PB_Current_user_ID__c != leadRecord.PB_Current_user_ID__c) {
                        changedFields.add('PB_Current_user_ID__c');
                    }
                    
                    if (oldLeadRecord.PB_Design_user_assigned__c != leadRecord.PB_Design_user_assigned__c) {
                        changedFields.add('PB_Design_user_assigned__c');
                    }
                    if (oldLeadRecord.Play__c != leadRecord.Play__c) {
                        changedFields.add('Play__c');
                    }
                    if (oldLeadRecord.PPT_Uploaded__c != leadRecord.PPT_Uploaded__c) {
                        changedFields.add('PPT_Uploaded__c');
                    }
                    if (oldLeadRecord.Pre_Qualified_Date__c != leadRecord.Pre_Qualified_Date__c) {
                        changedFields.add('Pre_Qualified_Date__c');
                    }
                    if (oldLeadRecord.Pre_Qualified_FollowUp_Date__c != leadRecord.Pre_Qualified_FollowUp_Date__c) {
                        changedFields.add('Pre_Qualified_FollowUp_Date__c');
                    }
                    if (oldLeadRecord.Project_Name__c != leadRecord.Project_Name__c) {
                        changedFields.add('Project_Name__c');
                    }
                    if (oldLeadRecord.propertyAddress__c != leadRecord.propertyAddress__c) {
                        changedFields.add('propertyAddress__c');
                    }
                    if (oldLeadRecord.Property_Address__c != leadRecord.Property_Address__c) {
                        changedFields.add('Property_Address__c');
                    }
                    if (oldLeadRecord.Property_Name__c != leadRecord.Property_Name__c) {
                        changedFields.add('Property_Name__c');
                    }
                    if (oldLeadRecord.Property_Possession_Date__c != leadRecord.Property_Possession_Date__c) {
                        changedFields.add('Property_Possession_Date__c');
                    }
                    if (oldLeadRecord.Property_Possession_Status__c != leadRecord.Property_Possession_Status__c) {
                        changedFields.add('Property_Possession_Status__c');
                    }
                    if (oldLeadRecord.Property_Usage__c != leadRecord.Property_Usage__c) {
                        changedFields.add('Property_Usage__c');
                    }
                    if (oldLeadRecord.Rate_of_conversion__c != leadRecord.Rate_of_conversion__c) {
                        changedFields.add('Rate_of_conversion__c');
                    }
                    if (oldLeadRecord.Ready_for_Convert_Time__c != leadRecord.Ready_for_Convert_Time__c) {
                        changedFields.add('Ready_for_Convert_Time__c');
                    }
                    if (oldLeadRecord.Ready_to_Convert__c != leadRecord.Ready_to_Convert__c) {
                        changedFields.add('Ready_to_Convert__c');
                    }
                    if (oldLeadRecord.Call_Stage__c != leadRecord.Call_Stage__c) {
                        changedFields.add('Call_Stage__c');
                    }
                    if (oldLeadRecord.Re_Contact_Date__c != leadRecord.Re_Contact_Date__c) {
                        changedFields.add('Re_Contact_Date__c');
                    }
                    if (oldLeadRecord.Recontacted_FollowUp_Date_Update__c != leadRecord.Recontacted_FollowUp_Date_Update__c) {
                        changedFields.add('Recontacted_FollowUp_Date_Update__c');
                    }
                    if (oldLeadRecord.RECORD_ID__c != leadRecord.RECORD_ID__c) {
                        changedFields.add('RECORD_ID__c');
                    }
                    if (oldLeadRecord.RecordForDeletion__c != leadRecord.RecordForDeletion__c) {
                        changedFields.add('RecordForDeletion__c');
                    }
                    if (oldLeadRecord.Referee_Account__c != leadRecord.Referee_Account__c) {
                        changedFields.add('Referee_Account__c');
                    }
                    if (oldLeadRecord.Referrer_City__c != leadRecord.Referrer_City__c) {
                        changedFields.add('Referrer_City__c');
                    }
                    if (oldLeadRecord.Referee_Code__c != leadRecord.Referee_Code__c) {
                        changedFields.add('Referee_Code__c');
                    }
                    if (oldLeadRecord.Referee_Email_ID__c != leadRecord.Referee_Email_ID__c) {
                        changedFields.add('Referee_Email_ID__c');
                    }
                    if (oldLeadRecord.Referee_Name__c != leadRecord.Referee_Name__c) {
                        changedFields.add('Referee_Name__c');
                    }
                    if (oldLeadRecord.Referee_Number__c != leadRecord.Referee_Number__c) {
                        changedFields.add('Referee_Number__c');
                    }
                    if (oldLeadRecord.Region__c != leadRecord.Region__c) {
                        changedFields.add('Region__c');
                    }
                    if (oldLeadRecord.rejected_by__c != leadRecord.rejected_by__c) {
                        changedFields.add('rejected_by__c');
                    }
                    if (oldLeadRecord.Requirement_Details__c != leadRecord.Requirement_Details__c) {
                        changedFields.add('Requirement_Details__c');
                    }
                    if (oldLeadRecord.RR_User_Id__c != leadRecord.RR_User_Id__c) {
                        changedFields.add('RR_User_Id__c');
                    }
                    if (oldLeadRecord.Scope_Of_Work__c != leadRecord.Scope_Of_Work__c) {
                        changedFields.add('Scope_Of_Work__c');
                    }
                    if (oldLeadRecord.Secondary_Email__c != leadRecord.Secondary_Email__c) {
                        changedFields.add('Secondary_Email__c');
                    }
                    if (oldLeadRecord.Second_Date_of_Contact__c != leadRecord.Second_Date_of_Contact__c) {
                        changedFields.add('Second_Date_of_Contact__c');
                    }
                    if (oldLeadRecord.Site_Service_Needed_for__c != leadRecord.Site_Service_Needed_for__c) {
                        changedFields.add('Site_Service_Needed_for__c');
                    }
                    if (oldLeadRecord.Source__c != leadRecord.Source__c) {
                        changedFields.add('Source__c');
                    }
                    if (oldLeadRecord.Source_Journey__c != leadRecord.Source_Journey__c) {
                        changedFields.add('Source_Journey__c');
                    }
                    if (oldLeadRecord.Third_Date_of_Contact__c != leadRecord.Third_Date_of_Contact__c) {
                        changedFields.add('Third_Date_of_Contact__c');
                    }
                    if (oldLeadRecord.Time_On_Last_page__c != leadRecord.Time_On_Last_page__c) {
                        changedFields.add('Time_On_Last_page__c');
                    }
                    if (oldLeadRecord.Total_Call_Duration__c != leadRecord.Total_Call_Duration__c) {
                        changedFields.add('Total_Call_Duration__c');
                    }
                    if (oldLeadRecord.Twitter__c != leadRecord.Twitter__c) {
                        changedFields.add('Twitter__c');
                    }
                    if (oldLeadRecord.Unread_Time__c != leadRecord.Unread_Time__c) {
                        changedFields.add('Unread_Time__c');
                    }
                    if (oldLeadRecord.User_Browser__c != leadRecord.User_Browser__c) {
                        changedFields.add('User_Browser__c');
                    }
                    if (oldLeadRecord.UserID__c != leadRecord.UserID__c) {
                        changedFields.add('UserID__c');
                    }
                    if (oldLeadRecord.User_Last_Url__c != leadRecord.User_Last_Url__c) {
                        changedFields.add('User_Last_Url__c');
                    }
                    if (oldLeadRecord.User_Mobile__c != leadRecord.User_Mobile__c) {
                        changedFields.add('User_Mobile__c');
                    }
                    if (oldLeadRecord.User_OS__c != leadRecord.User_OS__c) {
                        changedFields.add('User_OS__c');
                    }
                    if (oldLeadRecord.Voucher_Code__c != leadRecord.Voucher_Code__c) {
                        changedFields.add('Voucher_Code__c');
                    }
                    if (oldLeadRecord.Whatsapp_Opt_IN__c != leadRecord.Whatsapp_Opt_IN__c) {
                        changedFields.add('Whatsapp_Opt_IN__c');
                    }
                    if (oldLeadRecord.When_would_you_like_to_have_the_home__c != leadRecord.When_would_you_like_to_have_the_home__c) {
                        changedFields.add('When_would_you_like_to_have_the_home__c');
                    }
                    if (oldLeadRecord.Where_are_you_currently_located__c != leadRecord.Where_are_you_currently_located__c) {
                        changedFields.add('Where_are_you_currently_located__c');
                    }
                    if (oldLeadRecord.Which_language_are_you_most_comfortable__c != leadRecord.Which_language_are_you_most_comfortable__c) {
                        changedFields.add('Which_language_are_you_most_comfortable__c');
                    }
                    if (oldLeadRecord.Who_will_be_staying_in_the_house__c != leadRecord.Who_will_be_staying_in_the_house__c) {
                        changedFields.add('Who_will_be_staying_in_the_house__c');
                    }
                    if (oldLeadRecord.Wohoo_Card__c != leadRecord.Wohoo_Card__c) {
                        changedFields.add('Wohoo_Card__c');
                    }
                    if (oldLeadRecord.Work__c != leadRecord.Work__c) {
                        changedFields.add('Work__c');
                    }
                    if (oldLeadRecord.XUID__c != leadRecord.XUID__c) {
                        changedFields.add('XUID__c');
                    }
                    if (oldLeadRecord.YMUrl__c != leadRecord.YMUrl__c) {
                        changedFields.add('YMUrl__c');
                    }
                    if (oldLeadRecord.Flat_Number__c != leadRecord.Flat_Number__c) {
                        changedFields.add('Flat_Number__c');
                    }
                    if (oldLeadRecord.For_Reassignment__c != leadRecord.For_Reassignment__c) {
                        changedFields.add('For_Reassignment__c');
                    }
                    if (oldLeadRecord.Interior_Budget__c != leadRecord.Interior_Budget__c) {
                        changedFields.add('Interior_Budget__c');
                    }
                    if (oldLeadRecord.IP_Address__c != leadRecord.IP_Address__c) {
                        changedFields.add('IP_Address__c');
                    }
                    if (oldLeadRecord.Lead_Source_Sub_Category__c != leadRecord.Lead_Source_Sub_Category__c) {
                        changedFields.add('Lead_Source_Sub_Category__c');
                    }
                    if (oldLeadRecord.Location__c != leadRecord.Location__c) {
                        changedFields.add('Location__c');
                    }
                    if (oldLeadRecord.Page_Id__c != leadRecord.Page_Id__c) {
                        changedFields.add('Page_Id__c');
                    }
                    if (oldLeadRecord.Page_URL_1__c != leadRecord.Page_URL_1__c) {
                        changedFields.add('Page_URL_1__c');
                    }
                    if (oldLeadRecord.Page_Variant__c != leadRecord.Page_Variant__c) {
                        changedFields.add('Page_Variant__c');
                    }
                    if (oldLeadRecord.Partner__c != leadRecord.Partner__c) {
                        changedFields.add('Partner__c');
                    }
                    if (oldLeadRecord.Partner_Notification__c != leadRecord.Partner_Notification__c) {
                        changedFields.add('Partner_Notification__c');
                    }
                    if (oldLeadRecord.Preferred_Time_to_Contact__c != leadRecord.Preferred_Time_to_Contact__c) {
                        changedFields.add('Preferred_Time_to_Contact__c');
                    }
                    if (oldLeadRecord.Property_Type__c != leadRecord.Property_Type__c) {
                        changedFields.add('Property_Type__c');
                    }
                    if (oldLeadRecord.Property_Type_For_Interior__c != leadRecord.Property_Type_For_Interior__c) {
                        changedFields.add('Property_Type_For_Interior__c');
                    }
                    if (oldLeadRecord.Qualified_Status__c != leadRecord.Qualified_Status__c) {
                        changedFields.add('Qualified_Status__c');
                    }
                    if (oldLeadRecord.Recontacted__c != leadRecord.Recontacted__c) {
                        changedFields.add('Recontacted__c');
                    }
                    if (oldLeadRecord.Referral_Mobile__c != leadRecord.Referral_Mobile__c) {
                        changedFields.add('Referral_Mobile__c');
                    }
                    if (oldLeadRecord.Submission_Date_Time__c != leadRecord.Submission_Date_Time__c) {
                        changedFields.add('Submission_Date_Time__c');
                    }
                    if (oldLeadRecord.Units_Required__c != leadRecord.Units_Required__c) {
                        changedFields.add('Units_Required__c');
                    }
                    if (oldLeadRecord.User_Details__c != leadRecord.User_Details__c) {
                        changedFields.add('User_Details__c');
                    }   
                    
                    if (!changedFields.isEmpty()) {
                        leadIdSet.add(leadRecord.Id);
                        leadIdToChangedFieldsMap.put(leadRecord.Id, changedFields);
                    }
                    
                }  
            }
            
            if (!leadIdSet.isEmpty()) {
                // Call the future method with the necessary data
              //  if(Trigger.new[0].LastModifiedBy.Email != 'salesforce2lsq@designcafe.com' || Trigger.new[0].LastModifiedBy.Email != 'rishabh.pandey@partner.designcafe.com' )
              //  LSQ_Lead_Update.sendUpdatedDataToLSQ(new List<Id>(leadIdSet), leadIdToChangedFieldsMap);
               // System.debug('send to LSQ');
            }
        }


        //==== Designer Dashboard Updates ====//
        if(Trigger.isAfter && Trigger.isUpdate){
            if (RecursiveTriggerHandler.isFirstTime && 
                ((Trigger.new[0].Status != Trigger.old[0].Status) || 
                 // Approx budget. Client Budget. Designer. old != new
                 (Trigger.new[0].Meeting_Venue__c != Trigger.old[0].Meeting_Venue__c) ||
                 (Trigger.new[0].Approx_Budget__c != Trigger.old[0].Approx_Budget__c)  ||
                 (Trigger.new[0].Client_s_Budget__c != Trigger.old[0].Client_s_Budget__c)||
                 (Trigger.new[0].Design_User__c != Trigger.old[0].Design_User__c)||
                 (Trigger.new[0].Willingness_For_Meeting__c != Trigger.old[0].Willingness_For_Meeting__c)
                 && (Trigger.new[0].Status =='Meeting Confirmed' || (Trigger.new[0].Status =='Meeting Scheduled'))) ||
                (Trigger.new[0].Status =='Converted') || (Trigger.new[0].Broadcast_Status__c == '0') ||
                ((Trigger.old[0].Is_MS__c !=true && Trigger.new[0].Is_MS__c ==true) && (Trigger.old[0].Status !='Junk' && Trigger.new[0].Status =='Junk')) ){
                    RecursiveTriggerHandler.isFirstTime = false;
                    System.debug('PostLeadToDesignerDashboard : Callout');
                    if(!System.isBatch() && !System.isFuture()){
                        // KUNAL: OLD API            PostLeadToDesignerDashboard.callServer(Trigger.new[0].id);
                    }
                }
        }       
        //==== CustomerDashboard Updates ====//       
        if(Trigger.isAfter && Trigger.isUpdate){
            if(Trigger.new[0].Status== 'Meeting Scheduled' ){                
                if(!System.isBatch() && !System.isFuture()){
                    //Meetingscheduled.callserver(Trigger.new[0].id);
                    //AddCustomers_GraphQL.addCustomers(Trigger.new[0].id);
                }
            }
        }
        //==== send data to Lead Costing Software API ====//
        /*if(Trigger.isAfter && Trigger.isUpdate){
            if(Trigger.new[0].Status =='Converted'){
                if(!System.isBatch() && !System.isFuture()){
                    LcsAPI.LCScallServer(Trigger.New[0].id);  
                }
            }
        }  */
        //====Channel Partner Portal Integration Starts====//
        if(trigger.isAfter && trigger.isInsert){
            if(Trigger.new[0].Status=='New' && Trigger.new[0].Channel__c == 'Offline' && Trigger.new[0].Source__c == 'DSA'){
                VDC_CPInsertLead.CPcallout(Trigger.New[0].id);
            } 
        }       
        if(trigger.isAfter && trigger.isUpdate){
            list<lead> leadList = new list<lead>();
            for(lead l : trigger.new){
                if(l.Status=='New' ||
                   l.Status=='Connected' ||
                   l.Status=='Not Connected' ||
                   l.Status=='Meeting Scheduled' ||
                   l.Status=='Meeting Confirmed' ||
                   l.Status=='Converted'){
                       if(trigger.oldMap.get(l.Id).id == l.Id && l.Channel__c == 'Offline' && l.Source__c == 'DSA'){
                           if(trigger.oldMap.get(l.Id).DC_Lead_Status__c != l.DC_Lead_Status__c ||
                              trigger.oldMap.get(l.Id).Name != l.Name || 
                              trigger.oldMap.get(l.Id).APIMOBILE__c != l.APIMOBILE__c ||
                              trigger.oldMap.get(l.Id).Project_Name__c != l.Project_Name__c || 
                              trigger.oldMap.get(l.Id).City != l.City ||
                              trigger.oldMap.get(l.Id).Email != l.Email || 
                              trigger.oldMap.get(l.Id).PostalCode != l.PostalCode ||
                              trigger.oldMap.get(l.Id).Willingness_For_Meeting__c != l.Willingness_For_Meeting__c ||
                              trigger.oldMap.get(l.Id).Meeting_Venue__c != l.Meeting_Venue__c || 
                              trigger.oldMap.get(l.Id).DSA_Code__c != l.DSA_Code__c ||
                              trigger.oldMap.get(l.Id).DSA__c != l.DSA__c || 
                              trigger.oldMap.get(l.Id).ConvertedOpportunityId != l.ConvertedOpportunityId ||
                              trigger.oldMap.get(l.Id).CMM_Name__c != l.CMM_Name__c || 
                              trigger.oldMap.get(l.Id).ConvertedAccountId != l.ConvertedAccountId ||
                              trigger.oldMap.get(l.Id).Status != l.Status){
                                  leadList.add(l);
                              }
                       }                     
                   }
            }
            if(leadList.size()>0){
                VDC_CPUpdateLead.CPcallout(leadList[0].id);
            }
        }
        //====Channel Partner Portal Integration Ends====//
        //==== Lead to Greet Vendor Starts ====//
        /*if(Trigger.isAfter && Trigger.isInsert ){
system.debug('LeadTOGReet Trig126:');
if((RecursiveTriggerHandler.isFirstTime && Trigger.new[0].Status=='New' ) || 
(Trigger.new[0].Is_MS__c ==true)){
system.debug('LeadTOGReet Trig line129:');
RecursiveTriggerHandler.isFirstTime = false;
if(!System.isBatch() && !System.isFuture()){
leadtogreet.Callout(Trigger.New[0].id);
}
}
}   */
        if(Trigger.isAfter && Trigger.isInsert ){
            List<String> leadIdSet = new List<String>();
            for(Lead l : Trigger.New){
                if(l.Status=='New'){
                    leadIdSet.add(l.Id);
                } 
            }
            //LSQAPIThroughDifferentUser.Callout(leadIdSet);
        }     
     
        if(Trigger.isAfter && Trigger.isInsert && RecursiveTriggerHandler.isFirstTime){
            List<String> leadIdSet = new List<String>();
            for(Lead l : Trigger.New){
                if(l.Status=='New' || (l.Is_MS__c == true)){
                    leadIdSet.add(l.Id);
                } 
            }
            RecursiveTriggerHandler.isFirstTime = false;
            System.debug('leadIdSet on insert 1 ==> ' + leadIdSet);
            //LSQAPIThroughDifferentUser.Callout(leadIdSet);
            Leadtogreet.Callout(leadIdSet);
        }
        
        /*if(Trigger.isAfter && Trigger.isUpdate) {
system.debug('LeadTOGReet TrigUpd 136:');
if((Trigger.new[0].Status=='New'  ||
Trigger.new[0].DC_Lead_Status__c== 'Meeting Scheduled' ||
(Trigger.new[0].DC_Lead_Status__c== 'Prospect' && Trigger.new[0].Status=='Connected' )||
(Trigger.new[0].DC_Lead_Status__c== 'Followup' && Trigger.new[0].Status=='Connected' )||
(Trigger.new[0].DC_Lead_Status__c== 'Pre-qualified' && Trigger.new[0].Status=='Connected' )||
(Trigger.new[0].DC_Lead_Status__c== 'qualified' && Trigger.new[0].Status=='Connected' )||
(Trigger.new[0].DC_Lead_Status__c== 'Follow-UP' && Trigger.new[0].Status=='Connected' ) ||
(Trigger.new[0].DC_Lead_Status__c== 'Junk' && Trigger.new[0].Status=='Connected')||
Trigger.new[0].DC_Lead_Status__c== 'Recontacted' ||
Trigger.new[0].DC_Lead_Status__c== 'CC Error' || 
Trigger.new[0].Status== 'Not Connected' )){
if(Trigger.new[0].Channel__c !=null){
if(!System.isBatch() && !System.isFuture()){
//leadtogreet.Callout(Trigger.New[0].id);
}
}
}
} */
        if(Trigger.isAfter && Trigger.isUpdate) {
            System.debug('after update call');
            List<String> leadIdSet = new List<String>();
            for(Lead ld: Trigger.new){
                if((Trigger.oldMap.get(ld.Id).APIMOBILE__c != ld.APIMOBILE__c || Trigger.oldMap.get(ld.Id).LastName != ld.LastName ||
                   Trigger.oldMap.get(ld.Id).Email != ld.Email || Trigger.oldMap.get(ld.Id).Source__c != ld.Source__c ||
                   Trigger.oldMap.get(ld.Id).Follow_Up_Date_Time__c != ld.Follow_Up_Date_Time__c || Trigger.oldMap.get(ld.Id).City != ld.City ||
                   Trigger.oldMap.get(ld.Id).DC_Lead_Source__c != ld.DC_Lead_Source__c || Trigger.oldMap.get(ld.Id).DC_Campaign_Source__c != ld.DC_Campaign_Source__c ||
                   Trigger.oldMap.get(ld.Id).Project_Name__c != ld.Project_Name__c || Trigger.oldMap.get(ld.Id).DC_Lead_Status__c != ld.DC_Lead_Status__c ||
                   Trigger.oldMap.get(ld.Id).Call_Stage__c != ld.Call_Stage__c || Trigger.oldMap.get(ld.Id).Property_Possession_Date__c != ld.Property_Possession_Date__c ||
                   Trigger.oldMap.get(ld.Id).DSAname__c != ld.DSAname__c || Trigger.oldMap.get(ld.Id).Lead_Owner_Name__c != ld.Lead_Owner_Name__c ||
                   Trigger.oldMap.get(ld.Id).Status != ld.Status) && ld.Status != 'New'
                  ){ 
                      leadIdSet.add(ld.Id);
                }
                if(leadIdSet.size() > 0){
                    System.debug('leadIdSet ==> ' + leadIdSet);
                    Leadtogreet.CalloutOnUpdate(leadIdSet);   
                }
            }
            /*for(Lead l1: Trigger.New){
                if((l1.Status=='New'  ||
                    l1.DC_Lead_Status__c== 'Meeting Scheduled' ||
                    (l1.DC_Lead_Status__c== 'Prospect' && l1.Status=='Connected' )||
                    (l1.DC_Lead_Status__c== 'Followup' && l1.Status=='Connected' )||
                    (l1.DC_Lead_Status__c== 'Pre-qualified' && l1.Status=='Connected' )||
                    (l1.DC_Lead_Status__c== 'qualified' && l1.Status=='Connected' )||
                    (l1.DC_Lead_Status__c== 'Follow-UP' && l1.Status=='Connected' ) ||
                    (l1.DC_Lead_Status__c== 'Junk' && l1.Status=='Connected')||
                    l1.DC_Lead_Status__c== 'Recontacted' ||
                    l1.DC_Lead_Status__c== 'CC Error' || 
                    l1.Status== 'Not Connected' )){
                        if(l1.Channel__c !=null){
                            leadIdSet.add(l1.Id);
                        }
                    }
                
            }
            if (leadIdSet.size() > 0) {
                leadtogreet.Callout(leadIdSet);
            }*/
            
            //==== Lead to Greet Vendor ends ====//
            //==== Lead to Webengage Vendor Starts ====//
            if(Trigger.isAfter && Trigger.isInsert ){
                if(Trigger.new[0].Status=='New' || 
                   Trigger.new[0].Status=='Meeting Scheduled' ||
                   Trigger.new[0].Status=='Meeting Confirmed'){
                       if(!System.isBatch() && !System.isFuture()){
                           DC_Webengage.Callout(Trigger.New[0].id);
                       }
                   }
            }
            if(Trigger.isAfter && Trigger.isUpdate ){
                if(Trigger.new[0].Status=='New' ||
                   Trigger.new[0].Status=='Connected' ||
                   Trigger.new[0].Status=='Not Connected' ||
                   Trigger.new[0].Status=='Meeting Scheduled' ||
                   Trigger.new[0].Status=='Meeting Confirmed' ||
                   Trigger.new[0].Status=='Converted'){
                       if(!System.isBatch() && !System.isFuture()){ 
                          DC_Webengage.Callout(Trigger.New[0].id);
                       }
                   }           
            }
            //==== Lead to Webengage Vendor ends ====//
            //==== YM Welcome Templates ====//
            /*  if(Trigger.isAfter && trigger.isInsert){
if(Trigger.new != null){
system.enqueueJob(new YMTemplateCallout(Trigger.new));
List<Id> leadIds = new List<Id>();
for(lead ld:trigger.new){
if(ld.Messaging_Source__c == null){
leadIds.add(ld.Id);
}
}
if (leadIds != null) YMTemplateCallout.sendYMTemplateCalloutREST(leadIds);

}
} */
            
            /*  if(trigger.isAfter && trigger.isinsert){
if(trigger.new != null){
for(lead ld:trigger.new){
if(ld.Messaging_Source__c == null){

if(ld.whatsapp_opt_in__c == 'Accepted'){

}

else{
// YMTemplateCallout.sendYMTemplateCalloutREST(ld.Whatsapp_Opt_in__c, ld.id);
}
}
}
}
} */
            
            //===============================================//
        }
    }
}