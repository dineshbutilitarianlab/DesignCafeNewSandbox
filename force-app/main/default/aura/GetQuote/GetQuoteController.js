({
    doInit : function(component, event, helper){
        var action = component.get("c.showbutton");
        action.setParams({
            recId : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue() === 'Enabled'){
                    component.set("v.ShowButton",true)
                }
                else{
                    component.set("v.ShowButton",false)
                }
            }
        });
        
        $A.enqueueAction(action);
        
    },
    getQuote : function(component, event, helper) {
        var action = component.get("c.LCScallServer");
        action.setParams({
            recId : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                   var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success',
                    message: 'Customer data sent to LCS Successfully..!',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
                toastEvent.fire();  
                $A.get('e.force:refreshView').fire();
                  } 
           else if (state === "ERROR") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error',
                    message: 'Rqueste cant sent because data is missing.',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'pester'
                });
                toastEvent.fire(); 
                $A.get('e.force:refreshView').fire();
                
            }
        });
        $A.enqueueAction(action);
    }
})