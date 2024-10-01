({
	handleResponse : function(component, event, response) {
        
        // create a one-time use instance of the serverEcho action
        // in the server-side controller
        var action = component.get("c.feedbackResponse");
        action.setParams({ recId : component.get("v.recordId"),
                          response: response,
                          comments: component.get("v.comments"),
                          projectId : component.get('v.Project_ArtifactRecord').Project_Milestone__c 
                         });
        
        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                let params= {
                    "type":"success",
                    "title": "Success!",
                    "message": 'Thank you for Feedback. '
                }
                this.showToast(component,params);
                $A.get("e.force:refreshView").fire();
                $A.get("e.force:closeQuickAction").fire();
                
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    let errorString=JSON.stringify(errors);
                    let params= {
                        "type":"error",
                        "title": "Error!",
                        "message":errorString 
                    }
                    this.showToast(component,params);
                }
        });        
        $A.enqueueAction(action);        
	},
   
    showToast : function(component, params) {
        var toastEvent = $A.get("e.force:showToast");
        if(params){
            toastEvent.setParams(params);
            toastEvent.fire();
        }        
    }
})