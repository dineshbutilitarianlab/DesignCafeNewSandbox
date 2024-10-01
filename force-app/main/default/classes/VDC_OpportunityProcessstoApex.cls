/*
* Code Development : V-Fory Team
* Modified Date    : 16th August 2021
* Developer        : Vineesha
*/
public class VDC_OpportunityProcessstoApex {
    public static void ownerchange(List<opportunity> NewOpps,map<id,opportunity> OldMap,boolean Isinsert){
        list<Account> UpdateAcc = new list<Account>();
        Map<id,Account> AccOppMap = New Map<Id,Account>(); 
        Set<Id> accountIds = new Set<Id>();
        Map<Id,Account> accountMap ;
        for (Opportunity Opp : NewOpps) {
            if (String.isNotBlank(Opp.AccountId)) {
                accountIds.add(Opp.AccountId);
            }
        }
        accountMap = new Map<Id, Account>([select id,For_Promotion__c from Account where id in: accountIds]);
        for(Opportunity Opp: NewOpps){
            if (accountMap.containsKey(Opp.AccountId)) {
                AccOppMap.put(Opp.Id,accountMap.get(Opp.AccountId));
            }
        }
        for(Opportunity Opp: NewOpps){
            //start of process builder -- Update Site Condition
            if(Opp.The_Doors_Windows_are_installed_Requir__c && !Opp.Frames_for_all_external_Doors_Windows__c){
                Opp.Frames_for_all_external_Doors_Windows__c = true;
            }
            if(Opp.Putty_and_1_coat_of_plastering_Required__c && !Opp.All_walls_are_completed_Required__c){
                Opp.All_walls_are_completed_Required__c = true;
            }
            if(Opp.Flooring_is_completed_Required__c && !Opp.Floors_are_levelled_out_prepped_Basic__c){
                Opp.Floors_are_levelled_out_prepped_Basic__c = true;
            }
            //end of process builder--Update Site Condition
            // ------------------------------------------//
            //Mark for Promotion on Opty Closed Lost -- workflow
            if(Isinsert){
                if(Opp.StageName == 'Closed Lost'){
                    Account Acc = AccOppMap.get(Opp.Id); Acc.For_Promotion__c = true;
                    UpdateAcc.add(Acc);
                }
                //Proposal stage update -- workflow
                /*if(Opp.Proposal_Sent_Date__c != null){
                    Opp.StageName = 'Proposal Sent';
                }*/
                //Update DSA email in opportunity -- workflow
                if(Opp.DSA_Email__c == null){
                    Opp.DSA_Email__c = Opp.DSA__r.Acc_Email__c;
                }
            }
            if(!Isinsert){
                if(Opp.StageName == 'Closed Lost' && OldMap.get(Opp.Id).StageName != 'Closed Lost'){
                    Account Acc = AccOppMap.get(Opp.Id); Acc.For_Promotion__c = true;
                    UpdateAcc.add(Acc);
                }
                //Proposal stage update -- workflow
                /*if(Opp.Proposal_Sent_Date__c != null && OldMap.get(Opp.Id).Proposal_Sent_Date__c == null){
                    Opp.StageName = 'Proposal Sent';
                }*/
                //Update DSA email in opportunity -- workflow
                if(Opp.DSA_Email__c == null && OldMap.get(Opp.Id).DSA_Email__c != null){
                    Opp.DSA_Email__c = Opp.DSA__r.Acc_Email__c;
                }
            }
            
        }
        If(UpdateAcc.size()>0){ 
            Update UpdateAcc;
        }
    }
}