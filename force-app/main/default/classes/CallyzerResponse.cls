public class CallyzerResponse {
    public List<Data> data{get;set;}
    public String message{get;set;}
    public Integer recordsTotal{get;set;}
    public Integer recordsFiltered{get;set;}
    public Integer srNoCounterStart{get;set;}

    public class Data {
        //public String employee{get;set;}
        public String employeeName{get;set;}
        public String employeeNumber{get;set;}
        public String employeeCode{get;set;}
        //public String client{get;set;}
        public String clientName{get;set;}
       // public String countryCode{get;set;}
        public String clientNumber{get;set;}
       //public String callDate { get { return date; } set { date = value; } }
    	//public String callTime { get { return time; } set { time = value; } }

        public String callDate{get;set;}
        public String callTime{get;set;}
        public String duration{get;set;}
        public Integer durationInSeconds{get;set;}
        public String callType{get;set;}
        //public String note{get;set;}
        public String callRecordingPath{get;set;}
        public String uniqueId{get;set;}
       // public String createdDate{get;set;}
        //public String modifiedDate{get;set;}
    }
}