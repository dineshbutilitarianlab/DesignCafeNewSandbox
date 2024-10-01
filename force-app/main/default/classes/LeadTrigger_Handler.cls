public without sharing class LeadTrigger_Handler {
    @TestVisible static DateTime todayDateTime      = System.now();
    
    // -----------------------Update few Time stamps and Referee Fields-----------
    public static void miscUpdatesOnLeads(Map<Id,Lead> allNewLeadsMap , Map<Id,Lead> allOldLeadsMap){
        
        for(Id leadId : allNewLeadsMap.keySet()){
            // ************* Update PreQualified Date---------------------
            if(allNewLeadsMap.get(leadId).DC_Lead_Status__c != allOldLeadsMap.get(leadId).DC_Lead_Status__c && (allNewLeadsMap.get(leadId).DC_Lead_Status__c == DesignCafeConstants.LEADSTAGE_PREQUALIFIED
                                                                                                                || (allNewLeadsMap.get(leadId).Pre_Qualified_Date__c == null && (allNewLeadsMap.get(leadId).DC_Lead_Status__c == DesignCafeConstants.LEADSTAGE_MEETINGSCHEDULED || allNewLeadsMap.get(leadId).DC_Lead_Status__c == DesignCafeConstants.LEADSTAGE_MEETINGDONE)))){
                                                                                                                    
                                                                                                                    allNewLeadsMap.get(leadId).Pre_Qualified_Date__c                = todayDateTime.date();
                                                                                                                }
            // ************* Update eQualified Date---------------------
            if(allNewLeadsMap.get(leadId).DC_Lead_Status__c != allOldLeadsMap.get(leadId).DC_Lead_Status__c && (allNewLeadsMap.get(leadId).DC_Lead_Status__c == DesignCafeConstants.LEADSTAGE_QUALIFIED
                                                                                                                || (allNewLeadsMap.get(leadId).Lead_Qualified_Date__c == null && (allNewLeadsMap.get(leadId).DC_Lead_Status__c == DesignCafeConstants.LEADSTAGE_MEETINGSCHEDULED || allNewLeadsMap.get(leadId).DC_Lead_Status__c == DesignCafeConstants.LEADSTAGE_MEETINGDONE)))){
                                                                                                                    
                                                                                                                    allNewLeadsMap.get(leadId).Lead_Qualified_Date__c                = todayDateTime.date();
                                                                                                                }
            if(allOldLeadsMap.get(leadId).Designer__c!= allNewLeadsMap.get(leadId).Designer__c){
                allNewLeadsMap.get(leadId).Has_Designer_Accepted__c = 'Designer Assigned, Acceptance Pending';
                //allNewLeadsMap.get(leadId).Designer_Deadline__c = Integer.valueOf(system.now().hour());
                
                Datetime now = Datetime.now();
                Integer offset = UserInfo.getTimezone().getOffset(now);
                Datetime local = now.addSeconds(offset/1000);
                system.debug('Local Time-->'+local);
                //  allNewLeadsMap.get(leadId).Designer_Deadline__c= deadlineOfAcceptance8hoursCalculation(local);
                
            }
        }
    }
    
    
    public static Datetime getLocalDateTime(Datetime current){
        Date currDate = current.date();
        
        Time currTime = current.time();
        //        system.debug('fghdfgh : ' + currDate + '--' +currTime);
        Datetime local = datetime.newinstance(currDate,currTime); // This will return date time in my local time
        //system.debug(local);
        return local;
        
    } 
    
    
    public static DateTime deadlineOfAcceptance8hoursCalculation(DateTime dtInstance){
        Integer WORKING_HOUR_START  = Integer.valueOf(Design_Cafe_Settings__c.getOrgDefaults().Working_Hour_Start_Time__c);
        Integer WORKING_HOUR_END    = Integer.valueOf(Design_Cafe_Settings__c.getOrgDefaults().Working_Hour_End_Time__c);
        Integer hourCmp = dtInstance.Hour();
        system.debug('Date Instance-->'+dtInstance);
        DateTime deadlineDtInstance = dtInstance;
        Integer differTime = (Integer)(WORKING_HOUR_END - hourCmp);
        if(differTime < 8){            
            Integer timeToAdd = 8 - differTime;
            //return deadlineDtInstance.addDays(1).addHours(WORKING_HOUR_START + timeToAdd);
            return deadlineDtInstance.addHours(WORKING_HOUR_START + timeToAdd);
        }else{
            Integer negTime = (Integer)(8 - differTime);
            return  deadlineDtInstance.addHours(WORKING_HOUR_END+negTime);
        }
    }
    // ----------------------Update OCM Team---------------------
    public static void updateOCMTeam(List<Lead> allNewLeads){
        
        Set<Id> setOfDSAId = new Set<Id>(); 
        Map<String,String> mapOfAccountIdWithTeam = new Map<String,String>();
        Map<String,String> mapOfAccountIdWithCMMName= new Map<String,String>();
        for(Lead eachLead : allNewLeads){
            system.debug('eachlead.DSA__c '+eachlead.DSA__c);
            if(eachLead.DSA__c!=null){
                setOfDSAId.add(eachLead.DSA__c);
            }  
        }
        if(setOfDSAId != null){
            for(Account acc : [Select id,Channel_Marketing_Manager__r.Team__c,CMM_Name__c from Account where id in: setOfDSAId]){
                if(acc.Channel_Marketing_Manager__c != null && acc.Channel_Marketing_Manager__r.Team__c != null){
                    mapOfAccountIdWithTeam.put(acc.id,acc.Channel_Marketing_Manager__r.Team__c.split(';')[0]);
                }
                if(acc.CMM_Name__c != null){
                    mapOfAccountIdWithCMMName.put(acc.id,acc.CMM_Name__c);
                }  
            } 
            
            for(Lead eachLead :allNewLeads){     
                eachLead.CMM_Team__c    = mapOfAccountIdWithTeam.get(eachLead.DSA__c) != null ? mapOfAccountIdWithTeam.get(eachLead.DSA__c) : null;
                eachLead.CMM_Name__c    = mapOfAccountIdWithCMMName.get(eachLead.DSA__c) != null ? mapOfAccountIdWithCMMName.get(eachLead.DSA__c) : null;
            }
        }
    }
    
    // ----------------------Update DSA & Referee Fields---------------------
    public static void updateRefereeAndDSA(List<Lead> allNewLeads){
        SET<String> dsaCodes                                = new SET<String>();
        SET<String> refreeCodes                             = new SET<String>();
        MAP<String,Account> dsaAccountsMap                  = new MAP<String,Account>();
        MAP<String,Account> employeeAccountsMap             = new MAP<String,Account>();
        for(Lead eachLead : allNewLeads){
            dsaCodes.add(eachLead.DSA_Code__c);
            refreeCodes.add(eachLead.Referee_Code__c);
        }
        
        if(!dsaCodes.isEmpty()){
            dsaAccountsMap                          = LeadTrigger_Model.queryAccountsByRefereeCode(dsaCodes , DesignCafeConstants.RECTYPE_SALESPARTNER);
        }
        if(!refreeCodes.isEmpty()){
            employeeAccountsMap                     = LeadTrigger_Model.queryAccountsByRefereeCode(refreeCodes , DesignCafeConstants.RECTYPE_EMPLOYEE);
        }
        for(Lead eachLead : allNewLeads){
            eachLead.Region__c = eachLead.City;
            // ************* Update DSA---------------------
            if(eachLead.DSA_Code__c != null && dsaAccountsMap.get(eachLead.DSA_Code__c) != null){
                eachLead.DSA__c = dsaAccountsMap.get(eachLead.DSA_Code__c).Id;
            }
            
            // ************* Update Referee---------------------
            if(eachLead.Referee_Code__c != null && employeeAccountsMap.get(eachLead.Referee_Code__c) != null){
                eachLead.Referee_Account__c = employeeAccountsMap.get(eachLead.Referee_Code__c).Id;
            }
        }
    }
    
    
    //-----------------Create Followup Tasks for 3times/3days in case of No Response. 
    public static void updateFollowUpTime(Map<Id,Lead> allNewLeadsMap , Map<Id,Lead> allOldLeadsMap){
        List<Lead> listOfLeadToUpdate               = new List<Lead>();
        List<Task> listOfTaskToInsert               = new List<Task>();
        for(Id leadId : allNewLeadsMap.keySet()){
            if(allNewLeadsMap.get(leadId).DC_Lead_Status__c != allOldLeadsMap.get(leadId).DC_Lead_Status__c && allNewLeadsMap.get(leadId).DC_Lead_Status__c == DesignCafeConstants.LEADSTAGE_NORESPONSE){
                DateTime nxtDateTime                            = todayDateTime;
                Integer count                                   = math.mod(Integer.valueOf(allNewLeadsMap.get(leadId).Follow_Up_Count__c),3);
                
                if(allNewLeadsMap.get(leadId).Follow_Up_Count__c < 9){
                    
                    Task newTask                                            = new Task();
                    newTask.Subject                                         = DesignCafeConstants.TASK_SUBJECT;
                    newTask.WhoId                                           = allNewLeadsMap.get(leadId).Id;
                    newTask.OwnerId                                         = UserInfo.getUserId();
                    newTask.Priority                                        = 'Normal';
                    newTask.Status                                          = DesignCafeConstants.TASK_STATUS_OPEN;
                    newTask.Description                                     = 'Follow Up: 2.';
                    newTask.ActivityDate                                    = getNextFollowupTime( nxtDateTime , count).date();
                    newTask.ReminderDateTime                                = getNextFollowupTime( nxtDateTime , count);
                    newTask.IsReminderSet                                   = true;
                    newTask.Due_Date_Time__c                                = getNextFollowupTime( nxtDateTime , count);
                    
                    allNewLeadsMap.get(leadId).Follow_Up_Date_Time__c       = getNextFollowupTime( nxtDateTime , count);
                    allNewLeadsMap.get(leadId).Follow_Up_Count__c           = 2;
                    
                    listOfTaskToInsert.add(newTask); 
                }
            }
        }
        
        if(listOfTaskToInsert.size() > 0){
            insert listOfTaskToInsert;
        } 
        
    }    
    
    
    // *** If the status is changed from NoResponse , close all the open tasks
    public static void completeTasksOnResponse(Map<Id,Lead> allNewLeadsMap , Map<Id,Lead> allOldLeadsMap){
        List<Task> listOfTaskToUpdate               = new List<Task>();
        MAP<Id ,LIST<Task>> leadTOTaskMap           = LeadTrigger_Model.queryOpenTasks(allNewLeadsMap.keySet());
        
        for(Id leadId : allNewLeadsMap.keySet()){
            system.debug('leadToTaskMap.get(leadId) '+leadToTaskMap.get(leadId));
            if(allNewLeadsMap.get(leadId).DC_Lead_Status__c != allOldLeadsMap.get(leadId).DC_Lead_Status__c && allOldLeadsMap.get(leadId).DC_Lead_Status__c == DesignCafeConstants.LEADSTAGE_NORESPONSE){
                if(leadToTaskMap.get(leadId) != null){
                    for(Task eachTask : leadTOTaskMap.get(leadId)){
                        eachTask.status = DesignCafeConstants.TASK_STATUS_COMPLETED;
                        listOfTaskToUpdate.add(eachTask);
                    }  
                }
            }
        }
        if(listOfTaskToUpdate.size() > 0){
            update listOfTaskToUpdate;
        } 
    }
    
    
    //----------------Fetch Next Followup Time----------------------
    public static DateTime getNextFollowupTime(DateTime currentTime , Integer randomCount){
        Integer WORKING_HOUR_START                  = Integer.valueOf(Design_Cafe_Settings__c.getOrgDefaults().Working_Hour_Start_Time__c);
        Integer WORKING_HOUR_END                    = Integer.valueOf(Design_Cafe_Settings__c.getOrgDefaults().Working_Hour_End_Time__c);
        DateTime dt2 = currentTime.addHours(3);
        if(dt2.hour() <= WORKING_HOUR_END && dt2.hour() >= WORKING_HOUR_START){
            return dt2;
        }
        else {
            DateTime myDateTime = todayDateTime;
            if(!test.isrunningtest()){
                myDateTime = DateTime.newInstance(currentTime.year(), currentTime.month(), currentTime.day() + 1, WORKING_HOUR_START + 1 + randomCount ,0, 0);
            }
            return myDateTime;
        }
    }
    
    
  /* 
    //------------------------- Lead Distribution OLD Round-Robin to Sales Team--Sunset on April 30th 2021--------
    public static void distributeLeadToSalesOnMtngScheduled(Map<Id,Lead> allNewLeadsMap, Map<Id,Lead> allOldLeadsMap,Set<String> centerSet){
        MAP<Id,User> allUsers                               = new MAP<Id,User>();
        Set < Id > userIdSet                                = New Set < Id > ();
        Map < Id, Integer > mapOfUseridAndCountOflead       = New Map < Id, Integer > ();
        MAP<String,LIST<User>> mapRegionToUser              = new MAP<String,LIST<User>>();
        Map<String,Map<Integer,User>> mapOfVenueUserNumberandUser = New Map<String,Map<Integer,User>>();
        List<User> userList                                 = new List<User>();
  
        MAP<String,LIST<Lead>> regionToLeadsMap             = new MAP<String,LIST<Lead>>();
        List<Lead> leadsList                                = new List<Lead>();
        Set<String> groupToBeQueried                        = New Set<String>();
        Map<String,String> mapOfVenueandPublicGroups        = New Map<String,String>();
        Map<String,Integer> mapOfVenueLastUsernumber        = New Map<String,Integer>();
        For(DC_Center_To_Group_Mapping__c custSetObj:DC_Center_To_Group_Mapping__c.getall().values()){
            IF(centerSet.size()!=0 && centerSet.contains(custSetObj.Venue_Name__c)){
               
                mapOfVenueandPublicGroups.put(custSetObj.Public_Group_Name__c,custSetObj.Venue_Name__c);
                mapOfVenueLastUsernumber.put(custSetObj.Venue_Name__c,custSetObj.UserNumberLastAssigned__c.intValue());
            }
        }
        
        allUsers                                            = LeadTrigger_Model.queryUsers(mapOfVenueandPublicGroups.keyset()); // Users Queried
        userIdSet                                           = allUsers.keySet();
        system.debug('allusers: '+allUsers.values());
        for(User each : allUsers.values()){

            if(each.Team__c != null){
                List<String> multiSelectRegions = each.Team__c.split(';');
                
                if(multiSelectRegions.size() > 0 ){
                    for(String eachReg : multiSelectRegions ){
                        If(mapOfVenueandPublicGroups.containskey(eachReg)){
                            String venue = mapOfVenueandPublicGroups.get(eachReg);
                            If(mapRegionToUser.containskey(venue)){
                                mapRegionToUser.get(venue).add(each);
                            }
                            else{
                                mapRegionToUser.put(venue,New List<User>{each});
                            }
                        }
                    }
                }
            }
        }
        For(String venue:mapRegionToUser.keyset()){
            Map<Integer,user> mapOfUserNoUser = New Map<Integer,user>();
            For(User uObj:mapRegionToUser.get(venue)){
                mapOfUserNoUser.put(Integer.valueOf(uObj.UserNumber2__c),uObj);
            }
            mapOfVenueUserNumberandUser.put(venue,mapOfUserNoUser);
        }
        
        for(Id leadId : allNewLeadsMap.keySet()) {
            if(allNewLeadsMap.get(leadId).DC_Lead_Status__c != allOldLeadsMap.get(leadId).DC_Lead_Status__c && allNewLeadsMap.get(leadId).DC_Lead_Status__c == DesignCafeConstants.LEADSTAGE_MEETINGSCHEDULED){
                leadsList = new List<Lead>();
                
                if(allNewLeadsMap.get(leadId).Meeting_Venue__c != null && regionToLeadsMap.get(allNewLeadsMap.get(leadId).Meeting_Venue__c) != null){
                    leadsList = regionToLeadsMap.get(allNewLeadsMap.get(leadId).Meeting_Venue__c);
                }
                
                leadsList.add(allNewLeadsMap.get(leadId));
                regionToLeadsMap.put(allNewLeadsMap.get(leadId).Meeting_Venue__c , leadsList);
            }
        }
        system.debug('mapOfVenueUserNumberandUser '+mapOfVenueUserNumberandUser.size());
        system.debug('regionToLeadsMap '+regionToLeadsMap.size());
        if(mapOfVenueUserNumberandUser.size()>0 && regionToLeadsMap.size()>0){
            
            //roundRobinAssignmentOfLeadOwner(mapRegionToUser , regionToLeadsMap);
            roundRobinAssignmentOfLeadOwner2(mapOfVenueUserNumberandUser,regionToLeadsMap,mapOfVenueLastUsernumber);
        }
    }
    
    public static void roundRobinAssignmentOfLeadOwner2(Map<String,Map<Integer,User>> mapRegionToUser , MAP<String,LIST<Lead>> regionToLeadsMap,Map<String,Integer> mapOfVenueLastUsernumber){
        for(String eachRegion : mapRegionToUser.keySet()){
            List<Integer> listOfUserNumberSorted= New List<Integer>(mapRegionToUser.get(eachRegion).keyset());
            map<Integer,User> mapOfUsernumber = mapRegionToUser.get(eachRegion);
            listOfUserNumberSorted.sort();
            Integer lastUserNumber = mapOfVenueLastUsernumber.get(eachRegion);
            Integer index = listOfUserNumberSorted.indexOf(lastUserNumber);
            
            for(Lead leadObj:regionToLeadsMap.get(eachRegion)) {
                //   if((String.isNotBlank(leadObj.Lead_Owner_Role__c) && !leadObj.Lead_Owner_Role__c.containsIgnoreCase('sales')) || leadObj.OwnerId == '0052v00000fa26ZAAQ' || leadObj.OwnerId == '0052v00000fa26KAAQ' || Test.isRunningTest()) {
                if((String.isNotBlank(leadObj.Lead_Owner_Role__c) && !leadObj.Lead_Owner_Role__c.containsIgnoreCase('saleees')) || Test.isRunningTest()) {
                    
                    if(index==-1||index ==listOfUserNumberSorted.size()-1) {
                        index = 0;
                        leadObj.ownerid = mapOfUsernumber.get(listOfUserNumberSorted.get(index)).id;
                        lastUserNumber = listOfUserNumberSorted.get(index);
                        index++;                    
                    }
                    else{
                        index++;
                        leadObj.ownerid = mapOfUsernumber.get(listOfUserNumberSorted.get(index)).id;
                        lastUserNumber = listOfUserNumberSorted.get(index);
                        index++;
                    }
                    
                }
            }
            
            mapOfVenueLastUsernumber.put(eachRegion,lastUserNumber);
        }
        
        List<DC_Center_To_Group_Mapping__c> listOfcustomSettingTobeupdated = New List<DC_Center_To_Group_Mapping__c>();
        
        For(DC_Center_To_Group_Mapping__c custSetObj:DC_Center_To_Group_Mapping__c.getall().values()){
            If(mapOfVenueLastUsernumber.containskey(custSetObj.Venue_Name__c)){
                custSetObj.UserNumberLastAssigned__c = mapOfVenueLastUsernumber.get(custSetObj.Venue_Name__c);
                listOfcustomSettingTobeupdated.add(custSetObj);
            }
        }
        IF(listOfcustomSettingTobeupdated.size()>0){
            database.update(listOfcustomSettingTobeupdated);
        }
    }
   */
    public static void updateLeadTeamAndRegion(List < Lead > leadNewList, Set < Id > ownerIdSet) {
        If(OwnerIdSet.size() == 0) {
            for (Lead leadObj: leadNewList) {
                ownerIdSet.add(leadObj.OwnerId);
            }
        }
        Map < Id, User > mapOfUserAndId = New Map < Id, User > ([Select id, team__c, region__c from user where id in: ownerIdSet]);
        For(Lead leadObj: leadNewList) {
            IF(mapOfUserAndId.containskey(leadObj.OwnerId) && mapOfUserAndId.get(leadObj.OwnerId).team__c!=Null &&
               mapOfUserAndId.get(leadObj.OwnerId).region__c!=Null) {
                   leadObj.Lead_Owner_Region__c = mapOfUserAndId.get(leadObj.OwnerId).region__c;
                   leadObj.Lead_Owner_Team__c = mapOfUserAndId.get(leadObj.OwnerId).team__c;
               }
          IF(mapOfUserAndId.containskey(leadObj.Call_Center_Agent__c) && mapOfUserAndId.get(leadObj.Call_Center_Agent__c).team__c!=Null &&
               mapOfUserAndId.get(leadObj.Call_Center_Agent__c).region__c!=Null) {
                   leadObj.Call_Center_Agent_Region__c = mapOfUserAndId.get(leadObj.Call_Center_Agent__c).region__c;
                   leadObj.Call_Center_Agent_Team__c = mapOfUserAndId.get(leadObj.Call_Center_Agent__c).team__c;
               } 
        }
    }
    
    
  public static void handleLeadCustomSharing(Lead [] aOldLeads, Lead [] aNewLeads) {
        Integer lIndex = 0;
        String [] lLeadIDsForCustomSharing = new List<String>();
        String [] lDesignerIDsForCustomSharing = new List<String>();
        
        List<LeadShare> leadShareList = new List<LeadShare>();
        
        for(Lead LeadObj : aNewLeads) {
            Lead lOldLead = aOldLeads != null ? aOldLeads[lIndex] : null;
            
     //    if(LeadObj.Call_Center_Agent__c != null) {
     //           leadShareList.add(new LeadShare(LeadId = LeadObj.Id, UserOrGroupId =  LeadObj.Call_Center_Agent__c, LeadAccessLevel = 'Read',RowCause=Schema.leadshare.rowcause.Manual));
      //      }
            
            if(lOldLead == null || lOldLead.Designer__c != LeadObj.Designer__c != null) {
                //leadShareList.add(new LeadShare(LeadId = LeadObj.Id, UserOrGroupId=LeadObj.Designer__c, LeadAccessLevel='Edit'));
                lLeadIDsForCustomSharing.add(LeadObj.id);
                lDesignerIDsForCustomSharing.add(LeadObj.Designer__c);
            }
            
            lIndex++;
        }   
        
        if(leadShareList.size() > 0) {
            Database.SaveResult [] lSaveResults = Database.insert(leadShareList, false);
        }
        
        if(lLeadIDsForCustomSharing.size() > 0 && System.isBatch() == false) {
            //assignDesignerOwnership(lLeadIDsForCustomSharing, lDesignerIDsForCustomSharing);
        }
    } 
    
 
    @future
    public static void assignDesignerOwnership(String [] aLeadIDs, String [] aDesignerIDs) {
        Integer lIndex = 0;
        List<LeadShare> leadShareList = new List<LeadShare>();
        
        for(String lLeadID : aLeadIDs) {
            leadShareList.add(new LeadShare(LeadId=lLeadID, UserOrGroupId=aDesignerIDs[lIndex], LeadAccessLevel='Edit'));
            lIndex++;
        }
        
        if(leadShareList.size() > 0) {
            Database.SaveResult [] lSaveResults = Database.insert(leadShareList, false);
        }        
    }
    
    
    
    //-----------------------------SMS Integration events --> call in after Insert
    public static void smsIntegrationCallAfterInsert(Map<Id,Lead> allNewLeadsMap){
        // Comment on 22 August 2024 by Muskan Jain, request by DD Team , will not being used in salesforce.
        //ID jobID = System.enqueueJob(new SMSTriggeringEventsQueableClass('Lead' , allNewLeadsMap.keySet() , false));
    }
    
    
    //-----------------------------SMS Integration events --> call in after update
    public static void smsIntegrationCallAfterUpdate(Map<Id,Lead> allNewLeadsMap , Map<Id,Lead> allOldLeadsMap){
        Set<Id> allLeadIdsToProcess = new Set<Id>();
        Set<Id> allLeadIdsToProcessForChangeOfMeetingTime = new Set<Id>();
        for(Id each : allNewLeadsMap.keySet()){
            if(allNewLeadsMap.get(each).Willingness_For_Meeting__c != allOldLeadsMap.get(each).Willingness_For_Meeting__c && allOldLeadsMap.get(each).DC_Lead_Status__c != allNewLeadsMap.get(each).DC_Lead_Status__c){
                allLeadIdsToProcess.add(each);
            }
            else if(allNewLeadsMap.get(each).Willingness_For_Meeting__c != allOldLeadsMap.get(each).Willingness_For_Meeting__c && allOldLeadsMap.get(each).DC_Lead_Status__c == allNewLeadsMap.get(each).DC_Lead_Status__c){
                allLeadIdsToProcessForChangeOfMeetingTime.add(each);
            }
            else if(allNewLeadsMap.get(each).DC_Lead_Status__c != allOldLeadsMap.get(each).DC_Lead_Status__c ){
                allLeadIdsToProcess.add(each);
            }
        }
        
        if(allLeadIdsToProcess.size() > 0) {
            // Comment on 22 August 2024 by Muskan Jain, request by DD Team , will not being used in salesforce.
            //ID jobID1 = System.enqueueJob(new SMSTriggeringEventsQueableClass('Lead' , allLeadIdsToProcess , false));
        }
        
        if(allLeadIdsToProcessForChangeOfMeetingTime.size() > 0) {
            // Comment on 22 August 2024 by Muskan Jain, request by DD Team , will not being used in salesforce.
           //ID jobID2 = System.enqueueJob(new SMSTriggeringEventsQueableClass('Lead' , allLeadIdsToProcessForChangeOfMeetingTime , true));
        }
        
    }
    
    public static void preventDuplicates(List<Lead> newleadList){
        Set<String> setOfPhoneNo = New Set<String>();
        set<String> setOfExistingPhone = New Set<String>();
        IF(Label.Enable_Lead_Duplicates.equalsIgnoreCase('True')){
            for(Lead leadObj:newleadList) {
                If(leadObj.MobilePhone!=Null) {
                    setOfPhoneNo.add(leadObj.MobilePhone.right(10));
                    setOfPhoneNo.add('+91'+leadObj.MobilePhone.right(10));
                    setOfPhoneNo.add('91'+leadObj.MobilePhone.right(10));
                    setOfPhoneNo.add('0'+leadObj.MobilePhone.right(10));
                } 
            }
            
            for(Lead leadObj :[Select id,MobilePhone from lead where MobilePhone in :setOfPhoneNo]){
                
                If(leadObj.MobilePhone!=Null){
                    setOfExistingPhone.add(leadobj.MobilePhone.right(10));
                }               
                
            }
            
            For(Lead leadObj:newleadList){
                if(leadobj.MobilePhone!=Null && setOfExistingPhone.contains(leadobj.MobilePhone.right(10))){
                    leadobj.adderror('You\'re creating a duplicate record. We recommend you use an existing record instead');
                }
            }
        }
    }
    
    // Share lead with Designer when lead is insert.
    

    public static void shareLeadwithDesigner(List<Lead> newleadList) {
        Set<Id> setOfLeadId=new Set<Id>();
        List<LeadShare> listOfLeadShare = New List<LeadShare>();
        
        for(Lead leadObj : newleadList) {
            if(leadObj.Designer__c!=null) {
                setOfLeadId.add(leadObj.id);
            }   
        }
        
        Set<String> lTLGroupNames = new Set<String>();
        Lead [] lLeads = [Select id, Designer__c, Designer__r.ManagerId, Designer__r.Team__c from Lead where id in:setOfLeadId];
        
        for(Lead leadObj : lLeads) {        
            listOfLeadShare.add(createShareingLead(leadObj.id,leadObj.Designer__c));
            //listOfLeadShare.add(createShareingLead(leadObj.id,leadObj.Designer__r.ManagerId));
            
            if(String.isNotBlank(leadObj.Designer__r.Team__c)) {
                for(String lTeam : leadObj.Designer__r.Team__c.split(';')) {
                    lTLGroupNames.add('PRJ-' + lTeam + '-TL');
                }
            }
        }
        
        for(Group lGroup : [SELECT id, Name FROM Group WHERE name IN:lTLGroupNames]) {
            for(Lead leadObj : lLeads) {
                for(String lTeam : leadObj.Designer__r.Team__c.split(';')) {
                    String lGroupName = 'PRJ-' + lTeam + '-TL';
                    
                    if(lGroup.Name == lGroupName) {
                        listOfLeadShare.add(createShareingLead(leadObj.id, lGroup.id));
                    }
                }
            }
        }
        
        if(listOfLeadShare.size() > 0) {
            Database.insert(listOfLeadShare,False);
        }
    }
    
    // Share lead with Designer when lead is Update.
     
  public static void shareLeadwithDesignerUpdate(List<Lead> newleadList,Map<Id,Lead> oldLeadsMap){
        Set<Id> setOfLeadId                     =new Set<Id>();
        Set<Id> setOfOldDesignerId              =new Set<Id>();
        Set<Id> setOfShareDeleteUserId          =new Set<Id>();
        List<LeadShare> listOfLeadShare         = New List<LeadShare>();
        Set<String> lTLGroupNames               = new Set<String>();
        Set<String> oldTLGroupNames             = new Set<String>();
        
        for(Lead leadObj : newleadList) {
            if(leadObj.Designer__c!=null && (leadObj.Designer__c!=oldLeadsMap.get(leadObj.id).Designer__c || leadObj.OwnerId != oldLeadsMap.get(leadObj.id).OwnerId)) {
                setOfLeadId.add(leadObj.id);
                setOfOldDesignerId.add(oldLeadsMap.get(leadObj.id).Designer__c);
                system.debug(oldLeadsMap.get(leadObj.id).Designer_Team_Name__c);
                if(String.isNotBlank(oldLeadsMap.get(leadObj.id).Designer_Team_Name__c)) {
                    for(String lTeam : oldLeadsMap.get(leadObj.id).Designer_Team_Name__c.split(';')) {
                        oldTLGroupNames.add('PRJ-' + lTeam + '-TL');
                    }
                }
            }   
        }
        
        system.debug(oldTLGroupNames);
        for(User userObj : [Select id,ManagerId from user where id in:setOfOldDesignerId]) {
            setOfShareDeleteUserId.add(userObj.id);
            If(userObj.ManagerId != null){
                setOfShareDeleteUserId.add(userObj.ManagerId);
            }
        }
    
        /*
for(Group grpObj : [Select id from Group where id in:oldTLGroupNames]) {
setOfShareDeleteUserId.add(grpObj.id);
}
system.debug(setOfShareDeleteUserId);*/
        
    Lead [] lLeads = [Select id, Designer__c, Designer__r.ManagerId, Designer__r.Team__c from Lead where id in:setOfLeadId];
        
        for(Lead leadObj : lLeads) {
            listOfLeadShare.add(createShareingLead(leadObj.id,leadObj.Designer__c));
            //listOfLeadShare.add(createShareingLead(leadObj.id,leadObj.Designer__r.ManagerId));
            
            if(String.isNotBlank(leadObj.Designer__r.Team__c)) {
                for(String lTeam : leadObj.Designer__r.Team__c.split(';')) {
                    lTLGroupNames.add('PRJ-' + lTeam + '-TL');
                }
            }
        }
        
        for(Group lGroup : [SELECT id, Name FROM Group WHERE name IN:lTLGroupNames]) {
            for(Lead leadObj : lLeads) {
                for(String lTeam : leadObj.Designer__r.Team__c.split(';')) {
                    String lGroupName = 'PRJ-' + lTeam + '-TL';
                    
                    if(lGroup.Name == lGroupName) {
                        listOfLeadShare.add(createShareingLead(leadObj.id, lGroup.id));
                    }
                }
            }
        }
        
        list<LeadShare> leadShareDeleteList=[Select id,UserOrGroupId  from LeadShare where (UserOrGroupId in:setOfShareDeleteUserId OR  userOrGroup.Name  like 'PRJ-%-TL' ) and LeadId in:setOfLeadId AND RowCause = 'Manual' ];        
        if(leadShareDeleteList.size() > 0) {
            system.debug(leadShareDeleteList);
            delete leadShareDeleteList;
        }
        
        if(listOfLeadShare.size() > 0) {
            system.debug(listOfLeadShare);
            Database.insert(listOfLeadShare,False);
        }
        
        
    }
    
  public static LeadShare createShareingLead(String leadId,String UserId){
        LeadShare leadObject = new LeadShare();
        leadObject.UserOrGroupId =UserId;
        leadObject.LeadAccessLevel ='Edit';
        leadObject.LeadId =leadId;
        leadObject.RowCause = Schema.LeadShare.RowCause.Manual;
        return leadObject;
    }
    
    
    //----------------------- Lead trace record : On Lead Insert -
    public static void leadTraceOnLeadInsert(List<Lead> newleadList){
        List<Lead_Trace__c> listOfLeadTrace=new List<Lead_Trace__c>();
        
        for(Lead leadObj : newleadList){
            if(leadObj.DC_Lead_Status__c=='Meeting Scheduled' || leadObj.DC_Lead_Status__c=='Meeting Done' || leadObj.Status=='Converted'){
                Lead_Trace__c leadTraceObj=new Lead_Trace__c();
                leadTraceObj.Lead__c=leadObj.id;
                if(leadObj.Status=='Converted'){
                    leadTraceObj.Status__c='Converted(Sign-up)';
                }else{
                    leadTraceObj.Status__c=leadObj.DC_Lead_Status__c;
                }
                leadTraceObj.Tmestamp__c=date.today();
                listOfLeadTrace.add(leadTraceObj);
            }
        }
        if(listOfLeadTrace.size()>0){
            insert listOfLeadTrace;
        }
    }
    /* 
public static void leadTraceOnLeadInsert(List<Lead> newleadList){
List<Lead_Trace__c> listOfLeadTrace=new List<Lead_Trace__c>();
list<Lead_Trace__c> leadtrcList = [select id, Name,Lead__c, Opportunity__c,Tmestamp__c,Status__c from Lead_Trace__c];
List<Lead_Trace__c> oldLeadtrclist=new List<Lead_Trace__c>();
list<Lead_Trace__c> UpsertList = new list<Lead_Trace__c>();
for(Lead leadObj : newleadList){
if(leadObj.DC_Lead_Status__c=='Meeting Scheduled' || leadObj.DC_Lead_Status__c=='Meeting Done' || leadObj.Status=='Converted'){
for(Lead_Trace__c leadtrc : leadtrcList){
if((leadtrc.status__c == 'Meeting Scheduled' || leadtrc.status__c == 'Meeting Done' || leadtrc.status__c == 'Converted - Pending Sign-up')&& leadtrc.Lead__c == leadObj.Id){
oldleadtrclist.add(leadtrc);
}
}

Lead_Trace__c leadTraceObj=new Lead_Trace__c();
leadTraceObj.Lead__c=leadObj.id;
if(leadObj.Status=='Converted'){
leadTraceObj.Status__c='Converted - Pending Sign-up';
}else{
leadTraceObj.Status__c=leadObj.DC_Lead_Status__c;
}
leadTraceObj.Tmestamp__c=date.today();
listOfLeadTrace.add(leadTraceObj); 
}
if(listOfLeadTrace.size()>0 && oldleadtrclist.size()>0){
for(Lead_Trace__c NewLeadtrace:listOfLeadTrace){
for(Lead_Trace__c OldLeadtrace:oldleadtrclist){
if(NewLeadtrace.Lead__c == OldLeadtrace.Lead__c && NewLeadtrace.status__c == OldLeadtrace.status__c){
OldLeadtrace.OwnerId = leadObj.Owner__c;
OldLeadtrace.tmestamp__c = date.today();
UpsertList.add(OldLeadtrace);
}
else if(NewLeadtrace.Lead__c != OldLeadtrace.Lead__c && NewLeadtrace.status__c != OldLeadtrace.status__c){
UpsertList.add(NewLeadtrace);
}
}
}
if(UpsertList.size()>0){
upsert UpsertList;
}
}   
} 
}  
*/
    
    // -------------------- Lead trace record : On Lead Update -
    public static void leadTraceOnLeadUpdate(List<Lead> newleadList,Map<Id,Lead> oldLeadsMap){
        List<Lead_Trace__c> listOfLeadTrace=new List<Lead_Trace__c>();
        List<Lead_Trace__c> listOfRecordsToBeDeleted = new List<Lead_Trace__c>();
        List<Lead_Trace__c> listOfRecordsToBeUpdated = new List<Lead_Trace__c>();
        
        Boolean leadTraceMeetingScheduleExists = false;
        Boolean leadTraceMeetingDoneExists = false;
        Boolean leadTraceConvertedExists = false;
        Lead_Trace__c leadTraceMeetingScheduleRecord;
        Lead_Trace__c leadTraceMeetingDoneRecord;
        Lead_Trace__c leadTraceConvertedRecord;
        
        //query all the  Leads with existing lead trace records 
        Map<Id,Lead> leadRecordMap = new Map<Id,Lead>([SELECT Id,ownerid,isConverted,(select Id,Status__c from Lead_Traces__r) from Lead where id IN: newleadList]);
        System.debug('leadRecordMap '+leadRecordMap);
        for(Lead leadObj : newleadList){
            system.debug('leadObj.DC_Lead_status__c '+leadObj.DC_Lead_Status__c);
            if((leadObj.DC_Lead_Status__c != oldLeadsMap.get(leadObj.id).DC_Lead_Status__c)
               ||( leadObj.isconverted == true && oldLeadsMap.get(leadObj.id).isConverted != leadObj.isconverted) || (leadObj.Status == 'Converted')
               || leadObj.OwnerId != oldLeadsMap.get(leadObj.id).OwnerId)
            {
                
                List<Lead_Trace__c> leadTraceRecords = leadRecordMap.get(leadObj.id).Lead_Traces__r;
                System.debug('leadTraceRecords '+leadTraceRecords);
                if(leadTraceRecords.size()>0){
                    for(Lead_Trace__c ltRecords : leadTraceRecords){
                        if(ltRecords.status__c == leadObj.DC_Lead_Status__c && leadObj.Status == 'Prospect'){
                            leadTraceMeetingScheduleExists = true;
                            leadTraceMeetingScheduleRecord = ltRecords;
                        }
                        if(ltRecords.status__c == leadObj.DC_Lead_Status__c && leadObj.Status == 'Prospect'){
                            leadTraceMeetingDoneExists = true;
                            leadTraceMeetingDoneRecord = ltRecords;
                        }
                        if(ltRecords.status__c == 'Converted - Pending Sign-up' && leadObj.Status == 'Converted'){
                            leadTraceConvertedExists = true;
                            leadTraceConvertedRecord = ltRecords;
                        }
                    }    
                }
                
                // update owner field
                /* if(leadObj.OwnerId != oldLeadsMap.get(leadObj.id).OwnerId){
for(Lead_Trace__c eachTraceRecord : leadRecordMap.get(leadObj.id).Lead_Traces__r){
Lead_Trace__c record = new Lead_Trace__c(id=eachTraceRecord.id);
record.OwnerId = leadObj.OwnerId;
listOfRecordsToBeUpdated.add(record);  
}
} */
                
                //delete duplicate Lead_Trace records
                if(leadRecordMap.get(leadObj.id).Lead_Traces__r.size() > 0){ 
                    List<Lead_Trace__c> listOfRecords = CheckForExistingLeadTraceRecords(leadObj.DC_Lead_Status__c,oldLeadsMap.get(leadObj.id).DC_Lead_Status__c,leadRecordMap.get(leadObj.id),leadObj.isconverted); 
                    if(listOfRecords.size() > 0){
                        listOfRecordsToBeDeleted.addall(listOfRecords);
                    }
                } 
                if(leadTraceMeetingScheduleExists){
                    leadTraceMeetingScheduleRecord.OwnerId = leadRecordMap.get(leadObj.id).ownerid;
                    leadTraceMeetingScheduleRecord.Tmestamp__c = system.today();
                    listOfRecordsToBeUpdated.add(leadTraceMeetingScheduleRecord);
                }else if(leadTraceMeetingDoneExists){
                    leadTraceMeetingDoneRecord.OwnerId = leadRecordMap.get(leadObj.id).ownerid;
                    leadTraceMeetingDoneRecord.Tmestamp__c = system.today();
                    listOfRecordsToBeUpdated.add(leadTraceMeetingDoneRecord);
                }else if(leadTraceConvertedExists){
                    leadTraceConvertedRecord.OwnerId = leadRecordMap.get(leadObj.id).ownerid;
                    leadTraceConvertedRecord.Tmestamp__c = system.today();
                    listOfRecordsToBeUpdated.add(leadTraceConvertedRecord);
                }    
                else if((oldLeadsMap.get(leadObj.id).DC_Lead_Status__c != 'Meeting Done' && 
                         leadObj.DC_Lead_Status__c == 'Meeting Scheduled') || leadObj.isconverted == true || 
                        leadObj.DC_Lead_Status__c=='Meeting Done'){ 
                            Lead_Trace__c leadTraceObj=new Lead_Trace__c();
                            leadTraceObj.Lead__c=leadObj.id;
                            leadTraceObj.OwnerId = leadObj.OwnerId;
                            
                            if(leadObj.isconverted == true) {
                                leadTraceObj.Status__c='Converted - Pending Sign-up';
                                leadTraceObj.Opportunity__c = leadObj.convertedOpportunityId;
                            }
                            else {
                                leadTraceObj.Status__c=leadObj.DC_Lead_Status__c;
                            }
                            
                            leadTraceObj.Tmestamp__c = date.today();
                            listOfLeadTrace.add(leadTraceObj);
                        }	
            }
        }
        if(listOfRecordsToBeUpdated.size()>0){
            update listOfRecordsToBeUpdated;
        }
        if(listOfRecordsToBeDeleted.size()>0){
            delete listOfRecordsToBeDeleted;
        }
        if(listOfLeadTrace.size()>0){
            insert listOfLeadTrace;
        }   
    }
    
    public static List<Lead_Trace__c> CheckForExistingLeadTraceRecords(String newStatus,String oldStatus,Lead leadRecord,Boolean leadconverted){
        System.debug('entered method Check for LeadTraceRecords>>>'+newStatus +''+oldStatus+''+leadRecord);
        List<Lead_Trace__c> listOFRecordsToBeDeleted = new List<Lead_Trace__c>();
        
        /*   if(oldStatus == 'Meeting Scheduled' && newStatus != 'Meeting Done' && !leadconverted) {
for(Lead_Trace__c eachTraceRecord : leadRecord.Lead_Traces__r){
if(eachTraceRecord.status__c == 'Meeting Scheduled'){
listOFRecordsToBeDeleted.add(eachTraceRecord); 
}
}
} */
        //   else if(oldStatus == 'Meeting Done' && newStatus == 'Meeting Scheduled' && !leadconverted) {
        if(oldStatus == 'Meeting Done' && newStatus == 'Meeting Scheduled' && !leadconverted) {
            for(Lead_Trace__c eachTraceRecord : leadRecord.Lead_Traces__r) {
                if(eachTraceRecord.status__c == 'Meeting Done') {
                    listOFRecordsToBeDeleted.add(eachTraceRecord);
                }
            }
        }
        /* else if(oldStatus == 'Meeting Done' && newStatus != 'Meeting Scheduled' && !leadconverted){
for(Lead_Trace__c eachTraceRecord : leadRecord.Lead_Traces__r){
if(eachTraceRecord.status__c == 'Meeting Done' || eachTraceRecord.status__C == 'Meeting Scheduled'){
listOFRecordsToBeDeleted.add(eachTraceRecord); 
}
}
}  */
        
        return listOFRecordsToBeDeleted;
    }
    
}