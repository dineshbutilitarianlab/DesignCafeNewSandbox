@isTest
global class GoogleledMockupTest implements HttpCalloutMock
{
    public HTTPResponse respond(HTTPRequest req)     
    {
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        req.setMethod('POST');
        res = http.send(req);
        System.debug(res.getBody());
        return res;
    }
    @isTest
    public static void GoogleLeadManager()
    {
       Lead ld = new Lead();
        ld.LastName = 'test';
        ld.MobilePhone = '9809998899';
        ld.City = 'Mumbai';
        ld.Region__c ='Mumbai';
        insert ld;
        {
             HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        req.setMethod('POST');
        res = http.send(req);
        System.debug(res.getBody());
        }
    }
}