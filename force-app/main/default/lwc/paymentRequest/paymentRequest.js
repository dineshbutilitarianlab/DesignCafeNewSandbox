import { LightningElement ,wire,track,api} from 'lwc';
import { getRecord,createRecord} from 'lightning/uiRecordApi';
import Id from '@salesforce/user/Id';
import PROFILE_NAME_FIELD from '@salesforce/schema/User.Profile.Name';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';
import addPaymentRequest from '@salesforce/apex/PaymentRequestsHandler_GraphQL.addPaymentRequest';
import getPaymentRequest from '@salesforce/apex/PaymentRequestsHandler_GraphQL.getPaymentRequest';
import getQuotes from '@salesforce/apex/PaymentRequestsHandler_GraphQL.getQuotes';
import getQuoteDetails from '@salesforce/apex/PaymentRequestsHandler_GraphQL.getQuoteDetails';

const COLS=[
    { label: 'Payment Description', fieldName:"Payment"},
    { label: 'Category', fieldName:"Category"},
    { label: 'Amount Requested',fieldName:"Amount"}
];

//['Opportunity.Name','Opportunity.Modular_Amount_Dis_Incl_GST__c','Opportunity.Site_Services_Amount_Dis_Incl_GST__c','Opportunity.Request_Payment_For_Modular_Amount__c','Opportunity.Request_Payment_For_Site_Services_Amount__c','Opportunity.Modular_Payment_Description__c','Opportunity.Site_Service_Payment_Description__c','Opportunity.Customer_ID__c'];
const FIELDS =['Opportunity.Name','Opportunity.Modular_Amount_Dis_Incl_GST__c','Opportunity.Site_Services_Amount_Dis_Incl_GST__c','Opportunity.Customer_ID__c','Opportunity.AccountId','Opportunity.StageName',
               'Opportunity.Email__c','Opportunity.Id','Opportunity.Quote_Id__c','Opportunity.Designer_Team_Name__c','Opportunity.EC_Name__c','Opportunity.UserId__c'];

const ACCFIELDS=['Account.Name','Account.PAN__c','Account.GST_No__c','Account.Customer_type__c','Account.ShippingCity','Account.ShippingStreet','Account.ShippingCountry','Account.ShippingState','Account.ShippingPostalCode', 'Account.BillingStreet','Account.BillingCity','Account.BillingCountry','Account.BillingState','Account.BillingPostalCode',
                 'Account.FirstName','Account.LastName','Account.Phone','Account.PersonMobilePhone','Account.Id'];

export default class PaymentRequest extends LightningElement {
    @api recordId;
    customModPrice=0;
    @track calcAmount=0.0;
    @track calcAmount2=0.0;
    customPrice=0; 
    siteServCost;
    modularProjCost; 
    @track customModCheck=false;
    servCostCheck=false;
    // isChecked = false; 
    dataCols =COLS;
    @track colData;
     disableButton=false;
    oppRec;
    accRec;
    latestQuoteId;
    showPrice1=true;
    showPrice2=true; 
    //Boolean tracked variable to indicate if modal is open or not default value is false as modal is closed when page is loaded 
    isModalOpen=true;
    miniPopUp=true;
    discountLabel1;
    discountLabel2;
    modPayDesc;
    sitePayDesc;
    @api modProjCost;
    @api siteServiceCost;
    modularRecordId;
    siteServiceRecordId;
    @track successBooleanArray=[];
    @track paymentReqArray=[];
    errorMsg="";
    @api accountId;
    errorMsgList=[];
    modDisabled=false;
    disableReqButton=false;
    processCmplt =false;
    
    @track arrayOptions = [];
    renderedCallback = false;
    @track quotes = [];
    mobilePhoneAcc;

    tagVisible = false;
    userId = Id;
    currentUserProfile;
    @track priceValidation = false;
    priceValidationMsg = "Amount should not be less than 20000";
    connectedCallback(){
        this.colData=[];
    }

