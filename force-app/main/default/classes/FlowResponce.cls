global class FlowResponce {
    @InvocableMethod(label = 'Read JSON')
    global static void ReadJson(){
        RestResponse res = RestContext.response;
        res.responseBody  = Blob.valueOf('{"recieved"}');
    }
}