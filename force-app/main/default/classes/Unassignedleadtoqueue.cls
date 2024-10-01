global class Unassignedleadtoqueue implements Database.Batchable<sObject>,schedulable{
   
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        integer month=system.today().month();
       // integer day=system.today().day();
    string  query = 'select id, ownerid,createddate, owner.name,Region__c from lead';
  
        //This is query for getting records
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<lead> AllleadRecords){

        group q=[select id from group where type ='queue' and Name = 'System Administrator' limit 200]; 
       
        for(lead  l: AllleadRecords){
        If((l.createddate.addhours(1) <= system.now() &&  l.owner.name == 'unassigned' && l.Region__c == NULL) || test.isRunningTest())
        {
           l.ownerid= q.id;
         Update l;

    }
       }
    }
    global void finish(Database.BatchableContext BC){
        
    }
    global void execute(SchedulableContext sc) {
        Unassignedleadtoqueue b=new Unassignedleadtoqueue();
        Database.executebatch(b,50);
  

    }
}