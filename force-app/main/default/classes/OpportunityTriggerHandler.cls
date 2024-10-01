/*
Developer : Ankit Soni 
Created Date : 14 OCT 2019
Description : Handle opportunity Trigger on different action. 
*/
public class OpportunityTriggerHandler {
        
    public static void handleOpportunityInsertTrigger( List<Opportunity> oppts){  
       opportunityTeamMemberWithDesigner(oppts);
     
    }

    public static void handleOpportunityUpdateTrigger( List<Opportunity> oppts,map<id,Opportunity> oldMap){
       opportunityTeamMemberWithDesignerUpdate(oppts,oldMap);
       
    }

    // public static void UpdateRemarsForSales(List<Opportunity> oppts) {
    //     List<Opportunity> oppList = new List<Opportunity>();
    //     for (Opportunity opporytunityRecord : oppts) {
    //         opporytunityRecord.Remarks_For_Marketing__c = opporytunityRecord.Offer_and_discounts__c;
    //         //String multiPicklistValues = opporytunityRecord.Offer_and_discounts__c;
    //         if (opporytunityRecord.Offer_and_discounts__c != null) {
    //             if ( String.isBlank(opporytunityRecord.Remarks_For_Marketing__c) ) {
    //                 opporytunityRecord.Remarks_For_Marketing__c = opporytunityRecord.Remarks_For_Marketing__c.replace(';', ',');
    //             } else {
    //                 String multiPicklistValues = opporytunityRecord.Remarks_For_Marketing__c.replace(';', ',');
    //                 opporytunityRecord.Remarks_For_Marketing__c = opporytunityRecord.Remarks_For_Marketing__c + ','+ multiPicklistValues;
    //             }
    //         }
            
    //         if (opporytunityRecord.Remarks_For_Marketing__c != null)
    //         {
    //             opporytunityRecord.Remarks_For_Marketing__c = opporytunityRecord.Remarks_For_Marketing__c.replace(';', ',');
    //         }else {
                
    //         }
    //     }
    // }
    
    public static void opportunityTeamMemberWithDesigner( List<Opportunity> oppts) {
        Set<Id> setOfOppId=new Set<Id>();
        List<OpportunityTeamMember> listOfOppTeamMember=new List<OpportunityTeamMember>();
        
        for(Opportunity opp : oppts) {
            if(opp.Designer__c !=null ) {
                setOfOppId.add(opp.id);
            }
        }
        
        for(Opportunity opp : [Select id, Designer__c,Designer__r.ManagerId,Designer__r.Manager.ManagerId from Opportunity where id in:setOfOppId]){
            OpportunityTeamMember oppTeamDesigner        =createOpportunityTeamMember(opp.id,opp.Designer__c,'Designer');
            OpportunityTeamMember oppTeamDesignerTL      =createOpportunityTeamMember(opp.id,opp.Designer__r.ManagerId ,'Design Team Lead');
            OpportunityTeamMember oppTeamDesignerManager =createOpportunityTeamMember(opp.id,opp.Designer__r.Manager.ManagerId,'Design Manager');
            listOfOppTeamMember.add(oppTeamDesigner);
            listOfOppTeamMember.add(oppTeamDesignerTL);
            listOfOppTeamMember.add(oppTeamDesignerManager);
        }
        system.debug('----$$$---'+listOfOppTeamMember);
        if(listOfOppTeamMember.size()>0) {
            Database.insert(listOfOppTeamMember,False);
        }
    }
    
    public static void opportunityTeamMemberWithDesignerUpdate( List<Opportunity> oppts,map<id,Opportunity> oldMap) {
        Set<Id> setOfOppId = new Set<Id>();
        Set<Id> setOfDeleteUserId = new Set<Id> ();
        Set<Id> setOfOldDesignerId = new Set<Id> ();
        List<OpportunityTeamMember> listOfOppTeamMember = new List<OpportunityTeamMember>(); 
        
        for(Opportunity opp : oppts) {
            if(opp.Designer__c != null && opp.Designer__c != oldMap.get(opp.id).Designer__c) {
                setOfOppId.add(opp.id);
                setOfOldDesignerId.add(oldMap.get(opp.id).Designer__c);
            }
        }
        
        for(Opportunity opp :[Select id, Designer__c,Designer__r.ManagerId,Designer__r.Manager.ManagerId from Opportunity where id in:setOfOppId]) {  
            OpportunityTeamMember oppTeamDesigner=createOpportunityTeamMember(opp.id,opp.Designer__c,'Designer');
            OpportunityTeamMember oppTeamDesignerTL=createOpportunityTeamMember(opp.id,opp.Designer__r.ManagerId ,'Design Team Lead');
            OpportunityTeamMember oppTeamDesignerManager =createOpportunityTeamMember(opp.id,opp.Designer__r.Manager.ManagerId,'Design Manager');
            listOfOppTeamMember.add(oppTeamDesigner);
            listOfOppTeamMember.add(oppTeamDesignerTL);            
            listOfOppTeamMember.add(oppTeamDesignerManager);
        }            
        
        List<OpportunityTeamMember> oppTeamMemnbrDeleteList=[Select id from OpportunityTeamMember where OpportunityId in: setOfOppId];
        
        if(oppTeamMemnbrDeleteList.size() > 0) {
            delete oppTeamMemnbrDeleteList;
        }
        
        if(listOfOppTeamMember.size() > 0) {
            Database.insert(listOfOppTeamMember,False);
        }
    }

