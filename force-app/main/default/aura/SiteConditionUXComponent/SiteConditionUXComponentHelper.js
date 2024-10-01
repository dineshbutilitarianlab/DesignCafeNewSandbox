({
    getOpportunityData: function(component, event) {
        var action = component.get("c.cbvalues");
        action.setParams({"recordId" : component.get('v.recordId')});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = JSON.parse(response.getReturnValue());
                var OppRec = JSON.parse(result['OpportunityRecord']);
                component.set('v.OpportunityRecord',OppRec);
                component.set("v.FramesofExtDoorsWin",OppRec['Frames_for_all_external_Doors_Windows__c']);
                component.set("v.AllWallCompleted",OppRec['All_walls_are_completed_Required__c']);
                component.set("v.Floorsleveledout",OppRec['Floors_are_levelled_out_prepped_Basic__c']);
                component.set("v.Doorwindowinstall",OppRec['The_Doors_Windows_are_installed_Requir__c']);
                component.set("v.puttyonecoat",OppRec['Putty_and_1_coat_of_plastering_Required__c']);
                component.set("v.Flooringcompleted",OppRec['Flooring_is_completed_Required__c']);
             //   component.set("v.requiredtoc",OppRec['If_the_required_part_is_checked_the_co__c']);
                component.set("v.Notes",OppRec['Notes__c']);
            }
        });
        $A.enqueueAction(action);
    },
    SaveupdatedOppvalues: function(component,event,helper){
        var OppRec = component.get("v.OpportunityRecord");
        OppRec['Frames_for_all_external_Doors_Windows__c'] =component.get('v.FramesofExtDoorsWin');
        OppRec['All_walls_are_completed_Required__c'] =component.get('v.AllWallCompleted');
        OppRec['Floors_are_levelled_out_prepped_Basic__c'] =component.get('v.Floorsleveledout');
        OppRec['The_Doors_Windows_are_installed_Requir__c'] =component.get('v.Doorwindowinstall');
        OppRec['Putty_and_1_coat_of_plastering_Required__c'] =component.get('v.puttyonecoat');
        OppRec['Flooring_is_completed_Required__c'] =component.get('v.Flooringcompleted');
     //   OppRec['If_the_required_part_is_checked_the_co__c'] =component.get('v.requiredtoc');
        OppRec['Notes__c'] =component.get('v.Notes');
        var action = component.get("c.UpdateOpportunitySite");
        action.setParams({
            "oppRec" : JSON.stringify(OppRec)
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                helper.showSuccess(component, event, helper);
            }
        });
        $A.enqueueAction(action);
    },
    
    showError : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Error',
            message: 'Not Updated Successfully',
            duration:' 5000',
            key: 'info_alt',
            type: 'error',
            mode: 'pester'
        });
        toastEvent.fire();
        component.set("v.disablevalues",true);
    },
    showSuccess : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Success',
            message: 'Updated Successfully',
            duration:' 5000',
            key: 'info_alt',
            type: 'success',
            mode: 'pester'
        });
        toastEvent.fire();
        component.set("v.disablevalues",true);
    }    
})