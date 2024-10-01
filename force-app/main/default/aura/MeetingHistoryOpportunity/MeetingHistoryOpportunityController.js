({
    doInit: function(component, event, helper) {
        component.set("v.editMode",true);
        var meetingType = [{label: "--None--", value: "--None--",},
                           {label: "EC", value: "EC",},
                           {label: "Site Visit", value: "Site Visit"},
                           {label: "Virtual Meeting", value: "Virtual Meeting"}];
        component.find("meeting_Type").set("v.options", meetingType);
        
        var meetingVenue = [{label: "--None--", value: "--None--",},
                            {label: "MGDC", value: "MGDC"},
                            {label: "WDC", value: "WDC"},
                            {label: "Mumbai DC", value: "Mumbai DC"},
                            {label: "Hyderabad DC", value: "Hyderabad DC"},
                            {label: "HSRDC", value: "HSRDC"},
                            {label: "Chennai DC", value: "Chennai DC"},
                            {label: "Thane DC", value: "Thane DC"},
                            {label: "KDRMYS", value: "KDRMYS"},
                            {label: "YERPUN", value: "YERPUN"},
                            {label: "BHHYD", value: "BHHYD"},
                            {label: "JPDC", value: "JPDC"},
                           {label: "SJPBLR", value: "SJPBLR"},
                           {label: "KHMUM", value: "KHMUM"},
                           {label: "WLMUM", value: "WLMUM"},
                           {label: "OMRCH", value: "OMRCH"},
                           {label: "HRBRBLR", value: "HRBRBLR"},
                           {label: "RSPCO", value: "RSPCO"},
                           {label: "DNVIZ", value: "DNVIZ"},
                           {label: "DC-WB-KOL-PRIMAC", value: "DC-WB-KOL-PRIMAC"},
                           {label: "DC-GJ-AHM-SOFTVOLUTE", value: "DC-GJ-AHM-SOFTVOLUTE"},];
        component.find("meeting_Venue").set("v.options", meetingVenue);
        
        var action = component.get('c.getDefaultValue'); 
        action.setParams({
            recId : component.get("v.recordId")
        });
        action.setCallback(this, function(a){
            var state = a.getState(); 
            if(state == 'SUCCESS') {
                //alert(JSON.stringify(a.getReturnValue())); 
                component.find("Meeting_Scheduled_Date").set("v.value", a.getReturnValue().meetingDateTime);
                component.set("v.meetingType",a.getReturnValue().meetingType);
                component.set("v.meetingVenue",a.getReturnValue().meetingVenue);
            }
        });
        $A.enqueueAction(action);
    },
    handleSave : function(component, event, helper) {
        var obj = [{"opportunityId":component.get("v.recordId"),
                    "meetingType": component.get("v.meetingType"),
                    "meetingVenue" : component.get("v.meetingVenue"),
                    "meetingDateTime": component.find("Meeting_Scheduled_Date").get("v.value")
                    
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
                $A.get('e.force:refreshView').fire();
            }
        });
        $A.enqueueAction(action);
        
    },
    handleEdit :function(component, event, helper){
        component.set("v.editMode",false); 
    }
})