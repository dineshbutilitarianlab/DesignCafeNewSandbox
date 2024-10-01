global class LeadActivityBatchClass implements database.Batchable<sobject>,schedulable{
    
    global Database.queryLocator start(Database.BatchableContext bc){
     String RecordUrl = '';
  
        Datetime Response = System.now().addhours(-24);
//      Datetime Response = System.now().addhours(-1);
        String query ='SELECT Id,Delay_in_response__c,Status,DC_Lead_Status__c,Lead_Response_time_by_SM__c,(select id,Disposition_Type__c from Tasks where Disposition_Type__c !=:RecordUrl) FROM Lead where Lead_Response_time_by_SM__c >:Response';
       
        return Database.getQueryLocator(query); // you can modify the query as per your requirement.
    }
    
    
    global void execute (Database.BatchableContext BC, List<Lead> ldList){
        List<Lead> leadlist = new list<lead>();
         System.debug('leadlist: '+leadlist);
        For(lead ld:ldlist){
            //&& ld.Lead_Response_time_by_SM__c.hour() == system.now().hour() && ld.Lead_Response_time_by_SM__c.day() == system.today().adddays(-1).day()    
           //     If(ld.tasks.size()== 0 && ld.Lead_Response_time_by_SM__c <= System.now() && ld.Lead_Response_time_by_SM__c.hour() >= system.now().hour() ){
         //If(ld.tasks.size()== 0 && ld.Delay_in_response__c==false && ld.Lead_Response_time_by_SM__c <= System.now() ){
		//If(ld.tasks.size()== 0 && ld.Delay_in_response__c==false){
		If(ld.tasks.size()== 0){
                      leadlist.add(ld);
                }
                
          }   
           update leadlist;
    }            
    
    global void finish(Database.BatchableContext BC){      
        
    }
    global void execute(SchedulableContext sc) {
        LeadActivityBatchClass b1 = new LeadActivityBatchClass();
        ID batchprocessid = Database.executeBatch(b1,200);   
        
    }  
}