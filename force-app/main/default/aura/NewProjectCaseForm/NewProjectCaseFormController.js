({
    doInit : function(component, event, helper) {
		
        // Prepare the action to load account record
        var action = component.get("c.getProject");
        action.setParams({"projectId": component.get("v.recordId")});

        // Configure response handler
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {                
                component.set("v.project", response.getReturnValue());
            } else {
                console.log('Problem getting Project, response state: ' + state);
            }
        });
        $A.enqueueAction(action); 
    },

    handleSaveCase: function(component, event, helper) {
        
        if(helper.validateCaseForm(component)) {
            
            // Prepare the action to create the new contact
            var saveCaseAction = component.get("c.saveCaseWithProject");
            
            saveCaseAction.setParams({
                "case1": component.get("v.newCase"),
                "project": component.get("v.project")
            });

            // Configure the response handler for the action
            saveCaseAction.setCallback(this, function(response) {
                var state = response.getState();
                
                if(state === "SUCCESS") {
                    var ret = response.getReturnValue();
                    var title = 'Success';
                    var toastType = 'success';
                    var msg = 'Support Case has been created successfully.';
                    
                    if(ret.status_code == '500') {
                        title = 'Error';
                        msg = ret.status_message;
                        toastType = 'error';
                    }
                    
                    // Prepare a toast UI message
                    var resultsToast = $A.get("e.force:showToast");
                    
                    resultsToast.setParams({
                        "title": title,
                        "message": msg,
                        "type" : toastType
                    });
                    
                    // Update the UI: close panel, show toast, refresh Project page
                    $A.get("e.force:closeQuickAction").fire();
                    resultsToast.fire();
                    $A.get("e.force:refreshView").fire();
                }
                else if (state === "ERROR") {
                    console.log('Problem saving Case, response state: ' + state);
                }
                else {
                    console.log('Unknown problem, response state: ' + state);
                }
            });

            // Send the request to create the new case
            $A.enqueueAction(saveCaseAction);
        }
        
    },

	handleCancel: function(component, event, helper) {
	    $A.get("e.force:closeQuickAction").fire();
    }
})