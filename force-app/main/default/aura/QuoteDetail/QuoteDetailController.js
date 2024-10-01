({
    handleSuccess : function(component, event, helper) {
        component.find('notifLib').showToast({
            "variant": "success",
            "title": "Quote successfully Created",
            "message": "Record ID: " + event.getParam("id")
        });
    },
    handleError : function(component, event, helper) {
        component.find('notifLib').showToast({
            "variant": "error",
            "title": "Record Failure",
            "message": "Quote was unable to create"
        });
    },
    handleCancel : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
        $A.get('e.force:refreshView').fire();    
    }
})