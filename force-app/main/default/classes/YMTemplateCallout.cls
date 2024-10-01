public class YMTemplateCallout {
    @future(callout=true)
    public static void sendYMTemplateCalloutREST(boolean Whatsapp_Opt_in,Id leadId){
        YM_Msg_Template_Notify__c data1 = YM_Msg_Template_Notify__c.getvalues('templatecallout1'); //---Whatsapp_Opt_in__c == false,Template---
        YM_Msg_Template_Notify__c data2 = YM_Msg_Template_Notify__c.getvalues('templatecallout2'); //---Whatsapp_Opt_in__c == true,Template----
        lead ld = [select id,Whatsapp_Opt_in__c,MobileYM__c,Messaging_Source__c from lead where id =:leadId];
        msgtemplateWrapper template = new msgtemplateWrapper();
        msgtemplateWrapper.body TempBody = new msgtemplateWrapper.body();
        msgtemplateWrapper.language lang = new msgtemplateWrapper.language();
        msgtemplateWrapper.template temp = new msgtemplateWrapper.template();
        try{
            //----- Whatsapp_Opt_in__c == false, then send 'templatecallout1' data to hit the API---------------------
            if(!Whatsapp_Opt_in){
                lang.code = data1.code__c;
                lang.policy = data1.policy__c;
                temp.language = lang;
                temp.name = data1.name__c;
                temp.namespace = data1.namespace__c;
                tempbody.to = ld.MobileYM__c;
                tempbody.ttl = data1.ttl__c;
                tempbody.type = data1.type__c;
                tempbody.template = temp;
                template.body = tempbody;
                string Jsonbody = JSON.serialize(template);
                Httprequest request = new HttpRequest();
                Http http = new Http();
                request.setMethod('POST');
                string jsonString = data1.url__c + '?bot='+data1.bot__c;
                request.setEndpoint(jsonString);
                request.setHeader('Content-Type', 'application/json');
                request.setHeader('x-auth-token', data1.x_auth_token__c);
                request.setBody(Jsonbody);
                HttpResponse response = http.send(request);
            }
            //----- Whatsapp_Opt_in__c == true, then send 'templatecallout2' data to hit the API----------------------
            else{
                lang.code = data2.code__c;
                lang.policy = data2.policy__c;
                temp.language = lang;
                temp.name = data2.name__c;
                temp.namespace = data2.namespace__c;
                tempbody.to = ld.MobileYM__c;
                tempbody.ttl = data2.ttl__c;
                tempbody.type = data2.type__c;
                tempbody.template = temp;
                template.body = tempbody;
                string Jsonbody = JSON.serialize(template);
                Httprequest request = new HttpRequest();
                Http http = new Http();
                request.setMethod('POST');
                string jsonString = data2.url__c + '?bot='+data2.bot__c;
                request.setEndpoint(jsonString);
                request.setHeader('Content-Type', 'application/json');
                request.setHeader('x-auth-token', data2.x_auth_token__c);
                request.setBody(Jsonbody);
                HttpResponse response = http.send(request);  
            }
            
        }catch(Exception e){
            System.debug('Error::'+e.getMessage());
        }
    }
}