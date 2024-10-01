public class CreateBigObjectValues implements System.Queueable, Database.AllowsCallouts {
    public void execute(System.QueueableContext context) {
        
        List<String> fieldLabelList = new List<String>{'Name', 'Industry', 'Rating', 'CreatedById', 'APIMOBILE', 'Is Customer Created'};
        List<String> fieldApiList = new List<String>{'Name', 'Industry', 'Rating', 'CreatedById', 'APIMOBILE', 'Is_Customer_Created'};
        //List<Schema.DisplayType> fielddataType = new List<Schema.DisplayType>();
        //List<String> dataTypes = new List<String>();
        
        String SobjectApiName = 'Lead';
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        for(String fieldName : fieldMap.keyset())
        {
            fieldApiList.add(fieldName);
            fieldLabelList.add(fieldMap.get(fieldName).getDescribe().getLabel());
            //fielddataType.add(fieldMap.get(fieldName).getDescribe().getType());
        }
        
        /*for(Schema.DisplayType sde : fielddataType){
            String stringIntance = String.valueOf(sde);
            dataTypes.add(stringIntance);
        }*/
        
        String objectAPIName = 'Lead_Archieve__b';
        String fieldDescription = 'This is the lead objects fields';
        
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId().substring(15);
        List<MetadataService.CustomField> listOfCustomField = new List<MetadataService.CustomField>();
        for(Integer i=0; i< fieldLabelList.size(); i++){
            MetadataService.CustomField customField = new MetadataService.CustomField();
            String result = fieldApiList[i].contains('__c') ? fieldApiList[i] :fieldApiList[i] + '__c';
            customField.fullName = objectAPIName + '.' + result;
            customField.label = fieldLabelList[i];
            customField.type_x = 'Text';
            customField.length = 255;
            customField.description = fieldDescription;
            listOfCustomField.add(customField);
        }
        
        System.debug('listOfCustomField ==> ' + listOfCustomField);
        List<MetadataService.SaveResult> results = service.createMetadata(listOfCustomField);
        System.debug('results ==> ' + results);
        for (MetadataService.SaveResult result : results) {
            if (result.success) {
                System.debug('Field created successfully.');
            } else {
                System.debug('Field creation failed with message: ' + result.errors[0].message);
            }
        }
        //CreateBigObjectDataBatch bc = new CreateBigObjectDataBatch(ListcustomField);
        //Database.executeBatch(bc);
       
    }
}