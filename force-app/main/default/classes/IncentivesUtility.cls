public class IncentivesUtility {
    public static void createOpportunityIncentive(List<Opportunity> aNewOpps, Map<ID, Opportunity> aOldMap) {
        Set<Id> setOfOppId=new  Set<Id>();
        List<Incentive__c> incentiveList = new List<Incentive__c>(); 
        Incentive_Amount__c objAmount = Incentive_Amount__c.getValues('Lead Incentive');
        
        for(Opportunity opp : aNewOpps) {
            if(opp.StageName == 'Closed Won' && aOldMap.get(opp.id).StageName != 'Closed Won') {
                setOfOppId.add(opp.id);
            }
        }
        
        Map<ID, Incentive__c> lOppIDToIncentiveMap = new Map<ID, Incentive__c>();
        
        for(Incentive__c lIncentive : [SELECT id, Opportunity__c FROM Incentive__c where Opportunity__c in:setOfOppId]) {
            lOppIDToIncentiveMap.put(lIncentive.Opportunity__c, lIncentive);
        }
        
        for(Opportunity opp : aNewOpps) {
            if(opp.StageName == 'Closed Won' && aOldMap.get(opp.id).StageName != 'Closed Won') {
                if(!lOppIDToIncentiveMap.containsKey(opp.id) && opp.Designer__c != null) {
                    Incentive__c insObj=new Incentive__c();
                    insObj.Opportunity__c=opp.id;
                    insObj.Type__c='Lead Incentive'; 
                    insObj.Designer__c = opp.Designer__c;
                    insObj.OwnerId = opp.Designer__c;
                    insObj.Amount__c= objAmount.Lead_Incentive__c;
                    incentiveList.add(insObj);
                }
            }
        }
        
        if(incentiveList.size() > 0) {
            insert incentiveList;
        }
    }
    
    // Create Incentive if we Create Payment
    public static void createProjectIncentives(Set<ID> aMilestoneIDSet) {
        Set<Id> lPaymentIDSet = new Set<Id>();
        
        for(Milestone1_Milestone__c lMilestones : [SELECT id, (SELECT id FROM Payments__r) FROM Milestone1_Milestone__c WHERE id IN:aMilestoneIDSet]) {
            for(Payment__c lPayment : lMilestones.Payments__r) {
                lPaymentIDSet.add(lPayment.id);
            }
        }
        
        List<Incentive__c> incentiveList = new List<Incentive__c>();
        UserRole roleId = [SELECT Id, Name FROM UserRole where Name = 'Design Partner'];
        Incentive_Amount__c objAmount = Incentive_Amount__c.getValues('Project Incentive');
        
        for(Payment__c objPayment : [Select Id, Milestone__c, Amount__c, Milestone__r.Project__c, Milestone__r.Project__r.Designer__c, 
                                     Milestone__r.Project__r.Designer__r.UserRoleId FROM Payment__c WHERE Id IN:lPaymentIDSet]) {         
            if(roleId.Id == objPayment.Milestone__r.Project__r.Designer__r.UserRoleId) {
                if(objPayment.Amount__c != null && objPayment.Milestone__c!= null) {
                    Incentive__c insObj=new Incentive__c();
                    insObj.Project_Milestone__c = objPayment.Milestone__c;
                    insObj.Type__c='Project Incentive';
                    insObj.Project__c=objPayment.Milestone__r.Project__c;
                    insObj.Designer__c = objPayment.Milestone__r.Project__r.Designer__c;
                    insObj.Amount__c=((objPayment.Amount__c*objAmount.Project_Incentive__c) / 100);
                    incentiveList.add(insObj);
                }
            }
        }
        
        if(incentiveList.size() > 0) {
            insert incentiveList;
        }
    }
    
     public static void createProjectIncentivesForDesignPartners(List<Milestone1_Milestone__c> listOfMilestones) {
     
        
        List<Incentive__c> incentiveList = new List<Incentive__c>();
        UserRole roleId = [SELECT Id, Name FROM UserRole where Name = 'Design Partner'];
      
        
        for(Milestone1_Milestone__c miletsone : [Select Id,   Project__c,Achieved_Revenue__c, Project__r.Designer__c, 
                                     Project__r.Designer__r.UserRoleId FROM Milestone1_Milestone__c WHERE Id =:listOfMilestones]) {         
            if(roleId.Id == miletsone.Project__r.Designer__r.UserRoleId) {
                if(miletsone.Achieved_Revenue__c != null ) {
                    Incentive__c insObj=new Incentive__c();
                    insObj.Project_Milestone__c = miletsone.Id;
                    insObj.Type__c='Project Incentive';
                    insObj.Project__c= miletsone.Project__c;
                    insObj.Designer__c = miletsone.Project__r.Designer__c;
                    system.debug('acheived revenue in milestone'+miletsone.Achieved_Revenue__c);
                   insObj.Amount__c = ((miletsone.Achieved_Revenue__c*6) / 100);
                    system.debug('project incentive'+ insObj.Amount__c);
                    incentiveList.add(insObj);
                }
            }
        }
        
        if(incentiveList.size() > 0) {
            insert incentiveList;
        }
    }
    
}