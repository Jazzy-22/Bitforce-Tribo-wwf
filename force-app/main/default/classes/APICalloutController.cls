public with sharing class APICalloutController {
    public static void createLlamadaAPIRecord(String objName, String objId, HttpResponse httpResponse , HttpRequest httpRequest, String errorMessage, String endpoint, String description ) {
        Llamada_API__c llamadaApi = new Llamada_API__c();
        if (httpResponse != null) {
            llamadaApi.C_digo_respuesta__c = httpResponse.getStatusCode();
            llamadaApi.Respuesta__c = httpResponse.getBody().abbreviate(131072);
            llamadaApi.Con_error__c = httpResponse.getStatusCode() == 200 || httpResponse.getStatusCode() == 201 ? false : true;
        } else {
            llamadaApi.Con_error__c = true;
            llamadaApi.Respuesta__c = errorMessage.abbreviate(131072);
        }
        llamadaApi.Id_objeto__c = objId;
        llamadaApi.M_todo__c = httpRequest.getMethod();
        llamadaApi.Solicitud__c = httpRequest.getBody();
        llamadaApi.Objeto__c = objName;
        llamadaApi.Detalle__c = description;
        if(endpoint != null) {
            llamadaApi.Endpoint__c = endpoint;
        } else {
            llamadaApi.Endpoint__c = httpRequest.getEndpoint();
        }
        insert llamadaApi;  
        
    }

    public static void prepareToCallToCreateLlamadaAPIRecord (Map<String, Object> bodyResponse, String objName, String objId, String endpoint, String description) {
        HttpResponse response = (HttpResponse) bodyResponse.get('response');
        HttpRequest request = (HttpRequest) bodyResponse.get('request');
        String errorMessage = (String) bodyResponse.get('errorMessage');
        APICalloutController.createLlamadaAPIRecord(objName, objId, response, request, errorMessage, endpoint, description);
    }

    public static Map<String, Object> handleCallout(String namedCredential, String method, String body) {
        Map<String, Object> resp = new Map<String, Object>();
        Map<String, Object> llamadaApi = new Map<String,Object>();

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(namedCredential);
        request.setMethod(method); 
        if(body != null) {
            request.setBody(body); 
        }
        llamadaApi.put('request', request);
        try {
            HttpResponse httpResponse = http.send(request);
            llamadaApi.put('response', httpResponse);
            resp.put('llamadaApi', llamadaApi);
            if(httpResponse.getStatusCode() == 200) {
                Map<String, Object> bodyMap = (Map<String, Object>) JSON.deserializeUntyped(httpResponse.getBody());
                resp.put('body', bodyMap);
                resp.put('status', 'success');
                return resp;
            } else {
                resp.put('status', 'error');
                resp.put('message', httpResponse.getStatusCode() + ' - '  + httpResponse.getBody());
                return resp;
            }
        } catch (Exception ex) {
            resp.put('status', 'error');
            resp.put('message', ex.getMessage());   
            llamadaApi.put('errorMessage', ex.getMessage() + ' - ' + ex.getStackTraceString());
            resp.put('llamadaApi', llamadaApi);
            return resp;
        }
    }
}