/* @Name        quickcilverAPI_Mockup_Duplicate.cls 
 * @Author      Colbridge <jozef.colbridge@siratek.in>
 * @Date        10 Nov, 2021
 * @Description - Part of test class for quickcilverAPI.cls
 *-------------------------------------------------------------------------------------------
 * Modification Log:
 * Version      Developer           Date            Description
 *-------------------------------------------------------------------------------------------
 * 1.0          Colbridge           10 Jan, 2022    Test for duplicate opportunity api response
 *-------------------------------------------------------------------------------------------*/
global class quickcilverAPI_Mockup_Duplicate implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest request) {
        quickcilverAPI.BillingAddressWrap billaddwrap = new quickcilverAPI.BillingAddressWrap();
        billaddwrap.city = 'Bengalurur';
        billaddwrap.country = 'IN';
        billaddwrap.email = 'test@test.com';
        billaddwrap.firstname = 'test';
        billaddwrap.lastname = 'test';
        billaddwrap.line1 = 'kormangala bengaluru';
        billaddwrap.line2 = '-';
        billaddwrap.postcode = '560067';
        billaddwrap.region = 'Bengaluru';
        billaddwrap.telephone = '+910000000000';
        
        quickcilverAPI.ShippingAddressWrap shipaddwrap = new quickcilverAPI.ShippingAddressWrap();
        shipaddwrap.billToThis = true;
        shipaddwrap.city = 'Bengaluru';
        shipaddwrap.country = 'IN';
        shipaddwrap.email = 'test@test.com';
        shipaddwrap.firstname = 'test';
        shipaddwrap.lastname = 'test';
        shipaddwrap.line1 = 'kormangala bengaluru';
        shipaddwrap.line2 = '-';
        shipaddwrap.postcode = '560067';
        shipaddwrap.region = 'Bengaluru';
        shipaddwrap.telephone = '+910000000000';
        
        list<quickcilverAPI.cardwrap> cwrap = new list<quickcilverAPI.cardwrap>();
        quickcilverAPI.cardwrap cw = new quickcilverAPI.cardwrap();
        cw.cardNumber = '1234';
        cw.cardPin = '1234';
        cwrap.add(cw);
        
        list<quickcilverAPI.paymentwrap> paywrap = new list<quickcilverAPI.paymentwrap>();
        quickcilverAPI.paymentwrap pw = new quickcilverAPI.paymentwrap();
        pw.amount = 100;
        pw.code = '356';
        paywrap.add(pw);
        
        list<quickcilverAPI.productsWrap> prodwrap = new list<quickcilverAPI.productsWrap>();
        quickcilverAPI.productsWrap pwrap = new quickcilverAPI.productsWrap();
        pwrap.currency_x = 0;
        pwrap.giftMessage = 'test';
        pwrap.price = 1234;
        pwrap.qty = 1;
        pwrap.sku ='CNPIN'; // EGVGBTNS001 / EGCGBWCLPGDS002 / CNPIN
        pwrap.theme ='';
        prodwrap.add(pwrap);
        
        quickcilverAPI.OpportunityDataWrap oppdatawrap = new quickcilverAPI.OpportunityDataWrap();
        oppdatawrap.address = shipaddwrap;
        oppdatawrap.billing = billaddwrap;
        oppdatawrap.deliveryMode = 'EMAIL';
        oppdatawrap.refno = '';
        oppdatawrap.payments = paywrap;
        oppdatawrap.products = prodwrap;
        
        quickcilverAPI.ResponseData rd = new quickcilverAPI.ResponseData();
        rd.cards = cwrap;
        rd.code = '5313'; // Duplicate ref. no.
        rd.message = 'Duplicate ref. no.'; // Duplicate ref. no.
        
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody(JSON.serialize(rd));
        response.setStatusCode(400); // bad request
        return response;
    }
}