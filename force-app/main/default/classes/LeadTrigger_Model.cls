public class LeadTrigger_Model {

    public static MAP<Id,User> queryUsers(Set<String> groupNames){
        return new MAP<Id,User>([Select id,name,Region__c,team__c,UserNumber2__c  from User where IsActive=true And id in (Select userOrGroupId from groupmember where group.Name in:groupNames)]); //AND lastlogindate =: System.Today()]);
    }
   
    
    public static MAP<String ,Account> queryAccountsByRefereeCode(SET<String> refereeCodes , String recordTypeName){
        MAP<String,Account> mapRefereeCodeToAcc         =  new MAP<String,Account>();
        Id redTypeID                                    = Schema.SObjectType.Account.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
        LIST<Account> employeeRecs                      = [Select id,name,Referee_Code_DC__c from Account where Referee_Code_DC__c IN : refereeCodes and RecordTypeId =: redTypeID ];
        for(Account each :employeeRecs ){
            mapRefereeCodeToAcc.put(each.Referee_Code_DC__c , each);
        }
        return mapRefereeCodeToAcc;
    }
    
     public static MAP<Id ,Lead> queryLeads(SET<Id> leadIds){
        return new MAP<Id,Lead>([select id,name,DC_Lead_Status__c,Follow_Up_Date_Time__c,Follow_Up_Count__c,First_Date_of_Contact__c,Second_Date_of_Contact__c,Third_Date_of_Contact__c,Fourth_Date_of_Contact__c from Lead where Id IN: leadIds]);
         
     }
     
     
     public static MAP<Id ,LIST<Task>> queryOpenTasks(SET<Id> leadIds){
        MAP<Id ,LIST<Task>> mapOfLeadToTasks = new MAP<Id ,LIST<Task>>();
        LIST<Task> listOfTasks = new LIST<Task>();
        for(Task each : [select id,whoId,IsReminderSet,Status from Task where whoId IN: leadIds AND IsReminderSet = true AND Status =: DesignCafeConstants.TASK_STATUS_OPEN ]){
            listOfTasks = new LIST<Task>();
            if(mapOfLeadToTasks.get(each.whoId) != null){
                listOfTasks = mapOfLeadToTasks.get(each.whoId);
            }
            listOfTasks.add(each);
            mapOfLeadToTasks.put(each.whoId , listOfTasks);
        }
        return mapOfLeadToTasks;
     } 
}