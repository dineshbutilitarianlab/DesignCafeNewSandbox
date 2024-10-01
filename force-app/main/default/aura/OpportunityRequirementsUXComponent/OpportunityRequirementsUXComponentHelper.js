({
    // Picklist data shown as buttons
    getoppPicklist: function(component, event) {
        var action = component.get("c.Opppicklistvalues");
        action.setParams({"recordId" : component.get('v.recordId')});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = JSON.parse(response.getReturnValue());
                var hometypeFinalValues = [];
                
                var oppoRec = JSON.parse(result['OppRecord']);
                component.set('v.OppRecord',oppoRec);
                component.set("v.HomeType",oppoRec['Home_Type__c']);
                component.set("v.ScopeOfWork",oppoRec['Scope_Of_Work__c']);
                component.set("v.Interiorworkneededfor",oppoRec['Interior_work_needed_for__c']);
                component.set("v.PropertyUsage",oppoRec['Property_Usage__c']);
                component.set("v.RequirementDetails",oppoRec['Requirement_Details__c']);
                component.set("v.CivilWork",oppoRec['Civil_Work__c']);
                component.set("v.FloorArea",oppoRec['Floor_Area__c']);
                component.set("v.MoveIn",oppoRec['Move_in__c']);
                
                
                var HomeTypevalues = result['Home_Type__c'];
                var finalHometypeValues = [];
                for (var i = 0; i < HomeTypevalues.length; i++) {
                    var valueObj={
                        'value':HomeTypevalues[i]
                    };
                    if(oppoRec['Home_Type__c'] != undefined && oppoRec['Home_Type__c'].includes(HomeTypevalues[i])){
                        valueObj.isSelected = true; 
                    }else{
                        valueObj.isSelected = false; 
                    }
                    finalHometypeValues.push(valueObj);
                }
                
                var Propertyvalues = result['Property_Usage__c'];
                var finalPropertyvalues = [];
                for (var i = 0; i < Propertyvalues.length; i++) {
                    var valueObj={
                        'value':Propertyvalues[i]
                    };
                    if(!!oppoRec['Property_Usage__c'] && oppoRec['Property_Usage__c'].includes(Propertyvalues[i])){
                        valueObj.isSelected = true; 
                    }else{
                        valueObj.isSelected = false; 
                    }
                    finalPropertyvalues.push(valueObj);
                }
                
                var interiorValues = result['Interior_work_needed_for__c'];
                var finalinteriorValues = [];
                for (var i = 0; i < interiorValues.length; i++) {
                    var valueObj={
                        'value':interiorValues[i]
                    };
                    if(!!oppoRec['Interior_work_needed_for__c'] && oppoRec['Interior_work_needed_for__c'].includes(interiorValues[i])){
                        valueObj.isSelected = true; 
                    }else{
                        valueObj.isSelected = false; 
                    }
                    finalinteriorValues.push(valueObj);
                }
                
                var Scopevalues = result['Scope_Of_Work__c'];
                var finalScopevalues = [];
                for (var i = 0; i < Scopevalues.length; i++) {
                    var valueObj={
                        'value':Scopevalues[i]
                    };
                    if(!!oppoRec['Scope_Of_Work__c'] && oppoRec['Scope_Of_Work__c'].includes(Scopevalues[i])){
                        valueObj.isSelected = true; 
                    }else{
                        valueObj.isSelected = false; 
                    }
                    finalScopevalues.push(valueObj);
                }
                
                var ReqDetailsvalues = result['Requirement_Details__c'];
                var finalReqDetailsvalues = [];
                for (var i = 0; i < ReqDetailsvalues.length; i++) {
                    var valueObj={
                        'value':ReqDetailsvalues[i]
                    };
                    if(!!oppoRec['Requirement_Details__c'] && oppoRec['Requirement_Details__c'].includes(ReqDetailsvalues[i])){
                        valueObj.isSelected = true; 
                    }else{
                        valueObj.isSelected = false; 
                    }
                    finalReqDetailsvalues.push(valueObj);
                }
                
                var CWScopevalues = [];
                
                if(!!oppoRec['Civil_Work__c'] && oppoRec['Civil_Work__c']){
                    var valueObj={
                        'value':'true',
                        'isSelected':true
                    };
                    var valueObj2={
                        'value':'false',
                        'isSelected':false
                    };
                    CWScopevalues.push(valueObj);
                    CWScopevalues.push(valueObj2);
                }else{
                    var valueObj={
                        'value':'false',
                        'isSelected':true
                    }; 
                    
                    var valueObj2={
                        'value':'true',
                        'isSelected':false
                    }; 
                    CWScopevalues.push(valueObj);
                    CWScopevalues.push(valueObj2);
                }
                component.set("v.ListHomeType",finalHometypeValues);
                component.set("v.ListScopeOfWork",finalScopevalues);
                component.set("v.ListInteriorworkneededfor",finalinteriorValues);
                component.set("v.ListPropertyUsage",finalPropertyvalues);
                component.set("v.ListRequirementDetails",finalReqDetailsvalues);
                component.set("v.ListCivilWork",CWScopevalues);
                component.set("v.FloorArea",oppoRec['Floor_Area__c']);
                component.set("v.MoveIn",oppoRec['Move_in__c']);
            }
        });
        $A.enqueueAction(action);
    },
    // Submit to save the updated values in leads
    Saveupdatedoppvalues: function(component,event,helper){
        var oppoRec = component.get("v.OppRecord");
        var hometypeArray = component.get("v.ListHomeType");
        var scopeOfWorkArray =  component.get("v.ListScopeOfWork");
        var interiorArray =  component.get("v.ListInteriorworkneededfor");
        var propertyArray = component.get("v.ListPropertyUsage");
        var RequirementArray = component.get("v.ListRequirementDetails");
        var civilWorkArray = component.get("v.ListCivilWork");
        
        var hometype = null;
        for(var i=0;i<hometypeArray.length;i++){
            if(hometypeArray[i].isSelected){
                if(!!hometype){
                    hometype = hometype+';'+hometypeArray[i].value;
                }else{
                    hometype = hometypeArray[i].value;
                }
            }
        }
        
        var scopeOfWork = null;
        for(var i=0;i<scopeOfWorkArray.length;i++){
            if(scopeOfWorkArray[i].isSelected){
                if(!!scopeOfWork){
                    scopeOfWork = scopeOfWork+';'+scopeOfWorkArray[i].value;
                }else{
                    scopeOfWork = scopeOfWorkArray[i].value;
                }
            }
        }
        
        var interior = null;
        for(var i=0;i<interiorArray.length;i++){
            if(interiorArray[i].isSelected){
                if(!!interior){
                    interior = interior+';'+interiorArray[i].value;
                }else{
                    interior = interiorArray[i].value;
                }
            }
        }
        
        var property = null;
        for(var i=0;i<propertyArray.length;i++){
            if(propertyArray[i].isSelected){
                if(!!property){
                    property = property+';'+propertyArray[i].value;
                }else{
                    property = propertyArray[i].value;
                }
            }
        }
        
         var Requirement = null;
        for(var i=0;i<RequirementArray.length;i++){
            if(RequirementArray[i].isSelected){
                if(!!Requirement){
                    Requirement = Requirement+';'+RequirementArray[i].value;
                }else{
                    Requirement = RequirementArray[i].value;
                }
            }
        }
        
        var civilWork = false;
        for(var i=0;i<civilWorkArray.length;i++){
            if(civilWorkArray[i].isSelected){
                civilWork = civilWorkArray[i].value;
            }
        }
        oppoRec['Home_Type__c'] = hometype;
        oppoRec['Scope_Of_Work__c'] = scopeOfWork;
        oppoRec['Interior_work_needed_for__c'] = interior;
        oppoRec['Property_Usage__c'] = property;
        oppoRec['Requirement_Details__c'] = Requirement;
        oppoRec['Civil_Work__c'] =civilWork;
        oppoRec['Floor_Area__c'] =component.get('v.FloorArea');
        oppoRec['Move_in__c'] =component.get('v.MoveIn');
        
        var action = component.get("c.UpdateOpportunityRec");
           action.setParams({
            "oppoRec" : JSON.stringify(oppoRec)
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
        component.set("v.disablepicklistvalues",true);
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
        component.set("v.disablepicklistvalues",true);
    }
})