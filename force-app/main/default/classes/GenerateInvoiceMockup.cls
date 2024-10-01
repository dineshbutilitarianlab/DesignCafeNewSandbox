global class GenerateInvoiceMockup implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest request) {
        
        GenerateInvoiceController.invoiceBreakUpwrap invBreak= new GenerateInvoiceController.invoiceBreakUpwrap();
        invBreak.baseAmount = 127118;
        invBreak.CGST = 0;
        invBreak.IGST = 0;
        invBreak.SGST = 22881;
        invBreak.totalAmount = 22881;
        invBreak.totalTaxValue =  150000;
        
        GenerateInvoiceController.invoicewrap invwrap = new GenerateInvoiceController.invoicewrap();
        invwrap.applicationId = 'Test applicationId';
        invwrap.projectID = 'PROJECT2';
        invwrap.invoiceDate = '03/09/2020';
        invwrap.invoiceNumber = 'MGDC/Sep-20/0060';
        invwrap.invoicePdf = 'https://designcafe.s3.ap-south-1.amazonaws.com/invoice_MGDC_Sep-20_0060.pdf';
        invwrap.paymentLink = 'https://rzp.io/i/mmLY3yG';
        invwrap.razorpayInvoiceReceipt = '1599128858303';
        invwrap.paymentName = '15% Supply of works';
        invwrap.invoiceBreakUp = invBreak;
        
        GenerateInvoiceController.invoicedata invd = new GenerateInvoiceController.invoicedata();
        invd.invoice = invwrap;
        
        GenerateInvoiceController.ResponseData rd = new GenerateInvoiceController.ResponseData();
        rd.statusCode = '200';
        rd.code = '200';
        rd.data = invd;
        rd.message = 'Success';
        
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody(JSON.serialize(rd));
        response.setStatusCode(200);
        return response;
    }
}