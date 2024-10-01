({
    init : function(component, event, helper) {
        var pageReference = component.get("v.pageReference");
        let mobno = pageReference.state.c__mobilenum;
        var unId = pageReference.state.c__callId;
        if(mobno == undefined && unId == undefined){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type" : "error",
                "message": "Please open the url with the mobile no and uniqueId"
            });
            toastEvent.fire();
            return ;
        }
        var action = component.get('c.fetchLeadDetails'); 
        action.setParams({
            "mobileNo" : mobno,
            "uniqueId" : unId
        });
        action.setCallback(this, function(a){
            var state = a.getState();
            if(state == 'SUCCESS') {
                if(a.getReturnValue() == 'Lead Not Found'){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "type" : "error",
                        "message": "Lead is not available in the database.Redirecting to create the new lead"
                    });
                    toastEvent.fire();
                    var evt = $A.get("e.force:navigateToComponent");
                    evt.setParams({
                        componentDef : "c:DialerLeadCreater",
                        componentAttributes: {
                            
                        }
                    });
                    evt.fire();
                }
                else{
                    window.open('/'+a.getReturnValue(),'_self');
                }
                
            }
            else{
                
            }
        });
        $A.enqueueAction(action);
    }
})