/**
Created By - Jai Kumar
Created Date - 06/12/2019
Description - This class for Project Team Member funcrionality.
*/

public class ProjectTeamMemberHandler {
    // Method for update Manager and Customer_Contact when insert Project_Team_Member.
    public static void updateManagerAndCustomerOnPTMInsert(List<Project_Team_Member__c> ptmList){
    Set<Id> setOfPTMId = new Set<Id>();
    List<Project_Team_Member__c> ptmListToUpdate=new  List<Project_Team_Member__c>();
       for(Project_Team_Member__c ptmObj : ptmList){
             setOfPTMId.add(ptmObj.Id);
        }  
          
      if(setOfPTMId.size()>0){ 
        for(Project_Team_Member__c ptmObj :[select id,Role__c,Project__r.Customer__r.personContactId,User__r.ManagerId from Project_Team_Member__c where id in: setOfPTMId]){
            Project_Team_Member__c protmObj=new Project_Team_Member__c();
            protmObj.id=ptmObj.id;
            protmObj.Manager__c=ptmObj.User__r.ManagerId;
            protmObj.Customer_Contact__c=ptmObj.Project__r.Customer__r.personContactId;
            ptmListToUpdate.add(protmObj);
         }
       }      
       if(ptmListToUpdate.size()>0){
            update ptmListToUpdate;
       }
    }
     // Method for update Manager when Update User of Project_Team_Member.
     public static void updateManagerAndCustomerOnPTMUpdate(List<Project_Team_Member__c> ptmList, Map<Id,Project_Team_Member__c> objPtmMap){
       Set<Id> setOfPTMId = new Set<Id>();
       List<Project_Team_Member__c> ptmListToUpdate=new  List<Project_Team_Member__c>();
       for(Project_Team_Member__c ptmObj : ptmList){
         if(ptmObj.User__c!= objPtmMap.get(ptmObj.id).User__c){
             setOfPTMId.add(ptmObj.Id);
         }  
      }   
      if(setOfPTMId.size()>0){ 
        for(Project_Team_Member__c ptmObj :[select id,Role__c,Project__r.Customer__r.personContactId,User__r.ManagerId from Project_Team_Member__c where id in: setOfPTMId]){
            Project_Team_Member__c protmObj=new Project_Team_Member__c();
            protmObj.id=ptmObj.id;
            protmObj.Manager__c=ptmObj.User__r.ManagerId;
            ptmListToUpdate.add(protmObj);
         }
       }
      
         if(ptmListToUpdate.size()>0){
            update ptmListToUpdate;
         }
     
     }
    public static void updateCHMonProjectPTMInsert(List<Project_Team_Member__c> ptmList){
         map<id,string> mapOfUser = new map<id,string>();
        List<Id> listofuserids = new List<Id>();
        List<Milestone1_Project__c> milObjList=new  List<Milestone1_Project__c>();
        map<id,Milestone1_Project__c> mapOfIdWithProject = new map<id,Milestone1_Project__c>();
        
        Set<Id> userids = new Set<Id>();
        
        for(Project_Team_Member__c ptmObj : ptmList){
            userids.add(ptmObj.user__c);
        }
        
        Map<Id,User> userRegionMap = new Map<Id,User>([SELECT Id, Region__c,Team__c FROM User where ID IN :userids]);        
          
        
        for(Project_Team_Member__c ptmObj : ptmList) {
            if(ptmObj.User__c == null) {
                continue;
                
            }
            
            if(!mapOfIdWithProject.keyset().contains(ptmObj.Project__c)) {
                mapOfIdWithProject.put(ptmObj.Project__c,new Milestone1_Project__c(id=ptmObj.Project__c));
            }
             listofuserids.add(ptmObj.User__c);
            
            Milestone1_Project__c proObj = mapOfIdWithProject.get(ptmObj.Project__c);
           
            
            if(ptmObj.Role__c=='Customer Happiness Manager') {
                proObj.CHM__c=ptmObj.User__c;                
                proObj.CHM_Team__c = userRegionMap.get(ptmObj.User__c).Region__c;
               
            }
            
            if(ptmObj.Role__c == 'Primary Designer') {
                proObj.Designer__c =ptmObj.User__c;
                proObj.OwnerId = ptmObj.User__c;
                proObj.Design_Team_Name__c = userRegionMap.get(ptmObj.User__c).Team__c;
            }
            
            if(ptmObj.Role__c == 'Project Manager') {
                proObj.Project_Manager_Assigned__c = 'Yes';
            }
        }
        
        List<Milestone1_Milestone__c> milestonetoBeUpdated = new List<Milestone1_Milestone__c>();
        for(User usr : [select Id , email from User where Id IN :listofuserids AND email != NULL]){
            mapOfUser.put(usr.Id , usr.Email);
        }
       for(Milestone1_Milestone__c milestone : [select id,project__c,CHM_Email__c,Designer_Email__c from Milestone1_Milestone__c where  project__c IN :mapOfIdWithProject.Keyset() ]){
            if(mapOfIdWithProject.get(milestone.Project__c) != null && mapOfIdWithProject.get(milestone.Project__c).CHM__c != NULL){
                Id userId = mapOfIdWithProject.get(milestone.Project__c).CHM__c;
                if(mapOfUser.containsKey(userId)){
                    milestone.CHM_Email__c = mapOfUser.get(userId);
                }                
            } 
            
            if(mapOfIdWithProject.get(milestone.Project__c) != null && mapOfIdWithProject.get(milestone.Project__c).Designer__c != NULL){
                Id userId = mapOfIdWithProject.get(milestone.Project__c).Designer__c;
                if(mapOfUser.containsKey(userId)){
                    milestone.Designer_Email__c = mapOfUser.get(userId);
                }                
            }
		     milestonetoBeUpdated.add(milestone);       
        }
        
        if(milestonetoBeUpdated.size() >0){
            update milestonetoBeUpdated;
        }
        if(mapOfIdWithProject.values().Size()>0){
            update mapOfIdWithProject.values();
        }
    }
    
