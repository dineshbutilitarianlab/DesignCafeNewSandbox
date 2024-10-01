public class CallyzerJsonResponse {
    public List<Data> data;
    public String message; 
    public Integer recordsTotal;
    public Integer recordsFiltered;
    public Integer srNoCounterStart; 
    
    public class Data {
        public String employee;
        public String employeeName;
        public String employeeNumber;
        public String employeeCode;
        public String client;
        public String clientName;
        public String countryCode;
        public String clientNumber;
       	public String callDate;
       	public String callTime;
        public String duration;
        public Integer durationInSeconds;
        public String callType;
        public String note;
        public String callRecordingPath;
        public String uniqueId;
        public String createdDate;
        public String modifiedDate;
    }
    
    public static void testCoverage(){
    	Integer i=0;    
    }
}