import { LightningElement, api, track,wire } from 'lwc';
import refereeCodeMethod from '@salesforce/apex/ReferralInformation.refereeCode';
import updateRefereeDetailsMethod from '@salesforce/apex/ReferralInformation.updateRefereeDetails';
import getLeadInfo from '@salesforce/apex/ReferralInformation.getLeadInfo';
import getOpportunityInfo from '@salesforce/apex/ReferralInformation.getOpportunityInfo';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';
import { NavigationMixin } from 'lightning/navigation';
import { refreshApex } from '@salesforce/apex';
//import { getObjectInfo } from 'lightning/uiObjectInfoApi';

export default class ReferralInformation extends NavigationMixin(LightningElement) {

    @api recordId;
    refereeCode;
    refereeNumber;
    isReadOnly = false;
    isRecordIdAvailable = false;
  //  @track opportunities;
    @track leads;
    @track refereeDetailsTemp = {
        "Name" : "",
        "PersonMobilePhone" : "",
        "PersonEmail" : "",
        "Referee_Code_DC__c" : ""
    };
    @track refereeDetails = {
        "Name" : "",
        "PersonMobilePhone" : "",
        "PersonEmail" : "",
        "Referee_Code_DC__c" : ""
    };

   
   /* getObjectInfo(){
        this[NavigationMixin.GenerateUrl]({
            type : 'standard__recordPage',
            attributes : {
                recordId : this.recordId,
                actionName : 'View'
            },
        }).then(url => {
            const parser = document.createElement('a');
            parser.href = url;
            const PathArray = parser.pathname.split('/');
            const ObjectAPIName = PathArray[2];
            console.log('object name'+PathArray);
            console.log('object url'+url);
        }).catch(error => {
            console.log('error '+error);
        })
    }
    @wire(getObjectName, { recordId: '$recordId' })
    objectInfo({ error, data }) {
        if (data) {
            console.log('Object API Name:', data);
        } else if (error) {
            console.error('Error fetching object info:', error);
        }
    }
*/
/*connectedCallback() {
    
    if (this.recordId) {
        console.log('recordid =>',this.recordId);
            this.getOppData();
        }
}*/

    getOppData(){
        console.log('recordid ==>',this.recordId);
        getOpportunityInfo({recordId : this.recordId})
                .then(result =>{
                    console.log('result ',result);
                    console.log('isReadOnly',this.isReadOnly);
                    if(result !=null && result !=undefined){
                        this.refereeDetails.Name = result.ST_Referee_Name__c;
                        this.refereeDetails.PersonMobilePhone = result.ST_Referee_Number__c;
                        this.refereeDetails.PersonEmail = result.Referee_Email_ID__c;
                        this.refereeDetails.Referee_Code_DC__c = result.ST_Referee_Code__c;
                        console.log('DC_Lead_Source__c',result.DC_Lead_Source__c);
                        console.log('isReadOnly',this.isReadOnly);
                        console.log('this.refereeDetails',this.refereeDetails);
                        if(result.DC_Lead_Source__c == 'DC Client referral'){
                            this.isReadOnly = true;
                        }
                        console.log('isReadOnly=>>',this.isReadOnly);
                    }
                    else{
                        this.getLeadData();
                    }
                        
                })
                .catch(error =>{
                         console.log('opportunity error:',error);
                })
    }
  
