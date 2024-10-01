({
    doInit: function(component, event, helper) {
        component.set("v.editMode",true);
        var action = component.get('c.getDefaultValue'); 
        action.setParams({
            recId : component.get("v.recordId")
        });
        action.setCallback(this, function(a){
            var state = a.getState(); 
            if(state == 'SUCCESS') {
                component.set("v.RefereeName",a.getReturnValue().RefereeName);
                component.set("v.RefereeNumber",a.getReturnValue().RefereeNumber);
                component.set("v.RefereeCode",a.getReturnValue().RefereeCode);
                component.set("v.RefereeEmail",a.getReturnValue().WohooCard);
            }
        });
        $A.enqueueAction(action);
    },
    handleEdit:function(component, event, helper){
        component.set("v.editMode",false);  
    },
    handleSave :function(component, event, helper){
        var obj = [{"leadId":component.get("v.recordId"),
                    "RefereeName": component.get("v.RefereeName"),
                    "RefereeNumber" : component.get("v.RefereeNumber"),
                    "RefereeCode" : component.get("v.RefereeCode"),
                    "RefereeEmail": component.get("v.RefereeEmail")
                    
                   }];
        var action = component.get('c.saveDataTOLead'); 
        action.setParams({
            records : JSON.stringify(obj)
        });
        action.setCallback(this, function(a){
            var state = a.getState(); 
            if(state == 'SUCCESS') {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type" :"success",
                    "title": "Success!",
                    "message": "The record has been updated successfully."
                });
                toastEvent.fire();
                component.set("v.editMode",true); 
            }
        });
        $A.enqueueAction(action);  
    },
    handleCancel : function(component, event, helper){
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    }
})