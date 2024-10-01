import { LightningElement,api,wire } from 'lwc';
import fetchLeads from '@salesforce/apex/leadAttachment.fetchLeads';
export default class Attachment extends  LightningElement{
   @api recordId;
   lstLead=[];
    lstColumns = [
        {  
            label: "File Name",  
            fieldName: "File_Name__c",  
            type: "text",  
            typeAttributes: { target: "_blank" }  
           },
            {label:'File Url', fieldName:'File_Url__c', type:'url'}
           
         
    ];
@wire(fetchLeads,{recId:'$recordId'}) 

    leads({data,error}){
        console.log("recid:: ",this.recordId);
    if(data){
        console.log("data:: ",JSON.stringify(data));
      
        this.lstLead =data;
        
        
    }
    if(error){
        console.error("err:: ",JSON.stringify(error));
        this.lstLead=undefined;
    }
}
   
}