    renderedCallback(){
        if(this.renderedCallback==false&&this.recordId!=undefined){
            getQuotes({recId : this.recordId})
            .then(result=>{
                console.log("Res===>"+JSON.stringify(result))
                console.log("ResLen===>"+result.length)
                for(let i=0;i<result.length;i++){
                    if(result[i].Latest_Quote__c==true){    // If true, set this as default value.
                        getQuoteDetails({ quoteId : result[i].Id })
                        .then(result2=>{
                            this.quotes = result2;   //  Set result to quotes.
                            this.quotes.quoteUrl = '/'+result2.Id;    //  Link to Quote.
                            this.latestQuoteId = result2.Id;    // Assigning latest quote id for future references.
                            this.quotes.accountUrl = '/'+result2.AccountId;    //  Link to Account.
                        })
                        .catch(error=>{
                            console.log("Error==>"+error);
                        })
                    }
                    this.arrayOptions = [...this.arrayOptions ,{value: result[i].Id , label: result[i].QuoteNumber}];   //  Assigning dropdown options to array.
                }
            })
            .catch(error=>{
                console.log("Error===>"+error);
            })
            
            getPaymentRequest({oppId : this.recordId})
            .then(result=>{
                console.log("Payment Req===>"+JSON.stringify(result))
                console.log("Payment Req Length===>"+result.length)
                if(result.length>0){
                    this.disableReqButton=true;
                }
            })
            .catch(error=>{
                console.log("Error===>"+error);
            })
            this.renderedCallback=true;
        }
    }

    get options() {
        return this.arrayOptions;   //  Returning dropdown options.
    }

    //Getting the current user profile and check whether it is system admin or not and set the 5% visiblity
    @wire(getRecord, { recordId: Id, fields: [PROFILE_NAME_FIELD]}) 
    userDetails({error, data}) {
        if (data) {
            this.currentUserProfile = data.fields.Profile.value.fields.Name.value;
            if(this.currentUserProfile != null && (this.currentUserProfile.toLowerCase() == 'sales team lead' || this.currentUserProfile.toLowerCase() == 'FOFO' || this.currentUserProfile.toLowerCase() == 'sales executive')) {
                this.priceValidation = true;
                console.log('currentUserProfile==>>'+this.currentUserProfile);
            }
            if( this.currentUserProfile != null && this.currentUserProfile.toLowerCase() == 'system administrator')
                  this.tagVisible = true;
                  console.log('profile name=> '+data.fields.Profile.value.fields.Name.value);
                  console.log('display prop : '+ this.tagVisible);
        } else if (error) {
            this.error = error ;
        }
       
    
    }

    // Function get quote details on dropdown change. --->Start.
    handleDropdownChange(event) {
        this.value = event.detail.value;
        console.log("Id===>"+this.value)
        getQuoteDetails({ quoteId : this.value })
        .then(result=>{
            this.quotes = result;   //  Set result to quotes.
            this.quotes.quoteUrl = '/'+result.Id;    //  Link to Quote.
            this.quotes.accountUrl = '/'+result.AccountId;    //  Link to Account.
        })
        .catch(error=>{
            console.log("Error==>"+error);
        })
    }
    // Function get quote details on dropdown change. --->End.

