({
    doInit : function(cmp, event, helper) {
        try {
            var action = cmp.get("c.assignDesignOwnership");
            action.setParams({aRecID : cmp.get("v.recordId")});
            
            action.setCallback(this, function(response) {
                var state = response.getState();
                
                if (state === "SUCCESS") {
                    console.log('Server call succeeded!');
                    cmp.set("v.message", response.getReturnValue());
                    $A.get('e.force:refreshView').fire();
                }
                else {
                    console.log('Server call failed!');
                }
            });
        }
        catch(e) {
            console.log(e);
        }
        
        $A.enqueueAction(action);
    }
})