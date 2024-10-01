@RestResource(urlMapping='/LeadAddition/*')
global without sharing class InboundLeadHandler {
    
    @HttpPost
    global static String doPost(String name,String phone ) 
    {
		return name+phone;
    }
}