    private static OpportunityTeamMember createOpportunityTeamMember( String oppId,String userId,String role) {
        OpportunityTeamMember oppTeam= new OpportunityTeamMember();
        oppTeam.TeamMemberRole=role;
        oppTeam.OpportunityId=oppId;
        oppTeam.UserId=userId;
        oppTeam.OpportunityAccessLevel='Edit';
        return oppTeam;
    }
    
    // ---------------------------------------TargetRevenue of Sales executive --- Sneha
  public static void getTargetRevenueOfSalesExecutive( List<Opportunity> oppts , MAP<Id,Opportunity> mapOldOptys , Boolean isInsertOperation){
        system.debug('In Target Revenue ---');
        Set<Id> setOfOwnerId = new Set<Id>();
        List<Opportunity> listOfOpptUpdate=new  List<Opportunity> ();
        Map<Id,List<Monthly_Target__c>> maoOfUserWithMonthlyTarget=new  Map<Id,List<Monthly_Target__c>>(); 
        
        Map<Integer,String> monthNameMap=new Map<Integer, String>{1 =>'January', 2=>'February', 3=>'March', 4=>'April', 5=>'May',
                                                                    6=>'June', 7=>'July', 8=>'August', 9=>'September',10=>'October',
                                                                    11=>'November', 12=>'December'};
           for(Opportunity opp : oppts) {
               if(opp.stageName == 'Closed Won' ){
                   setOfOwnerId.add(opp.OwnerId);                  
               }
           }
        if(setOfOwnerId != null){
           for(Monthly_Target__c monthObj: [select id,Month__c,Year__c ,User__c,Target_Revenue__c from Monthly_Target__c where User__c in:setOfOwnerId]){
               if(!maoOfUserWithMonthlyTarget.keyset().contains(monthObj.User__c)){
                    maoOfUserWithMonthlyTarget.put(monthObj.User__c,new list<Monthly_Target__c>());
                }
               
                maoOfUserWithMonthlyTarget.get(monthObj.User__c).add(monthObj);
                              
           }
        }
          for(Opportunity opp : oppts) { 
             
              	Decimal targetRevenue=0;
              	String targetRevenueId;
              	if( (isInsertOperation == true && opp.OwnerId!=null ) 
                     	|| (isInsertOperation == false && opp.OwnerId!=null 
                        		&& (opp.stagename != mapOldOptys.get(opp.Id).stagename || opp.OwnerId != mapOldOptys.get(opp.Id).OwnerId || opp.closeDate != mapOldOptys.get(opp.Id).closeDate))){
                      
                         if(opp.stageName == 'Closed Won' ){
                             Integer month           = opp.CloseDate.Month();
                             Integer year            = opp.CloseDate.Year();
                             String createdDtmonth   = monthNameMap.get(month);
                      
                             
                             if(maoOfUserWithMonthlyTarget != null && maoOfUserWithMonthlyTarget.containsKey(opp.OwnerId)){               
                                 for(Monthly_Target__c targetObj :maoOfUserWithMonthlyTarget.get(opp.OwnerId)){
                                     if(targetObj.Month__c==createdDtmonth && targetObj.Year__c==String.valueOf(year)){
                                         targetRevenue   =targetObj.Target_Revenue__c;
                                         targetRevenueId = targetObj.Id;
                                     }
                                 }
                             }
                         }
                         else{
                             targetRevenueId = null;
                         }
              
                      if(isInsertOperation == true){
                          Opportunity optyInst = new Opportunity();
                          optyInst.id = opp.id;
                          optyInst.Monthly_Target__c =  targetRevenueId;
                          listOfOpptUpdate.add(optyInst);
                      }else{
                       
                          opp.Monthly_Target__c =  targetRevenueId;
                      }
                  }
              }
        
              if(isInsertOperation == true && listOfOpptUpdate != null){
                  update listOfOpptUpdate;
              }
                 
       }
       
