({
    doInitHelper:  function(component, event, helper) { 
        var action = component.get("c.accessFiles");
        action.setParams({
            "currentUserId" : component.get("v.currentUserId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
            component.set('v.files', response.getReturnValue());
            var files = component.get('v.files');
                if(files ==  null){
                component.set('v.message', "Project Quotation Not Available!!");                
                }
            }
        });        
        $A.enqueueAction(action);
    }
})