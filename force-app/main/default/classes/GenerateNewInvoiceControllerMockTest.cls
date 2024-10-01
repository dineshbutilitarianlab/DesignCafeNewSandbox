public class GenerateNewInvoiceControllerMockTest  implements HttpCalloutMock{
        public HttpResponse respond(HTTPRequest req){
            HttpResponse res = new HttpResponse();
            res.setStatus('OK');
            res.setStatusCode(200);
            string jsonBody='{"accessToken":"TESTTOKEN", "statusCode":200,"code":200,"message":"Success","data":{"invoice":{"applicationId":"Salesforce","projectID":"DC-35718","paymentName":"5% Supply of interior works","invoiceDate": null,"invoiceBreakUp":{"baseAmount":0.847457627118644,"SGST":0,"CGST":0,"IGST":0.15254237288135591,"totalTaxValue":0.15254237288135591,"totalAmount":1},"extraPaymentsInvoiceBreakup":[],"invoiceNumber":"RCDC/Dec-21/0021","invoicePdf":"https://test-designcafe.s3.ap-south-1.amazonaws.com/proforma_invoice-RCDC_Dec-21_0021.pdf","paymentLink":"---"}}}';
                            
            res.setBody(jsonBody);
            return res; 
        }}