       // Rollup on Monthly Target

       public static void rollupSignUpAmontOnMonthlyTarget( List<Opportunity> newOpty, List<Opportunity> oldOpty , Boolean isUpdateDeleteOperation){
           
            Set<id> targetIds= new Set<id>();
            List<Monthly_Target__c> targetToUpdate= new List<Monthly_Target__c>();
        
            if(newOpty != null) {
                for (Opportunity item : newOpty){
                  targetIds.add(item.Monthly_Target__c);
                }
            }
      
            if (isUpdateDeleteOperation) {
                for (Opportunity item : oldOpty){
                    targetIds.add(item.Monthly_Target__c);
                }
            }
        
            // get a map of the shipments with the number of items
            Map<id,Monthly_Target__c> targetMap = new Map<id,Monthly_Target__c>([select id, name,Achieved_Revenue__c from Monthly_Target__c where id IN :targetIds]);
            Decimal revenue = 0;
            // query the shipments and the related inventory items and add the size of the inventory items to the shipment's items__c
            for (Monthly_Target__c tgt : [select Id, Name,(select id,Amount from Opportunities__r) from Monthly_Target__c where Id IN :targetIds]) {
                revenue = 0;
                for(Opportunity eachOpty : tgt.Opportunities__r){
                    revenue += (eachOpty.Amount != null ? eachOpty.Amount : 0);
                }
                system.debug(revenue);
                targetMap.get(tgt.Id).Achieved_Revenue__c = revenue ;
                targetToUpdate.add(targetMap.get(tgt.Id));
                system.debug(targetToUpdate);
            }
            if(targetToUpdate != null)
                update targetToUpdate;        
        }
       
       
    //----------- For Lead Conversion Tracking - Lead Trace Update -- Sneha
    public static void updateLeadTraceOnClosedWonOpty(Map<id, Opportunity> newMapOpty, Map<id, Opportunity> oldMapOpty) {
        System.debug('updateLeadTraceOnClosedWonOpty call || newMapOpty ==> ' + newMapOpty);
        Set<String> lOppIDSet = new Set<String>();
        Map<String, Lead_Trace__c> lOppIDToLeadTraceMap = new Map<String, Lead_Trace__c>();
        
        for(Opportunity lOpp : newMapOpty.values()) {
            Opportunity lOldOpp = oldMapOpty.get(lOpp.id);
            
            if(lOpp.StageName != lOldOpp.StageName && (lOpp.StageName == 'Closed Won' || lOldOpp.StageName == 'Closed Won')) {
                lOppIDSet.add(lOpp.Id);
            }
        }
        System.debug('lOppIDSet ==> ' + lOppIDSet);
        if(lOppIDSet.isEmpty()) {
            return;
        }
      
        Lead_Trace__c [] listToUpdate = new List<Lead_Trace__c>();
		
        for(Lead_Trace__c lLeadTrace : [SELECT id, Name, lead__c, Status__c, Opportunity__c, Tmestamp__c FROM Lead_Trace__c WHERE Opportunity__c IN:lOppIDSet]) {
			lOppIDToLeadTraceMap.put(lLeadTrace.Opportunity__c, lLeadTrace);
		}
		
        System.debug('lOppIDToLeadTraceMap ==> ' + lOppIDToLeadTraceMap);
        for(String lOppID : lOppIDSet) {
            Opportunity lOpp = newMapOpty.get(lOppID);
            Lead_Trace__c lLeadTrace = lOppIDToLeadTraceMap.get(lOppID);
            
            if(lLeadTrace == null) {
                lLeadTrace = new Lead_Trace__c(opportunity__c=lOppID);
            }
            
            if(lOpp.StageName == 'Closed Won') {
            	lLeadTrace.Status__c = 'Signed-up';
            }
            else {
                lLeadTrace.Status__c = 'Converted - Pending Sign-up';
            }
            
            lLeadTrace.Tmestamp__c = Date.today();
            listToUpdate.add(lLeadTrace);
        }
            
        System.debug('before if listToUpdate ' + listToUpdate);
        if(!listToUpdate.isEmpty()){
            System.debug('in if listToUpdate ==> ' + listToUpdate);
            upsert listToUpdate;
        }
    }
}