    @wire (getRecord,{recordId :'$recordId',fields:FIELDS})
    oppRecord({data,error}){
        if(data){            
            this.oppRec =data; 
            this.accountId =data.fields.AccountId.value;
            this.modularProjCost = this.oppRec.fields.Modular_Amount_Dis_Incl_GST__c.value;
            this.modProjCost = "Modular Project Cost :" +this.oppRec.fields.Modular_Amount_Dis_Incl_GST__c.value ;
            this.siteServCost =this.oppRec.fields.Site_Services_Amount_Dis_Incl_GST__c.value;
            this.siteServiceCost ="Site Services Cost :" +this.oppRec.fields.Site_Services_Amount_Dis_Incl_GST__c.value;
            if(this.modularProjCost <=0 || this.modularProjCost ==null){
                this.modDisabled =true;
            }
            if(this.siteServCost <=0 || this.siteServCost ==null){
                this.disableButton=true;
            }
            if(data.fields.StageName.value =="Closed Won"){
                this.errorMsgList.push("Do not allow payment request if the opportunity is Closed Won...");

            } if(data.fields.Modular_Amount_Dis_Incl_GST__c.value == 0 || data.fields.Modular_Amount_Dis_Incl_GST__c.value == null || data.fields.Modular_Amount_Dis_Incl_GST__c.value == undefined){
                this.errorMsgList.push("Modular Amount should not be Zero Or Null...");
            }
        }
        if(error){
            console.log("error:: ",error.body.message);
        }
    }
    @wire(getRecord,{recordId:"$accountId",fields:ACCFIELDS})
    accountData({data,error}){
        if(data){
            this.accRec = data;
            console.log("Account Data:: ",JSON.stringify(data));
         /*   if(data.fields.ShippingCity.value ==null || data.fields.ShippingCountry.value ==null || data.fields.ShippingStreet.value ==null || data.fields.ShippingState.value ==null || data.fields.ShippingPostalCode.value ==null ){
                this.errorMsgList.push("Please fill the Shipping address details before requesting for payment...");
            }
            if(data.fields.BillingCity.value ==null || data.fields.BillingCountry.value ==null || data.fields.BillingStreet.value ==null || data.fields.BillingState.value ==null || data.fields.BillingPostalCode.value ==null ){
                this.errorMsgList.push("Please fill the Billing address details before requesting for payment...");
            }
            if(data.fields.PAN__c.value ==null || data.fields.PAN__c.value ==undefined){
                this.errorMsgList.push("Please fill the PAN details before requesting for payment...");
            } 
            //console.log('data.fields.Customer_type__c.value ::'+Customer_type__c.value);
            console.log('data.fields.Customer_type__c.value ::'+data.fields.Customer_type__c.value);
            if(data.fields.Customer_type__c.value  ==null || data.fields.Customer_type__c.value  ==undefined){
                this.errorMsgList.push("Please fill the Customer Type details before requesting for payment...");
            }
            if(data.fields.Customer_type__c.value =="B2B" && ( data.fields.GST_No__c.value ==null || data.fields.GST_No__c.value ==undefined)){
                this.errorMsgList.push("Please fill the GST details before requesting for payment...");
            }
            console.log("this.errorMsgList:: ",this.errorMsgList);*/
        }
        else if(error){
            console.error("Error while fetching Account details:: ",JSON.stringify(error));
        }
    }

