@isTest
private class CallyzerJsonResponseTest {
    
    static testMethod void testJsonDeserialization() {
        String jsonResponse = '{'+
            '"data": ['+
                '{'+
                    '"employee": "Porselvi M (8123632919)",'+
                    '"employeeName": "Porselvi M",'+
                    '"employeeNumber": "8123632919",'+
                    '"employeeCode": "",'+
            		'"client": "Unknown (+91-9176011477)",'+
            		'"clientName": "Unknown",'+
            		'"countryCode": "91",'+
            		'"clientNumber": "9176011477",'+
                    '"callDate": "28 Dec 2023",'+
                    '"callTime": "06:13 PM",'+
					'"duration": "",'+
            		'"durationInSeconds": "0",'+
            		'"callType": "Outgoing",'+
            		'"note": "",'+
            		'"callRecordingPath": "",'+
            		'"uniqueId": "InZavQHJesMBEcjHCN-e7oz2ICzfwMnZMSC-k5wO6Is",'+
                    '"createdDate": "2023-12-28 18:13:15",'+
                    '"modifiedDate": null'+
                '}'+
            '],'+
            '"message": "Sample message",'+
            '"recordsTotal": 1,'+
            '"recordsFiltered": 1,'+
            '"srNoCounterStart": 0'+
        '}';
        Test.startTest();
        CallyzerJsonResponse response = (CallyzerJsonResponse)JSON.deserialize(jsonResponse, CallyzerJsonResponse.class);
        Test.stopTest();

        System.assertNotEquals(null, response, 'Response should not be null');
        System.assertEquals(1, response.recordsTotal, 'Incorrect recordsTotal');
        System.assertEquals('Porselvi M (8123632919)', response.data[0].employee, 'Incorrect employee name');
        System.assertEquals('28 Dec 2023', response.data[0].callDate, 'Incorrect call date');
        
        CallyzerJsonResponse.testCoverage();
    }
}