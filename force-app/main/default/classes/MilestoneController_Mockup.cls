global class MilestoneController_Mockup implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest request) {
        
        MilestoneController.invoiceBreakUpwrap invBreak= new MilestoneController.invoiceBreakUpwrap();
        invBreak.baseAmount = 127118;
        invBreak.CGST = 0;
        invBreak.IGST = 0;
        invBreak.SGST = 22881;
        invBreak.totalAmount = 22881;
        invBreak.totalTaxValue =  150000;
        
        MilestoneController.invoicewrap invwrap = new MilestoneController.invoicewrap();
        invwrap.applicationId = 'Test applicationId';
        invwrap.projectID = 'PROJECT2';
        invwrap.invoiceDate = '03/09/2020';
        invwrap.invoiceNumber = 'MGDC/Sep-20/0060';
        invwrap.invoicePdf = 'https://designcafe.s3.ap-south-1.amazonaws.com/invoice_MGDC_Sep-20_0060.pdf';
        invwrap.paymentLink = 'https://rzp.io/i/mmLY3yG';
        invwrap.razorpayInvoiceReceipt = '1599128858303';
        invwrap.paymentName = '15% Supply of works';
        invwrap.invoiceBreakUp = invBreak;
        
        MilestoneController.invoicedata invd = new MilestoneController.invoicedata();
        invd.invoice = invwrap;
        
        MilestoneController.ResponseData rd = new MilestoneController.ResponseData();
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