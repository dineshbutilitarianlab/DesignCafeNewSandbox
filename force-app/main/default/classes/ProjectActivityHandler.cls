/**
Created By - Jai Kumar
Created Date - 06/12/2019
Description - This class for Project Activity funcrionality.
*/

public class ProjectActivityHandler{
   public static void updateCustomerOnPAInsert(Map<Id, Milestone1_Milestone__c> recMapById){
        Set<Id> setOfProAcitvityId = new Set<Id>();
        List<Milestone1_Milestone__c> proAcivityListToUpdate=new  List<Milestone1_Milestone__c>();
        for(Milestone1_Milestone__c paObj : recMapById.values()){
            setOfProAcitvityId.add(paObj.Id);
        }  
        
        if(setOfProAcitvityId.size()>0){ 
            for(Milestone1_Milestone__c ptmObj :[select id,Project__r.Customer__r.personContactId from Milestone1_Milestone__c where id in: setOfProAcitvityId]){
                Milestone1_Milestone__c proActObj=new Milestone1_Milestone__c();
                proActObj.id=ptmObj.id;
                proActObj.Customer_Contact__c=ptmObj.Project__r.Customer__r.personContactId;
                proAcivityListToUpdate.add(proActObj);
            }
        }
        
        if(proAcivityListToUpdate.size()>0){
            update proAcivityListToUpdate;
        }
    }
    // Actual_Completion_Date greater then Plan end date then update Allchild milstone plan end date.
    public static void updateMilestonePlannedDate(Map<Id, Milestone1_Milestone__c> recMapById, Map<Id, Milestone1_Milestone__c> oldRecMapById) {
        
        system.debug('INNNNNNNNNNNNNNN');
        Set<Id> setOfProjectId                                          = new Set<Id>();
        List<Milestone1_Milestone__c> proMileStoneListToUpdate          = new List<Milestone1_Milestone__c>();
        Map<String, Milestone1_Milestone__c> mapOfOrderWithMilestone    = new Map<String, Milestone1_Milestone__c>();
        LIST<Milestone1_Project__c> projsToUpdate                       = new LIST<Milestone1_Project__c>();
        
        for(Milestone1_Milestone__c milObj : recMapById.values()) {
            Milestone1_Milestone__c lOldRec = oldRecMapById.get(milObj.id);
            
            if(milObj.Deadline__c !=null && lOldRec != null) {
                if(milObj.Complete__c && milObj.Actual_Completion_Date__c != null && milObj.Actual_Completion_Date__c != lOldRec.Actual_Completion_Date__c) {
                    if(milObj.Actual_Completion_Date__c > milObj.Deadline__c) {
                        setOfProjectId.add(milObj.Project__c);
                    }
                }
                
                if(milObj.Deadline__c != lOldRec.Deadline__c && milObj.Kickoff__c == lOldRec.Kickoff__c) {
                    setOfProjectId.add(milObj.Project__c);
                }
            }
        }
        
        if(setOfProjectId.size() == 0) {
          return;    
        }
        MAP<Id,Milestone1_Project__c> projectsMap   = new MAP<ID,Milestone1_Project__c>([select id,name,Survey_Date__c,KYC_Date__c,Design_Finalization_Date__c,First_Cut_Presentation_Date__c,X3D_Presentation_Date__c,Kickoff_Meeting_Date__c
                                                                                        from Milestone1_Project__c where id IN: setOfProjectId]);
        
        for(Milestone1_Milestone__c milObj : [SELECT id, Deadline__c,Type__c, Kickoff__c, Project__c, Order__c,Project__r.Kickoff__c,Relative_Deadline_in_days__c FROM Milestone1_Milestone__c WHERE Project__c IN:setOfProjectId]) {
            if(milObj.Order__c != null && milObj.Order__c > 0) {
                mapOfOrderWithMilestone.put(String.valueOf(milObj.Project__c ) + String.valueOf(milObj.Order__c), milObj);
            }
        }
        
        for(Milestone1_Milestone__c milObj : recMapById.values()) {
            Milestone1_Milestone__c lOldRec = oldRecMapById.get(milObj.id);
            
            if(lOldRec != null) {
                if(milObj.Complete__c && milObj.Actual_Completion_Date__c != null && milObj.Actual_Completion_Date__c != lOldRec.Actual_Completion_Date__c) {
                    if(milObj.Deadline__c != null && milObj.Actual_Completion_Date__c > milObj.Deadline__c) {
                        Integer numberOfDays = 0;
                        
                        //if(lOldRec.Actual_Completion_Date__c == null) {
                            numberOfDays = integer.valueOf(milObj.Delay_in_Activity_Completion__c); 
                        //}
                        //else {
                        //    numberOfDays = date.valueOf(lOldRec.Actual_Completion_Date__c).daysBetween(date.valueOf(milObj.Actual_Completion_Date__c));
                       // }
                        if(numberOfDays > 0 && milObj != null && milObj.Order__c != null && mapOfOrderWithMilestone != null){
                            system.debug('No Of Days' + numberOfDays);
                            proMileStoneListToUpdate = updateMilstonePlanDateFromProject(numberOfDays, milObj.Order__c, milObj, mapOfOrderWithMilestone);
                        }
                    }
                }
                else {
                    if(ProjectTriggerRecursiveHandler.isFirstTimePlanEndDate) {
                        if(milObj.Type__c == 'Site Survey' || milObj.Type__c == 'KYC' || milObj.Type__c == 'First Cut Presentation' || 
                           milObj.Type__c == '3D Presentation' || milObj.Type__c == 'Kickoff Meeting with PM' || milObj.Type__c == 'Design Finalization') {
                            if(milObj.Deadline__c != null && milObj.Deadline__c != lOldRec.Deadline__c && milObj.Kickoff__c == lOldRec.Kickoff__c) {
                                Integer numberOfDays = lOldRec.Deadline__c.daysBetween(date.valueOf(milObj.Deadline__c));
                                if(numberOfDays > 0){
                                    proMileStoneListToUpdate = updateMilstonePlanDateFromProject(numberOfDays, milObj.Order__c, milObj, mapOfOrderWithMilestone);
                                }
                                ProjectTriggerRecursiveHandler.isFirstTimePlanEndDate = false;
                                system.debug(proMileStoneListToUpdate);
                            }
                        }
                    }
                }
            }
        }
        
        if(proMileStoneListToUpdate.size() > 0) {
            ProjectTriggerRecursiveHandler.isFirstTime = false;
            update proMileStoneListToUpdate;
            system.debug('########');
            system.debug(proMileStoneListToUpdate);
            for(Milestone1_Milestone__c eachMili : proMileStoneListToUpdate){
                if(eachMili.Project__c != null && projectsMap.get(eachMili.Project__c) != null) {
                    DateTime dateInstance = eachMili.Deadline__c != null ? DateTime.newInstance(eachMili.Deadline__c, Time.newInstance(10, 0, 0, 0)) : null;
                    if(eachMili.Type__c == 'Site Survey'){ 
                        projectsMap.get(eachMili.Project__c).Survey_Date__c                     = dateInstance;
                        //projsToUpdate.add(projectsMap.get(eachMili.Project__c)) ;
                    }if(eachMili.Type__c == 'KYC'){
                        projectsMap.get(eachMili.Project__c).KYC_Date__c                        = dateInstance;
                        
                    }if(eachMili.Type__c ==  'First Cut Presentation'){
                        projectsMap.get(eachMili.Project__c).First_Cut_Presentation_Date__c     = dateInstance;
                        
                        
                    }if(eachMili.Type__c ==  '3D Presentation'){
                        projectsMap.get(eachMili.Project__c).X3D_Presentation_Date__c           = dateInstance;
                                               
                    }if(eachMili.Type__c ==  'Kickoff Meeting with PM'){
                        projectsMap.get(eachMili.Project__c).Kickoff_Meeting_Date__c            = dateInstance;
                        
                    }if(eachMili.Type__c ==  'Design Finalization') {
                        projectsMap.get(eachMili.Project__c).Design_Finalization_Date__c        = dateInstance;
                        
                    }
                }
                system.debug(projectsMap);
            }  
        }
        if(projectsMap.size() > 0 && projectsMap != null){
            system.debug('---------');
            system.debug(projectsMap);
            
            update projectsMap.values();            
        }
    }
    
