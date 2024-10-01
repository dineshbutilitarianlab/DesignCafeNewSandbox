public class DialerRedirectController {
    @AuraEnabled
    public static string fetchLeadDetails(String mobileNo,String uniqueId){
        system.debug(mobileNo);
        mobileNo = mobileNo.replaceAll('[^a-zA-Z0-9\\s+]', '');
        mobileNo = mobileNo.trim();
        if(mobileNo.contains('91')){
            mobileNo = mobileNo.remove('91');   
        }
        system.debug(mobileNo);
        List<Lead> leadList = [select id,MobilePhone,APIMOBILE__c,CallUniqueI__c from Lead where APIMOBILE__c =: mobileNo LIMIT 1];
        if(leadList.size() > 0){
            leadList[0].CallUniqueI__c = uniqueId;
            update leadList;
            return leadList[0].id;
        }
        else{
            return 'Lead Not Found';
        }
        
    }
    
}