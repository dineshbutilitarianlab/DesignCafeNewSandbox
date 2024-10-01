({
	myAction : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        
        toastEvent.setParams({
            "mode" : "sticky",
            "type" : "error",
            "title": "Invalid Operation",
            "message": "You do not have permission to change the Project Stage."
        });
        
        toastEvent.fire();
		$A.get('e.force:refreshView').fire();
	}
})