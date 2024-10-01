({
	doInit : function(component, event, helper) {
		component.set("v.disablevalues",true);
        helper.getOpportunityData(component, event);
	},
    onChange1 : function(cmp, event, helper) {
      var cb1 = event.getSource().get("v.value");  
        cmp.set('v.FramesofExtDoorsWin',cb1);
    },
    onChange2 : function(cmp, event, helper) {
      var cb2 = event.getSource().get("v.value");  
        cmp.set('v.AllWallCompleted',cb2);
    },
    onChange3 : function(cmp, event, helper) {
      var cb3 = event.getSource().get("v.value");  
        cmp.set('v.Floorsleveledout',cb3);
    },
    onChange4 : function(cmp, event, helper) {
      var cb4 = event.getSource().get("v.value");  
        cmp.set('v.Doorwindowinstall',cb4);
    },
    onChange5 : function(cmp, event, helper) {
      var cb5 = event.getSource().get("v.value");  
        cmp.set('v.puttyonecoat',cb5);
    },
    onChange6 : function(cmp, event, helper) {
      var cb6 = event.getSource().get("v.value");  
        cmp.set('v.Flooringcompleted',cb6);
    },
  /*  onChange7 : function(cmp, event, helper) {
      var cb7 = event.getSource().get("v.value");  
        cmp.set('v.requiredtoc',cb7);
    },*/
    onChange8 : function(cmp, event, helper) {
      var cb8 = event.getSource().get("v.value");  
        cmp.set('v.Notes',cb8);
    },
    handleEdit :function(component, event, helper){
        component.set("v.disablevalues",false); 
    },
    UpdateOpportunity : function(component, event, helper){
            helper.SaveupdatedOppvalues(component, event,helper);  
    }
})