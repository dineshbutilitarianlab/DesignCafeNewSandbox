@isTest public class GenerateNewInvoice_GRaphQLMockTest  implements HttpCalloutMock{
        public HttpResponse respond(HTTPRequest req){
            HttpResponse res = new HttpResponse();
            res.setStatus('200');
            res.setStatusCode(200);
            //string jsonBody='{"data": {"GenerateInvoicenewflow": {"code": 200,"message": "Invoice created successfully","data": {"invoiceId": "INV-8AxyMPKjm","invoice": {"invoiceID": "INV-8AxyMPKjm","invoiceNumber": "29/07-22/00713","invoicePdf": "https://design-cafe-design-cafe-pre-production33-5207954.dev.odoo.com/mail/view?model=account.move&res_id=368717&access_token=c27527a0-79ed-4d2c-938e-7357cbdac336","SGST": 9.9,"CGST": 9.9,"IGST": 0,"totalTaxValue": 19.8,"invoiceAmount": 130,"status": "posted","invoiceDate": "2022-07-13","odooInvoiceId": 368717}}}}}';
            //String jsonBody = '{"data":{"GenerateInvoicenewflow":{"code":200, "data":{"invoice":{"CGST"=50.71, "IGST"=0, "SGST"=50.71, "invoiceAmount"=665, "invoiceDate"="2022-07-13", "invoiceID"="INV-TAnOYCqzx", "invoiceNumber"="29/07-22/00716", invoicePdf"=https://design-cafe-design-cafe-pre-production33-5207954.dev.odoo.com/mail/view?model=account.move&res_id=368724&access_token=a6722602-d4af-4514-8f8b-cb22da97d986, odooInvoiceId=368724, status=posted,"invoiceDate"= "2022-07-13","odooInvoiceId"= 368717}, invoiceId=INV-TAnOYCqzx}, message=Invoice created successfully}}}';
            String jsonBody = '{"data":{"GenerateInvoicenewflow":{"code":200, "data":{"invoice":{"CGST":50.71, "IGST":0, "SGST":50.71, "invoiceAmount":665, "invoiceDate":"2022-07-13", "invoiceID":"INV-TAnOYCqzx", "invoiceNumber":"29/07-22/00716", "invoicePdf":"https://design-cafe-design-cafe.com", "odooInvoiceId":"368724", "status":"posted","invoiceDate": "2022-07-13","odooInvoiceId": 368717}, "invoiceId":"INV-TAnOYCqzx"}, "message":"Invoice created successfully"}}}';
            res.setBody(jsonBody);
            return res; 
        }}