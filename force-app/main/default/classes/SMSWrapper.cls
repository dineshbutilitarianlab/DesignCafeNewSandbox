public class SMSWrapper {
    
    public String sender{get;set;}
    public String route{get;set;}
    public String country{get;set;}
    public LIST<SMSDetail> sms{get;set;}
    public SMSWrapper(String sender ,String route, String country, List<SMSDetail> sms){
        this.route      = route;
        this.sender     = sender;
        this.country    = country;
        this.sms        = sms;
        
    }
    
    public class SMSDetail{
        public String message{get;set;}
        public List<String> to{get;set;}
        public SMSDetail(String message , List<String> to){
            this.message    = message;
            this.to         = to;
        }
    }
}