public class LeadAllocationBatch implements Database.Batchable<sobject>{
    
    
    public Database.querylocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([Select Id,Region__c,Channel__c,Source__c,DC_Lead_Source__c, DC_Campaign_Source__c,Call_Center_Agent__c,
                                         Lead_Allocation_Time__c,Call_Center_Agent_Region__c,Call_Center_Agent_Team__c,OwnerId,Status from lead where status in ('New','Assigned') And Owner.Name='Unassigned']);
        
    }
    
    public void execute(Database.BatchableContext BC, List<Lead> scope){
        Map < String, String > mapofLeadandAgencyName = New Map < String, String > ();
        Map < String, Set < Id >> mapOfGroupNameAndMembersSet = New Map < String, Set < Id >> ();
        Map < Id, Integer > mapOfUseridAndCountOflead = New Map < Id, Integer > ();
        Set < Id > userIdSet = New Set < Id > ();
        Map<Id,Lead> mapOfLeadToBeUpdated = New Map<Id,Lead>();
        For(Lead_Allocation_Rule__c leadAllocObj: [Select id, Agency_Group_Name__c, Channel__c, Source__c,Lead_allocation_Rule_Key__c ,
                                                   Lead_Source__c, Region__c,Campaign_Source__c From Lead_Allocation_Rule__c]) {
           If(leadAllocObj.Lead_allocation_Rule_Key__c!=null){
                 mapofLeadandAgencyName.put(leadAllocObj.Lead_allocation_Rule_Key__c, leadAllocObj.Agency_Group_Name__c);                                            
          }
                               
         }
       // For(GroupMember gmObj : [SELECT UserOrGroupId,Group.Name FROM GroupMember where Group.Name in :mapofLeadandAgencyName.values() And
                      //            UserOrGroupId in (Select id from User where LastloginDate >= :System.Now().addDays(-1) And UserRole.Name like '%Call Center%')]){
        For(GroupMember gmObj : [SELECT UserOrGroupId,Group.Name FROM GroupMember where Group.Name in :mapofLeadandAgencyName.values() And 
                                              UserOrGroupId in (Select id from User where UserRole.Name like '%Call Center%')]){                              
            IF(mapOfGroupNameAndMembersSet.containskey(gmObj.Group.Name)) {
                mapOfGroupNameAndMembersSet.get(gmObj.Group.Name).add(gmObj.UserOrGroupId);
            }
            Else {
                mapOfGroupNameAndMembersSet.put(gmObj.Group.Name, New Set < Id > {gmObj.UserOrGroupId });
            }
            userIdSet.add(gmObj.UserOrGroupId);
        }
        Map<Id,String> mapofUserIdAndName = New Map<Id,String>();
        For(AggregateResult argObj: [SELECT OwnerId, Count(Id) ownerCount FROM Lead where status in ('New','Assigned') group by OwnerId having OwnerId in: userIdSet ]) {
            mapOfUseridAndCountOflead.put((ID) argObj.get('OwnerId'), (Integer) argObj.get('ownerCount'));
        }
        userIdSet.removeAll(mapOfUseridAndCountOflead.keyset());
        For(Id userId:userIdSet){
            mapOfUseridAndCountOflead.put(userId,0);
        }
        //List<String> fieldList = SObjectType.Lead.FieldSets.LeadAllocationSet.getFields();
        For(Lead leadObj: scope) {
            Map<String, Object> mapOfFields = leadObj.getPopulatedFieldsAsMap();
            String key;
            For(String keyField:Label.LeadAllocationfields.split(',')){
                If(mapOfFields.containskey(keyField)){
                    If(key!=Null){
                        key =key+(String)mapOfFields.get(keyField);
                    }
                    else{
                        key = (String)mapOfFields.get(keyField);
                    }
                }
            }
            //String key = leadObj.Region__c + leadObj.Channel__c + leadObj.Source__c + leadObj.DC_Lead_Source__c + leadObj.DC_Campaign_Source__c;
            Id callCenterAgent;
            IF(leadObj.Call_Center_Agent__c!=Null){
                callCenterAgent = leadObj.Call_Center_Agent__c;
            }
            If(key!=Null){
            If(mapofLeadandAgencyName.containskey(key) && mapOfGroupNameAndMembersSet.containskey(mapofLeadandAgencyName.get(key))) {
                For(Id userId: mapOfGroupNameAndMembersSet.get(mapofLeadandAgencyName.get(key))) {
                    If(callCenterAgent!=Null && callCenterAgent==userId){
                        continue;
                    }
                    If(mapOfUseridAndCountOflead != null && mapOfUseridAndCountOflead.containskey(leadObj.OwnerId) && mapOfUseridAndCountOflead.containskey(userId)) {
                        id ownerId = leadObj.OwnerId;
                        leadObj.OwnerId = mapOfUseridAndCountOflead.get(userId) <= mapOfUseridAndCountOflead.get(leadObj.OwnerId) ?
                            userId : leadObj.OwnerId;
                        leadObj.Status = 'Assigned';
                        leadObj.Call_Center_Agent__c = leadObj.OwnerId;
                        LeadObj.Lead_Allocation_Time__c = System.now();                       
                        mapOfLeadToBeUpdated.put(leadObj.Id,leadObj);
                    }
                    Else {
                        leadObj.OwnerId = userId;
                        leadObj.Status = 'Assigned';
                        leadObj.Call_Center_Agent__c = leadObj.OwnerId;
                        LeadObj.Lead_Allocation_Time__c = System.now();
                        mapOfLeadToBeUpdated.put(leadObj.Id,leadObj);
                    }
                    
                }
                if(leadObj.ownerId != null && mapOfUseridAndCountOflead.get(leadObj.ownerId) != null ){
                    mapOfUseridAndCountOflead.put(leadObj.ownerId,mapOfUseridAndCountOflead.get(leadObj.ownerId)+1);
                }
            }}
        }
        If(mapOfLeadToBeUpdated.size()>0){
            database.saveresult[] dv = Database.update(mapOfLeadToBeUpdated.values(),false) ;
            for(database.saveresult sv1:dv){
                System.debug('sv1'+sv1);
            }
            
        }
    }
    public void finish(Database.BatchableContext BC){
        
    }
}