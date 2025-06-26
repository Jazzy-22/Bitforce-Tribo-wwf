public without sharing class MPNotificationController {

    public static Map<String, Object> handleNotification(RestRequest req) {
        String type = req.params.get('type');
        String IdMP = req.params.get('data.id');
        if(type == 'payment' && IdMP != null) { 
            return handleMPInformation(IdMP);
        } else {
            return new Map<String, Object>{'status' => 'success'};
        }
    }

    /**
     * @description Handle the Mercado Pago information
     * @param paymentId The payment ID
     * @return Map<String, Object> The response from the Mercado Pago API
     */
    private static Map<String, Object> handleMPInformation (String paymentId) {

        Map<String, Object> resp = new Map<String, Object>(); 
        Map<String, Object> subscription = new Map<String, Object>();
        Map<String, Object> preference = new Map<String, Object>();
        String recordId = null;
        Map<String, Object>  payment = getMPPayment(paymentId);
        Map<String, Object> paymentLlamadaApi = (Map<String, Object>) payment.get('llamadaApi');

        if(payment.get('status') != 'error') {

            Map<String, Object> body = (Map<String, Object>) payment.get('body');
            if(body.get('external_reference') == 'Recurring payment validation'){
                resp.put('status', 'validation Payment');
                Map<String, Object> payLlamadaApi = (Map<String, Object>) payment.get('llamadaApi');
                APICalloutController.prepareToCallToCreateLlamadaAPIRecord(payLlamadaApi, 'Formulario_de_donaciones__c', null, 'https://api.mercadopago.com/v1/payments', 'Validación de pago recurrente. La subscripción ya fue aceptada pero mp aún no confirmó el primer pago. El pago real tendra un Id diferente.');                            
                return resp;
            }
            if(body.get('external_reference') != null) {
                recordId = (String) body.get('external_reference');
                List<Formulario_de_donaciones__c> record = new List<Formulario_de_donaciones__c>();
                if(recordId != null) {
                    record = [SELECT Id, Id_externo_de_MP__c, Forma_de_pago__c FROM Formulario_de_donaciones__c WHERE Id = : recordId LIMIT 1];
                    if(record.size() > 0) {
                        if(record[0].Forma_de_pago__c == 'Recurrente') {
                            subscription = MPSubscriptionController.getMPSubscription(record[0].Id_externo_de_MP__c);
                            String subDescription = 'Id del pago de Mercado Pago relacionado con esta subscripción: ' + body.get('id');
                            if(subscription.get('status') == 'success') {
                                resp.put('subscription', subscription.get('body'));
                            } else {
                                resp.put('status', 'error');
                                resp.put('message', 'Error Getting Subscription from MP: ' + subscription.get('message'));
                            }

                            Map<String, Object> subLlamadaApi = (Map<String, Object>) subscription.get('llamadaApi');
                            APICalloutController.prepareToCallToCreateLlamadaAPIRecord(subLlamadaApi, 'Formulario_de_donaciones__c', recordId, 'https://api.mercadopago.com/preapproval', subDescription);
                        } else {
                            preference = getMPPreference(record[0].Id_externo_de_MP__c);
                            String prefDescription = 'Id del pago de Mercado Pago relacionado con esta preferencia: ' + body.get('id');
                            if(preference.get('status') == 'success') {
                                resp.put('preference', preference.get('body'));
                            } else {
                                resp.put('status', 'error');
                                resp.put('message', 'Error Getting Preference from MP: ' + preference.get('message'));
                            }
                            Map<String, Object> prefLlamadaApi = (Map<String, Object>) preference.get('llamadaApi');
                            APICalloutController.prepareToCallToCreateLlamadaAPIRecord(prefLlamadaApi, 'Formulario_de_donaciones__c', recordId,  'https://api.mercadopago.com/checkout/preferences', prefDescription);                    
                        }
                        String paymentDescription = (String) resp.get('message');
                        APICalloutController.prepareToCallToCreateLlamadaAPIRecord(paymentLlamadaApi, 'Formulario_de_donaciones__c', recordId, 'https://api.mercadopago.com/v1/payments', paymentDescription);
                        
                        if(resp.get('status') == 'error') {
                            return resp;
                        }
                    } else {
                        resp.put('status', 'error');
                        resp.put('message', 'No se pudo obtener un registro que corresponda al campo external_reference de MercadoPago');
                        APICalloutController.prepareToCallToCreateLlamadaAPIRecord(paymentLlamadaApi, 'Formulario_de_donaciones__c', null, 'https://api.mercadopago.com/v1/payments', 'No se pudo obtener el registro. El valor del campo external_reference no corresponde con ningún Id del objeto Formulario_de_donaciones__c');
                        return resp;
                    }
                } else {
                    resp.put('status', 'error');
                    resp.put('message', 'No se pudo obtener el registro. El valor del campo external_reference de MP es nulo');                        
                    APICalloutController.prepareToCallToCreateLlamadaAPIRecord(paymentLlamadaApi, 'Formulario_de_donaciones__c', null, 'https://api.mercadopago.com/v1/payments',  'No se pudo obtener el registro. El valor del campo external_reference de MP es nulo');
                    return resp;
                }
            } else {
                resp.put('status', 'error');
                resp.put('message', 'No se pudo obtener el registro. No existe el campo external_reference en MP');
                APICalloutController.prepareToCallToCreateLlamadaAPIRecord(paymentLlamadaApi, 'Formulario_de_donaciones__c', null, 'https://api.mercadopago.com/v1/payments', 'No se pudo obtener el registro. No existe el campo external_reference en Mercado Pago');
                return resp;
            }
            resp.put('status', 'success');
            resp.put('payment', payment.get('body')); 
            return resp;

        } else {
            APICalloutController.prepareToCallToCreateLlamadaAPIRecord(paymentLlamadaApi, 'Formulario_de_donaciones__c', null, 'https://api.mercadopago.com/v1/payments', null);            
            resp.put('status', 'error');
            resp.put('message', 'Payment Error: ' + payment.get('message'));
            return resp;
        }
    }

    private static Map<String, Object> getMPPreference(String Id) {
        String endpoint = 'callout:MP_Preference/' + Id;
        return APICalloutController.handleCallout(endpoint, 'GET', null);
    }

    /**
     * @description Get the payment information from Mercado Pago
     * @param Id The payment ID
     * @return Map<String, Object> The response from the Mercado Pago API
     */
    private static Map<String, Object> getMPPayment(String Id) {
        String endpoint = 'callout:MP_Payment/' + Id;
        return APICalloutController.handleCallout(endpoint, 'GET', null);
    }

}