({   
    doInitHelper:  function(component, event, helper) { 
        var milstoneId= component.get("v.recordId");
        var action = component.get("c.getDocumentTemplate");
        action.setParams({
            "recordId" : milstoneId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.comments', response.getReturnValue()); 
            }
        });        
        $A.enqueueAction(action);
    }, 
    handleCreation : function(component, event, helper) {

        if(component.get("v.comments") == undefined || component.get("v.comments").length == 0) {
            let params= {
                "type":"error",
                "title": "Error",
                "message": 'Please enter Comments/Minutes of Meeting.'
            }
            
            this.showToast(component,params);
            return;
        }
        
        // create a one-time use instance of the serverEcho action
        // in the server-side controller
        var action = component.get("c.createArtifact");
        action.setParams({ recId : component.get("v.recordId"),
                          mom: component.get("v.comments")
                         });
        
        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.artifactId', response.getReturnValue());
                this.openTab(component, event, helper);
                let params= {
                    "type":"success",
                    "title": "Success!",
                    "message": 'Artifact successfully created.'
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
                    //System.debug("Error Occured " + errorString);
                    let params= {
                        "type":"error",
                        "title": "Error!",
                        "message": "A Milestone cannot have more than one draft Milestone Document."
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
    },
    openTab: function(component, event, helper) {       
       debugger;
        var workspaceAPI = component.find("workspace");
        workspaceAPI.openTab({
            pageReference: {
                "type": "standard__recordPage",
                "attributes": {
                    "recordId":component.get('v.artifactId'),
                    "actionName":"view"
                },
                "state": {}
            },
            focus: true
        }).then(function(response) {
            workspaceAPI.getTabInfo({
                tabId: response
            }).then(function(tabInfo) {
                console.log("The recordId for this tab is: " + tabInfo.recordId);
            });
        }).catch(function(error) {
            console.log(error);
        });
    }
   
})