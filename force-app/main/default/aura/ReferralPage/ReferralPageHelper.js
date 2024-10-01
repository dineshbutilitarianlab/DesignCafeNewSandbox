({
	getLeadsList : function(component, event) {
        var action = component.get('c.getLeads');
        // Set up the callback
        action.setCallback(this, function(actionResult) {
            component.set('v.Leads', actionResult.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    
    updateHelper : function(component, event) {
        var ld = event.getSource().get("v.value")
        console.log('ld-- > ' + JSON.stringify(ld));
        
        var action1 = component.get("c.saveLd");
        action1.setParams({ "ld" : ld });
        action1.setCallback(this, function(resp){
            var state = resp.getState();
            if(state === "SUCCESS"){
                $A.get('e.force:refreshView').fire();
                console.log('server- > ' + resp.getReturnValue());
                alert('Success');
            }
            else if (state === "ERROR") {
                var errors = resp.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } 
                else {
                    console.log(resp.getReturnValue());
                }
            }
        });
        $A.enqueueAction(action1);
    }
})