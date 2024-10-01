({
    
    deleteExistingTLGroup : function(cmp, event, helper){
            var action = cmp.get("c.deleteOldTLGroup");
            action.setParams({projID : cmp.get("v.recordId")});
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    console.log('Server Response' + response.getReturnValue());
                    
                }
                else {
                    console.log('Server call failed!');
                }
            });
            $A.enqueueAction(action);
        },
    
    	addNewTLGroup : function(cmp, event, helper){
            var action1 = cmp.get("c.sharingOnProjectforDesigner");
            action1.setParams({projID : cmp.get("v.recordId")});
            action1.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    console.log('Server Response' + response.getReturnValue());
                    
                    var toastEvent = $A.get("e.force:showToast");
                         toastEvent.setParams({
                          "title": "Success!",
                             "type" : "success",
                          "message": "Success"
                          });
                         toastEvent.fire();
                        $A.get("e.force:closeQuickAction").fire();
                        $A.get('e.force:refreshView').fire(); 
                }
                else {
                    console.log('Server call failed!');
                }
            });
            $A.enqueueAction(action1);
        }
})