public class LeadAllocationSchedule implements Schedulable{
    public void execute(SchedulableContext sc) {
		Database.executeBatch(New LeadAllocationBatch());
     }
}