    public static void updateCHMonProjectPTMUpdate(List<Project_Team_Member__c> ptmList, Map<Id,Project_Team_Member__c> objPtmMap) {
	 map<id,string> mapOfUser = new map<id,string>();
        List<Id> listofuserids = new List<Id>();
        List<Milestone1_Project__c> milObjList=new  List<Milestone1_Project__c>();
        map<id,Milestone1_Project__c> mapOfIdWithProject = new map<id,Milestone1_Project__c>();
        Set<Id> userids = new Set<Id>();
        
        for(Project_Team_Member__c ptmObj : ptmList){
            userids.add(ptmObj.user__c);
        }
        
        Map<Id,User> userRegionMap = new Map<Id,User>([SELECT Id, Region__c,Team__c FROM User where id IN :userids]);        
          
        for(Project_Team_Member__c ptmObj : ptmList) {
            if(ptmObj.user__c !=objPtmMap.get(ptmObj.id).user__c) {
                if(!mapOfIdWithProject.keyset().contains(ptmObj.Project__c)) {
                    mapOfIdWithProject.put(ptmObj.Project__c,new Milestone1_Project__c(id=ptmObj.Project__c));
                }
                
                listofuserids.add(ptmObj.User__c);
                               
                Milestone1_Project__c proObj = mapOfIdWithProject.get(ptmObj.Project__c);
                
                if(ptmObj.Role__c=='Customer Happiness Manager') {
                    proObj.CHM__c=ptmObj.User__c;                    
                    proObj.CHM_Team__c = userRegionMap.get(ptmObj.User__c).Region__c;
                }
                
                if(ptmObj.Role__c=='Primary Designer') { 
                    proObj.Designer__c =ptmObj.User__c;
                    proObj.OwnerId = ptmObj.User__c;
                    proObj.Design_Team_Name__c = userRegionMap.get(ptmObj.User__c).Team__c;
                }
                
                if(ptmObj.Role__c == 'Project Manager') {
                    proObj.Project_Manager_Assigned__c = 'Yes';
                }
            }
            
        }
          List<Milestone1_Milestone__c> milestonetoBeUpdated = new List<Milestone1_Milestone__c>();
        for(User usr : [select Id , email from User where Id IN :listofuserids AND email != NULL]){
            mapOfUser.put(usr.Id , usr.Email);
        }
       for(Milestone1_Milestone__c milestone : [select id,project__c,CHM_Email__c,Designer_Email__c from Milestone1_Milestone__c where  project__c IN :mapOfIdWithProject.Keyset() ]){
            if(mapOfIdWithProject.get(milestone.Project__c) != null && mapOfIdWithProject.get(milestone.Project__c).CHM__c != NULL){
                Id userId = mapOfIdWithProject.get(milestone.Project__c).CHM__c;
                if(mapOfUser.containsKey(userId)){
                    milestone.CHM_Email__c = mapOfUser.get(userId);
                }                
            } 
            
            if(mapOfIdWithProject.get(milestone.Project__c) != null && mapOfIdWithProject.get(milestone.Project__c).Designer__c != NULL){
                Id userId = mapOfIdWithProject.get(milestone.Project__c).Designer__c;
                if(mapOfUser.containsKey(userId)){
                    milestone.Designer_Email__c = mapOfUser.get(userId);
                }                
            }
		     milestonetoBeUpdated.add(milestone);       
        }
        
        if(milestonetoBeUpdated.size() >0){
            update milestonetoBeUpdated;
        }
        if(mapOfIdWithProject.values().Size()>0){
            update mapOfIdWithProject.values();
        }
        
         
        
        
    }
    // Share Project tean member with Project Group.
    public static void shareRecordDefaultProjectGroup(List<Project_Team_Member__c> ptmList){
        Set<Id> setOfProjectTeamId = new Set<Id>();
        Map<String,Id> mapOfGroupNameProjectTeamId = New Map<String,Id>();
        List<GroupMember>listGroupMember =new List<GroupMember>();  
        Set<Id> setOfUserId =new  Set<Id>();
        Set<Id> setOfOldUserId =new  Set<Id>();
        
        For(Project_Team_Member__c projectTeam :ptmList){
            if(projectTeam.Project__c!=null){
                setOfProjectTeamId.add(projectTeam.id);
                
            }
        }
        
        for(Project_Team_Member__c proTeamObj: [Select id,User__c,Project__r.Project_Number__c from Project_Team_Member__c where id in:setOfProjectTeamId]){
            if(proTeamObj.User__c!=null){
                setOfUserId.add(proTeamObj.User__c);
            }
            
            mapOfGroupNameProjectTeamId.put('PRJ-'+proTeamObj.Project__r.Project_Number__c,proTeamObj.Id);            
        }
        
        if(!System.isBatch()) {
            createGroupMemberFuture(mapOfGroupNameProjectTeamId,setOfUserId,setOfOldUserId);
        }
    }
    
