global class updateAccounttoDD_MockUp implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest request) {
        Account acc = [select id,name,PersonEmail,PersonMobilePhone,BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry from Account];
        updateaccounttodesignerdashboard.accountdatawrap aw = new updateaccounttodesignerdashboard.accountdatawrap();
        aw.billingAddressCity = acc.BillingCity;
        aw.billingAddressCountry = acc.BillingCountry;
        aw.billingAddressShippingState = acc.BillingState;
        aw.billingAddressStreet = acc.BillingStreet;
        aw.billingAddressZipOrPostalCode = acc.BillingPostalCode;
        aw.customerEmail = acc.PersonEmail;
        aw.customerName = acc.Name;
        aw.customerPhone = acc.PersonMobilePhone;
        aw.shippingAddressCity = acc.ShippingCity;
        aw.shippingAddressCountry = acc.ShippingCountry;
        aw.shippingAddressShippingState = acc.ShippingState;
        aw.shippingAddressStreet = acc.ShippingStreet;
        aw.shippingAddressCountry = acc.ShippingCountry;
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody(JSON.serialize(aw));
        response.setStatusCode(200);
        return response;
    }
}