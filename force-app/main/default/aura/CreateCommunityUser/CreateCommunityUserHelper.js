({
    createUser : function(component, event) {
        var action = component.get("c.createUser");
        action.setParams({
            accId : component.get('v.recordId')
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var Object = response.getReturnValue();
                let toastParams = {
                    title: "Error",
                    message: Object.message ,
                    type: "error"
                };
                
                if(Object.code == 400){
                    toastParams.title = 'Error';
                    toastParams.type = 'error';
                }
                if(Object.code == 200){
                     toastParams.title = 'Success';
                    toastParams.type = 'success';
                }
                let toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams(toastParams);
                toastEvent.fire();
                $A.get("e.force:closeQuickAction").fire();
                
            }
        });
        $A.enqueueAction(action);
    }
})