    getLeadData(){
        getLeadInfo({recordId : this.recordId})
            .then(result =>{
                    console.log('result ',result);
                     console.log('isReadOnly',this.isReadOnly);
                      this.refereeDetails.Name = result.Referee_Name__c;
                      this.refereeDetails.PersonMobilePhone  = result.Referee_Number__c;
                      this.refereeDetails.PersonEmail = result.Referee_Email_ID__c;
                      this.refereeDetails.Referee_Code_DC__c =result.Referee_Code__c;
                      console.log('DC_Lead_Source__c',result.DC_Lead_Source__c);
                      console.log('this.refereeDetails',this.refereeDetails);
                        console.log('isReadOnly',this.isReadOnly);
                      if(result.DC_Lead_Source__c == 'DC Client referral'){
                                this.isReadOnly = true;
                         }
                          console.log('isReadOnly=>>',this.isReadOnly);
            })
            .catch(error =>{
                    console.log('Lead error:',error);
            })
    }
    /*    @wire(getLeadInfo,{recordId : '$recordId'}) 
        lead(result) {
            console.log('result =>',result);
            console.log('result data',result.data);
            this.leads = result.data;

            if(result.data){
                //this.leads = data;
                 this.refereeDetails.Name = result.data.Referee_Name__c;
                 this.refereeDetails.PersonMobilePhone  = result.data.Referee_Number__c;
                 this.refereeDetails.PersonEmail = result.data.Referee_Email_ID__c;
                this.refereeDetails.Referee_Code_DC__c =result.data.Referee_Code__c;
                //error = undefined;
            }
            else if(result.error){
                console.log('Lead error:',result.error);
            }
        } */
    handleRefereeCode(event){
        
        if(event.target.value != null || !event.target.value.isEmpty() || event.target.value != ''){
            console.log('this.refereeDetails at refree code',this.refereeDetails);
            this.refereeCode = event.target.value;
            refereeCodeMethod({refereeCode: this.refereeCode, refereeNumber: this.refereeNumber})
            .then(result=>{
                console.log('this.refereeDetails inside then refree code',this.refereeDetails);
                Object.assign(this.refereeDetailsTemp, result);
                console.log('this.refereeDetails after refree code',this.refereeDetails);
            })
            .catch(error=>{
                this.showErrorToast('Referee Code Not Matched!');
            })
        }
    }

    handleRefereeNumber(event){
        console.log('value ==> ', event.target.value);
 
        if(event.target.value != null || !event.target.value.isEmpty() || event.target.value != ''){
            this.refereeNumber = event.target.value;
            refereeCodeMethod({refereeCode : this.refereeCode, refereeNumber: this.refereeNumber})
            .then(result=>{
                Object.assign(this.refereeDetailsTemp, result);
            })
            .catch(error=>{
                this.showErrorToast('Referee Number Not Matched!');
            })
        }

    }
    renderedCallback(){
        
        if (this.recordId && !this.isRecordIdAvailable) {
            this.isRecordIdAvailable = true;
            console.log('recordid render ==>',this.recordId);
            this.getOppData();
            //this.getLeadData();
        }
    }
    handleSave(event){
        if(!this.refereeDetails.Referee_Code_DC__c.startsWith("DCREF-")){
            this.showErrorToast('Referee Code must start with "DCREF-"');  
            return; 
        }
        if(this.refereeDetails.Name == '' || this.refereeDetails.PersonMobilePhone == '' || this.refereeDetails.PersonEmail == ''){
            this.showErrorToast('Please fill all the fields!');  
            return;     
        }
        
        updateRefereeDetailsMethod({recordId: this.recordId, updatedRefereeDetails : this.refereeDetails})
            .then(result=>{
                this.showSuccessToast();
                this.dispatchEvent(new CloseActionScreenEvent());
            })
            .catch(error=>{
                this.showErrorToast('Error', error.body.message, 'error');
            })
    }

    handleSearch(event){
        console.log('this.refereeDetails before search',this.refereeDetails);
        console.log('this.refereeDetailsTemp before search',this.refereeDetailsTemp);
        Object.assign(this.refereeDetails, this.refereeDetailsTemp);  
        console.log('this.refereeDetails after search',this.refereeDetails);
        console.log('this.refereeDetailsTemp after search',this.refereeDetailsTemp);
        //this.isReadOnly = (this.refereeDetails.Referee_Code_DC__c != '' || this.refereeDetails.PersonEmail != '' || this.refereeDetails.PersonMobilePhone != '') ? true : false;
    }

    handleInputChange(event){
        if(event.target.name == 'Name'){
            this.refereeDetails.Name = event.target.value;
        }
        if(event.target.name == 'PersonMobilePhone'){
            this.refereeDetails.PersonMobilePhone = event.target.value;
        }
        if(event.target.name == 'PersonEmail'){
            this.refereeDetails.PersonEmail = event.target.value;
        }
        if(event.target.name == 'Referee_Code_DC__c'){
            this.refereeDetails.Referee_Code_DC__c = event.target.value;
        }
    }

    showSuccessToast() {
        const event = new ShowToastEvent({
            title: 'Success',
            message: 'Referral Updated Successfully!',
            variant: 'success',
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
    }

    showErrorToast(errorMsg) {
        const evt = new ShowToastEvent({
            title: 'Error',
            message: errorMsg,
            variant: 'error',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }
}