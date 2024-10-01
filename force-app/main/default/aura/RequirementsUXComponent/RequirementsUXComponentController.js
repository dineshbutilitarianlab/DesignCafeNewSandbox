({
    //Load Lead Picklist values
    doInit: function(component, event, helper) { 
        component.set("v.disablepicklistvalues",true);
        helper.getLeadPicklist(component, event);
        //helper.getPicklistValues(component, event);
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

    ListEatButtons : function(cmp, event, helper) {
        var whichOne = event.getSource().get("v.name");
        var HomeTypevalues = cmp.get('v.ListEat');
        for (var i = 0; i < HomeTypevalues.length; i++) {
            if(HomeTypevalues[i].value == whichOne){
                HomeTypevalues[i].isSelected = HomeTypevalues[i].isSelected ? false: true;
            }
        }
        cmp.set("v.ListEat", HomeTypevalues);
    },
    
  
    
    ListWhowillbestayinginthehouseButtons : function(cmp, event, helper) {
        var whichOne = event.getSource().get("v.name");
        var HomeTypevalues = cmp.get('v.ListWhowillbestayinginthehouse');
        for (var i = 0; i < HomeTypevalues.length; i++) {
            if(HomeTypevalues[i].value == whichOne){
                HomeTypevalues[i].isSelected = HomeTypevalues[i].isSelected ? false: true;
            }
        }
        cmp.set("v.ListWhowillbestayinginthehouse", HomeTypevalues);
    },    
    
 
    
     ListLiveButtons : function(cmp, event, helper) {
        var whichOne = event.getSource().get("v.name");
        var HomeTypevalues = cmp.get('v.ListLive');
        for (var i = 0; i < HomeTypevalues.length; i++) {
            if(HomeTypevalues[i].value == whichOne){
                HomeTypevalues[i].isSelected = HomeTypevalues[i].isSelected ? false: true;
            }
        }
        cmp.set("v.ListLive", HomeTypevalues);
    },
    
      ListPlayButtons : function(cmp, event, helper) {
        var whichOne = event.getSource().get("v.name");
        var HomeTypevalues = cmp.get('v.ListPlay');
        for (var i = 0; i < HomeTypevalues.length; i++) {
            if(HomeTypevalues[i].value == whichOne){
                HomeTypevalues[i].isSelected = HomeTypevalues[i].isSelected ? false: true;
            }
        }
        cmp.set("v.ListPlay", HomeTypevalues);
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
    
    onChangeOFL : function(cmp, event, helper) {
      var OFL = event.getSource().get("v.value");  
        cmp.set('v.OthersforLive', OFL);
    },    

    onChangeOFP : function(cmp, event, helper) {
      var OFP = event.getSource().get("v.value");  
        cmp.set('v.OthersforPlay', OFP);
    },  
    
    onChangeWAYCL : function(cmp, event, helper) {
      var WAYCL = event.getSource().get("v.value");  
        cmp.set('v.Whereareyoucurrentlylocated', WAYCL);
    },  

    onChangeWLAYMC : function(cmp, event, helper) {
      var WLAYMC = event.getSource().get("v.value");  
        cmp.set('v.Whichlanguageareyoumostcomfortable', WLAYMC);
    },  

    onChangeIOLPS : function(cmp, event, helper) {
      var IOLPS = event.getSource().get("v.value");  
        cmp.set('v.Ifotherlanguagespleasespecify', IOLPS);
    },      
    

    onChangeHMKDYH : function(cmp, event, helper) {
      var HMKDYH = event.getSource().get("v.value");  
        cmp.set('v.Howmanykidsdoyouhave', HMKDYH);
    },  

    onChangeAOFK : function(cmp, event, helper) {
      var AOFK = event.getSource().get("v.value");  
        cmp.set('v.AgeofFirstkid', AOFK);
    },  

    onChangeGOFK : function(cmp, event, helper) {
      var GOFK = event.getSource().get("v.value");  
        cmp.set('v.GenderofFirstkid', GOFK);
    },  

    onChangeAOSK : function(cmp, event, helper) {
      var AOSK = event.getSource().get("v.value");  
        cmp.set('v.AgeofSecondkid', AOSK);
    },  

    onChangeGOSK : function(cmp, event, helper) {
      var GOSK = event.getSource().get("v.value");  
        cmp.set('v.GenderofSecondkid', GOSK);
    },
    
    
    onChangeAOTK : function(cmp, event, helper) {
      var GOSK = event.getSource().get("v.value");  
        cmp.set('v.AgeofThirdkid', AOTK);
    },  

    onChangeGOTK : function(cmp, event, helper) {
      var GOTK = event.getSource().get("v.value");  
        cmp.set('v.GenderofThirdkid', GOTK);
    },  

    onChangeAOFK : function(cmp, event, helper) {
      var AOFK = event.getSource().get("v.value");  
        cmp.set('v.AgeofFourthkid', AOFK);
    },  

    onChangeGOFK : function(cmp, event, helper) {
      var GOFK = event.getSource().get("v.value");  
        cmp.set('v.GenderofFourthkid', GOFK);
    },  

    onChangeDYHP : function(cmp, event, helper) {
      var DYHP = event.getSource().get("v.value");  
        cmp.set('v.Doyouhavepets', DYHP);
    },  

    OnChangeWWYLTHH : function(cmp, event, helper) {
      // var Whenwouldyouliketohavethehome = event.getSource().get("v.value"); 
        var Whenwouldyouliketohavethehome = cmp.get("v.ld.Whenwouldyouliketohavethehome");
      //  alert(Whenwouldyouliketohavethehome);
   cmp.set('v.ld.Whenwouldyouliketohavethehome', Whenwouldyouliketohavethehome);
    },
    
    
    
     OnChangeWork : function(cmp, event, helper) {
        var Work = cmp.get("v.ld.Work");
      //  alert(Work);
   cmp.set('v.ld.Work', Work);
    },
    
      OnChangeCabReq : function(cmp, event, helper) {
        var CabReq = cmp.get("v.ld.CabReq");
     // alert(CabReq);
   cmp.set('v.ld.CabReq', CabReq);
    },   
    
    onChangeDTN : function(cmp, event, helper) {
      var DTN = event.getSource().get("v.value");  
        cmp.set('v.DesignerTeamName', DTN);
    },     
    
    
    onChangeMI : function(cmp, event, helper) {
      var MI = event.getSource().get("v.value");  
        cmp.set('v.MoveIn', MI);
    },
     onChangePPD : function(cmp, event, helper) {
      var PPD = event.getSource().get("v.value");  
        cmp.set('v.PropertyPossessionDate', PPD);
    },
    
    getToggleButtonValue:function(cmp, event, helper){
        var checkCmp = cmp.find("tglbtn").get("v.checked");
        cmp.set("v.ListCivilWork",checkCmp);
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
    
    
    
    
     ListSSNFButtons : function(cmp, event, helper) {
        var whichOne = event.getSource().get("v.name");
        var HomeTypevalues = cmp.get('v.ListSiteServiceNeededfor');
        
        for (var i = 0; i < HomeTypevalues.length; i++) {
            if(HomeTypevalues[i].value == whichOne){
                HomeTypevalues[i].isSelected = HomeTypevalues[i].isSelected ? false: true;
            }
        }
       
        cmp.set("v.ListSiteServiceNeededfor", HomeTypevalues);
           
    },      
    
 
    //--- For Edit Option 
    handleEdit :function(component, event, helper){
        component.set("v.disablepicklistvalues",false); 
    },
    
    // Update All required fields using Submit Button 
    UpdateLead : function(component, event, helper){
            helper.Saveupdatedleadvalues(component, event,helper);  
    }
})