import { LightningElement, wire,api ,track} from 'lwc';
import { getRecord,updateRecord  } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';


const FIELDS = [
    'Quote.BillingName',
    'Quote.Modular_Amount__c',
    'Quote.Property_Type__c',
    'Quote.PM_Fee__c',
    'Quote.Site_Services_Amount__c',
    'Quote.Modular_Or_Site_Service_Changes__c',
    'Quote.Quote_Link__c',
    'Quote.Offer_1__c']

export default class quotationRanges extends LightningElement {
    @api recordId;
    @track fieldValues=[];
    wiredresults=[];
    @track rowData=[];
    dataToSave = [];
    @track originalData;

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredRecord(wireResult) {
        console.log('jjjjj');
        const { data, error } = wireResult;
    this.wiredresults = wireResult;
        if (data) {
            this.fieldValues = [];        
            console.log('dd'+JSON.stringify(data));
            const baseAmount = data.fields.BillingName.value;
            const modularAmount = data.fields.Modular_Amount__c.value;
            const discount = data.fields.Property_Type__c.value;
            const pMFee = data.fields.PM_Fee__c.value;
            const siteServicesAmt = data.fields.Site_Services_Amount__c.value;
            const totalCalValue = data.fields.Modular_Or_Site_Service_Changes__c.value;
            const quoteLink = data.fields.Quote_Link__c.value;
            const offer = data.fields.Offer_1__c.value;

            // Setting up rowData
            this.rowData = [
                {
                    id: this.generateRandomId(),
                    header: 'Base Amount',
                    cells: [
                        { id: 0, value: baseAmount,fieldname: 'BillingName'},
                        { id: 1, value: baseAmount,fieldname: 'BillingName'},
                        { id: 2, value: baseAmount,fieldname: 'BillingName'}, 
                        { id: 3, value: baseAmount,fieldname: 'BillingName'},
                        { id: 4, value: baseAmount,fieldname: 'BillingName'},
                        
                        
                    ]
                },
                {
                    id: this.generateRandomId(),
                    header: 'Base Amount + GST',
                    cells: [
                        { id: 0, value: modularAmount,fieldname: 'Modular_Amount__c' },
                        { id: 1, value: modularAmount,fieldname: 'Modular_Amount__c' },
                        { id: 2, value: modularAmount ,fieldname: 'Modular_Amount__c'},
                        { id: 3, value: modularAmount ,fieldname: 'Modular_Amount__c'},
                        { id: 4, value: modularAmount,fieldname: 'Modular_Amount__c' },
                        
                        
                    ]
                },
                {
                    id: this.generateRandomId(),
                    header: '% Discount',
                    cells: [
                        { id: 0, value: discount,fieldname: 'Property_Type__c'  },
                        { id: 1, value: discount,fieldname: 'Property_Type__c'  },
                        { id: 2, value: discount,fieldname: 'Property_Type__c'  },
                        { id: 3, value: discount,fieldname: 'Property_Type__c'  },
                        { id: 4, value: discount,fieldname: 'Property_Type__c'  },
                        
                        
                    ]
                },                
                {
                    id: this.generateRandomId(),
                    header: 'Flat Discount',
                    cells: [
                        { id: 0, value: siteServicesAmt,fieldname: 'Site_Services_Amount__c'  },
                        { id: 1, value: siteServicesAmt,fieldname: 'Site_Services_Amount__c'  },
                        { id: 2, value: siteServicesAmt,fieldname: 'Site_Services_Amount__c'  },
                        { id: 3, value: siteServicesAmt,fieldname: 'Site_Services_Amount__c'  },
                        { id: 4, value: siteServicesAmt,fieldname: 'Site_Services_Amount__c'  },
                        
                        
                    ]
                },
                {
                    id: this.generateRandomId(),
                    header: 'PM Fee %',
                    cells: [
                        { id: 0, value: pMFee,fieldname: 'PM_Fee__c' ,
                        isComboBox: true , options:[ { label: '7%', value: '7%' },
                                                       { label: '9%', value: '9%' }
                                                    ] },
                        { id: 1, value: pMFee,fieldname: 'PM_Fee__c' ,
                        isComboBox: true , options:[ { label: '7%', value: '7%' },
                                                       { label: '9%', value: '9%' }
                                                    ] },
                        { id: 2, value: pMFee,fieldname: 'PM_Fee__c' ,
                        isComboBox: true , options:[ { label: '7%', value: '7%' },
                                                       { label: '9%', value: '9%' }
                                                    ] },
                        { id: 3, value: pMFee,fieldname: 'PM_Fee__c' ,
                        isComboBox: true , options:[ { label: '7%', value: '7%' },
                                                       { label: '9%', value: '9%' }
                                                    ] },
                        { id: 4, value: pMFee,fieldname: 'PM_Fee__c' ,
                        isComboBox: true , options:[ { label: '7%', value: '7%' },
                                                       { label: '9%', value: '9%' }
                                                    ] },
                        
                        
                    ]
                },
                {
                    id: this.generateRandomId(),
                    header: 'PM Fee Value',
                    cells: [
                        { id: 0, value: siteServicesAmt,fieldname: 'Site_Services_Amount__c'  },
                        { id: 1, value: siteServicesAmt,fieldname: 'Site_Services_Amount__c'  },
                        { id: 2, value: siteServicesAmt,fieldname: 'Site_Services_Amount__c'  },
                        { id: 3, value: siteServicesAmt,fieldname: 'Site_Services_Amount__c'  },
                        { id: 4, value: siteServicesAmt,fieldname: 'Site_Services_Amount__c'  },
                        
                        
                    ]
                },
                {
                    id: this.generateRandomId(),
                    header: 'Total Value',
                    cells: [
                        { id: 0, value: totalCalValue,fieldname: 'Modular_Or_Site_Service_Changes__c'  },
                        { id: 1, value: totalCalValue,fieldname: 'Modular_Or_Site_Service_Changes__c'  },
                        { id: 2, value: totalCalValue,fieldname: 'Modular_Or_Site_Service_Changes__c'  },
                        { id: 3, value: totalCalValue,fieldname: 'Modular_Or_Site_Service_Changes__c'  },
                        { id: 4, value: totalCalValue,fieldname: 'Modular_Or_Site_Service_Changes__c'  },
                        
                    ]
                },
                {
                    id: this.generateRandomId(),
                    header: 'Link of Quote PDFs',
                    cells: [
                        { id: 0, value: quoteLink,fieldname: 'Quote_Link__c'  },
                        { id: 1, value: quoteLink,fieldname: 'Quote_Link__c'  },
                        { id: 2, value: quoteLink,fieldname: 'Quote_Link__c'  },
                        { id: 3, value: quoteLink,fieldname: 'Quote_Link__c'  },
                        { id: 4, value: quoteLink,fieldname: 'Quote_Link__c'  },
                        
                    ]
                },
                {
                    id: this.generateRandomId(),
                    header: 'Offers',
                    cells: [
                        { id: 0, value: offer,fieldname: 'Offer_1__c'  },
                        { id: 1, value: offer,fieldname: 'Offer_1__c'  },
                        { id: 2, value: offer,fieldname: 'Offer_1__c'  },
                        { id: 3, value: offer,fieldname: 'Offer_1__c'  },
                        { id: 4, value: offer,fieldname: 'Offer_1__c'  },
                        
                    ]
                }
            ];
            this.originalData = JSON.parse(JSON.stringify(this.rowData));
            console.log('this.originalData  1 ',this.originalData);
        } else if (error) {
            // Handle error
        }
    }
    renderedCallback(){
    console.log('ggg-->'+this.recordId);
    }
    connectedCallback() {
        this.refreshData();
    }
    