    closeModal() {
        this.dispatchEvent(new CloseActionScreenEvent());
        this.isModalOpen=false;
        const dispStatus =false;
        this.dispatchEvent(new CustomEvent("senddispstatus",{detail:dispStatus,bubbles:true}));
        console.log("check for event fired!");
        eval("$A.get('e.force:refreshView').fire()");
        
    }
    requestPayment() {
        // to close modal set isModalOpen tarck value as false
        //Add your code to call apex method or do some processing
       // this.isModalOpen = false;
            this.processCmplt =true;
            this.disableReqButton=true;            
            this.mobilePhoneAcc = this.accRec.fields.Phone.value;

            if(!this.mobilePhoneAcc){  // Checking phone is empty/not.
                console.log("Empty phone");
                this.mobilePhoneAcc = this.accRec.fields.PersonMobilePhone.value;  // Assign mobile to variable.
            }
                
            if(this.calcAmount > 0){
                    const fields={Request_Amount__c:this.calcAmount,
                        Description__c:this.modPayDesc,                    
                        Opportunity__c:this.recordId,
                        Client_ID__c:this.oppRec.fields.Customer_ID__c.value,Category__c:"Modular",
                        First_Name__c:this.accRec.fields.FirstName.value,
                        Last_Name__c:this.accRec.fields.LastName.value,
                        Customer_Phone__c:this.mobilePhoneAcc,
                        PAN_Card_No__c:this.accRec.fields.PAN__c.value,
                        GST_No__c:this.accRec.fields.GST_No__c.value,
                        Customer_Type__c:this.accRec.fields.Customer_type__c.value,
                        Billing_Street__c:this.accRec.fields.BillingStreet.value,
                        Billing_City__c:this.accRec.fields.BillingCity.value,
                        Billing_Country__c:this.accRec.fields.BillingCountry.value,
                        Billing_State__c:this.accRec.fields.BillingState.value,
                        Billing_zip__c:this.accRec.fields.BillingPostalCode.value,
                        Shipping_Street__c:this.accRec.fields.ShippingStreet.value,
                        Shipping_City__c:this.accRec.fields.ShippingCity.value,
                        Shipping_Country__c:this.accRec.fields.ShippingCountry.value,
                        Shipping_State__c:this.accRec.fields.ShippingState.value,
                        Shipping_Zip__c:this.accRec.fields.ShippingPostalCode.value,
                        Email__c:this.oppRec.fields.Email__c.value,
                        Oppo_Id__c:this.oppRec.fields.Id.value,
                        Quote_Id__c:this.latestQuoteId,
                        User_Id__c:this.oppRec.fields.UserId__c.value,
                        Team_Name__c:this.oppRec.fields.Designer_Team_Name__c.value,
                        EC_Name__c:this.oppRec.fields.EC_Name__c.value,
                        Account_ID__c:this.accRec.fields.Id.value};
                        this.paymentReqArray.push(fields);
                        // console.log("Modular===>"+JSON.stringify(this.paymentReqArray));
            }
            if(this.calcAmount2 >0){
                const fields ={Request_Amount__c:this.calcAmount2,Description__c:this.sitePayDesc, Opportunity__c:this.recordId,
                            Client_ID__c:this.oppRec.fields.Customer_ID__c.value,Category__c :"Site Services",
                            First_Name__c:this.accRec.fields.FirstName.value,
                            Last_Name__c:this.accRec.fields.LastName.value,
                            Customer_Phone__c:this.mobilePhoneAcc,
                            PAN_Card_No__c:this.accRec.fields.PAN__c.value,
                            GST_No__c:this.accRec.fields.GST_No__c.value,
                            Customer_Type__c:this.accRec.fields.Customer_type__c.value,
                            Billing_Street__c:this.accRec.fields.BillingStreet.value,
                            Billing_City__c:this.accRec.fields.BillingCity.value,
                            Billing_Country__c:this.accRec.fields.BillingCountry.value,
                            Billing_State__c:this.accRec.fields.BillingState.value,
                            Billing_zip__c:this.accRec.fields.BillingPostalCode.value,
                            Shipping_Street__c:this.accRec.fields.ShippingStreet.value,
                            Shipping_City__c:this.accRec.fields.ShippingCity.value,
                            Shipping_Country__c:this.accRec.fields.ShippingCountry.value,
                            Shipping_State__c:this.accRec.fields.ShippingState.value,
                            Shipping_Zip__c:this.accRec.fields.ShippingPostalCode.value,
                            Email__c:this.oppRec.fields.Email__c.value,
                            Oppo_Id__c:this.oppRec.fields.Id.value,
                            Quote_Id__c:this.latestQuoteId,
                            User_Id__c:this.oppRec.fields.UserId__c.value,
                            Team_Name__c:this.oppRec.fields.Designer_Team_Name__c.value,
                            EC_Name__c:this.oppRec.fields.EC_Name__c.value,
                            Account_ID__c:this.accRec.fields.Id.value};
                            this.paymentReqArray.push(fields);
                            // console.log("Site Services===>"+JSON.stringify(this.paymentReqArray));
            }
           
            if(this.paymentReqArray.length >0 && this.errorMsgList.length ==0){
                addPaymentRequest({paymReqList : this.paymentReqArray})
                
                .then(response=>{
                    console.log('Response::'+ JSON.stringify(response));
                    if(response.hasOwnProperty('Modular')){
                            if(response.Modular.statusCode ==200) {
                                console.log("in modular:: "+response.Modular);
                                this.dispatchEvent(
                                    new ShowToastEvent({
                                    title: 'Success',
                                    message: response.Modular.message+ ` with Modular Request Id -${response.Modular.data.requestID}`,
                                    variant: 'success',
                                    mode: 'pester'
                                    })
                                );       
                            }
                            else{
                                this.dispatchEvent(
                                    new ShowToastEvent({
                                        title: 'Error while creating Modular Record',
                                        message: response.Modular.message,
                                        variant: 'error',
                                        mode: 'pester'
                                    })
                                );
                            }   
                                           
                           
                    }
                    if(response.hasOwnProperty('Site Services')){
                        if(response["Site Services"].statusCode ==200){
                            console.log("in site services:: "+response["Site Services"]);
                                this.dispatchEvent(
                                new ShowToastEvent({
                                title: 'Success',
                                message: response["Site Services"].message+ ` with Site Services Request Id -${response["Site Services"].data.requestID}`,
                                variant: 'success',
                                mode: 'pester'
                                })
                            );       
                        }
                        else{
                            this.dispatchEvent(
                                new ShowToastEvent({
                                    title: 'Error while creating Site Services Record',
                                    message: response["Site Service"].message,
                                    variant: 'error',
                                    mode: 'pester'
                                })
                            );
                        }
                    }     
                })
                .catch(error=>{
                        console.log("error:: ",JSON.stringify(error));
                        this.dispatchEvent(
                            new ShowToastEvent({
                            title: 'Error while Record Creation.',
                            message: error,
                            variant: 'error',
                            mode: 'pester'
                        })
                    );
                })
                .finally(()=>{
                    this.processCmplt=false;
                    this.dispatchEvent(new CloseActionScreenEvent());
                });
            }
            else if(this.errorMsgList.length >0){
                    let errMsg="";
                    if(this.errorMsgList.length >1){
                        errMsg = this.errorMsgList.join('\n');
                    }
                    else{
                        this.errorMsgList.forEach(err=>errMsg=err);
                    }
                    this.dispatchEvent(new ShowToastEvent({
                        title: 'Error while creating records.Please check',
                        message: errMsg,
                        variant: 'error',
                        mode: 'pester'
                    }));
                    this.processCmplt=false;
                   
            }
            else{
                this.processCmplt=false;
            }
            
    }
    
