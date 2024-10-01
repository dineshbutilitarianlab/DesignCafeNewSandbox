/*
@author : Ankit Soni
@modified : Azar Khasim
*/
public class LeadAssignmentHandler{
    public LeadAssignmentHandler(){
        
    }
}
/*
public without sharing class LeadAssignmentHandler {
    public static void assignDesignerByRR(List<Lead> aleads, Map <Id,Lead > oldMap) {   
        //--- New---//
        list<id> userids = new list<id>();
        //--- New---//
        Set<String> expCenGroup = new Set<String>();
        Set<Id> uIds = new Set<Id>();         
        Map<String, Map<String, List<User>>> grRoleUserMap = new Map<String, Map<String, List<User>>>();          
        Map<Integer,User> mapNumberToUser = null;
        Map<Integer,User> mapNumberToUserTL = null;
        Map<Integer,User> mapNumberToUserSD = null;
        List<Integer> listOfUserNumberSorted = null;
        List<Integer> listOfUserNumberSortedTL = null;
        List<Integer> listOfUserNumberSortedSD = null;
        List<Lead> lLeadsForProcessing = new List<Lead>();
        List<LastLeadAssignedDesigner__c> listOfcustomSettingTobeupdated = null;
        Datetime lRefTime = Datetime.now();
        for(Lead l : aleads) {
            if(l.Designer__c == null && l.DC_Lead_Status__c == 'Meeting Scheduled' && l.Willingness_For_Meeting__c != null && l.Willingness_For_Meeting__c > lRefTime) {
                lLeadsForProcessing.add(l);
                expCenGroup.add(l.Meeting_Venue__c+'_Designers_Team_ST');
            }
        }
        system.debug('expCenGroup: '+expCenGroup);
        if(lLeadsForProcessing.size() == 0) {
            return;
        }
        
        List<GroupMember> gmems = [SELECT Id, UserOrGroupId, Group.Name FROM GroupMember where Group.Name IN :expCenGroup ];
        
        for(GroupMember gm : gmems){
            uIds.add(gm.UserOrGroupId);         
        }
        
        Map<Id, User> usersMap = new Map<Id, User>([SELECT Id, UserRoleId, UserRole.Name, UserNumber2__c FROM User WHERE Id IN :uIds]);
        
        for(GroupMember gm : gmems){
            uIds.add(gm.UserOrGroupId);            
            if(grRoleUserMap.containsKey(gm.Group.Name)){
                if(grRoleUserMap.get(gm.Group.Name).containsKey(usersMap.get(gm.UserOrGroupId).UserRole.Name)){
                    grRoleUserMap.get(gm.Group.Name).get(usersMap.get(gm.UserOrGroupId).UserRole.Name).add(usersMap.get(gm.UserOrGroupId));       
                }else{
                    grRoleUserMap.get(gm.Group.Name).put(usersMap.get(gm.UserOrGroupId).UserRole.Name, new List<User>{usersMap.get(gm.UserOrGroupId)});
                }                
            }else{
                grRoleUserMap.put(gm.Group.Name, new Map<String, List<User>>{usersMap.get(gm.UserOrGroupId).UserRole.Name => new List<User>{usersMap.get(gm.UserOrGroupId)}}); 
            }
        }        
        listOfcustomSettingTobeupdated = New List<LastLeadAssignedDesigner__c>(); 
        //--- New---//
        DDR__c data1 = DDR__c.getvalues('Mumbai');
        system.debug('uidsssssss'+ uids);
        userids.addall(uids);
        Integer countformumdc = data1.index__c == null?0:Integer.valueOf(data1.index__c);
        //--- New---//
        
        
        for(Lead l : lLeadsForProcessing){ 
            if(l.DC_Lead_Status__c == 'Meeting Scheduled' && oldMap.get(l.Id).Designer__c == NULL){   
         //   if(l.DC_Lead_Status__c == 'Meeting Scheduled' && oldMap.get(l.Id).Designer__c != NULL){    
                system.debug('INNNNNNNNN');
                String customSettRec = null;
                String customSettRecTL = null;
                String customSettRecSD = null;
                String customSettRecleadcount= null;
                String customSettRecAssignedStatus= null;
                
                customSettRecleadcount = l.Meeting_Venue__c +'_Lead_Count'; 
                customSettRecAssignedStatus = l.Meeting_Venue__c +'_Lead_Assigned_Status';
                
                Map<String,LastLeadAssignedDesigner__c> roleTOLastUsernumber = LastLeadAssignedDesigner__c.getAll();
                
                Decimal assignedLeadCount = roleTOLastUsernumber.get(customSettRecleadcount).Number__c;                
                Integer leadcount; 
                
                if(assignedLeadCount == null)
                    roleTOLastUsernumber.get(customSettRecleadcount).Number__c = 0;           
                
                leadcount = (Integer)roleTOLastUsernumber.get(customSettRecleadcount).Number__c;                
                leadcount++;
                //==
                
                Decimal internalAssignedLeadStatus = roleTOLastUsernumber.get(customSettRecAssignedStatus).Number__c;                
                Integer internalAssignedStatus; 
                
                if(internalAssignedLeadStatus == null)
                    roleTOLastUsernumber.get(customSettRecAssignedStatus).Number__c = 0;           
                
                internalAssignedStatus = (Integer)roleTOLastUsernumber.get(customSettRecAssignedStatus).Number__c;
                //===
                system.debug(internalAssignedStatus );
                mapNumberToUser = null;
                listOfUserNumberSorted = null;
 //==========================================================================================================================================================//               
                if(l.Meeting_Venue__c == 'Mumbai DC'){
                    countformumdc = countformumdc == userids.size()?0:countformumdc;
                    l.designer__c = userids[countformumdc];
                    countformumdc ++;  
                } 
                else{  
 //==========================================================================================================================================================//               
                system.debug(grRoleUserMap.get(l.Meeting_Venue__c+'_Designers_Team_ST').containsKey('Design Manager'));
   
                if(math.mod(leadcount, 2) == 0 && grRoleUserMap.get(l.Meeting_Venue__c+'_Designers_Team_ST').containsKey('Design Manager')){
                    if(grRoleUserMap.get(l.Meeting_Venue__c+'_Designers_Team_ST').containsKey('Design Manager')){ 
                        
                        mapNumberToUser = new Map<Integer,User>();
                      
                        for(User u : grRoleUserMap.get(l.Meeting_Venue__c+'_Designers_Team_ST').get('Design Manager')){
                            mapNumberToUser.put(Integer.valueof(u.UserNumber2__c), u);
                        }
                        
                        listOfUserNumberSorted = New List<Integer>(mapNumberToUser.keyset());
                        listOfUserNumberSorted.sort();                    
                        customSettRec = l.Meeting_Venue__c +'_Design_Manager';
                        Decimal lastDP = roleTOLastUsernumber.get(customSettRec).Number__c;
                        Integer lastDPUserNumber = 0;
                        
                        if(lastDP != null)
                            lastDPUserNumber = (Integer)roleTOLastUsernumber.get(customSettRec).Number__c;
                        
                        Integer index = listOfUserNumberSorted.indexOf(lastDPUserNumber);
                        
                        IF(index==-1||index ==listOfUserNumberSorted.size()-1){
                            index = 0;                        
                            l.Designer__c = mapNumberToUser.get(listOfUserNumberSorted.get(index)).id;
                            lastDPUserNumber = listOfUserNumberSorted.get(index);               
                        }else{
                            index++;
                            l.Designer__c = mapNumberToUser.get(listOfUserNumberSorted.get(index)).id;
                            lastDPUserNumber = listOfUserNumberSorted.get(index);
                        }
                        
                        roleTOLastUsernumber.get(customSettRec).Number__c = lastDPUserNumber;
                        roleTOLastUsernumber.get(customSettRecleadcount).Number__c = leadcount; 
                        For(LastLeadAssignedDesigner__c custSetObj:LastLeadAssignedDesigner__c.getAll().values()){
                            
                            If(roleTOLastUsernumber.containskey(custSetObj.Name)){                        
                                custSetObj.Number__c = roleTOLastUsernumber.get(custSetObj.Name).Number__c;
                                listOfcustomSettingTobeupdated.add(custSetObj);
                            }                    
                        }                   
                    }
                }
                else{                    
                    system.debug('Else Here');
                    Decimal lastTL= NULL;
                    Integer lastTLUserNumber,indexTL;
                    
                    Decimal lastSD;
                    Integer lastSDUserNumber,indexSD;
                    system.debug('Meeting venue '+ l.Meeting_Venue__c);
     
    //======================================================================================================================================//
                       
                        if(grRoleUserMap.get(l.Meeting_Venue__c+'_Designers_Team_ST').containsKey('Community Manager')){
                            mapNumberToUserTL = new Map<Integer,User>();                   
                            for(User u : grRoleUserMap.get(l.Meeting_Venue__c+'_Designers_Team_ST').get('Community Manager')){
                                mapNumberToUserTL.put(Integer.valueof(u.UserNumber2__c), u);
                            }                   
                            listOfUserNumberSortedTL = New List<Integer>(mapNumberToUserTL.keyset());
                            listOfUserNumberSortedTL.sort(); 
                            customSettRecTL = l.Meeting_Venue__c +'_Community_Manager'; 
                            lastTL = roleTOLastUsernumber.get(customSettRecTL).Number__c;
                            lastTLUserNumber = 0;                    
                            if(lastTL != null)
                                lastTLUserNumber = (Integer)roleTOLastUsernumber.get(customSettRecTL).Number__c;                   
                            indexTL = listOfUserNumberSortedTL.indexOf(lastTLUserNumber);  
                        }    
                        //*****************************************************************
                        IF(indexTL==-1 && grRoleUserMap.get(l.Meeting_Venue__c+'_Designers_Team_ST').containsKey('Community Manager')){
                            indexTL = 0;                        
                            l.Designer__c = mapNumberToUserTL.get(listOfUserNumberSortedTL.get(indexTL)).id;
                            lastTLUserNumber = listOfUserNumberSortedTL.get(indexTL);                                            
                        }  
                        else if(grRoleUserMap.get(l.Meeting_Venue__c+'_Designers_Team_ST').containsKey('Community Manager')){
                            indexTL++;
                            if(listOfUserNumberSortedTL.size() == indexTL){
                                l.Designer__c = mapNumberToUserTL.get(listOfUserNumberSortedTL.get(indexTL-1)).id;
                                lastTLUserNumber = listOfUserNumberSortedTL.get(indexTL-1);
                            }
                            else{
                            	l.Designer__c = mapNumberToUserTL.get(listOfUserNumberSortedTL.get(indexTL)).id;
                            	lastTLUserNumber = listOfUserNumberSortedTL.get(indexTL);
                            }
                        }else if(grRoleUserMap.get(l.Meeting_Venue__c+'_Designers_Team_ST').containsKey('Community Manager') == false && grRoleUserMap.get(l.Meeting_Venue__c+'_Designers_Team_ST').containsKey('Design Manager')){ 
                            IF(indexSD==-1 || indexSD == listOfUserNumberSortedSD.size()-1){
                                indexSD = 0;                        
                                l.Designer__c = mapNumberToUserSD.get(listOfUserNumberSortedSD.get(indexSD)).id;
                                lastSDUserNumber = listOfUserNumberSortedSD.get(indexSD);                                                    
                            }else{
                                indexSD++;
                                l.Designer__c = mapNumberToUserSD.get(listOfUserNumberSortedSD.get(indexSD)).id;
                                lastSDUserNumber = listOfUserNumberSortedSD.get(indexSD);
                            }
                        }else{}                   
                        
                        if(customSettRecTL != NULL)
                            roleTOLastUsernumber.get(customSettRecTL).Number__c = lastTLUserNumber;
                        if(customSettRecSD != NULL)
                            roleTOLastUsernumber.get(customSettRecSD).Number__c = lastSDUserNumber;
                        roleTOLastUsernumber.get(customSettRecleadcount).Number__c = leadcount;
                        roleTOLastUsernumber.get(customSettRecAssignedStatus).Number__c = internalAssignedStatus;
                        
                        For(LastLeadAssignedDesigner__c custSetObj:LastLeadAssignedDesigner__c.getAll().values()){
                            
                            If(roleTOLastUsernumber.containskey(custSetObj.Name)){                        
                                custSetObj.Number__c = roleTOLastUsernumber.get(custSetObj.Name).Number__c;
                                listOfcustomSettingTobeupdated.add(custSetObj);
                            }                       
                        }
                    } 
                   }
              //  }
                IF(listOfcustomSettingTobeupdated.size()>0){
                        database.update(listOfcustomSettingTobeupdated);
                    }
                system.debug(l.Designer__c);
                if(l.Designer__c != null && (l.Has_Designer_Accepted__c == 'Designer Not Assigned' || l.Designer__c != oldMap.get(l.Id).Designer__c)) {
                    l.Has_Designer_Accepted__c = 'Designer Assigned, Acceptance Pending';
                }
            }
        }  
        //--- New---//
        data1.index__c = countformumdc;
        update data1;
        //--- New---//
    }
}   */
//=========================================================New DDR=============================================================================//
//=====================================================******OLD Designer RoundRobin*****======================================================//
/*
public without sharing class LeadAssignmentHandler {
    public static void assignDesignerByRR(List<Lead> aleads, Map <Id,Lead > oldMap) {   
     
        Set<String> expCenGroup = new Set<String>();
        Set<Id> uIds = new Set<Id>();         
        Map<String, Map<String, List<User>>> grRoleUserMap = new Map<String, Map<String, List<User>>>();          
        Map<Integer,User> mapNumberToUser = null;
        Map<Integer,User> mapNumberToUserTL = null;
        Map<Integer,User> mapNumberToUserSD = null;
        List<Integer> listOfUserNumberSorted = null;
        List<Integer> listOfUserNumberSortedTL = null;
        List<Integer> listOfUserNumberSortedSD = null;
        List<Lead> lLeadsForProcessing = new List<Lead>();
        List<LastLeadAssignedDesigner__c> listOfcustomSettingTobeupdated = null;
        //Datetime lRefTime = Datetime.now().addHours(6);
        Datetime lRefTime = Datetime.now();
        for(Lead l : aleads) {
            if(l.Designer__c == null && l.DC_Lead_Status__c == 'Meeting Scheduled' && l.Willingness_For_Meeting__c != null && l.Willingness_For_Meeting__c > lRefTime) {
                lLeadsForProcessing.add(l);
                expCenGroup.add(l.Meeting_Venue__c+'_Designers_Team');
            }
        }
        system.debug('expCenGroup: '+expCenGroup);
        if(lLeadsForProcessing.size() == 0) {
            return;
        }
        
        List<GroupMember> gmems = [SELECT Id, UserOrGroupId, Group.Name FROM GroupMember where Group.Name IN :expCenGroup ];
        
        for(GroupMember gm : gmems){
            uIds.add(gm.UserOrGroupId);         
        }
        
        Map<Id, User> usersMap = new Map<Id, User>([SELECT Id, UserRoleId, UserRole.Name, UserNumber2__c FROM User WHERE Id IN :uIds]);
        
        for(GroupMember gm : gmems){
            uIds.add(gm.UserOrGroupId);            
            if(grRoleUserMap.containsKey(gm.Group.Name)){
                if(grRoleUserMap.get(gm.Group.Name).containsKey(usersMap.get(gm.UserOrGroupId).UserRole.Name)){
                    grRoleUserMap.get(gm.Group.Name).get(usersMap.get(gm.UserOrGroupId).UserRole.Name).add(usersMap.get(gm.UserOrGroupId));       
                }else{
                    grRoleUserMap.get(gm.Group.Name).put(usersMap.get(gm.UserOrGroupId).UserRole.Name, new List<User>{usersMap.get(gm.UserOrGroupId)});
                }                
            }else{
                grRoleUserMap.put(gm.Group.Name, new Map<String, List<User>>{usersMap.get(gm.UserOrGroupId).UserRole.Name => new List<User>{usersMap.get(gm.UserOrGroupId)}}); 
            }
        }        
        listOfcustomSettingTobeupdated = New List<LastLeadAssignedDesigner__c>();        
        
        //***************** RR Lead assignment in 5(TL/SD):1(DP) Manner ***************************
        for(Lead l : lLeadsForProcessing){ 
            if(l.DC_Lead_Status__c == 'Meeting Scheduled' && oldMap.get(l.Id).Designer__c == NULL){    
              system.debug('INNNNNNNNN');
                String customSettRec = null;
                String customSettRecTL = null;
                String customSettRecSD = null;
                String customSettRecleadcount= null;
                String customSettRecAssignedStatus= null;
                
                customSettRecleadcount = l.Meeting_Venue__c +'_Lead_Count'; 
                customSettRecAssignedStatus = l.Meeting_Venue__c +'_Lead_Assigned_Status';
                
                Map<String,LastLeadAssignedDesigner__c> roleTOLastUsernumber = LastLeadAssignedDesigner__c.getAll();
                
                Decimal assignedLeadCount = roleTOLastUsernumber.get(customSettRecleadcount).Number__c;                
                Integer leadcount; 
                
                if(assignedLeadCount == null)
                    roleTOLastUsernumber.get(customSettRecleadcount).Number__c = 0;           
                
                leadcount = (Integer)roleTOLastUsernumber.get(customSettRecleadcount).Number__c;                
                leadcount++;
                //==
                
                Decimal internalAssignedLeadStatus = roleTOLastUsernumber.get(customSettRecAssignedStatus).Number__c;                
                Integer internalAssignedStatus; 
                
                if(internalAssignedLeadStatus == null)
                    roleTOLastUsernumber.get(customSettRecAssignedStatus).Number__c = 0;           
                
                internalAssignedStatus = (Integer)roleTOLastUsernumber.get(customSettRecAssignedStatus).Number__c;
                //===
                system.debug(internalAssignedStatus );
                mapNumberToUser = null;
                listOfUserNumberSorted = null;
                
                if(math.mod(leadcount, 6) == 0 && grRoleUserMap.get(l.Meeting_Venue__c+'_Designers_Team').containsKey('Design Partner')){
                    if(grRoleUserMap.get(l.Meeting_Venue__c+'_Designers_Team').containsKey('Design Partner')){                    
                        
                        mapNumberToUser = new Map<Integer,User>();
                        
                        for(User u : grRoleUserMap.get(l.Meeting_Venue__c+'_Designers_Team').get('Design Partner')){
                            mapNumberToUser.put(Integer.valueof(u.UserNumber2__c), u);
                        }
                        
                        listOfUserNumberSorted = New List<Integer>(mapNumberToUser.keyset());
                        listOfUserNumberSorted.sort();                    
                        
                        customSettRec = l.Meeting_Venue__c +'_Design_Partner'; 
                        Decimal lastDP = roleTOLastUsernumber.get(customSettRec).Number__c;
                        Integer lastDPUserNumber = 0;
                        
                        if(lastDP != null)
                            lastDPUserNumber = (Integer)roleTOLastUsernumber.get(customSettRec).Number__c;
                        
                        Integer index = listOfUserNumberSorted.indexOf(lastDPUserNumber);
                        
                        IF(index==-1||index ==listOfUserNumberSorted.size()-1){
                            index = 0;                        
                            l.Designer__c = mapNumberToUser.get(listOfUserNumberSorted.get(index)).id;
                            lastDPUserNumber = listOfUserNumberSorted.get(index);
                            //index++;     //??               
                        }else{
                            index++;
                            l.Designer__c = mapNumberToUser.get(listOfUserNumberSorted.get(index)).id;
                            lastDPUserNumber = listOfUserNumberSorted.get(index);
                        }
                        
                        roleTOLastUsernumber.get(customSettRec).Number__c = lastDPUserNumber;
                        roleTOLastUsernumber.get(customSettRecleadcount).Number__c = leadcount; 
                        For(LastLeadAssignedDesigner__c custSetObj:LastLeadAssignedDesigner__c.getAll().values()){
                            
                            If(roleTOLastUsernumber.containskey(custSetObj.Name)){                        
                                custSetObj.Number__c = roleTOLastUsernumber.get(custSetObj.Name).Number__c;
                                listOfcustomSettingTobeupdated.add(custSetObj);
                            }                    
                        }                   
                    }
                }else{                    
                system.debug('Else Here');
                    Decimal lastTL= NULL;
                    Integer lastTLUserNumber,indexTL;
                    
                    Decimal lastSD;
                    Integer lastSDUserNumber,indexSD;
                    
                    //===
                    if(grRoleUserMap.get(l.Meeting_Venue__c+'_Designers_Team').containsKey('Design Team Lead')){
                    mapNumberToUserTL = new Map<Integer,User>();                   
                    for(User u : grRoleUserMap.get(l.Meeting_Venue__c+'_Designers_Team').get('Design Team Lead')){
                        mapNumberToUserTL.put(Integer.valueof(u.UserNumber2__c), u);
                    }                   
                    listOfUserNumberSortedTL = New List<Integer>(mapNumberToUserTL.keyset());
                    listOfUserNumberSortedTL.sort(); 
                    customSettRecTL = l.Meeting_Venue__c +'_Design_Team_Lead'; 
                    lastTL = roleTOLastUsernumber.get(customSettRecTL).Number__c;
                    lastTLUserNumber = 0;                    
                    if(lastTL != null)
                        lastTLUserNumber = (Integer)roleTOLastUsernumber.get(customSettRecTL).Number__c;                   
                    indexTL = listOfUserNumberSortedTL.indexOf(lastTLUserNumber);  
                    }
                    //====
                    if(grRoleUserMap.get(l.Meeting_Venue__c+'_Designers_Team').containsKey('Designer')){
                    mapNumberToUserSD = new Map<Integer,User>();
                    for(User u : grRoleUserMap.get(l.Meeting_Venue__c+'_Designers_Team').get('Designer')){
                        mapNumberToUserSD.put(Integer.valueof(u.UserNumber2__c), u);
                    }
                    listOfUserNumberSortedSD = New List<Integer>(mapNumberToUserSD.keyset());
                    listOfUserNumberSortedSD.sort();
                    customSettRecSD = l.Meeting_Venue__c +'_Designer'; 
                    lastSD = roleTOLastUsernumber.get(customSettRecSD).Number__c;
                    lastSDUserNumber = 0;                    
                    if(lastSD != null)
                        lastSDUserNumber = (Integer)roleTOLastUsernumber.get(customSettRecSD).Number__c;                    
                    indexSD = listOfUserNumberSortedSD.indexOf(lastSDUserNumber);
                    }
                    //*****************************************************************
                    
                    IF(indexTL==-1 && grRoleUserMap.get(l.Meeting_Venue__c+'_Designers_Team').containsKey('Design Team Lead')){
                        indexTL = 0;                        
                        l.Designer__c = mapNumberToUserTL.get(listOfUserNumberSortedTL.get(indexTL)).id;
                        lastTLUserNumber = listOfUserNumberSortedTL.get(indexTL);                                            
                    }                    
                    else if(grRoleUserMap.get(l.Meeting_Venue__c+'_Designers_Team').containsKey('Design Team Lead') && indexTL == listOfUserNumberSortedTL.size()-1){
                        
                        IF(indexSD==-1 && grRoleUserMap.get(l.Meeting_Venue__c+'_Designers_Team').containsKey('Designer')){
                            indexSD = 0;                        
                            l.Designer__c = mapNumberToUserSD.get(listOfUserNumberSortedSD.get(indexSD)).id;
                            lastSDUserNumber = listOfUserNumberSortedSD.get(indexSD);                                                    
                        }else if(grRoleUserMap.get(l.Meeting_Venue__c+'_Designers_Team').containsKey('Designer') && indexSD == listOfUserNumberSortedSD.size()-1){                            
                            if(internalAssignedStatus ==0){
                                internalAssignedStatus = 1;
                                indexTL = 0;                        
                                l.Designer__c = mapNumberToUserTL.get(listOfUserNumberSortedTL.get(indexTL)).id;
                                lastTLUserNumber = listOfUserNumberSortedTL.get(indexTL);  
                            }else{
                                internalAssignedStatus = 0;
                                indexSD = 0; 
                                l.Designer__c = mapNumberToUserSD.get(listOfUserNumberSortedSD.get(indexSD)).id;
                                lastSDUserNumber = listOfUserNumberSortedSD.get(indexSD); 
                            }
                        }else if(grRoleUserMap.get(l.Meeting_Venue__c+'_Designers_Team').containsKey('Designer')){
                            indexSD++;
                            l.Designer__c = mapNumberToUserSD.get(listOfUserNumberSortedSD.get(indexSD)).id;
                            lastSDUserNumber = listOfUserNumberSortedSD.get(indexSD);
                        }else{
                              indexTL = 0;                        
                              l.Designer__c = mapNumberToUserTL.get(listOfUserNumberSortedTL.get(indexTL)).id;
                              lastTLUserNumber = listOfUserNumberSortedTL.get(indexTL);
                        }                            
                    }else if(grRoleUserMap.get(l.Meeting_Venue__c+'_Designers_Team').containsKey('Design Team Lead')){
                        indexTL++;
                        l.Designer__c = mapNumberToUserTL.get(listOfUserNumberSortedTL.get(indexTL)).id;
                        lastTLUserNumber = listOfUserNumberSortedTL.get(indexTL);
                    }else if(grRoleUserMap.get(l.Meeting_Venue__c+'_Designers_Team').containsKey('Design Team Lead') == false && grRoleUserMap.get(l.Meeting_Venue__c+'_Designers_Team').containsKey('Designer')){
                        IF(indexSD==-1 || indexSD == listOfUserNumberSortedSD.size()-1){
                            indexSD = 0;                        
                            l.Designer__c = mapNumberToUserSD.get(listOfUserNumberSortedSD.get(indexSD)).id;
                            lastSDUserNumber = listOfUserNumberSortedSD.get(indexSD);                                                    
                        }else{
                            indexSD++;
                            l.Designer__c = mapNumberToUserSD.get(listOfUserNumberSortedSD.get(indexSD)).id;
                            lastSDUserNumber = listOfUserNumberSortedSD.get(indexSD);
                        }
                    }else{}                   
                    
                    if(customSettRecTL != NULL)
                    roleTOLastUsernumber.get(customSettRecTL).Number__c = lastTLUserNumber;
                    if(customSettRecSD != NULL)
                    roleTOLastUsernumber.get(customSettRecSD).Number__c = lastSDUserNumber;
                    roleTOLastUsernumber.get(customSettRecleadcount).Number__c = leadcount;
                    roleTOLastUsernumber.get(customSettRecAssignedStatus).Number__c = internalAssignedStatus;
                    
                    For(LastLeadAssignedDesigner__c custSetObj:LastLeadAssignedDesigner__c.getAll().values()){
                        
                        If(roleTOLastUsernumber.containskey(custSetObj.Name)){                        
                            custSetObj.Number__c = roleTOLastUsernumber.get(custSetObj.Name).Number__c;
                            listOfcustomSettingTobeupdated.add(custSetObj);
                        }                       
                    }
                }
                
                IF(listOfcustomSettingTobeupdated.size()>0){
                    database.update(listOfcustomSettingTobeupdated);
                }               
            }
            system.debug(l.Designer__c);
            if(l.Designer__c != null && (l.Has_Designer_Accepted__c == 'Designer Not Assigned' || l.Designer__c != oldMap.get(l.Id).Designer__c)) {
                l.Has_Designer_Accepted__c = 'Designer Assigned, Acceptance Pending';
            }
        }
    }    
}
 */