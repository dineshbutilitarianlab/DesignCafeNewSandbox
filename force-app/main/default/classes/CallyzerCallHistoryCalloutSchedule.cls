public class CallyzerCallHistoryCalloutSchedule implements Schedulable {
    
    public void execute(SchedulableContext ctx) {
    	CallyzerCallHistoryCalloutFuture.calloutCallyzerCallHistoryAPI();	
    }
    
}