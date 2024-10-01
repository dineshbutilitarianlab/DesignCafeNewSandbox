public class MilestoneQuickActionController {
    
    @auraEnabled
    public static void assignDesigner(String recId){
        try{
            Milestone1_Project__c Milestone=[SELECT Id, Is_Designer_Assigned__c 
                                             FROM Milestone1_Project__c
                                             WHERE Id = :recId];
            Milestone.Is_Designer_Assigned__c='Yes';
            update Milestone;
            Project_Team_Member__c teamMember = [Select id,Is_Designer_Assigned__c from Project_Team_Member__c where Project__c =:Milestone.Id and Role__c = 'Primary Designer' limit 1];
            if( teamMember != null){
                teamMember.Is_Designer_Assigned__c='Yes';
                update teamMember;
            }
                
        }catch(exception e){
            System.debug('^^^ e=' + e);
            throw new AuraHandledException('Error ' + e.getMessage());
        }
    }
    
    @auraEnabled
    public static void rejectDesigner(String recId,String Comments){
        try{
            Milestone1_Project__c Milestone= new Milestone1_Project__c(Id=recId,Reason_for_Rejection__c=Comments,Is_Designer_Assigned__c='No');          
            update Milestone;
            Project_Team_Member__c teamMember = [Select id,Is_Designer_Assigned__c from Project_Team_Member__c where Project__c =:Milestone.Id and Role__c = 'Primary Designer' limit 1];
            if( teamMember != null){
                teamMember.Is_Designer_Assigned__c='No';
                update teamMember;
            }
        }catch(exception e){
            throw new AuraHandledException('Error ' + e.getMessage());
        }
    }
}