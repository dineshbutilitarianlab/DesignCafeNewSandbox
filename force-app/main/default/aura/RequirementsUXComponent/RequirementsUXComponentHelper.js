({
    // Picklist data shown as buttons
    getLeadPicklist: function(component, event) {
        var action = component.get("c.picklistvalues");
        action.setParams({"recordId" : component.get('v.recordId')});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = JSON.parse(response.getReturnValue());
                var hometypeFinalValues = [];
                
                var leadRec = JSON.parse(result['LeadRecord']);
                component.set('v.LeadRecord',leadRec);
                component.set("v.HomeType",leadRec['Home_Type__c']);
                component.set("v.ScopeOfWork",leadRec['Scope_Of_Work__c']);
                component.set("v.Interiorworkneededfor",leadRec['Interior_work_needed_for__c']);
                component.set("v.Eat",leadRec['Eat__c']);   
                component.set("v.SiteServiceNeededfor",leadRec['Site_Service_Needed_for__c']);                   
                component.set("v.PropertyUsage",leadRec['Property_Usage__c']);
                component.set("v.RequirementDetails",leadRec['Requirement_Details__c']);
                component.set("v.CivilWork",leadRec['Civil_Work__c']);
                component.set("v.ld.Work",leadRec['Work__c']);       
                component.set("v.ld.CabReq",leadRec['Cab_Req__c']);                    
                component.set("v.Live",leadRec['Live__c']);    
                component.set("v.Play",leadRec['Play__c']);                 
                component.set("v.FloorArea",leadRec['Area__c']);
                component.set("v.OthersforLive",leadRec['Others_for_Live__c']);   
                component.set("v.OthersforPlay",leadRec['Others_for_Play__c']); 
                component.set("v.Howmanykidsdoyouhave",leadRec['How_many_kids_do_you_have__c']); 
                component.set("v.AgeofFirstkid",leadRec['Age_of_First_kid__c']); 
                component.set("v.GenderofFirstkid",leadRec['Gender_of_First_kid__c']); 
                component.set("v.AgeofSecondkid",leadRec['Age_of_Second_kid__c']); 
                component.set("v.GenderofSecondkid",leadRec['Gender_of_Second_kid__c']);    
                component.set("v.AgeofThirdkid",leadRec['Age_of_Third_kid__c']);
                component.set("v.GenderofThirdkid",leadRec['Gender_of_Third_kid__c']);
                component.set("v.AgeofFourthkid",leadRec['Age_of_Fourth_kid__c']);
                component.set("v.GenderofFourthkid",leadRec['Gender_of_Fourth_kid__c']);
                component.set("v.Doyouhavepets",leadRec['Do_you_have_pets__c']);   
                component.set("v.Whowillbestayinginthehouse",leadRec['Who_will_be_staying_in_the_house__c']);
                component.set("v.Whereareyoucurrentlylocated",leadRec['Where_are_you_currently_located__c']);  
                component.set("v.Whichlanguageareyoumostcomfortable",leadRec['Which_language_are_you_most_comfortable__c']);  
                component.set("v.Ifotherlanguagespleasespecify",leadRec['If_other_languages_please_specify__c']);                  
                component.set("v.MoveIn",leadRec['Move_in__c']);
                component.set("v.PropertyPossessionDate",leadRec['Property_Possession_Date__c']);
                component.set("v.ld.Whenwouldyouliketohavethehome",leadRec['When_would_you_like_to_have_the_home__c']); 
                component.set("v.DesignerTeamName",leadRec['Designer_Team_Name__c']); 
                                
                var HomeTypevalues = result['Home_Type__c'];
                var finalHometypeValues = [];
                for (var i = 0; i < HomeTypevalues.length; i++) {
                    var valueObj={
                        'value':HomeTypevalues[i]
                    };
                    if(leadRec['Home_Type__c'] != undefined && leadRec['Home_Type__c'].includes(HomeTypevalues[i])){
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
                    if(!!leadRec['Property_Usage__c'] && leadRec['Property_Usage__c'].includes(Propertyvalues[i])){
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
                    if(!!leadRec['Interior_work_needed_for__c'] && leadRec['Interior_work_needed_for__c'].includes(interiorValues[i])){
                        valueObj.isSelected = true; 
                    }else{
                        valueObj.isSelected = false; 
                    }
                    finalinteriorValues.push(valueObj);
                }

                var EatValues = result['Eat__c'];
                var finalEatValues = [];
                for (var i = 0; i < EatValues.length; i++) {
                    var valueObj={
                        'value':EatValues[i]
                    };
                    if(!!leadRec['Eat__c'] && leadRec['Eat__c'].includes(EatValues[i])){
                        valueObj.isSelected = true; 
                    }else{
                        valueObj.isSelected = false; 
                    }
                    finalEatValues.push(valueObj);
                }
                
                
                 var SiteServiceNeededforValues = result['Site_Service_Needed_for__c'];
                var finalSiteServiceNeededforValues = [];
                for (var i = 0; i < SiteServiceNeededforValues.length; i++) {
                    var valueObj={
                        'value':SiteServiceNeededforValues[i]
                    };
                    if(!!leadRec['Site_Service_Needed_for__c'] && leadRec['Site_Service_Needed_for__c'].includes(SiteServiceNeededforValues[i])){
                        valueObj.isSelected = true; 
                    }else{
                        valueObj.isSelected = false; 
                    }
                    finalSiteServiceNeededforValues.push(valueObj);
                }               
                      
                    
  
     var action = component.get("c.getWhenwouldyouliketohavethehomeValue");
       action.setCallback(this, function(response) {
           var state = response.getState();
            if (state === "SUCCESS") {
               var result = response.getReturnValue();
                var WhenwouldyouliketohavethehomeMap = [];
                for(var key in result){
                    WhenwouldyouliketohavethehomeMap.push({key: key, value: result[key]});
                }
              component.set("v.WhenwouldyouliketohavethehomeMap", WhenwouldyouliketohavethehomeMap);
            }
      });
       $A.enqueueAction(action);
                
                
     var action = component.get("c.getWorkValue");
       action.setCallback(this, function(response) {
           var state = response.getState();
            if (state === "SUCCESS") {
               var result = response.getReturnValue();
                var WorkMap = [];
                for(var key in result){
                    WorkMap.push({key: key, value: result[key]});
                }
              component.set("v.WorkMap", WorkMap);
            }
      });
       $A.enqueueAction(action);                
                
     var action = component.get("c.getCabReqValue");
       action.setCallback(this, function(response) {
           var state = response.getState();
            if (state === "SUCCESS") {
               var result = response.getReturnValue();
                var CabReqMap = [];
                for(var key in result){
                    CabReqMap.push({key: key, value: result[key]});
                }
              component.set("v.CabReqMap", CabReqMap);
            }
      });
       $A.enqueueAction(action);                   
                      
                
                var WhowillbestayinginthehouseValues = result['Who_will_be_staying_in_the_house__c'];
                var finalWhowillbestayinginthehouseValues = [];
                for (var i = 0; i < WhowillbestayinginthehouseValues.length; i++) {
                    var valueObj={
                        'value':WhowillbestayinginthehouseValues[i]
                    };
                    if(!!leadRec['Who_will_be_staying_in_the_house__c'] && leadRec['Who_will_be_staying_in_the_house__c'].includes(WhowillbestayinginthehouseValues[i])){
                        valueObj.isSelected = true; 
                    }else{
                        valueObj.isSelected = false; 
                    }
                    finalWhowillbestayinginthehouseValues.push(valueObj);
                }                
                
                    
                 var LiveValues = result['Live__c'];
                var finalLiveValues = [];
                for (var i = 0; i < LiveValues.length; i++) {
                    var valueObj={
                        'value':LiveValues[i]
                    };
                    if(!!leadRec['Live__c'] && leadRec['Live__c'].includes(LiveValues[i])){
                        valueObj.isSelected = true; 
                    }else{
                        valueObj.isSelected = false; 
                    }
                    finalLiveValues.push(valueObj);
                }    
                
                 var PlayValues = result['Play__c'];
                var finalPlayValues = [];
                for (var i = 0; i < PlayValues.length; i++) {
                    var valueObj={
                        'value':PlayValues[i]
                    };
                    if(!!leadRec['Play__c'] && leadRec['Play__c'].includes(PlayValues[i])){
                        valueObj.isSelected = true; 
                    }else{
                        valueObj.isSelected = false; 
                    }
                    finalPlayValues.push(valueObj);
                }                 
                
                
                var Scopevalues = result['Scope_Of_Work__c'];
                var finalScopevalues = [];
                for (var i = 0; i < Scopevalues.length; i++) {
                    var valueObj={
                        'value':Scopevalues[i]
                    };
                    if(!!leadRec['Scope_Of_Work__c'] && leadRec['Scope_Of_Work__c'].includes(Scopevalues[i])){
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
                    if(!!leadRec['Requirement_Details__c'] && leadRec['Requirement_Details__c'].includes(ReqDetailsvalues[i])){
                        valueObj.isSelected = true; 
                    }else{
                        valueObj.isSelected = false; 
                    }
                    finalReqDetailsvalues.push(valueObj);
                }
                
                var CWScopevalues = [];
                
                if(!!leadRec['Civil_Work__c'] && leadRec['Civil_Work__c']){
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
                component.set("v.ListEat",finalEatValues);       
                component.set("v.ListSiteServiceNeededfor",finalSiteServiceNeededforValues);                   
                component.set("v.ListPropertyUsage",finalPropertyvalues);
                component.set("v.ListRequirementDetails",finalReqDetailsvalues);
                component.set("v.ListCivilWork",CWScopevalues); 
                component.set("v.ListLive",finalLiveValues); 
                component.set("v.ListPlay",finalPlayValues);                
                component.set("v.FloorArea",leadRec['Area__c']);
                component.set("v.OthersforLive",leadRec['Others_for_Live__c']); 
                component.set("v.OthersforPlay",leadRec['Others_for_Play__c']); 
                component.set("v.Howmanykidsdoyouhave",leadRec['How_many_kids_do_you_have__c']); 
                component.set("v.AgeofFirstkid",leadRec['Age_of_First_kid__c']); 
                component.set("v.GenderofFirstkid",leadRec['Gender_of_First_kid__c']); 
                component.set("v.AgeofSecondkid",leadRec['Age_of_Second_kid__c']); 
                component.set("v.GenderofSecondkid",leadRec['Gender_of_Second_kid__c']);  
                component.set("v.AgeofThirdkid",leadRec['Age_of_Third_kid__c']);
                component.set("v.GenderofThirdkid",leadRec['Gender_of_Third_kid__c']);
                component.set("v.AgeofFourthkid",leadRec['Age_of_Fourth_kid__c']);
                component.set("v.GenderofFourthkid",leadRec['Gender_of_Fourth_kid__c']);
                component.set("v.Doyouhavepets",leadRec['Do_you_have_pets__c']);    
                component.set("v.ListWhowillbestayinginthehouse",finalWhowillbestayinginthehouseValues);                   
                component.set("v.MoveIn",leadRec['Move_in__c']);
                component.set("v.Whereareyoucurrentlylocated",leadRec['Where_are_you_currently_located__c']); 
                component.set("v.Whichlanguageareyoumostcomfortable",leadRec['Which_language_are_you_most_comfortable__c']); 
                component.set("v.Ifotherlanguagespleasespecify",leadRec['If_other_languages_please_specify__c']); 
                component.set("v.PropertyPossessionDate",leadRec['Property_Possession_Date__c']);
                component.set("v.ld.Whenwouldyouliketohavethehome",leadRec['When_would_you_like_to_have_the_home__c']); 
                component.set("v.ld.Work",leadRec['Work__c']);   
                component.set("v.ld.CabReq",leadRec['Cab_Req__c']);     
                component.set("v.DesignerTeamName",leadRec['Designer_Team_Name__c']);                 
            }
        });
        $A.enqueueAction(action);
    },
       
    // Submit to save the updated values in leads
    Saveupdatedleadvalues: function(component,event,helper){
  
        var leadRec = component.get("v.LeadRecord");
        var hometypeArray = component.get("v.ListHomeType");
        var scopeOfWorkArray =  component.get("v.ListScopeOfWork");
        var interiorArray =  component.get("v.ListInteriorworkneededfor");
        var EatArray =  component.get("v.ListEat");
        var SiteServiceNeededforArray =  component.get("v.ListSiteServiceNeededfor");        
        var propertyArray = component.get("v.ListPropertyUsage");
        var RequirementArray = component.get("v.ListRequirementDetails");
        var civilWorkArray = component.get("v.ListCivilWork");
        var LiveArray = component.get("v.ListLive");        
        var PlayArray = component.get("v.ListPlay"); 
        var WhowillbestayinginthehouseArray =  component.get("v.ListWhowillbestayinginthehouse");     
        var hometype = null;
        var WhenwouldyouliketohavethehomeArray =  component.get("v.ld.Whenwouldyouliketohavethehome");  
        var WorkArray =  component.get("v.ld.Work");     
        var CabReqArray =  component.get("v.ld.CabReq");    
        
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
        
        var Eat = null;
        for(var i=0;i<EatArray.length;i++){
            if(EatArray[i].isSelected){
                if(!!Eat){
                    Eat = Eat+';'+EatArray[i].value;
                }else{
                    Eat = EatArray[i].value;
                }
            }
        }    

        /*
        var SiteServiceNeededfor = null;
        if(civilWorkArray === true){
            for(var i=0;i<SiteServiceNeededforArray.length;i++){
                if(SiteServiceNeededforArray[i].isSelected){
                    if(!!SiteServiceNeededfor){
                        SiteServiceNeededfor = SiteServiceNeededfor+';'+SiteServiceNeededforArray[i].value;
                    }else{
                        SiteServiceNeededfor = SiteServiceNeededforArray[i].value;
                    }
                }
            }   
        }
		*/ 
        var SiteServiceNeededfor = null;
        for(var i=0;i<SiteServiceNeededforArray.length;i++){
            if(SiteServiceNeededforArray[i].isSelected){
                if(!!SiteServiceNeededfor){
                    SiteServiceNeededfor = SiteServiceNeededfor+';'+SiteServiceNeededforArray[i].value;
                }else{
                    SiteServiceNeededfor = SiteServiceNeededforArray[i].value;
                }
            }
        }            
       
        var Whowillbestayinginthehouse = null;
        for(var i=0;i<WhowillbestayinginthehouseArray.length;i++){
            if(WhowillbestayinginthehouseArray[i].isSelected){
                if(!!Whowillbestayinginthehouse){
                    Whowillbestayinginthehouse = Whowillbestayinginthehouse+';'+WhowillbestayinginthehouseArray[i].value;
                }else{
                    Whowillbestayinginthehouse = WhowillbestayinginthehouseArray[i].value;
                }
            }
        }         

                
        
        var Live = null;
        for(var i=0;i<LiveArray.length;i++){
            if(LiveArray[i].isSelected){
                if(!!Live){
                    Live = Live+';'+LiveArray[i].value;
                }else{
                    Live = LiveArray[i].value;
                }
            }
        }        
        
        var Play = null;
        for(var i=0;i<PlayArray.length;i++){
            if(PlayArray[i].isSelected){
                if(!!Play){
                    Play = Play+';'+PlayArray[i].value;
                }else{
                    Play = PlayArray[i].value;
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
        
        
        /*var civilWork = false;
        for(var i=0;i<civilWorkArray.length;i++){
            if(civilWorkArray[i].isSelected){
                civilWork = civilWorkArray[i].value;
            }
        }
        
        */
        
          
        
        leadRec['Home_Type__c'] = hometype;
        leadRec['Scope_Of_Work__c'] = scopeOfWork;
        leadRec['Interior_work_needed_for__c'] = interior;
        leadRec['Eat__c'] = Eat;   
        leadRec['Site_Service_Needed_for__c'] = SiteServiceNeededfor;          
        leadRec['Property_Usage__c'] = property;
        leadRec['Requirement_Details__c'] = Requirement;
        //leadRec['Civil_Work__c'] =civilWork;
        leadRec['Civil_Work__c'] =component.get('v.CivilWork');
        leadRec['Work__c'] =component.get('v.ld.Work');   
        leadRec['Cab_Req__c'] =component.get('v.ld.CabReq');           
        leadRec['Live__c'] =Live;   
        leadRec['Play__c'] =Play;         
        leadRec['Area__c'] =component.get('v.FloorArea');
        leadRec['Others_for_Live__c'] =component.get('v.OthersforLive');  
        leadRec['Others_for_Play__c'] =component.get('v.OthersforPlay');  
        leadRec['How_many_kids_do_you_have__c'] =component.get('v.Howmanykidsdoyouhave');  
        leadRec['Age_of_First_kid__c'] =component.get('v.AgeofFirstkid');  
        leadRec['Gender_of_First_kid__c'] =component.get('v.GenderofFirstkid');  
        leadRec['Age_of_Second_kid__c'] =component.get('v.AgeofSecondkid');  
        leadRec['Gender_of_Second_kid__c'] =component.get('v.GenderofSecondkid');  
        leadRec['Age_of_Third_kid__c'] =component.get('v.AgeofThirdkid'); 
        leadRec['Gender_of_Third_kid__c'] =component.get('v.GenderofThirdkid'); 
        leadRec['Age_of_Fourth_kid__c'] =component.get('v.AgeofFourthkid'); 
        leadRec['Gender_of_Fourth_kid__c'] =component.get('v.GenderofFourthkid'); 
        leadRec['Do_you_have_pets__c'] =component.get('v.Doyouhavepets');    
        leadRec['Who_will_be_staying_in_the_house__c'] = Whowillbestayinginthehouse;          
        leadRec['Move_in__c'] =component.get('v.MoveIn');
        leadRec['Property_Possession_Date__c'] =component.get('v.PropertyPossessionDate');
        leadRec['Where_are_you_currently_located__c'] =component.get('v.Whereareyoucurrentlylocated');  
        leadRec['Which_language_are_you_most_comfortable__c'] =component.get('v.Whichlanguageareyoumostcomfortable');  
        leadRec['If_other_languages_please_specify__c'] =component.get('v.Ifotherlanguagespleasespecify');          
        leadRec['When_would_you_like_to_have_the_home__c'] =component.get('v.ld.Whenwouldyouliketohavethehome');          
        leadRec['Designer_Team_Name__c'] =component.get('v.DesignerTeamName');  
        var action = component.get("c.Updatelead");
           action.setParams({
            "leadRec" : JSON.stringify(leadRec)
        });
        
        /*
        Show toast error message When site Services / Civil Work is selected 
        but at least one Site Service Needed options is not selected.
        Also show error when Site Services / Civil Work is NOT selected 
        but at least one Site Service Needed options is selected.
        Otherwise, save the record.
        */
        if((component.get('v.CivilWork') == true && SiteServiceNeededfor != null) ||
           (component.get('v.CivilWork') == false && SiteServiceNeededfor == null)){
           action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var result = response.getReturnValue();
                    helper.showSuccess(component, event, helper);
                }
            });
            $A.enqueueAction(action);
        } else if (component.get('v.CivilWork') == false && SiteServiceNeededfor != null) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Error',
                message: 'Please select Site Services / Civil Work or deselect Site Service needed for',
                duration: '5000',
                key: 'info_alt',
                type: 'error',
                mode: 'dismissible'
            });
            toastEvent.fire();
        } else if (component.get('v.CivilWork') == true && SiteServiceNeededfor == null) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Error',
                message: 'Please select Site Service Needed for',
                duration: '5000',
                key: 'info_alt',
                type: 'error',
                mode: 'dismissible'
            });
            toastEvent.fire();
        }
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