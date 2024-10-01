global class UpdatePMRelatedRecords implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {
    global List<ID> projectList1;
    global List<CSVDataToUpdate__c> updatedList;
    private Boolean mRunMilestoneCompletion=true;
    private Boolean mUpdateProjectSchedule=true;
    private Boolean mBypassOppClosedWonCheck=false;
    
    global UpdatePMRelatedRecords() {
        projectList1 = new List<Id>();
        updatedList = new List<CSVDataToUpdate__c>();
    }
    
    global UpdatePMRelatedRecords(Boolean aRunMilestoneCompletion, Boolean aUpdateProjectSchedule, Boolean aBypassOppClosedWonCheck) {
        projectList1 = new List<Id>();
        updatedList = new List<CSVDataToUpdate__c>();
        mRunMilestoneCompletion = aRunMilestoneCompletion;
        mUpdateProjectSchedule = aUpdateProjectSchedule;
        mBypassOppClosedWonCheck = aBypassOppClosedWonCheck;
    }
    
    private Map<String, String> getAllFields(String sobjectname) {
        List<String> accessiblefields = new List<String>();
        Map<String, Schema.SObjectField> fields = Schema.getGlobalDescribe().get(sobjectname).getDescribe().SObjectType.getDescribe().fields.getMap();
        
        for(Schema.SObjectField field : fields.values()) {
            if(field.getDescribe().isAccessible()) {
                accessiblefields.add(field.getDescribe().getName());
            }
        }
        
        String allfields='';
        
        for(String fieldname : accessiblefields) {
            allfields += fieldname+',';
        }
        
        allfields = allfields.subString(0, allfields.length() - 1);
        return new Map<String, String>{sobjectname => allfields};
	}
    
    private static OpportunityTeamMember createOpportunityTeamMember( String oppId, String userId, String role) {
        OpportunityTeamMember oppTeam = new OpportunityTeamMember();
        oppTeam.TeamMemberRole = role;
        oppTeam.OpportunityId = oppId;
        oppTeam.UserId = userId;
        oppTeam.OpportunityAccessLevel = 'Edit';
        return oppTeam;
    }
    
    public static void opportunityTeamMemberWithDesigner( List<Opportunity> oppts) {
        Set<Id> setOfOppId = new Set<Id>();
        List<OpportunityTeamMember> listOfOppTeamMember = new List<OpportunityTeamMember>();
        
        for(Opportunity opp : oppts) {
            if(opp.Designer__c != null) {
                setOfOppId.add(opp.id);
            }
        }
        
        for(Opportunity opp : [Select id, Designer__c,Designer__r.ManagerId from Opportunity where id in:setOfOppId]) {
            listOfOppTeamMember.add(createOpportunityTeamMember(opp.id, opp.Designer__c, 'Designer'));
            
            if(String.isNotBlank(opp.Designer__r.ManagerId)) {
            	listOfOppTeamMember.add(createOpportunityTeamMember(opp.id, opp.Designer__r.ManagerId ,'Design Team Lead'));
            }
        }
        
        if(listOfOppTeamMember.size() > 0) {
            Database.insert(listOfOppTeamMember,False);
        }
    }
    
    global Database.querylocator start(Database.BatchableContext BC){
        String query = 'SELECT ' + getAllFields('CSVDataToUpdate__c').get('CSVDataToUpdate__c') + ' FROM CSVDataToUpdate__c where Status__c = false';
        System.debug('Start >> query>>' + query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        String ErrorLog = '';
        System.debug('In Execute>>' + scope);
        
        set<ID> accids = new Set<Id>();
        Map<String, CSVDataToUpdate__c> accountToCSVMap = new Map<String, CSVDataToUpdate__c>();
        
        for(sObject s : scope) {
            CSVDataToUpdate__c data = (CSVDataToUpdate__c)s;
            
            if(String.isNotBlank(data.Person_Account_ID__c)) {
                accountToCSVMap.put(data.Person_Account_ID__c, data);
            }
            else {
                ErrorLog = ErrorLog + '* Acc ID Not Match';
            }
        }    
        
        List<Opportunity> wonOpptsToUpdate = new List<Opportunity>();
        List<Opportunity> wonOppforProject = new List<Opportunity>();
        Map<Id, Opportunity> wonOppforProjectMap = new Map<Id, Opportunity>();
        Decimal [] lProjectValues = new List<Decimal>();
        DateTime [] lSignUpDatesOfProjects = new List<DateTime>();
        Boolean toUpdate,okForProject;
        
        if(accountToCSVMap.keySet() != null && accountToCSVMap.keySet().size() > 0) {
            System.debug('accountToCSVMap>>'+accountToCSVMap);
            Opportunity [] oppts = [SELECT Id, Name, AccountId, Designer__c, Region__c, StageName, Amount, X1st_Meeting_Date__c, X1st_Meeting_Person__c,
                                    CloseDate FROM Opportunity WHERE AccountId IN :accountToCSVMap.keySet()];
            
            if(oppts.size() > 0) {
                for(Opportunity op : oppts) {
                    toUpdate = false;
                    okForProject = true; 
                    System.debug('Opp Stage>>'+ op.StageName);
                    
                    if(op.StageName == 'Closed Won' || mBypassOppClosedWonCheck == true) {
                        if(accountToCSVMap.get(op.AccountId).Designer__c != NULL ) {
                            okForProject = false;
                            op.Designer__c = accountToCSVMap.get(op.AccountId).Designer__c;
                            toUpdate = true;
                        }
                        else {
                            if(op.Designer__c != NULL) {
                                okForProject = true;
                            }
                            else {
                                ErrorLog = ErrorLog + '* Opp ' + op.Name + ' Designer is already there but not in CSV,';                                
                                toUpdate = false;
                                continue;
                            }
                        }
                        
                        if(accountToCSVMap.get(op.AccountId).Five_Percent_Amount_paid__c != NULL) {
                            okForProject = false;
                            op.Signup_Amount__c = accountToCSVMap.get(op.AccountId).Five_Percent_Amount_paid__c;
                            toUpdate = true;
                        }
                        else {                              
                            ErrorLog = ErrorLog + '* Opp '+op.Name+' Sign up amount not is not there in csv';                                
                            toUpdate = false;
                            continue;                                
                        }
                        
                        if(op.Signup_Amount__c == NULL || op.Signup_Amount__c != NULL){
                            okForProject = false;
                            if(accountToCSVMap.get(op.AccountId).Five_Percent_Amount_paid__c != NULL ){
                                op.Signup_Amount__c = accountToCSVMap.get(op.AccountId).Five_Percent_Amount_paid__c;
                                toUpdate = true;
                            }
                            else{                                
                                ErrorLog = ErrorLog + '* Opp '+op.Name+' Amount is already there';                                
                                toUpdate = false;
                                continue; 
                            }
                        }
                        
                        if(op.Region__c == NULL){
                            okForProject = false;
                            if(accountToCSVMap.get(op.AccountId).City__c != NULL ){
                                op.Region__c = accountToCSVMap.get(op.AccountId).City__c;
                                toUpdate = true;
                            }
                            else{                                
                                ErrorLog = ErrorLog + '* Opp '+op.Name+' City is not there in opp and CSV,';                                
                                toUpdate = false;
                                continue; 
                            }
                        }
                        if(op.X1st_Meeting_Person__c == NULL){  
                            okForProject = false;
                            if(accountToCSVMap.get(op.AccountId).Designer__c != NULL ){
                                op.X1st_Meeting_Person__c = accountToCSVMap.get(op.AccountId).Designer__c;
                                toUpdate = true;
                            }
                            else{                               
                                ErrorLog = ErrorLog + '* Opp '+op.Name+' 1st meeting person is not there in opp and CSV,';                                
                                toUpdate = false;
                                continue; 
                            }                            
                        }
                        if(op.X1st_Meeting_Date__c == NULL){
                            okForProject = false;
                            if(accountToCSVMap.get(op.AccountId).Sign_up_date__c != NULL ){
                                op.X1st_Meeting_Date__c = accountToCSVMap.get(op.AccountId).Sign_up_date__c;
                                toUpdate = true;
                            }
                            else{                                
                                ErrorLog = ErrorLog + '* Opp '+op.Name+' 1st meeting date is not there in opp and CSV,';                                
                                toUpdate = false;
                                continue; 
                            }
                        } 
                        /*
                        if(op.CloseDate != accountToCSVMap.get(op.AccountId).Sign_up_date__c){ 
                            okForProject = false;
                            if(accountToCSVMap.get(op.AccountId).Sign_up_date__c != NULL ){
                                //op.CloseDate = accountToCSVMap.get(op.AccountId).Sign_up_date__c;
                                //toUpdate = true;                                
                                ErrorLog = ErrorLog + '* Opp '+op.Name+' Close date is already there but not Matching';                                
                            }
                            else{                                
                                ErrorLog = ErrorLog + '* Opp '+op.Name+' Close Date is already there';                                
                                toUpdate = false;
                                continue; 
                            }
                        } 
                        */
                        
                        
                        if(toUpdate) {
                            wonOpptsToUpdate.add(op); 
                            wonOppforProjectMap.put(op.Id, op);
                            lProjectValues.add(accountToCSVMap.get(op.AccountId).Sign_up_project_value__c);
            				lSignUpDatesOfProjects.add(DateTime.newInstance(accountToCSVMap.get(op.AccountId).Sign_up_date__c, Time.newInstance(10, 0, 0, 0)));
                        }
                        
                        if(okForProject) {
                            wonOppforProject.add(op);
                            wonOppforProjectMap.put(op.Id, op);
                            lProjectValues.add(accountToCSVMap.get(op.AccountId).Sign_up_project_value__c);
            				lSignUpDatesOfProjects.add(DateTime.newInstance(accountToCSVMap.get(op.AccountId).Sign_up_date__c, Time.newInstance(10, 0, 0, 0)));
                        }
                    }
                    else {
                        ErrorLog = ErrorLog + '* Opp ' + op.Name + ' is not Won';
                    }
                }
                
                if(String.isNotBlank(ErrorLog)) {
                    saveErrorDetails(scope[0], ErrorLog);
                    return;
                }
                
                Savepoint sp = Database.setSavepoint();
                
                if(wonOpptsToUpdate.size() > 0) {
                    try {
                        update wonOpptsToUpdate;
                        wonOppforProject.addAll(wonOpptsToUpdate);
                    }
                    catch(Exception e) {
                        ErrorLog = ErrorLog + '*Exception on update wonOpptsToUpdate::'+e.getMessage();  
                    }
                }
                else {
                    ErrorLog = ErrorLog + '* Opportunities is not change';                    
                }
                
                if(String.isNotBlank(ErrorLog)) {
                    Database.RollBack(sp);
                    saveErrorDetails(scope[0], ErrorLog);
                    return;
                }
                
                if(wonOppforProject.size() > 0) {
                    try {
                        opportunityTeamMemberWithDesigner(wonOppforProject);
                    }
                    catch(Exception e) {
                        ErrorLog = ErrorLog + '** EXCEPTION on call opportunityTeamMemberWithDesigner(wonOppforProject) ::'+ e.getMessage();
                        Database.RollBack(sp);
                        saveErrorDetails(scope[0], ErrorLog);
                        return;
                    }
                    
                    Milestone1_Project__c [] Projects = new List<Milestone1_Project__c>();
                    
                    try {
                        Projects = ProjectManagementUtility.cloneProject(wonOppforProject, lSignUpDatesOfProjects, lProjectValues);
                    }
                    catch(Exception e) {
                        ErrorLog = ErrorLog + '** EXCEPTION on call ProjectManagementUtility.cloneProject() ::'+ e.getMessage();
                        Database.RollBack(sp);
                        saveErrorDetails(scope[0], ErrorLog);
                        return;
                   	}
                    
                    Set<Id> projectIds = new Set<Id>();
                        
                    if(Projects.size() == 0) {
                        ErrorLog = ErrorLog + '** cloning bypassed the Project Creation.';
                        Database.RollBack(sp);
                        saveErrorDetails(scope[0], ErrorLog);
                        return;
                    }
                     
                    for(Milestone1_Project__c p : Projects) {
                        CSVDataToUpdate__c csvData = accountToCSVMap.get(wonOppforProjectMap.get(p.Opportunity__c).AccountId);
                        projectIds.add(p.Id);
                        csvData.Project__c = p.Id;
                        updatedList.add(csvData);
                        projectList1.add(p.Id);
                        p.Status__c = csvData.Project_Status__c;
                        p.Is_Designer_Assigned__c = 'Yes';
                        
                        if(mUpdateProjectSchedule == true) {
                            p.First_Cut_Presentation_Date__c = csvData.First_cut_presentation_date_if_done__c != NULL ? csvData.First_cut_presentation_date_if_done__c :p.First_Cut_Presentation_Date__c;
                            p.X3D_Presentation_Date__c = csvData.Three_d_presentation_date_if_done__c != NULL ? csvData.Three_d_presentation_date_if_done__c :p.X3D_Presentation_Date__c;
                          p.Design_Finalization_Date__c = csvData.Design_sign_off_date__c != NULL ? csvData.Design_sign_off_date__c :p.Design_Finalization_Date__c;
                        }
                    }
						
                    try {
                        update Projects;
                    }
                    catch(Exception e) {
                        ErrorLog = ErrorLog + '** EXCEPTION on Update Projects ::'+ e.getMessage();
                        Database.RollBack(sp);
                        saveErrorDetails(scope[0], ErrorLog);
                        return;
                    }
                    
                    if(mRunMilestoneCompletion == true) {
                        Map<ID, List<Milestone1_Milestone__c>> projTOMiles = new  Map<ID, List<Milestone1_Milestone__c>>();
                        List<Milestone1_Milestone__c> Miles = [select Id, Name, Project__c, Complete__c, Project__r.Design_Finalization_Date__c, Project__r.X3D_Presentation_Date__c, Project__r.First_Cut_Presentation_Date__c, (select id, Minutes_of_Meeting__c from Project_Artifacts__r where Status__c = 'Draft' Limit 1) from Milestone1_Milestone__c where Project__c IN :projectIds];
                        
                        if(Miles != null && Miles.size() > 0) {
                            for(Milestone1_Milestone__c mi : Miles) {
                                if(projTOMiles.get(mi.Project__c) != null) {
                                    projTOMiles.get(mi.Project__c).add(mi);
                                }
                                else {
                                    projTOMiles.put(mi.Project__c, new List<Milestone1_Milestone__c> {mi});
                                }
                            }
                        }
                       
                        List<Milestone1_Milestone__c> Miles1 = new List<Milestone1_Milestone__c>();                                    
                        Project_Artifact__c artif;
                        List<Project_Artifact__c> palist = new List<Project_Artifact__c>();
                        List<Project_Artifact__c> palistUpdate = new List<Project_Artifact__c>();
                        Payment__c pay;
                        List<Payment__c> paylist = new List<Payment__c>();
                                    
                        for(Milestone1_Project__c p : Projects) {
                            CSVDataToUpdate__c csvData = accountToCSVMap.get(wonOppforProjectMap.get(p.Opportunity__c).AccountId);
                            
                            if(csvData.Fifteen_percent_amount_paid__c != NULL) {
                                List<Milestone1_Milestone__c> mis = projTOMiles.get(p.Id);                                   
                                
                                for(Milestone1_Milestone__c mi : mis) {
                                    if( mi.Name == 'Know Your Client (KYC)') {
                                        artif = new Project_Artifact__c(Project__c = mi.Project__c, Project_Milestone__c = mi.Id, Status__c = 'Draft', Minutes_of_Meeting__c= 'MOM');
                                        palist.add(artif);
                                        mi.Complete__c = true;
                                        Miles1.add(mi);
                                    }
                                    
                                    if(mi.Name =='First Cut Presentation' || mi.Name =='Second Cut Presentation') {
                                        for(Project_Artifact__c paf : mi.Project_Artifacts__r) {
                                            paf.Minutes_of_Meeting__c = 'MOM';
                                            palistUpdate.add(paf);
                                        }
                                        
                                        mi.Actual_Completion_Date__c = csvData.First_cut_presentation_date_if_done__c;
                                        mi.Complete__c = true;  
                                        Miles1.add(mi);	
                                    }
                                            
                                    if(mi.Name == 'Design Finalization') {
                                        if(csvData.Fifteen_percent_amount_paid__c != NULL){
                                            pay = new Payment__c(Milestone__c = mi.Id, Amount__c = csvData.Fifteen_percent_amount_paid__c, Payment_Received_Date__c=csvData.Fifteen_Percent_amount_paid_date_if_done__c, Mode__c = 'Online');
                                            paylist.add(pay);
                                            mi.Complete__c = true;  
                                            Miles1.add(mi);	
                                        }    
                                    }
                                    
                                    if( mi.Name == 'Customer Site Survey' || mi.Name == 'Complete Customer Onboarding' || mi.Name =='Create 3D Shell' || mi.Name =='Design Finalization - Payment Checkpoint' ){
                                        mi.Complete__c = true; 
                                        Miles1.add(mi);                                            
                                    }
                                }                                  
                            }
                            else if(csvData.First_cut_presentation_date_if_done__c != NULL) {
                                List<Milestone1_Milestone__c> mis = projTOMiles.get(p.Id);
                                
                                for(Milestone1_Milestone__c mi : mis) {
                                    if(mi.Name =='First Cut Presentation') {
                                        for(Project_Artifact__c paf : mi.Project_Artifacts__r) {
                                            paf.Minutes_of_Meeting__c = 'MOM';
                                            palistUpdate.add(paf);
                                        }
                                        
                                        mi.Actual_Completion_Date__c = csvData.First_cut_presentation_date_if_done__c;
                                        mi.Complete__c = true;
                                        Miles1.add(mi);
                                    }
                                    
                                    if(mi.Name == 'Customer Site Survey' || mi.Name == 'Complete Customer Onboarding' || mi.Name =='Create 3D Shell') {
                                        mi.Complete__c = true;
                                        Miles1.add(mi);
                                    }
                                    
                                    if(mi.Name == 'Know Your Client (KYC)') {
                                        artif = new Project_Artifact__c(Project__c = mi.Project__c, Project_Milestone__c = mi.Id, Status__c = 'Draft', Minutes_of_Meeting__c= 'MOM');
                                        palist.add(artif);
                                        mi.Complete__c = true;
                                        Miles1.add(mi);
                                    }
                                }
                            }
                        }
                        
                        try {
                            if(paylist.size() > 0) {
                                insert paylist;
                            }
                        }
                        catch(Exception e) {
                            ErrorLog = ErrorLog + '** EXCEPTION on insert PayMent List ::'+ e.getMessage();
                            Database.RollBack(sp);
                            saveErrorDetails(scope[0], ErrorLog);
                            return;
                        }
                        
                        try {
                            List<Project_Artifact__c> lArtifactFinalList = new List<Project_Artifact__c>();
                            lArtifactFinalList.addAll(palistUpdate);
                            lArtifactFinalList.addAll(palist);
                            
                            if(lArtifactFinalList.size() > 0) {
                                upsert lArtifactFinalList;
                            }
                        }
                        catch(Exception e) {
                            ErrorLog = ErrorLog + '** EXCEPTION on upsert of Artifacts' + e.getMessage();
                            Database.RollBack(sp);
                            saveErrorDetails(scope[0], ErrorLog);
                            return;
                        }
                            
                        try {
                            if(Miles1.size() > 0) {
                                update Miles1;
                            }
                        }
                        catch(Exception e) {
                            ErrorLog = ErrorLog + '** EXCEPTION on Update Milestone List ::'+ e.getMessage();
                            Database.RollBack(sp);
                            saveErrorDetails(scope[0], ErrorLog);
                            return;
                        }
                    }
                }
            }
            else {
                ErrorLog = ErrorLog + '* No Projects is there for opp list ' + wonOppforProject;
            }
        }
        
        if(updatedList != null && updatedList.size() > 0) {
            update updatedList;
        }
		
        saveErrorDetails(scope[0], ErrorLog);
    }
    
    private void saveErrorDetails(SObject aRec, String aErrMsg) {
        CSVDataToUpdate__c data = (CSVDataToUpdate__c)aRec;
        update new CSVDataToUpdate__c(id=data.id, Data_Update_Status_Comments__c = aErrMsg, Status__c = true);
    }
    
    global void finish(Database.BatchableContext BC) { 
        if(projectList1 != NULL && projectList1.size() > 0) {
            Database.executeBatch(new ProjectTeamMemberShareBatch(projectList1), 1);
        }
    }
}