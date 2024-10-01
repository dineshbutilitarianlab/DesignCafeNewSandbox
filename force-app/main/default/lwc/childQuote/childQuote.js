import { LightningElement ,track,api} from 'lwc';
import getQuotes from '@salesforce/apex/PaymentRequestsHandler_GraphQL.getQuotes';
import getQuoteDetails from '@salesforce/apex/PaymentRequestsHandler_GraphQL.getQuoteDetails';

export default class ChildQuote extends LightningElement {
    @track arrayOptions = [];
    renderedCallback = false;
    @track quotes = [];
    @api recId;
    latestQuoteId;
    siteServicesAmountInclGST

    renderedCallback(){
        if(this.renderedCallback==false&&this.recId!=undefined){
            getQuotes({recId : this.recId})
            .then(result=>{
                console.log("Res===>"+JSON.stringify(result))
                console.log("ResLen===>"+result.length)
                for(let i=0;i<result.length;i++){
                    if(result[i].Latest_Quote__c==true){    // If true, set this as default value.
                        getQuoteDetails({ quoteId : result[i].Id })
                        .then(result2=>{
                            this.quotes = result2;   //  Set result to quotes.
                            this.quotes.quoteUrl = '/'+result2.Id;    //  Link to Quote.
                            this.latestQuoteId = result2.Id;    //  Assigning quote id for future references.
                            this.siteServicesAmountInclGST = result2.Site_Services_Amount_Incl_GST__c;
                            const valueChangeEvent = new CustomEvent("valuechange", {
                                detail: { 
                                        childId:this.latestQuoteId,
                                        siteServicesAmountInclGST: this.siteServicesAmountInclGST
                                    }
                              });
                            // Fire the custom event
                            this.dispatchEvent(valueChangeEvent); 
                            console.log("Latest Quote Id===>"+this.latestQuoteId);
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
            this.renderedCallback=true;   
        }
    }

    get options() {
        return this.arrayOptions;   //  Returning dropdown options.
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
}