    handlePrice(event){
        this.customModPrice = event.target.value;
            if(this.customModPrice < 20000 && this.priceValidation == true){
                if(!this.errorMsgList.includes(this.priceValidationMsg)){
                this.errorMsgList.push(this.priceValidationMsg);
                console.log('profile : '+this.currentUserProfile);
                console.log('price issue');
                }
            }
}

     handleChange(event) {
        
        this.customModPrice = event.target.value;
        this.calcAmount = event.target.value;
        if(this.customModPrice >0){
           
            //this.calcAmount = this.customModPrice;
            // this.modPayDesc = "Modular : "+this.customModPrice;
            this.modPayDesc = "Modular Custom Amount";
            const d1 = {"Payment" :this.modPayDesc, "Category" :"Modular","Amount" : this.customModPrice};
			if(this.colData.length>0){
                const recIndex = this.colData.findIndex(elem=>elem.Category ===d1.Category);
                if(recIndex !=-1){
                    this.colData.splice(recIndex,1);
                    this.colData =[...this.colData,d1];
                }
                else{
                    this.colData =[...this.colData,d1];
                }
            }
            else{
                this.colData = [...this.colData,d1];
            }
        }
    }
    handleChange2(event) {
        this.customPrice = event.target.value;
        this.calcAmount2 =event.target.value;
        if(this.customPrice>0){
            //this.calcAmount2 = this.customPrice;
            // this.sitePayDesc = "Site Service :"+this.customPrice;
            this.sitePayDesc = "Site Service Custom Amount";
            const d2 ={"Payment" :this.sitePayDesc,"Category" :"Site Service","Amount": this.customPrice};
            if(this.colData.length>0){
                const recIndex=this.colData.findIndex(elem=>elem.Category ===d2.Category);
                if(recIndex !=-1){
                    this.colData.splice(recIndex,1);
                    this.colData=[...this.colData,d2];
                }
                else{
                    this.colData=[...this.colData,d2];
                }
            }
            else{
                this.colData =[...this.colData,d2];
            }
        }

    }
    siteCalcAmntHandler(event){
        this.calcAmount2 = event.target.value;
    }
    modularCalcAmtHandler(event){
        this.calcAmount = event.target.value;
    }

