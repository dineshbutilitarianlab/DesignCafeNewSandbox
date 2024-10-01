public class TaskTrigger_Handler {
    @TestVisible static DateTime todayDateTime      = System.now();
    public static void updateReminderTime(Map<Id,Task> allNewTasksMap , Map<Id,Task> allOldTasksMap){
        List<Task> listOfTaskToUpdate               = new List<Task>();
        List<Lead> listOfLeadToUpdate               = new List<Lead>();
        Set<Id> allLeadIds                          = new Set<Id>();
        DateTime nxtDateTime                        = todayDateTime;
        Integer count                               = 0;
        
        for(Task eachTask : allNewTasksMap.values()){
         if(eachTask.WhoId!=null){//By Ranveer 5/12/2019.
            if(eachTask.WhoId.getSObjectType().getDescribe().getName().equalsIgnoreCase('Lead')){
                allLeadIds.add(eachTask.whoId);
            }
         }   
        }
        if(allLeadIds.size() > 0){
            MAP<Id,Lead> allLeadsMap                    = LeadTrigger_Model.queryLeads(allLeadIds);
        
                system.debug(allNewTasksMap.keySet());
                for(Id taskId : allNewTasksMap.keySet()){
                   Lead currentLead                                             = allLeadsMap.get(allNewTasksMap.get(taskId).whoId);
                   
                   if(allNewTasksMap.get(taskId).Status != allOldTasksMap.get(taskId).Status && allNewTasksMap.get(taskId).Status == DesignCafeConstants.TASK_STATUS_COMPLETED 
                            && currentLead != null && currentLead.DC_Lead_Status__c == DesignCafeConstants.LEADSTAGE_NORESPONSE ){
                       if(allNewTasksMap.get(taskId).whoId != null && currentLead != null && currentLead.Follow_Up_Count__c < 9){
                           
                           count                                                = math.mod(Integer.valueOf(currentLead.Follow_Up_Count__c),3);
                           allNewTasksMap.get(taskId).ActivityDate              = getNextFollowupTime( nxtDateTime , count).date();
                           allNewTasksMap.get(taskId).Due_Date_Time__c          = getNextFollowupTime( nxtDateTime , count);
                           allNewTasksMap.get(taskId).Status                    = DesignCafeConstants.TASK_STATUS_OPEN;
                           allNewTasksMap.get(taskId).ReminderDateTime          = getNextFollowupTime( nxtDateTime , count);
                           allNewTasksMap.get(taskId).IsReminderSet             = true;
                           allNewTasksMap.get(taskId).Description               = allNewTasksMap.get(taskId).Description + '\n The Follow Up Task: '+currentLead.Follow_Up_Count__c+ ' was completed. Re-opening task for Follow Up:'+(currentLead.Follow_Up_Count__c+1);
                           listOfTaskToUpdate.add(allNewTasksMap.get(taskId));
                           
                           currentLead.Follow_Up_Date_Time__c                   = getNextFollowupTime( nxtDateTime , count);
                           currentLead.Follow_Up_Count__c++;
                           listOfLeadToUpdate.add(currentLead);
                       }
                       else if(allNewTasksMap.get(taskId).whoId != null && currentLead != null && currentLead.Follow_Up_Count__c == 9){
                           currentLead.Status                                       = DesignCafeConstants.STATUS_JUNK;
                           currentLead.DC_Lead_Status__c                            = DesignCafeConstants.LEADSTAGE_DEAD;
                           currentLead.Call_Stage__c                                = DesignCafeConstants.CALLSTAGE_ATTEMPTSDONE;
                           listOfLeadToUpdate.add(currentLead);
                       }
                   }
               }
               if(listOfTaskToUpdate.size() > 0){
                    //insert listOfTaskToUpdate;
                }
                
                if(listOfLeadToUpdate.size() > 0){
                    update listOfLeadToUpdate;
                } 
            }
    }
    
    
    // ------------------------
    public static void  timeStampsOfCallUpadteOnLead(List < Task >  allNewTasks){
        List<Lead> listOfLeadToUpdate               = new List<Lead>();
        Set<Id> allLeadIds                          = new Set<Id>();
        
        for(Task eachTask : allNewTasks){
            if(eachTask.CallDurationInSeconds > 0 && (eachTask.CallType == 'Inbound' || eachTask.CallType =='Outbound') && eachTask.WhoId.getSObjectType().getDescribe().getName().equalsIgnoreCase('Lead')){
                 allLeadIds.add(eachTask.whoId);
            }
        }
        MAP<Id,Lead> allLeadsMap                    = LeadTrigger_Model.queryLeads(allLeadIds);
        
        if(allLeadsMap.values() != null){
            for(Lead eachLead : allLeadsMap.values()){
                system.debug(eachLEad);
                if(eachLead.First_Date_of_Contact__c == null){
                    eachLead.First_Date_of_Contact__c = todayDateTime.date();
                    listOfLeadToUpdate.add(eachLead);
                }
                else if(eachLead.Second_Date_of_Contact__c == null){
                    eachLead.Second_Date_of_Contact__c = todayDateTime.date();
                    listOfLeadToUpdate.add(eachLead);
                }
                else if(eachLead.Third_Date_of_Contact__c == null){
                    eachLead.Third_Date_of_Contact__c = todayDateTime.date();
                    listOfLeadToUpdate.add(eachLead);
                }
                else if(eachLead.Fourth_Date_of_Contact__c == null){
                    eachLead.Fourth_Date_of_Contact__c = todayDateTime.date();
                    listOfLeadToUpdate.add(eachLead);
                }
            }
            if(listOfLeadToUpdate.size() > 0){
                update listOfLeadToUpdate;
            }
        }
    }
    
    
    //----------------------Next Followup time generator
    public static DateTime getNextFollowupTime(DateTime currentTime , Integer randomCount){
        Integer WORKING_HOUR_START                  = Integer.valueOf(Design_Cafe_Settings__c.getOrgDefaults().Working_Hour_Start_Time__c);
        Integer WORKING_HOUR_END                    = Integer.valueOf(Design_Cafe_Settings__c.getOrgDefaults().Working_Hour_End_Time__c);
        DateTime dt2 = currentTime.addHours(3);
        if(dt2.hour() <= WORKING_HOUR_END && dt2.hour() >= WORKING_HOUR_START){
            system.debug(dt2);
            return dt2;
        }
        else {            
            DateTime myDateTime = todayDateTime;
            if(!test.isrunningtest()){
                myDateTime = DateTime.newInstance(currentTime.year(), currentTime.month(), currentTime.day() + 1, WORKING_HOUR_START + 1 + randomCount ,0, 0);
            }
            return myDateTime;
        }
    }
    
    
    //------------------------ Update lead's phone and channel when task insert.
    public static void  updateLeadfieldInsertTask(List < Task >  allNewTasks){
      Set<Id> setofLeadId=new Set<Id>();
      List<Lead> listOfLeadToUpdate=new  List<Lead>();
      
      for(Task tskObj : allNewTasks){
          if(tskObj.WhoId!=null){
              if(tskObj.CallType=='Inbound' && tskObj.Status=='Completed'){
                 setofLeadId.add(tskObj.WhoId);
               }
          }
      }
        system.debug('In To');
      for(Lead leadObj: [select id,Phone from Lead where id in: setofLeadId]){
           Lead ledObjt =new Lead();
           ledObjt.id=leadObj.id;
           ledObjt.MobilePhone=leadObj.Phone;
           ledObjt.Channel__c='Online';
           listOfLeadToUpdate.add(ledObjt);
       }
      if(listOfLeadToUpdate.size()>0){
        update listOfLeadToUpdate;
      } 
    }
    
    
    //------------------------ Update lead phone and channel when task update.
    public static void  updateLeadfieldUpdateTask(List < Task >  allNewTasks, Map<Id,Task> oldTasksMap){
      Set<Id> setofLeadId=new Set<Id>();
      List<Lead> listOfLeadToUpdate=new  List<Lead>();
      
      for(Task tskObj : allNewTasks){
          if(tskObj.WhoId!=null){
              if(tskObj.CallType=='Inbound' && tskObj.Status=='Completed' && 
                 ((oldTasksMap.get(tskObj.id).Status!=tskObj.Status) || (oldTasksMap.get(tskObj.id).CallType!=tskObj.CallType))){
                 setofLeadId.add(tskObj.WhoId);
               }
          }
      }
      for(Lead leadObj: [select id,Phone from Lead where id in: setofLeadId]){
           Lead ledObjt =new Lead();
           ledObjt.id=leadObj.id;
           ledObjt.MobilePhone=leadObj.Phone;
           ledObjt.Channel__c='Online';
           listOfLeadToUpdate.add(ledObjt);
       }
      if(listOfLeadToUpdate.size()>0){
        update listOfLeadToUpdate;
      } 
    }
}