    handleInputChange(event) {
        console.log('test');
        let fieldName = event.target.dataset.fieldName;
        console.log('fieldName1 '+fieldName);
        let fieldValue = event.target.value;
        console.log('fieldValue'+fieldValue);
        this.fieldValues = {...this.fieldValues, [fieldName]: fieldValue};
        console.log('fieldValues-->' + JSON.stringify(this.fieldValues));
    }


    

   handleUpdateRecord() {
        const fields = {};
        Object.keys(this.fieldValues).forEach(fieldName => {
            fields[fieldName] = this.fieldValues[fieldName];
        });
        console.log('fields-->'+fields);
        console.log('fields-->'+JSON.stringify(fields));
        fields.Id = this.recordId;
        const recordInput = { fields };

        updateRecord(recordInput)
            .then(() => {
                console.log('Record updated successfully');
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Records updated successfully',
                        variant: 'success'
                    })
                );
                this.refreshData();
            })
            .catch(error => {
                console.error('Error updating record: ', error);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            });
    }

    refreshData() { 
        console.log('refresh');
        return refreshApex(this.wiredresults);
    }
    handleCancel() {
       
        //this.refreshData();
        this.rowData  = JSON.parse(JSON.stringify(this.originalData));
        this.rowData.forEach(entry => {
            entry.id = this.generateRandomId(); 
        });
        console.log('this.rowData ',JSON.stringify(this.rowData));
        this.fieldValues = [];        
    } 
    generateRandomId() {
        const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
        let result = '';
        const charactersLength = chars.length;
        for (let i = 0; i < 6; i++) {
            result += chars.charAt(Math.floor(Math.random() * charactersLength));
        }
        return result;
    }
  

}