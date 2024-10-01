/*
* Code Creator  : Ankit Soni 
* Created Date  : 14 OCT 2019
* Code Modifier : V-Fory Team
* Modified Date : 10th December 2021
* Modified By   : Munna Shaik
*/
trigger OpportunityTrigger on Opportunity (after insert, after Update, after delete, before insert, before update, before delete) {
    //Boolean control = Boolean.valueOf(System.Label.Opp_Trigger_Bypass);
    Boolean beforeCheck = RecursiveTriggerHandler.runOnceOpp();
    Boolean afterCheck;
    if(!beforeCheck){
    	afterCheck = RecursiveTriggerHandler.runOnceOppAfter();    
    }
    
    System.debug('beforeCheck in OpportunityTrigger ==> ' + beforeCheck);
    System.debug('afterCheck in OpportunityTrigger ==> ' + afterCheck);
    if(beforeCheck || afterCheck || Test.isRunningTest()){
        list<opportunity> opp = trigger.new;
        if (trigger.isUpdate) {
            opportunity oldOpp = trigger.oldmap.get(opp[0].id);
            if ((oldOpp.Project_Created_On_Odoo__c != opp[0].Project_Created_On_Odoo__c) || (oldOpp.IsNewPaymentProject__c != opp[0].IsNewPaymentProject__c)) {
                return;
            }
        }
        //====In Order to update opportunity stageName as Closed Won there should be atleast One Opp Invoice is generated ====//
        if(Trigger.IsBefore && Trigger.IsUpdate){
            System.debug('Before Update Opp Trigger Call');
            OpportunityStageHandler.OpportunityStageWon(Trigger.New,Trigger.OldMap);
        } 
        
        //==== Post Opportunty for Designer Dashboard ====//
        if(Trigger.isAfter && Trigger.isUpdate && 
           (Trigger.new[0].StageName =='Meeting Done' ||  Trigger.new[0].StageName =='Proposal Sent'|| Trigger.new[0].StageName =='Follow Up' || Trigger.new[0].StageName =='Discussion'||   Trigger.new[0].StageName =='Awaiting Closure'|| Trigger.new[0].StageName =='Closed Won'|| Trigger.new[0].StageName =='Closed Lost' )){
               //RecursiveTriggerHandler.isFirstTime = false;
               if (!System.isFuture()) {
                   PostOpportunityToDesignerDashboard.callServer(Trigger.new[0].id);
               }
           }
        //==== Insert action for Before or After Events ====//
        if( Trigger.isInsert) {        
            if(Trigger.isBefore){        
                OpportunityTriggerHelper.updateOffers(trigger.new, null);
            }
            if(Trigger.isAfter){           
                OpportunityTriggerHandler.getTargetRevenueOfSalesExecutive(trigger.new,null, true);
                OpportunityTriggerHandler.handleOpportunityInsertTrigger(trigger.new);
                OpportunityTriggerHandler.rollupSignUpAmontOnMonthlyTarget(trigger.new , trigger.old , false);
            }       
        }
        //==== Update action for Before or After Events ====//
        else if(Trigger.isUpdate) {                    
            if(Trigger.isBefore){
                OpportunityTriggerHandler.getTargetRevenueOfSalesExecutive(trigger.new,trigger.oldMap,  false);
                OpportunityTriggerCMMhandler.getTargetRevenueOfCMMs(trigger.new, trigger.oldMap , false); 
                OpportunityTriggerHelper.updateOffers(trigger.new, Trigger.oldMap);          
            }     
            if(Trigger.isAfter){
                System.debug('OpportunityTrigger call updateLeadTraceOnClosedWonOpty');
                OpportunityTriggerHandler.updateLeadTraceOnClosedWonOpty(trigger.newMap,trigger.oldMap);
                OpportunityTriggerHandler.handleOpportunityUpdateTrigger(trigger.new, trigger.oldMap);//update the designer and delete the old opp team members
                OpportunityTriggerHandler.rollupSignUpAmontOnMonthlyTarget(trigger.new , trigger.old , true);
                //OpportunityTriggerCMMhandler.rollupSignUpAmontOnCMMMonthlyTarget(trigger.new , trigger.old , true);
                System.enqueueJob(new OpportunityTriggerAsyncHelper(trigger.newMap, trigger.oldMap)); 
                // OpportunityTriggerHandler.createTempSMS(trigger.newMap,trigger.oldMap);     
                // call order api to create woohoo card
                /*if(Trigger.new[0].StageName == 'Closed Won'){ 
                    quickcilverAPI.callServer(Trigger.new[0].id);
                }  */  
            }
        }
        //==== Delete action in Before or After Events starts ====//      
        else if(Trigger.isDelete){
            if(Trigger.isAfter){
                OpportunityTriggerHandler.rollupSignUpAmontOnMonthlyTarget(trigger.new , trigger.old , true);
                //OpportunityTriggerCMMhandler.rollupSignUpAmontOnCMMMonthlyTarget(trigger.new , trigger.old , true);
            }else if(Trigger.isBefore){
                LeadTracesDelete.LeadTraceRecordDeleteFMOpportunity(Trigger.oldMap);
            }
        }
        //==== Delete action in Before or After Events ends ====//
        //
        // ==== Opportunity Record to LCSAPI ==== //
        if(Trigger.isAfter && Trigger.isUpdate){
            if(Trigger.new[0].Name !=null &&   Trigger.new[0].Email__c !=null &&  Trigger.new[0].Region__c !=null &&  Trigger.new[0].Design_User_Name__c !=null && Trigger.new[0].SalesManagerName__c !=null &&   Trigger.new[0].SalesManagerEmail__c !=null){
                
                
                if (!System.isFuture()) {
                    //LcsAPIupdate.LcscallServer(Trigger.new[0].id);
                }
            }
        }
        //==== Opportunity Record to Webengage Team   Starts ====//
        if(Trigger.isAfter && Trigger.isInsert){
            if(Trigger.new[0].StageName == 'Meeting Done' ||Trigger.new[0].StageName== 'Proposal Sent' || Trigger.new[0].StageName=='Follow Up' || Trigger.new[0].StageName=='Discussion' ||  Trigger.new[0].StageName=='Awaiting Closure' ||  Trigger.new[0].StageName=='Closed Won' ||  Trigger.new[0].StageName=='Closed Lost' ){
                
                if (!System.isFuture()) {
                    DC_Webengageupdate.Callout(Trigger.new[0].id);
                }
            }
        }
        
        if(Trigger.isAfter && Trigger.isUpdate){
            system.debug('after update opp calling');
            if(Trigger.new[0].StageName == 'Meeting Done' || Trigger.new[0].StageName== 'Proposal Sent' || Trigger.new[0].StageName=='Follow Up' || Trigger.new[0].StageName=='Discussion' || Trigger.new[0].StageName=='Awaiting Closure' || Trigger.new[0].StageName=='Closed Won' || Trigger.new[0].StageName=='Closed Lost' ){
                 system.debug('dcwebenage calling');
                if (!System.isFuture()) {
                    system.debug('dcwebenage calling 2');
                    DC_Webengageupdate.Callout(Trigger.new[0].id);
                }
            }
        }
        //==== Opportunity record to Webengage team ends ====//
        //
        //==== CP Portal Insert API ====//
        if(trigger.isAfter && trigger.isInsert){
            if(Trigger.new[0].StageName=='Meeting Done' && Trigger.new[0].DSA__c != null){
                VDC_CPInsertOpportunity.CPcallout(Trigger.New[0].id);
            } 
        }   
        //==== CP Portal Update API ====//
        if(trigger.isAfter && trigger.isUpdate){
            list<opportunity> oppList = new list<opportunity>();
            for(opportunity o : trigger.new){
                if(o.stageName=='Meeting Done' ||
                   o.stageName=='Proposal Sent' ||
                   o.stageName=='Follow Up' ||
                   o.stageName=='Discussion' ||
                   o.stageName=='Awaiting Closure' ||
                   o.stageName=='Closed Won' ||
                   o.stageName=='Closed Lost'){
                       if((trigger.oldMap.get(o.Id).id == o.Id && o.DSA__c != null) || Test.isRunningTest()){
                           if(trigger.oldMap.get(o.Id).Name != o.Name ||
                              trigger.oldMap.get(o.Id).Region__c != o.Region__c ||
                              trigger.oldMap.get(o.Id).CloseDate != o.CloseDate || 
                              trigger.oldMap.get(o.Id).CreatedDate != o.CreatedDate ||
                              trigger.oldMap.get(o.Id).Phone__c != o.Phone__c || 
                              trigger.oldMap.get(o.Id).Email__c != o.Email__c ||
                              trigger.oldMap.get(o.Id).CMM_Name__c != o.CMM_Name__c ||
                              trigger.oldMap.get(o.Id).DSA_Code__c != o.DSA_Code__c ||
                              trigger.oldMap.get(o.Id).DSA__c != o.DSA__c ||
                              trigger.oldMap.get(o.Id).StageName != o.StageName){
                                  oppList.add(o);
                              }
                       }                     
                   }
            }
            if(oppList.size()>0){
                VDC_CPUpdateOpportunity.CPcallout(oppList[0].id);
            }
        }
        //==== V-fory Team Code Calls starts ====//
        if(trigger.isBefore &&(trigger.isInsert || trigger.isUpdate)){
            if(trigger.isInsert){
                VDC_OpportunityProcessstoApex.ownerchange(trigger.New,trigger.oldmap,true);
            }
            if(trigger.isUpdate){
                VDC_OpportunityProcessstoApex.ownerchange(trigger.New,trigger.oldmap,false);
            }
        }
        //==== V-fory Team Code Calls ends ====//
        
        
        //==== Update PM 7% in Quaote ==== Start//
        //Only blank update to calculate formula field//
        /*  if(Trigger.isAfter && Trigger.isUpdate){
List<Quote> quoteList = [select id,opportunityId,Latest_quote__c from quote where opportunityId = :Trigger.new[0].id and Latest_quote__c = true ORDER BY CreatedDate DESC LIMIT 1];
if(quoteList.size() > 0){
if(Trigger.new[0].Is_Pm_Site__c== true && Trigger.new[0].Meeting_Venue__c=='Mumbai DC'){
quoteList[0].Latest_quote__c = true;
}else{
quoteList[0].Latest_quote__c = true;
}
update quoteList;
}

} */
        //==== Update PM 7% in Quaote End====//
        
        
        //Calling an UpdateProject API
        if (Trigger.isAfter && Trigger.isUpdate)
            if (Trigger.new != null) {
                for (Opportunity NewoppList:trigger.new) {
                    Opportunity OldoppList = trigger.OldMap.get(NewoppList.id);
                    if (NewoppList.Customer_ID__c != OldoppList.Customer_ID__c ||
                        NewoppList.Meeting_Venue__c != OldoppList.Meeting_Venue__c ||
                        NewoppList.Amount != OldoppList.Amount ||
                        NewoppList.Modular_Amount_Dis_Incl_GST__c !=  OldoppList.Modular_Amount_Dis_Incl_GST__c ||
                        NewoppList.Site_Services_Amount_Dis_Incl_GST__c != OldoppList.Site_Services_Amount_Dis_Incl_GST__c||
                        NewoppList.Modular_discount__c != OldoppList.Modular_discount__c ||
                        NewoppList.Civil_discount__c != OldoppList.Civil_discount__c||
                        NewoppList.Channel__c != OldoppList.Channel__c ||
                        NewoppList.Modular_Milestone_Type__c != OldoppList.Modular_Milestone_Type__c ||
                        NewoppList.Signup_Amount__c != OldoppList.Signup_Amount__c ||
                        NewoppList.AccountId != OldoppList.AccountId ||
                        NewoppList.Design_User__r.Designer_Team__c != OldoppList.Design_User__r.Designer_Team__c ||
                        NewoppList.SalesManagerName__c != OldoppList.SalesManagerName__c ||
                        NewoppList.SalesManagerEmail__c != OldoppList.SalesManagerEmail__c ||
                        NewoppList.DesignerEmail__c != OldoppList.DesignerEmail__c ||
                        NewoppList.Design_User__r.Name != OldoppList.Design_User__r.Name) {
                            // Comment on 22 August 2024 by Muskan Jain, request by DD Team , will not being used in salesforce.
                            //RequestPaymentCreateProject.updateProjectOnOddo(NewoppList.id);
                        }
                }
            } 
    }
}