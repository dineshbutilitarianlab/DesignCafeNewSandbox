({
    
    callServer : function(component,method,callback,params) {
        var action = component.get(method);
        if (params) {
            action.setParams(params);
        }
        
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // pass returned value to callback function
                callback.call(this,response.getReturnValue());
            } else if (state === "ERROR") {
                // generic error handler
                var errors = response.getError();
                if (errors) {
                    console.log("Errors", errors);
                    if (errors[0] && errors[0].message) {
                        throw new Error("Error" + errors[0].message);
                    }
                } else {
                    throw new Error("Unknown Error");
                }
            }
        });
        
        $A.enqueueAction(action);
    },
    insertInvoice : function(component,event,helper){
        //alert(component.get("v.recordId"));
        var action = component.get("c.generateInvoiceData");
        action.setParams({
            recId : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS"){
               //alert('Generated'); 
            }
        });
        $A.enqueueAction(action);  
    },
    notifyToast: function (component, event, title, message, type) {
        let toastParams = {
            title: title,
            message: message,
            type: type
        };
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams(toastParams);
        toastEvent.fire();
    }
})