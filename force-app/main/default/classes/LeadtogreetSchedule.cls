global class LeadtogreetSchedule implements Schedulable {
    
    global void execute(SchedulableContext sc) {
        LeadtogreetBatch ltgBatch = new LeadtogreetBatch(); 
        Database.executeBatch(ltgBatch);
    }

}