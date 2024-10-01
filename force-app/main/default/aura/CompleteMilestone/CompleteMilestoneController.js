({

    getQuestions: function(component, event, helper) {

        helper.callServer(
            component,
            "c.completeMilestone",
            function(response) {
//                console.log('response------------------' + response);
                if(response != ""){
                console.log('response is not Empty');
                component.set('v.questionList', response);                    
                }
                else{
                component.set('v.isMilestoneActionEmpty', true);                                        
                console.log('response is Empty' + response);
                }
            }, {
                type : component.get('v.milestoneRecord.Type__c')
            }
        );
    },
        
    markComplete: function (component, event,helper) {
        component.set("v.milestoneRecord.Complete__c",true);
        component.set("v.milestoneSelected",false);
        
        component.find("recordHandler").saveRecord($A.getCallback(function(saveResult) {
            if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                $A.get("e.force:closeQuickAction").fire();
                $A.get('e.force:refreshView').fire();                
                // handle the success state
                var success = JSON.stringify(saveResult.success);
                helper.insertInvoice(component,event,helper);
                helper.notifyToast(component, event, "Success", "Milestone successfully marked as completed.", "success");                
            }else if (saveResult.state === "INCOMPLETE") {
                // handle the incomplete state
                console.log("User is offline, device doesn't support drafts.");
            } else if (saveResult.state === "ERROR") {
                // handle the error state
                var error = JSON.stringify(saveResult.error);
  				var message = saveResult.error[0].message;           
                helper.notifyToast(component, event, "Error Found", message, "error");
            } else {
                console.log('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
            }
        }));
    },
    
    
    onCancel: function (component, event) {
        $A.get("e.force:closeQuickAction").fire();
    }
    
})