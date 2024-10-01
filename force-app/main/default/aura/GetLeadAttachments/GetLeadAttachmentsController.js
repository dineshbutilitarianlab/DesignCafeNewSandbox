({
    handleClick : function (component, event, helper) {
        var action = component.get("c.LeadAttachment");
        component.set("v.Isdisabled",true);
        action.setParams({
            recId : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if (response.getReturnValue() === 200){
                    component.set("v.ShowButton",false)
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Success',
                        message: 'Lead Attachments generated Successfully...!',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'success',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                }
                if (response.getReturnValue() === 400){
                    var showToast = $A.get( "e.force:showToast" );
                    showToast.setParams({
                        title : 'Failure',
                        message : 'No files present in server.',
                        type : 'error'
                    });
                    showToast.fire();
                }
                if (response.getReturnValue() === 500) {
                    var showToast = $A.get( "e.force:showToast" );
                    showToast.setParams({
                        title : 'Failure' ,
                        message : 'Failure in Lead Attachments generation due to API Issue',
                        type : 'error'
                    });
                    showToast.fire();
                }
            }
            $A.get("e.force:closeQuickAction").fire();
            $A.get('e.force:refreshView').fire();
        });
        $A.enqueueAction(action);
    },
    //Call by aura:waiting event  
    handleShowSpinner: function(component, event, helper) {
        component.set("v.isSpinner", true); 
    },
    
    //Call by aura:doneWaiting event 
    handleHideSpinner : function(component,event,helper){
        component.set("v.isSpinner", false);
    }
});