    public static void shareRecordDefaultProjectGroupUpdate(List<Project_Team_Member__c> ptmList,Map<Id,Project_Team_Member__c> objPtmMap){
        Set<Id> setOfProjectTeamId = new Set<Id>();
        Map<String,Id> mapOfGroupNameProjectTeamId = New Map<String,Id>();
        Set<Id> setOfUserId =new  Set<Id>();
        Set<Id> setOfOldUserId =new  Set<Id>();
        Set<Id> setOfGroupId =new  Set<Id>();
        
        for(Project_Team_Member__c projectTeam :ptmList) {
            if(projectTeam.Project__c!=null) {
                setOfProjectTeamId.add(projectTeam.id);
            }
        }
        
        for(Project_Team_Member__c proTeamObj: [Select id,User__c,Project__r.Project_Number__c from Project_Team_Member__c where id in:setOfProjectTeamId]) {
            if(proTeamObj.User__c!=null && proTeamObj.User__c!= objPtmMap.get(proTeamObj.id).User__c ) {
                setOfUserId.add(proTeamObj.User__c);
                setOfOldUserId.add( objPtmMap.get(proTeamObj.id).User__c );
            }
            
            mapOfGroupNameProjectTeamId.put('PRJ-'+proTeamObj.Project__r.Project_Number__c,proTeamObj.Id);            
        }
        
        if(!System.isBatch()) {
            createGroupMemberFuture(mapOfGroupNameProjectTeamId,setOfUserId,setOfOldUserId);
        }
    }
    
    @future
    public static void createGroupMemberFuture(  Map<String,Id> mapOfGroupNameProjectTeamId, Set<Id> setOfUserId, Set<Id> setOfOldUserId){
       Set<Id> setOfGroupId =new  Set<Id>();
       List<GroupMember>listGroupMember =new List<GroupMember>();   
       For(group groupOb:[Select id,name from group where name in :mapOfGroupNameProjectTeamId.keyset()]){
          for (Id user : setOfUserId) {
                GroupMember gm= new GroupMember(); 
                gm.GroupId=groupOb.id;
                gm.UserOrGroupId = user;
                listGroupMember.add(gm);   
          } 
           setOfGroupId.add(groupOb.id);
        }  
          if(listGroupMember.size() > 0){
            insert listGroupMember;   
        }
        if(setOfOldUserId.size()>0 && setOfGroupId.size()>0){  
            List<GroupMember> ListGM  = [ Select Id from GroupMember where UserOrGroupID in :setOfOldUserId and GroupId  in :setOfGroupId ];
            
              if(listGroupMember.size() > 0){
                  delete ListGM;
              }
        } 
      }   
 }