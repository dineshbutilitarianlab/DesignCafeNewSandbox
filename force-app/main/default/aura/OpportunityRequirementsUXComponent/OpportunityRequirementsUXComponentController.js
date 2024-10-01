({
    //Load Lead Picklist values
    doInit: function(component, event, helper) { 
        component.set("v.disablepicklistvalues",true);
        helper.getoppPicklist(component, event);
    },
       
    homeTypeButtons : function(cmp, event, helper) {
        var whichOne = event.getSource().get("v.name");
        var HomeTypevalues = cmp.get('v.ListHomeType');
        for (var i = 0; i < HomeTypevalues.length; i++) {
            if(HomeTypevalues[i].value == whichOne){
                HomeTypevalues[i].isSelected = HomeTypevalues[i].isSelected ? false: true;
            }
        }
        cmp.set("v.ListHomeType", HomeTypevalues);
    },
    
    ListScopeOfWorkButtons : function(cmp, event, helper) {
        var whichOne = event.getSource().get("v.name");
        var HomeTypevalues = cmp.get('v.ListScopeOfWork');
        for (var i = 0; i < HomeTypevalues.length; i++) {
            if(HomeTypevalues[i].value == whichOne){
                HomeTypevalues[i].isSelected = HomeTypevalues[i].isSelected ? false: true;
            }
        }
        cmp.set("v.ListScopeOfWork", HomeTypevalues);
    },
    
    ListInteriorworkneededforButtons : function(cmp, event, helper) {
        var whichOne = event.getSource().get("v.name");
        var HomeTypevalues = cmp.get('v.ListInteriorworkneededfor');
        for (var i = 0; i < HomeTypevalues.length; i++) {
            if(HomeTypevalues[i].value == whichOne){
                HomeTypevalues[i].isSelected = HomeTypevalues[i].isSelected ? false: true;
            }
        }
        cmp.set("v.ListInteriorworkneededfor", HomeTypevalues);
    },
    
    ListPropertyUsageButtons : function(cmp, event, helper) {
        var whichOne = event.getSource().get("v.name");
        var HomeTypevalues = cmp.get('v.ListPropertyUsage');
        for (var i = 0; i < HomeTypevalues.length; i++) {
            if(HomeTypevalues[i].value == whichOne){
                HomeTypevalues[i].isSelected = HomeTypevalues[i].isSelected ? false: true;
            }
        }
        cmp.set("v.ListPropertyUsage", HomeTypevalues);
    },
    
    ListRequirementDetailsButtons : function(cmp, event, helper) {
        var whichOne = event.getSource().get("v.name");
        var HomeTypevalues = cmp.get('v.ListRequirementDetails');
        for (var i = 0; i < HomeTypevalues.length; i++) {
            if(HomeTypevalues[i].value == whichOne){
                HomeTypevalues[i].isSelected = HomeTypevalues[i].isSelected ? false: true;
            }
        }
        cmp.set("v.ListRequirementDetails", HomeTypevalues);
    },
    
    onChangeFA : function(cmp, event, helper) {
      var FA = event.getSource().get("v.value");  
        cmp.set('v.FloorArea', FA);
    },
    
    onChangeMI : function(cmp, event, helper) {
      var MI = event.getSource().get("v.value");  
        cmp.set('v.MoveIn', MI);
    },
    
    cwButton : function(cmp, event, helper) {
        var whichOne = event.getSource().get("v.name");
        var HomeTypevalues = cmp.get('v.ListCivilWork');
        for (var i = 0; i < HomeTypevalues.length; i++) {
            if(HomeTypevalues[i].value == whichOne){
                HomeTypevalues[i].isSelected = true;
            }else{
                HomeTypevalues[i].isSelected = false;
            }
        }
        
        cmp.set("v.ListCivilWork", HomeTypevalues);
    },
   
     handleEdit :function(component, event, helper){
        component.set("v.disablepicklistvalues",false); 
    },
    
    // Update All required fields using Submit Button 
    UpdateOpportunity : function(component, event, helper){
            helper.Saveupdatedoppvalues(component, event, helper);  
    }
})