    public static List<Milestone1_Milestone__c> updateMilstonePlanDateFromProject(Integer numberOfDays, Decimal orderNum, Milestone1_Milestone__c milObj, 
                                                                                  Map<String, Milestone1_Milestone__c> mapOfOrderWithMilestone) {
        List<Milestone1_Milestone__c> proMileStoneListToUpdate=new  List<Milestone1_Milestone__c>();
        
        if(orderNum != null) {
            Integer orderNo = integer.valueOf(orderNum) + 1;
            
            for(Integer i=orderNo; i <= mapOfOrderWithMilestone.size(); i++) {
                if(mapOfOrderWithMilestone.size() > 0) {
                    if(milObj.Project__c != null && mapOfOrderWithMilestone.containsKey(String.valueOf(milObj.Project__c ) + String.valueOf(i))) {
                        Milestone1_Milestone__c milStone            = mapOfOrderWithMilestone.get(String.valueOf(milObj.Project__c ) + String.valueOf(i));
                        //milStone.id                                 = mapOfOrderWithMilestone.get(String.valueOf(milObj.Project__c ) + String.valueOf(i)).id;
                       //milStone.Type__c                           = mapOfOrderWithMilestone.get(String.valueOf(milObj.Project__c ) + String.valueOf(i)).Type__c;
                        //milStone.Project__c                       = mapOfOrderWithMilestone.get(String.valueOf(milObj.Project__c ) + String.valueOf(i)).Project__c;
                        milStone.Deadline__c                        = mapOfOrderWithMilestone.get(String.valueOf(milObj.Project__c ) + String.valueOf(i)).Project__r.Kickoff__c.addDays(numberOfDays+Integer.valueOf(mapOfOrderWithMilestone.get(String.valueOf(milObj.Project__c ) + String.valueOf(i)).Relative_Deadline_in_days__c));
                        //milStone.Deadline__c                      = mapOfOrderWithMilestone.get(String.valueOf(milObj.Project__c ) + String.valueOf(i)).Deadline__c.addDays(numberOfDays);
                        //milStone.Kickoff__c                       = mapOfOrderWithMilestone.get(String.valueOf(milObj.Project__c ) + String.valueOf(i)).Kickoff__c.addDays(numberOfDays);
                        proMileStoneListToUpdate.add(milStone); 
                   
                    }
                }
            }
        }
        
        return proMileStoneListToUpdate;    
    }
}