    handleShowPrice(){
        this.showPrice1=!this.showPrice1;
        this.customModPrice=0;
        this.calcAmount=0;
    }

    handleSecShowPrice(){
        this.showPrice2=!this.showPrice2;
        this.customPrice=0;
        this.calcAmount2=0;
    }
    
        //for modular
        handleClick(event){
            if(event.target.label == "5%" && this.modularProjCost != null && this.customModPrice ==0){
                this.discountLabel1 = event.target.label;
                this.calcAmount = parseFloat(this.modularProjCost * (5/100)).toFixed(2);
                //this.modPayDesc = "Modular : "+this.calcAmount +" : "+this.discountLabel1;
                this.modPayDesc = this.discountLabel1+" of Modular";
            }
            else if(event.target.label == "10%" && this.modularProjCost != null && this.customModPrice ==0){                   
                    this.discountLabel1 = event.target.label;
                    this.calcAmount = parseFloat(this.modularProjCost * (10/100)).toFixed(2);
                   // this.modPayDesc = "Modular : "+this.calcAmount +" : "+this.discountLabel1;  
                //    this.modPayDesc = this.discountLabel1+" of Modular";     
                this.modPayDesc = this.discountLabel1+" of Modular";    

            }
                const d1 = {"Payment" :this.modPayDesc, "Category" :"Modular","Amount" : this.calcAmount};
			   if(this.colData.length>0){
                  const recIndex = this.colData.findIndex(element=>element.Category ===d1.Category);
                  if(recIndex != -1){
                      this.colData.splice(recIndex,1);
                      this.colData =[...this.colData,d1];
                  }
                  else{
                      this.colData =[...this.colData,d1];
                  }
               }
               else{                   
                   this.colData=[...this.colData,d1];
               }
        
        }
        //for site services
        handleClick2(event){
                   
                if(event.target.label=="5%" && this.siteServCost != null && this.customPrice ==0){ 
                    this.calcAmount2 = parseFloat(this.siteServCost *(5/100)).toFixed(2);
                    this.discountLabel2 = event.target.label;
                    // this.sitePayDesc ="Site Service :"+this.calcAmount2+" : "+this.discountLabel2;
                    this.sitePayDesc =this.discountLabel2+" of Site Service";             
            }   
            else if(event.target.label == "10%" && this.siteServCost != null && this.customModPrice ==0){                   
                this.discountLabel2 = event.target.label;
                this.calcAmount2 = parseFloat(this.siteServCost *(10/100)).toFixed(2);
               // this.modPayDesc = "Modular : "+this.calcAmount +" : "+this.discountLabel1;  
               this.sitePayDesc = this.discountLabel2+" of Site Service";              
          }      
              const d2 ={"Payment" :this.sitePayDesc,"Category" :"Site Service","Amount": this.calcAmount2};
                   if(this.colData.length>0){
                       const recIndex = this.colData.findIndex(element=>element.Category ===d2.Category);
                       if(recIndex !=-1){
                           this.colData.splice(recIndex,1);
                           this.colData =[...this.colData,d2];
                       }
                       else{
                           this.colData =[...this.colData,d2];
                       }
                   }
                   else{
                       this.colData =[...this.colData,d2];
                   }
        }
}