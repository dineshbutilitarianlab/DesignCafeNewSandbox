/**
Created By - Jai Kumar
Created Date - 05/12/2019
Description - This class for Task functionality.
*/

public class TaskHandler{
    // method for create Task.
    public static void createTask( Map<Id, Milestone1_Milestone__c> recMapById){
        List<Task> taskList=new List<Task>();
        
        for(Milestone1_Milestone__c milObj : recMapById.values()) {
            if(milObj.Deadline__c == null || milObj.Assign_To__c == null) {
                continue;
            }
            
            Task taskObj=createTaskRecord(milObj);
            taskList.add(taskObj);
        }
        
        if(taskList.size()>0){
            insert taskList;
        }
    }
    // method for Update Task.  
    public static void updateTask( Map<Id, Milestone1_Milestone__c> recMapById,Map<Id,Milestone1_Milestone__c> objprojectActivityMap){
        Set<Id> projectActivityId=new  Set<Id>();
        List<Task> taskList=new List<Task>();
        
        for(Milestone1_Milestone__c milObj : recMapById.values()){
            if((milObj.Deadline__c!=objprojectActivityMap.get(milObj.id).Deadline__c && milObj.Deadline__c!=null)
               ||(milObj.Assign_To__c!=objprojectActivityMap.get(milObj.id).Assign_To__c) ){
                   projectActivityId.add(milObj.id);
               }
        }
        
        if(projectActivityId.size() > 0) {
            map<String,task> mapofProjectIdWithTask = new map<String,task>();
            for(task tk : [select id,whatId from task where whatId in:projectActivityId and Status != 'Completed']){
                mapofProjectIdWithTask.put(tk.WhatId,tk);
            }
            for(Milestone1_Milestone__c milsObj: [select id,Deadline__c,Assign_To__c,Name, Complete__c from Milestone1_Milestone__c where id in:projectActivityId]){
                if(mapofProjectIdWithTask.keyset().contains(milsObj.id)) { 
                    
                    if(milsObj.Assign_To__c != null) {
                        Task taskObj=new Task();
                        taskObj.id=mapofProjectIdWithTask.get(milsObj.id).id;
                        taskObj.WhatId=milsObj.id;
                        taskObj.ActivityDate=milsObj.Deadline__c;
                        taskObj.ReminderDateTime=milsObj.Deadline__c.addDays(-1);
                        taskObj.OwnerId = milsObj.Assign_To__c;
                        taskList.add(taskObj);
                    }
                    
                }
                else {
                    if(milsObj.Assign_To__c != null){
                        Task taskObj = createTaskRecord(milsObj);
                        taskList.add(taskObj);
                    }
                    
                }
            }
            
            if(taskList.size() > 0) {
                Database.upsert(taskList, false);
            }
        }
    }
    // method for create task record.
    public static Task createTaskRecord(Milestone1_Milestone__c milsObj){
        Task taskObj=new Task();
        taskObj.ActivityDate=milsObj.Deadline__c;
        taskObj.WhatId=milsObj.id;
        taskObj.Subject=milsObj.Name;
        taskObj.IsReminderSet=true;
        
		if(milsObj.Complete__c == false) {
           taskObj.Status = 'On Hold'; 
        }
        else{
            taskObj.Status = 'Open';
		}
	
        taskObj.ReminderDateTime=milsObj.Deadline__c.addDays(-1);
		
        if(milsObj.Assign_To__c != null) {
            taskObj.OwnerId=milsObj.Assign_To__c;
		}
		
        return taskObj;
    }
}