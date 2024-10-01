({
    handleSuccess : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error!",
            "type" : "Success",
            "message": "Record is created successfully.Redirecting to the new record."
        });
        toastEvent.fire();
        var payload = event.getParams().response;
        window.open('/'+payload.id,'_self');
    }
    
})