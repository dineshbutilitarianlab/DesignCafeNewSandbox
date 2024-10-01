/*
* Code Development : V-Fory Team
* Modified Date    : 16th August 2021
* Developer        : Vineesha
* Code Modifier    : V-Fory Team
* Modified Date    : 30th December 2021
* Modified By      : Munna Shaik
*/
public class VDC_LeadProcesstoApex {
    
    public static Boolean firstRun = true;  //Static variable to stop erecursion
    //method to get profile name and username List
    public static List<String> getNames(String type){
        List<String> nameList ;
        if (type == 'Profile') {
            nameList = new List<String>{'Call Center Agent', 'Call Center Team Lead', 'CMM Executive', 'CMM', 'System Administrator', 'DesignCafe Profile'};
        }else if (type == 'User') {
            nameList = new List<String>{'Design Cafe Admin', 'Lakshmi P G', 'Gnanesh Puttaswamy', 'DesignCafe Site Guest User', 'DD Admin'};
        }
        return nameList;
    }
    public static void BroadcastAndOwnerChange(List<Lead> NewLeads){ 
        firstRun = false;
        Id ccAgentId, ccTeamLeadId, CMMExecutiveId, CMMId, SAId, DCId;
        Id DCAId, LPGId, GPId, DCSGUId,DDADMINId;
        List<String> profileNames = getNames('Profile');
        List<String> userNames = getNames('User');
        for (Profile profileRecord : [SELECT Id, Name FROM Profile WHERE Name IN :profileNames]) {
            if (profileRecord.name == 'Call Center Agent') {
                ccAgentId = profileRecord.Id;
            }else if (profileRecord.name == 'Call Center Team Lead') {
                ccTeamLeadId = profileRecord.Id;
            }else if (profileRecord.name == 'CMM Executive') {
                CMMExecutiveId = profileRecord.Id;
            }else if (profileRecord.name == 'CMM') {
                CMMId = profileRecord.Id;
            }else if (profileRecord.name == 'System Administrator') {
                SAId = profileRecord.Id;
            }else if (profileRecord.name == 'DesignCafe Profile') {
                DCId = profileRecord.Id;
            }
        }
        for (user userRecord : [SELECT Id, Name FROM user WHERE Name IN :userNames]) {
            if (userRecord.Name == 'Design Cafe Admin') {
                DCAId = userRecord.Id;
            }else if (userRecord.Name == 'Lakshmi P G') {
                LPGId = userRecord.Id;
            }else if (userRecord.Name == 'Gnanesh Puttaswamy') {
                GPId = userRecord.Id;
            }else if (userRecord.Name == 'DesignCafe Site Guest User') {
                DCSGUId = userRecord.Id;
            }else if (userRecord.Name == 'DD Admin') {
                DDADMINId = userRecord.Id;
            }
        }
       

        Id DCCallcenterId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('DC Call Center').getRecordTypeId();
        Id DCSalesManagerId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('DC Sales Manager').getRecordTypeId();
        list<Lead> UpdateLeadsList = New list<Lead>();
        Map<Id,Id> lastmodifiedProfileIdMap = new Map<Id,id>();
        set<Id> Lastmodifiedids = new set<Id>();
        map<id,id> UserIdProfileidMap = new map<Id,Id>();
        set<Id> ownerids = new set<Id>();
        map<id,id> OwnerIdProfileidMap  = new map<Id,Id>();
        List<user> UserList = new list<User>();
        
        // To get the logged in users profile to update Meeting_Scheduled_by__c 
        // when stage is Meeting Scheduled later in the code
        Id profileId = UserInfo.getProfileId();
        String profileName =[Select Id, Name from Profile where Id=:profileId].Name;
        system.debug('ProfileName'+profileName); 
        
        //====Getting LastModifiedIds
        for(Lead NewLea: NewLeads){
            Lastmodifiedids.add(NewLea.LastModifiedById);
            if(NewLea.DC_Lead_Status__c == 'CC Error'){
                ownerids.add(NewLea.OwnerId);
            }
        }
        //====Id and ProfileId of lastModifiedUsers and ownerUsers
        if(Lastmodifiedids.size()>0 || ownerids.size()>0){
            UserList = [select Id, ProfileId from user where Id=: Lastmodifiedids Or Id =:ownerids];
        }
        if(UserList.size()>0){ 
            for(User u:UserList){
                UserIdProfileidMap.put(U.Id,u.ProfileId);
            }
        }
        //====Putting Leadids and profileids in Map
        for(Lead Lea:NewLeads){
            Id ProfId = UserIdProfileidMap.get(Lea.LastModifiedById);
            Id OwnerProfId = UserIdProfileidMap.get(Lea.OwnerId);
            lastmodifiedProfileIdMap.put(Lea.Id,ProfId);
            OwnerIdProfileidMap.put(Lea.Id,OwnerProfId);
        }
        
        system.debug('lastmodifiedProfileIdMap '+lastmodifiedProfileIdMap);
        
        for(lead Lea:NewLeads){
            
            // Set Meeting_Scheduled_by__c depending on the logged in users profile name
            
           /* if (Lea.Status == 'Meeting Scheduled' && Lea.Meeting_Scheduled_by__c == Null) {  
                
                if ( (ProfileName == 'System Administrator' || ProfileId =='00e2v000003i4B1') ||(ProfileName == 'System Administrator API User' || ProfileId == '00e2u000000giSf') ||(ProfileName == 'System Administrator Support' || ProfileId == '00e2u000000gj4P') ||(ProfileName == 'System Administrator View Only') ||
                    (ProfileName == 'Super user Admin' || ProfileId =='00e2u000000giGP' ) ||
                    (ProfileName == '3D Designer' || ProfileId =='00e2v0000028Kdb' ) ||
                    (ProfileName == 'Customer Happiness Manager' || ProfileId =='00e2v0000028Kde' ) ||
                    (ProfileName == 'Design Partner' || ProfileId =='00e2v0000028Kdf' )||
                    (ProfileName == 'Floorplan Profile' ) ) {
                        Lea.Meeting_Scheduled_by__c = 'Admin';
                    }
                else if ((ProfileName == 'Call Center Agent' || ProfileId =='00e2v000002CSat' ) ||
                              (ProfileName == 'Call Center Team Lead'  || ProfileId =='00e2v000002CSau')) {
                                  Lea.Meeting_Scheduled_by__c = 'Call Center';
                              }
                else if ((ProfileName == 'Sales Executive' || ProfileId =='00e2v000002CSb0' ) ||
                         (ProfileName == 'Sales GM' || ProfileId =='00e2v000002CSb1' ) ||
                         (ProfileName == 'Sales Team Lead' || ProfileId =='00e2v000002CSb2' ) ||
                         (ProfileName == 'FOCO' || ProfileId =='00e72000000VPVB' ) ||
                         ( ProfileName == 'FOFO' || ProfileId =='00eC5000000LqxU' ) 
                        ) {
                            Lea.Meeting_Scheduled_by__c = 'Sales Manager';
                        }
                else if ((ProfileName == 'Affiliate'|| ProfileId =='00e2u000000gjfp') ){
                             Lea.Meeting_Scheduled_by__c = 'Affiliate';
                         }
                else if ((ProfileName == 'CMM' ||  ProfileId =='00e2v0000028IcS')  ||
                         (ProfileName == 'DC Offline Marketing Head' ||  ProfileId =='00e2u000000giTJ')  ||
                         (ProfileName == 'DC Online Marketing Head' ||  ProfileId =='00e2u000000giTK')  ||
                         (ProfileName == 'DC Online Marketing Team' ||  ProfileId =='00e2u000000gjGB')  ||
                         (ProfileName == 'DC Online Marketing Team Lead' ||  ProfileId =='00e2u000000gj95')  ||
                         (ProfileName == 'DC Organic and Website Marketing Head' ||  ProfileId =='00e2u000000giTL')  ||
                         (ProfileName == 'CMM Executive' || ProfileId =='00e2u000000giVA')) {
                             Lea.Meeting_Scheduled_by__c = 'Marketing';
                         }
                else if ((ProfileName == 'DesignCafe Profile' || ProfileId =='00e2v000002CU99')  &&
                         (Lea.Messaging_Source__c == 'WhatsApp' || Lea.Messaging_Source__c =='Chat')) {
                             Lea.Meeting_Scheduled_by__c = 'Chatbot';
                         }                
            }  */
            
            //==== Start of Process Builder - SM-Update Broadcast Status 
            if((Lea.Design_User__c == null && (Lea.Status == 'Meeting Confirmed' || Lea.Status == 'Meeting Scheduled') 
                && Lea.PB_BS_1_or_3_or_4__c == false && Lea.PB_BS_0_or_2__c == false && lea.Broadcast_Status__c != null)
               || Lea.Broadcast_Status__c =='0'){
                   Lea.Broadcast_Status__c = '0';
               }
            if(Lea.Design_User__c != null && Lea.PB_Current_user_ID__c != GPId && Lea.PB_Current_user_ID__c != DDADMINId){
                Lea.Broadcast_Status__c = '4';
            }
            if(Lea.PB_BS_1_or_3_or_4__c == true && 
               Lea.Design_User__c == null && Lea.PB_Current_user_ID__c != DCSGUId && Lea.PB_Current_user_ID__c != GPId){
                   Lea.Broadcast_Status__c = '2';
                   Lea.Is_Designer_Assigned__c = false;
               }
            if(Lea.Broadcast_Status__c == '0' || Lea.Broadcast_Status__c == '2'){
                Lea.PB_BS_0_or_2__c = true;
            }
            if(Lea.Broadcast_Status__c == '1' || Lea.Broadcast_Status__c == '3' || Lea.Broadcast_Status__c == '4'){
                Lea.PB_BS_1_or_3_or_4__c = true;
            }
            //==== end of Process Builder - SM-Update Broadcast Status 
            //================================================================//
            //================================================================//
            //==== start of Process Builder - Lead stage wise updates
            /*if(Lea.status == 'New' && lastmodifiedProfileIdMap.get(Lea.Id) == ccAgentId){
                Lea.OwnerId = DCAId;
            }*/
           if (Lea.Status == 'Connected' && Lea.Willingness_For_Meeting__c == null
                   && (Lea.Messaging_Source__c != 'Chat' || Lea.Messaging_Source__c != 'WhatsApp') 
                   && lastmodifiedProfileIdMap.get(Lea.Id) == ccAgentId
               &&  !(Lea.Lead_Owner_Role__c != null  && Lea.Lead_Owner_Role__c.Contains('Sales Manager'))
               && !(Lea.Lead_Owner_Role__c != null  && Lea.Lead_Owner_Role__c.Contains('Administrator'))){
                       system.debug('Previous Lead owner was not Sales Manager OR Admin');
                       Lea.OwnerId = Lea.LastModifiedById;
                   
            }
            /*   else if(Lea.Status == 'Connected' && Lea.Willingness_For_Meeting__c != null
&& (Lea.Messaging_Source__c == 'Chat' || Lea.Messaging_Source__c == 'WhatsApp') ){
Lea.Call_Center_Agent__c = LPGId;
Lea.Call_Stage__c = 'Meeting Scheduled';
Lea.Status = 'Meeting Scheduled';
Lea.Date_When_Meeting_is_Scheduled__c = system.today();
//Lea.Lead_Allocation_time_to_SM__c = system.now();
Lea.RecordTypeId = DCSalesManagerId;
Lea.DC_Lead_Status__c = 'Meeting Scheduled';
}  */
            else if(Lea.Willingness_For_Meeting__c != null 
                    && (Lea.Status == 'New' || Lea.Status == 'Not Connected' || Lea.Status == 'Connected') 
                    && (lastmodifiedProfileIdMap.get(Lea.Id) ==ccAgentId 
                        || lastmodifiedProfileIdMap.get(Lea.Id) == ccTeamLeadId)){
                            Lea.Call_Center_Agent__c  = Lea.LastModifiedById;
                            Lea.OwnerId = Lea.LastModifiedById;
                        }
            else if(Lea.Status == 'Meeting Scheduled' && Lea.DC_Lead_Status__c == 'Meeting Scheduled' 
                    && Lea.Willingness_For_Meeting__c != null 
                    && (lastmodifiedProfileIdMap.get(Lea.Id) ==ccAgentId || 
                        lastmodifiedProfileIdMap.get(Lea.Id) == ccTeamLeadId 
                       )){
                           if(Lea.Date_When_Meeting_is_Scheduled__c == NULL){
                               Lea.Date_When_Meeting_is_Scheduled__c = system.today();
                           }else{
                               system.debug('Date_When_Meeting_is_Scheduled__c');
                           }
                           // Lea.Date_When_Meeting_is_Scheduled__c = system.today();
                           /*if(Lea.Lead_Allocation_time_to_SM__c == NULL){
                               Lea.Lead_Allocation_time_to_SM__c = system.now();
                           }else{
                               system.debug('Lead_Allocation_time_to_SM__c');
                           }*/
                           
                           
                           //  Lea.Lead_Allocation_time_to_SM__c = system.now();
                           Lea.Call_Center_Agent__c = Lea.LastModifiedById;                        
                           Lea.RecordTypeId = DCSalesManagerId;
                       }
            
            else if(Lea.Status == 'Meeting Scheduled' && Lea.DC_Lead_Status__c == 'Meeting Scheduled' 
                    && Lea.Willingness_For_Meeting__c != null  &&
                    (lastmodifiedProfileIdMap.get(Lea.Id) == DCId || lastmodifiedProfileIdMap.get(Lea.Id) == SAId || 
                     lastmodifiedProfileIdMap.get(Lea.Id) ==CMMExecutiveId || lastmodifiedProfileIdMap.get(Lea.Id) == CMMId)){
                         if(Lea.Call_Center_Agent__c == NULL){
                             Lea.Call_Center_Agent__c = LPGId;
                         }else{
                             system.debug('Call_Center_Agent__c');
                         }
                         //   Lea.Call_Center_Agent__c = LPGId;
                         if(Lea.Date_When_Meeting_is_Scheduled__c == NULL){
                             Lea.Date_When_Meeting_is_Scheduled__c = system.today();
                         }else{
                             system.debug('Date_When_Meeting_is_Scheduled__c');
                         }
                         //   Lea.Date_When_Meeting_is_Scheduled__c = system.today();
                        /* if(Lea.Lead_Allocation_time_to_SM__c == NULL){
                             Lea.Lead_Allocation_time_to_SM__c = system.now();
                         }else{
                             system.debug('Lead_Allocation_time_to_SM__c');
                         }*/
                         //   Lea.Lead_Allocation_time_to_SM__c = system.now();
                         Lea.RecordTypeId = DCSalesManagerId;
                     }
            else if(Lea.DC_Lead_Status__c == 'CC Error' 
                    && (OwnerIdProfileidMap.get(Lea.Id) == ccAgentId || OwnerIdProfileidMap.get(Lea.Id) == ccTeamLeadId)){
                        Lea.RecordTypeId = DCCallcenterId;
                    }
            //==== end of Process Builder - Lead stage wise updates
        }
    }
}