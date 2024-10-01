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
                    console.log('if'+response.getReturnValue());
                    component.set("v.ShowButton",true)
                }
                else{
                    console.log('else'+response.getReturnValue());
                    component.set("v.ShowButton",false)
                }
            }
        });  
        $A.enqueueAction(action);   
    },
    SendBookingForm : function(component, event, helper) {
        helper.fetchdetails(component,event,helper);
    }
})