public class CallCenterAPI{
    public CallCenterAPI(){
        
    }
}
/*
public class CallCenterAPI {
    @future(callout=true)
    public static void basicAuthCallout(String LeadId){
        String regionId;
        //Lead l = [select id,MobilePhone,Region__c,Is_Bulk_Upload__c,City, CreatedBy.Profile.Name from Lead Where id=: leadId LIMIT 1];
        Lead l = [select id,MobilePhone,Region__c,DC_Lead_Source__c,Is_Bulk_Upload__c,City, Channel__c, Source__c,Property_Possession_Date__c,Source_Journey__c,Email, Name, CreatedBy.Profile.Name, CreatedDate from Lead Where id=: leadId LIMIT 1];
        //System.debug(l);       
        {
            if(l.Region__c == 'BENGALURU' || l.City =='BENGALURU' ){
                regionId = '88888222';
            }
            if(l.Region__c =='MUMBAI' || l.City == 'MUMBAI'){
                regionId = '88888111';
            }
            if(l.Region__c == 'HYDERABAD' || l.City == 'HYDERABAD' ){
                regionId = '88888333';
            }
            //String toSend = 'http://103.252.26.62/vicidial/non_agent_api.php?source=fromsealseforce&user=api_user&pass=qBcRmu7AlBq67dkX&function=add_lead&';
            //toSend = toSend+'list_id='+regionId+'&add_to_hopper=Y&phone_number='+l.MobilePhone+'&vendor_lead_code='+l.id+'&address2='+l.id;
            //String toSend = 'http://alma-blr.connectionsdirect.in/vicidial/non_agent_api.php?source=fromsealseforce&user=api_user&pass=qBcRmu7AlBq67dkX&function=add_lead&';
          //  toSend = toSend+'list_id='+regionId+'&add_to_hopper=Y&phone_number='+l.MobilePhone+'&vendor_lead_code='+l.Id+'&custom_fields=Y&Lead_Name='+l.Name+'&Mobile='+l.MobilePhone+'&SF_Lead_ID='+l.Id+'&Property_Possession_Date='+l.Property_Possession_Date__c+'&Channel='+l.Channel__c+'&Source_1='+l.DC_Lead_Source__c+'&Source_Journey='+l.Source_Journey__c+'&Created_Date='+l.CreatedDate+'&Email_1='+l.Email+'&Region='+l.Region__c;
            //System.debug(toSend);
            HttpRequest req = new HttpRequest();
            HttpResponse res = new HttpResponse();
            Http http = new Http();
            req.setMethod('POST');
          //  req.setEndpoint(toSend);
            if(!test.isRunningTest())
               res = http.send(req);
            System.debug(res);
            //System.debug(res.getBody());
        }
    }
}  */