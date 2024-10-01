({
    doInit: function(component, event, helper) {
        console.log('This is do init method');
        let action = component.get("c.checkPaymentRequestCreated");
        action.setParams({
            oppId: component.get( "v.recordId" )
        });
        action.setCallback(this, function(response) {
        	console.log("doInit : Response : " + response.toString()); 
            let state = response.getState();
            component.set("v.IsRequestPaymentAvailable",response.getReturnValue());
        });
        $A.enqueueAction( action );
    },
    
    handleSubmit : function(component, event, helper) {
        let action = component.get( "c.addPayment" );
   
        component.set("v.Isdisabled",true);
        action.setParams({
            oppId: component.get( "v.recordId" )
        });
        action.setCallback(this, function(response) {
            console.log("Aura AddManualPayment : Response : "+ response.toString());
            let state = response.getState();
            let paymentStatus = response.getReturnValue();
            console.log(paymentStatus.length);
            
            for (let i = 0; i < paymentStatus.length; i++) {
                
                //let payment = paymentStatus[i].payment;
                let errorMessage = paymentStatus[i].errorMessage;
                //let paymentType = paymentStatus[i].paymentType;
                let APIresptoAura = paymentStatus[i].APIresptoAura;
                let APIcodetoAura = paymentStatus[i].APIcodetoAura;
                //console.log("ErrorMessage: " + errorMessage);
                //console.log("type : " + paymentType);
                console.log("APIcodetoAura : " + APIcodetoAura)
                console.log("APIresptoAura : " + APIresptoAura)
                //console.log("payment : " + payment);
                
                if (APIcodetoAura === '200') {
                    let showToast = $A.get( "e.force:showToast" );
                    showToast.setParams({
                        title : 'Payment Receipt status: -',
                        message : APIresptoAura.toString(),
                        type : 'success',
                    });
                    showToast.fire();
                }
                else if (APIcodetoAura === '400'){
                    let showToast = $A.get( "e.force:showToast" );
                    showToast.setParams({
                        title : 'Failure in Payment Receipt generation',
                        message : APIresptoAura.toString(),
                        type : 'error'
                    });
                    showToast.fire();
                }
                    else {
                        let showToast = $A.get( "e.force:showToast" );
                        showToast.setParams({
                            title : 'Failure in payment generation',
                            message : errorMessage,
                            type : 'error'
                        });
                        showToast.fire();
                    }
                $A.get("e.force:closeQuickAction").fire();
                $A.get('e.force:refreshView').fire();
            }
        });
        $A.enqueueAction( action );
    },
    
    handleChange : function(component, event, helper) {
        // console.log(event.getParam("value"));
        // if(event.getParam("value") <= 0){
        //     var validity = cmp.find("myinput").get("v.validity");
        //     console.log('valid',validity.valid); 
        //     // var validity = cmp.find("myinput").get("v.validity");
        //     // console.log(validity.valid); //returns true

        //     component.find('myinput').setCustomValidity("wwwww");
        // }
    },
    
    handleCancel : function(cmp,event,helper){
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": cmp.get("v.recordId")
        });
        navEvt.fire();
    },
    getValueFromLwc : function(component, event, helper) {
		component.set('v.latestQuoteId',event.getParam('childId')); //siteServicesAmountInclGST
		//component.set('v.siteServicesAmountInclGST',event.getParam('siteServicesAmountInclGST')); //siteServicesAmountInclGST
         var sitevalue = event.getParam('siteServicesAmountInclGST');
        if(sitevalue == 0){
            component.set("v.SiteServicedisabled",true);
        }
        else{
            component.set("v.SiteServicedisabled",false);
        }
        console.log("test1"+event.getParam('childId'));
         console.log("SiteServicedisabled"+sitevalue);
         console.log("SiteServicedisabled"+component.get("v.SiteServicedisabled"));
        
	},
    
    handleUploadFinished: function(cmp,event,helper){
    	let uploadedFiles = event.getParam("files"); //all the files uploaded
        let allFiles=[]; //in the form of [{Id:"",Name:""}];
        let allIdsToDelete=[];
        if(uploadedFiles && Array.isArray(uploadedFiles) && uploadedFiles.length>0){ //in case of multiple file upload in one time
            allFiles = uploadedFiles.map(file=>{return {Id:file.documentId,Title:file.name};});
        }
        else if(uploadedFiles && uploadedFiles !=null){ // in case of only single file upload in one time
            allFiles.push({Id:uploadedFiles.documentId,Title:uploadedFiles.name});
        }
        if(allFiles && allFiles.length>0){
            if(cmp.get("v.sObjectAttachedFiles") !=null){ // In case if user is uploading one file at a time for multiple files(3 files- uploading 1 at a time)
                const alreadyAttachedFiles = cmp.get("v.sObjectAttachedFiles");
                alreadyAttachedFiles.forEach(file=>allFiles.push(file));
            }
            cmp.set("v.sObjectAttachedFiles",allFiles); //all the files which have to be displayed in the file card cmp
         	cmp.set("v.idsToBeDeleted",allFiles); //we would use this attrib in apex to do dml for files which gets created.
            console.log("allFiles:: ",JSON.stringify(allFiles)); 
        }        
	},
    deleteAttachments: function(cmp,event,helper){
       helper.deleteDocs(cmp,event);
    },
})