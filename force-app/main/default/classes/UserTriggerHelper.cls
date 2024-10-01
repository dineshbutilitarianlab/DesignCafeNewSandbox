public class UserTriggerHelper {
    
    public static void addToPublicGroup(List<User> newList){
        Map<String,Id> mapOfGroupNameAndId = New Map<String,Id>();
        List<GroupMember> listOfGroupMemberToBeInserted = New List<GroupMember>();
        For(Group groupObj:[Select id,Name,developername from group where (not name  like '%LTC%')]){
            IF(groupObj.Name!=Null){
                mapOfGroupNameAndId.put(groupObj.Name.tolowerCase(),groupObj.Id);
            }}
        For(User userObj:newList){
                IF(userObj.UserRoleName__c!=Null && (userObj.UserRoleName__c.equalsIgnoreCase('Internal Sales Agent')||userObj.UserRoleName__c.equalsIgnoreCase('Call Center Agent'))){
                    continue;
                }
                If(userObj.UserRoleName__c!=Null && (userObj.UserRoleName__c.equalsIgnoreCase('Internal Sales Team Lead')||userObj.UserRoleName__c.equalsIgnoreCase('Call Center Team Lead')) && userObj.Team__c!=Null){
                    For(String team:userObj.team__c.split(';')){
                        IF(mapOfGroupNameAndId.containskey(team.toLowerCase())){
                            GroupMember groupMemberObj = New GroupMember();
                            groupMemberObj.UserOrGroupId = userObj.Id;
                            groupMemberObj.GroupId = mapOfGroupNameAndId.get(team.toLowerCase());
                            listOfGroupMemberToBeInserted.add(groupMemberObj);
                        }
                    }
                }
                If(userObj.UserRoleName__c!=Null && (userObj.UserRoleName__c.equalsIgnoreCase('Internal Sales Team Director')) && userObj.Region__c!=Null){
                    For(String region:userObj.Region__c.split(';')){
                        IF(mapOfGroupNameAndId.containskey(region.toLowerCase())){
                            GroupMember groupMemberObj = New GroupMember();
                            groupMemberObj.UserOrGroupId = userObj.Id;
                            groupMemberObj.GroupId = mapOfGroupNameAndId.get(region.toLowerCase());
                            listOfGroupMemberToBeInserted.add(groupMemberObj);
                        }
                    }
            }
        }
        
        If(listOfGroupMemberToBeInserted.size()>0){
            Database.insert(listOfGroupMemberToBeInserted) ;
        }
    }
    
    public static void removeFromPublicGroup(Map<Id,Set<String>> mapOfUserIdAndGroupNameSet){
        List<GroupMember> ListOfGroupMemberToBeDeleted = New List<GroupMember>();
        For(GroupMember gMemberObj:[Select Id,UserOrGroupId,Group.Name from GroupMember where UserOrGroupId in :mapOfUserIdAndGroupNameSet.keyset() ]){
            IF(gMemberObj.Group.Name!=Null && mapOfUserIdAndGroupNameSet.containskey(gMemberObj.UserOrGroupId) && 
               (mapOfUserIdAndGroupNameSet.get(gMemberObj.UserOrGroupId).contains(gMemberObj.Group.Name))){
                   ListOfGroupMemberToBeDeleted.add(gMemberObj);
               }
        }
        
        If(ListOfGroupMemberToBeDeleted.size()>0){
            Database.delete(ListOfGroupMemberToBeDeleted);
        }
    }
    
}