@IsTest
public class FBConversionAPITest {

    private class RestMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            //String fullJson = 'your Json Response';
            HTTPResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'text/json');
            //res.setBody(fullJson);
            res.setStatusCode(200);
            string jsonBody ='{"data":{"AuthenticationToken":{"accessToken":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjbGllbnRJZCI6Ijc3MTAxNTgyLWV2OGs5ODg3cnl0dWlramhnYm5lcnQ0MyIsImlhdCI6MTY1NzE5NDA2OCwiZXhwIjoxNjU3MTk0MjQ4fQ.mr3GHUDfDdzYbmY5eyLkkO7B51PQQFh8931mRw5QLFs","message":"success","code":200}},"error":[]}';
            //String jsonRes ='{"responseJson":{"data":{"AddPaymentRequests":{"code":200,"data":{"requestID":"PR-XUnHsezie"},"message":"Payment request added successfully","statusCode":200}}},"errors":[]}';
            res.setBody(jsonBody); 
            return res;
        }
    }
    @testSetup
    public static void setupData() {
        Facebook_Conversion_Api__c cs = new Facebook_Conversion_Api__c(
            Name = 'FB Convertion Setting',
            access_token__c = 'EAADpXJxh7BMBAJndcZBmsGU0XbbFLMTJ3eYvv5hvq3S5g8dBHcyjv65ZBnZA0jitJCemsOsL06oNP4gbIsHDoLLiAdwsQrzjY9txNO3ytYdJV8WGxZA8pfpUJ0J6X2ZCKXXc27aZBAxXwUfNRFLkxpiWbCtSJ9UNHivDszd9ZBywoe62gRjroLMWQZAhBEYLtvMZD',
            API_Version__c = 'v16.0',
            Endpoint__c = 'https://graph.facebook.com',
            PixelId__c = '555410081511945'
        );
        insert cs;
    }

    @isTest
    public static void fbConvertionApiRequestTest() {
        FBConversionAPI.ActionRequest actionRequest = new FBConversionAPI.ActionRequest();
        actionRequest.event_name = 'Lead';
        actionRequest.action_source = 'system_generated';
        actionRequest.em = 'vikas.s@partner.designcafe.com';
        actionRequest.ph = '9898987678';
        actionRequest.stage = 'New';
        actionRequest.PropertyType = '1 BHK';
        actionRequest.Location = 'Bengalure';
        Test.setMock(HttpCalloutMock.class, new RestMock());
        FBConversionAPI.fbConvertionApiRequest(new List<FBConversionAPI.actionRequest>{actionRequest});
    }
}