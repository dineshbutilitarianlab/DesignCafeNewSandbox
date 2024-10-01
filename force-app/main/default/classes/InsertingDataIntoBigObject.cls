public class InsertingDataIntoBigObject {
    
    public static void insertLeadArchievesBigObject(){
        List<Lead_Archieve__b> leadArchieveList = new List<Lead_Archieve__b>();
        List<Lead> leadData = [SELECT Id, Name, Phone, Industry, Rating, CreatedById, APIMOBILE__c, Is_Customer_Created__c, Status, Meeting_Type__c, Meeting_Venue__c FROM Lead WHERE APIMOBILE__c != null LIMIT 10];
        System.debug('leadData size ==> ' + leadData.size());
        for(Lead ld: leadData){
            Lead_Archieve__b archieveObj = new Lead_Archieve__b();
            archieveObj.Name__c = ld.Name;
            archieveObj.Phone__c = ld.APIMOBILE__c != null ? ld.APIMOBILE__c : '97938749283';
            archieveObj.Rating__c = ld.Rating;
            archieveObj.CreatedById__c = ld.CreatedById;
            archieveObj.APIMOBILE__c = ld.APIMOBILE__c;
            archieveObj.Is_Customer_Created__c = String.valueOf(ld.Is_Customer_Created__c);
            archieveObj.Status__c = ld.Status;
            archieveObj.Meeting_Type__c = ld.Meeting_Type__c;
            archieveObj.Meeting_Venue__c = ld.Meeting_Venue__c;
            leadArchieveList.add(archieveObj);        
        }
        if(leadArchieveList.size() > 0){
            System.debug('leadArchieveList ==> ' + leadArchieveList);
            List<Database.SaveResult> results = Database.insertImmediate(leadArchieveList);
            System.debug('results ==> ' + results);
            for(Database.SaveResult result : results){
                if (result.success) {
                    System.debug('Field created successfully.');
                } else {
                    System.debug('Field creation failed with message: ' + result.errors[0].message);
                }
            }
        }
    }
    
    public static void insertLeadArchieves(){
        List<Archieved_Leads__c> leadArchieveList = new List<Archieved_Leads__c>();
        List<Lead> leadData = [SELECT Id, Name, Channel__c, Client_s_Budget__c, DSA__c, DSA_Code__c, Email, FirstName, LastName, Status, DC_Lead_Status__c, MobilePhone, Call_Stage__c, Referee_Account__c, Referee_Code__c, Source__c FROM Lead LIMIT 100];
        System.debug('leadData size ==> ' + leadData.size());
        for(Lead ld: leadData){
            Archieved_Leads__c archieveObj = new Archieved_Leads__c();
            //archieveObj.Name = ld.Name;
            archieveObj.Channel__c = ld.Channel__c;
            archieveObj.Client_s_Budget__c = ld.Client_s_Budget__c;
            archieveObj.DSA__c = ld.DSA__c;
            archieveObj.DSA_Code__c = ld.DSA_Code__c;
            archieveObj.Email__c = ld.Email;
            archieveObj.First_Name__c = ld.FirstName;
            archieveObj.Last_Name__c = ld.LastName;
            archieveObj.Lead_Stage__c = ld.Status;
            archieveObj.Lead_Status__c = ld.DC_Lead_Status__c;
            archieveObj.MobilePhone__c = ld.MobilePhone;
            archieveObj.Reason__c = ld.Call_Stage__c;
            archieveObj.Referee_Account__c = ld.Referee_Account__c;
            archieveObj.Referee_Code__c = ld.Referee_Code__c;
            archieveObj.Source__c = ld.Source__c;
            leadArchieveList.add(archieveObj);        
        }
        if(leadArchieveList.size() > 0){
            System.debug('leadArchieveList ==> ' + leadArchieveList);
            List<Database.SaveResult> results = Database.Insert(leadArchieveList);
            System.debug('results ==> ' + results);
            for(Database.SaveResult result : results){
                if (result.success) {
                    System.debug('Field created successfully.');
                } else {
                    System.debug('Field creation failed with message: ' + result.errors[0].message);
                }
            }
        }
    }
    
    public static void fetchBigObjectData(){
    	System.debug('====== Lead_Archieve__b Data =====');  
        List<Lead_Archieve__b> leadArchieveList = [SELECT Id, CreatedById, CreatedDate, SystemModstamp, Phone__c, Name__c, CreatedById__c, Rating__c, APIMOBILE__c, Is_Customer_Created__c, Status__c, Meeting_Type__c, Meeting_Venue__c FROM Lead_Archieve__b];
        System.debug('size ==> ' + leadArchieveList.size());
        System.debug('leadArchieveList ==> ' + leadArchieveList);
    }
}