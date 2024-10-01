public class CallyzerMockHttpResponseGenerator implements HttpCalloutMock  {
    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"data": [{"employee": "Siddique Shariff (9731450211)","employeeName": "Siddiqu Shariff","employeeNumber": "9731450211","employeeCode": "DC-01333","client": "Unknown (+91-9003014201)","clientName": "Unknown","countryCode": "91","clientNumber": "9003014201","date": "29 Dec 2023","time": "03:14 PM","duration": null,"durationInSeconds": 0,"callType": "Outgoing","note": null,"callRecordingPath": null,"uniqueId": " -R7tMPUvHk7Sr5vEoitaITex3bGxIvQ2EojsZEQiCbI","createdDate": "2023-12-29 15:15:44","modifiedDate": null}],"message": null,"recordsTotal": 1,"recordsFiltered": 1,"srNoCounterStart": 0}');
        res.setStatusCode(200); 
        return res;
    }
}