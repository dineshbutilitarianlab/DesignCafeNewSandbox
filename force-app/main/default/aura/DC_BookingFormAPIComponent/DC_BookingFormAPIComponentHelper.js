({
    fetchdetails : function(component,event,helper) {
        var action = component.get("c.fetchDetails");
        action.setParams({
            OppId : component.get("v.recordId")
        });
        action.setCallback(this, function(a){
            var state = a.getState();
            if(state == 'SUCCESS'){
                component.set('v.wrapperclass',a.getReturnValue());
                var wrap = component.get('v.wrapperclass');
                var opty1 = wrap.projectType;
                var opty2 = wrap.scopeOfWork;
                var opty3 = wrap.proposedValue;
                var opty4 = wrap.modularAmount;
             //   var opty5 = wrap.modularDiscount;
                var opty6 = wrap.siteServicesAmount;
             //   var opty7 = wrap.siteServicesDiscount;
                var opty8 = wrap.decorAmount;
                var opty9 = wrap.signupAmount;
                var opty10 = wrap.signupValue;
                var opty11 = wrap.pan;
               // alert(wrap.pan);
                if(wrap.projectType == undefined || wrap.scopeOfWork == undefined || wrap.proposedValue == undefined ||
                   wrap.modularAmount == undefined || wrap.siteServicesAmount == undefined || wrap.decorAmount == undefined || wrap.signupAmount == undefined ||
                   wrap.signupValue == undefined || wrap.pan == undefined){ 
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                         mode: 'sticky',
                        "title": "Required Fields not updated",
                        "message": "Before Performing sendBookingForm action please update Required Fields."
                    });
                    toastEvent.fire();
                }
                else{
                    helper.gobookingform(component,event,helper)  
                }  
            }
        });
        $A.enqueueAction(action);
    },
    gobookingform : function(component,event){
        var action = component.get("c.DC_BookingFormAPIServer");
        action.setParams({
            Oppid : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success',
                    message: 'BookingForm data sent to Customer Dashboard Successfully..!',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
                toastEvent.fire();  
                $A.get('e.force:refreshView').fire();
                component.set("v.disablevalues",true);
            } 
            else if (state === "ERROR") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error',
                    message: 'Failed to send data to Customer Dashboard.',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'pester'
                });
                toastEvent.fire(); 
                $A.get('e.force:refreshView').fire();
                component.set("v.disablevalues",true);
            }
        });
        $A.enqueueAction(action);
    }
})