trigger UserTrigger on User (after insert,after update) {
    TriggerFactory.createTriggerDispatcher(User.sObjectType);
}