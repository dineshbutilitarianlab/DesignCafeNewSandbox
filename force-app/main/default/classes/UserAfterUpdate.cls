public class UserAfterUpdate extends TriggerHandlerBase {
    
    public override void mainEntry(TriggerParameters tp) {
        updateUserGroup((Map <Id, User > ) tp.oldMap,(Map <Id, User > ) tp.newMap); 
    }
    
    private static void updateUserGroup(Map <Id, User > oldMap,Map <Id, User > newMap){
        List<User> userListToBeUpdated = New List<User>();
        Map<Id,Set<String>> mapofUserIdAndGroupName = New Map<Id,Set<String>>();
        For(Id userId:newMap.keyset()){
            If(oldMap.get(userId).team__c!=newMap.get(userId).team__c || oldMap.get(userId).region__c!=newMap.get(userId).region__c){
                userListToBeUpdated.add(newMap.get(userId));
            }
            IF(newMap.get(userId).UserRoleName__c!=Null && (newMap.get(userId).UserRoleName__c.equalsIgnoreCase('Internal Sales Agent')||newMap.get(userId).UserRoleName__c.equalsIgnoreCase('Call Center Agent'))){
                continue;
            }
            If(oldMap.get(userId).UserRoleName__c!=Null && (oldMap.get(userId).UserRoleName__c.equalsIgnoreCase('Internal Sales Team Lead')||oldMap.get(userId).UserRoleName__c.equalsIgnoreCase('Call Center Team Lead')) && oldMap.get(userId).team__c!=Null){
                For(String team:oldMap.get(userId).team__c.split(';')){
                    If(mapofUserIdAndGroupName.containskey(userId)){
                        mapofUserIdAndGroupName.get(userId).add(team);
                    }
                    else{
                        mapofUserIdAndGroupName.put(userId,New Set<String>{team}); 
                    }
                }
            }
            If(oldMap.get(userId).UserRoleName__c!=Null && (oldMap.get(userId).UserRoleName__c.equalsIgnoreCase('Internal Sales Team Director') && oldMap.get(userId).Region__c!=Null)){
                For(String region:oldMap.get(userId).Region__c.split(';')){
					If(mapofUserIdAndGroupName.containskey(userId)){
                        mapofUserIdAndGroupName.get(userId).add(region);
                    }
                    else{
                        mapofUserIdAndGroupName.put(userId,New Set<String>{region}); 
                    }
                }
            }
        }
        IF(mapofUserIdAndGroupName.size()>0){
            UserTriggerHelper.removeFromPublicGroup(mapofUserIdAndGroupName);
        }
        If(userListToBeUpdated.size()>0){
            UserTriggerHelper.addToPublicGroup(userListToBeUpdated);
        }
    }
}