public without sharing class ProjectMemberRoundRobinAsync implements Queueable {
    private class RRProcessData {
        Map<String, List<User>> mapRegionToUserCHM = new Map<String, List<User>>();
        Map<String, List<User>> mapRegionToUserSurvey = new Map<String, List<User>>();
        Map<String, List<User>> mapRegionToUser3DShell = new Map<String, List<User>>();
        Map<String, List<Milestone1_Project__c>> regionToProjectMap = new Map<String, List<Milestone1_Project__c>>();
    }
    
    private String mUserRole;
    private Queueable mChildToSpawn = null;
    private RRProcessData mProcessData = new RRProcessData();
    private Map<ID, Milestone1_Project__c> mIDToProjectMap = new Map<ID, Milestone1_Project__c>();
    
    public ProjectMemberRoundRobinAsync(Map<ID, Milestone1_Project__c> aIDToProjectMap, Queueable aChildToSpawn) {
        mIDToProjectMap.putAll(aIDToProjectMap);
        mChildToSpawn = aChildToSpawn;
    }
    
    private ProjectMemberRoundRobinAsync(RRProcessData aProcessData, Queueable aChildToSpawn, String aUserRole) {
        mUserRole = aUserRole;
        mProcessData = aProcessData;
        mChildToSpawn = aChildToSpawn;
    }
    
    public void execute(QueueableContext context) {
        Application_Settings__c recordOwner = Application_Settings__c.getValues('CRASH_RECORD_OWNER');
        try {
            runRoundRobin();
        }
        catch(Exception e) {
            // #2. Send error email
            if(recordOwner != Null){
                Database.insert(new Error_Log__c(Error_Message__c=e.getMessage(),Error_Type__c='Project Round-robin', OwnerId=recordOwner.value__c),false);
            }
        }
    }
    
    private void runRoundRobin() {
        if(String.isBlank(mUserRole)) {
            Application_Settings__c lSetting1 = Application_Settings__c.getValues('PROJECT_TEAM_MEMBER_ROUND_ROBIN');
            
            if(lSetting1 == null || String.isBlank(lSetting1.Value__c) || lSetting1.Value__c.equalsIgnoreCase('true')) {
                buildProcessData();
                mChildToSpawn = new ProjectMemberRoundRobinAsync(mProcessData, mChildToSpawn, 'Customer Happiness Manager');
            }
        }
        else {
            if(mUserRole == '3D Shell Designer') {
                runProjectTeamMemberAssignment(mProcessData.mapRegionToUser3DShell, mProcessData.regionToProjectMap, '3D Shell Designer');
            }
            else if(mUserRole == 'Survey Manager') {
                runProjectTeamMemberAssignment(mProcessData.mapRegionToUserSurvey, mProcessData.regionToProjectMap, 'Survey Manager');
            }
            else if(mUserRole == 'Customer Happiness Manager') {
                runProjectTeamMemberAssignment(mProcessData.mapRegionToUserCHM, mProcessData.regionToProjectMap, 'Customer Happiness Manager');
            }            
        }
        
        if(mChildToSpawn != null) {
            System.enqueueJob(mChildToSpawn);
        }
    }
    
    public void buildProcessData() {
        List<String> roleList = New List<String> {
            DesignCafeConstants.ROLE_CHM, DesignCafeConstants.ROLE_Survey, 
            DesignCafeConstants.ROLE_3DShellDesigner
        };
            
        for(Id projectId : mIDToProjectMap.keySet()) {
            Milestone1_Project__c lProject = mIDToProjectMap.get(projectId);
            
            if(String.isBlank(lProject.Region__c)) {
                continue;
            }
            
            Milestone1_Project__c [] lProjects = mProcessData.regionToProjectMap.get(lProject.Region__c);
            
            if(lProjects == null) {
                lProjects = new List<Milestone1_Project__c>();
                mProcessData.regionToProjectMap.put(lProject.Region__c, lProjects);
            }
            
            lProjects.add(mIDToProjectMap.get(projectId));
        }
            
        for(User lUser : [Select id, Name, Region__c, UserNumber2__c, UserRole.Name FROM User WHERE IsActive=true AND UserRole.Name IN:roleList AND Region__c != null]) {
            List<String> multiSelectRegions = lUser.Region__c.split(';');
            
            for(String lRegion : multiSelectRegions) {
                if(lUser.UserRole.Name == DesignCafeConstants.ROLE_CHM) {
                    User [] lUserList = mProcessData.mapRegionToUserCHM.get(lRegion);
                    
                    if(lUserList == null) {
                        lUserList = new List<User>();
                        mProcessData.mapRegionToUserCHM.put(lRegion, lUserList);
                    }
                    
                    lUserList.add(lUser);
                }
                else if(lUser.UserRole.Name == DesignCafeConstants.ROLE_Survey) {
                    User [] lUserList = mProcessData.mapRegionToUserSurvey.get(lRegion);
                    
                    if(lUserList == null) {
                        lUserList = new List<User>();
                        mProcessData.mapRegionToUserSurvey.put(lRegion, lUserList);
                    }
                    
                    lUserList.add(lUser);
                }
                else if(lUser.UserRole.Name == DesignCafeConstants.ROLE_3DShellDesigner) {
                    User [] lUserList = mProcessData.mapRegionToUser3DShell.get(lRegion);
                    
                    if(lUserList == null) {
                        lUserList = new List<User>();
                        mProcessData.mapRegionToUser3DShell.put(lRegion, lUserList);
                    }
                    
                    lUserList.add(lUser);
                }
            }
        }
    }
    
	private void runProjectTeamMemberAssignment(Map<String, List<User>> mapRegionToUser, Map<String, List<Milestone1_Project__c>> regionToProjectMap, String roleUser) {
        Integer remainder = 0;
        Integer countOfLeads = 0;
        Integer maxProjectToBeAssigned = 0;
        Map<Integer, User> mapNumberToUser;
        Milestone1_Project__c [] projectToUpdate = new List<Milestone1_Project__c>();
        Project_Team_Member__c [] projectTeamToUpdate = new LIST<Project_Team_Member__c>();
        Map<String, Map<Integer, User>> regionUser = new Map<String, Map<Integer, User>>();
        List<TeamUserAssignmentNumber__c> listOfcustomSettingTobeupdated = New List<TeamUserAssignmentNumber__c>();
        
        for(String eachRegion : mapRegionToUser.keySet()) {
            mapNumberToUser = new Map<Integer, User>();
            
            for(User u : mapRegionToUser.get(eachRegion)) {
                mapNumberToUser.put(integer.valueof(u.UserNumber2__c), U);                
            }
            
            List<Integer> listOfUserNumberSorted = New List<Integer>(mapNumberToUser.keyset());
            listOfUserNumberSorted.sort();
            String roleUser_region = roleUser + ' ' + eachRegion; 
            Map<String, TeamUserAssignmentNumber__c> roleTOLastUsernumber = TeamUserAssignmentNumber__c.getAll();
            
            if(!roleTOLastUsernumber.containsKey(roleUser_region)) {
                continue;
            }
                
            Decimal tan = roleTOLastUsernumber.get(roleUser_region).LastAssignedUserNumber__c;
            Integer lastUserNumber = 0;
            
            if(tan != null) {
            	lastUserNumber = (Integer)roleTOLastUsernumber.get(roleUser_region).LastAssignedUserNumber__c;
            }
            
            Integer index = listOfUserNumberSorted.indexOf(lastUserNumber);
            
            Milestone1_Project__c [] lProjects = regionToProjectMap.get(eachRegion);
            
            if(lProjects == null || lProjects.size() == 0) {
                continue;
            }
            
            For(Milestone1_Project__c projObj : lProjects) {
                Project_Team_Member__c prc = new Project_Team_Member__c();
                prc.Project__c = projObj.id;                
                prc.Role__c = roleUser;
                
                IF(index==-1||index ==listOfUserNumberSorted.size() - 1) {
                    index = 0;
                    prc.User__c = mapNumberToUser.get(listOfUserNumberSorted.get(index)).id;
                    lastUserNumber = listOfUserNumberSorted.get(index);
                    index++;                    
                }
                else {
                    index++;
                    prc.User__c = mapNumberToUser.get(listOfUserNumberSorted.get(index)).id;
                    lastUserNumber = listOfUserNumberSorted.get(index);
                }
                
                projectTeamToUpdate.add(prc);
                roleTOLastUsernumber.get(roleUser_region).LastAssignedUserNumber__c = lastUserNumber;
                
                for(TeamUserAssignmentNumber__c custSetObj:TeamUserAssignmentNumber__c.getall().values()) {
                    if(roleTOLastUsernumber.containskey(custSetObj.Name)) {
                        custSetObj.LastAssignedUserNumber__c = roleTOLastUsernumber.get(custSetObj.Name).LastAssignedUserNumber__c;
                        listOfcustomSettingTobeupdated.add(custSetObj);
                    }                    
                }
            }           
        }
        
        if(projectTeamToUpdate.size() > 0) {
            insert projectTeamToUpdate;                            
        }   
        
         if(listOfcustomSettingTobeupdated.size() > 0) {
            database.update(listOfcustomSettingTobeupdated);
        } 
    }
}