({
    doInit : function(component, event, helper) {
       // alert('Invoice Generated');
        var action = component.get("c.callServer");
        action.setParams({
            oppId : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
           if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success',
                    message: 'Invoice Re-Generated Successfully...!',
                    duration:' 9000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
               toastEvent.fire(); 
               var url = '/'+component.get("v.recordId");
               setTimeout(window.open(url,'_self'),5000);
          
            }
            else if (state === "ERROR") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error',
                    message: 'Cannot regenerate Invoice for the previous month',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'pester'
                });
                toastEvent.fire(); 
             //   var url = '/'+component.get("v.recordId");
              //  setTimeout(window.open(url,'_self'),5000);
            }
        });
        $A.enqueueAction(action);
    }
})