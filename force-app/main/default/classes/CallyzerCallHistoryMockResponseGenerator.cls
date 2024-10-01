@isTest
global class CallyzerCallHistoryMockResponseGenerator implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{ "data": [ { "employee": "Porselvi M (8123632919)", "employeeName": "Porselvi M", "employeeNumber": "8123632919", "employeeCode": null, "client": "Unknown (+91-8056097090)", "clientName": "Unknown", "countryCode": "91", "clientNumber": "8056097090", "date": "28 Dec 2023", "time": "06:10 PM", "duration": null, "durationInSeconds": 0, "callType": "Outgoing", "note": null, "callRecordingPath": null, "uniqueId": " v7at0caYF7sZALeobV0Zx6e_Af1dBtGOWf9rfnlCFH0", "createdDate": "2023-12-28 18:10:51", "modifiedDate": null } ], "message": null, "recordsTotal":14, "recordsFiltered":1, "srNoCounterStart": 0 }'); 
        res.setStatusCode(200);
        return res;
    }
}