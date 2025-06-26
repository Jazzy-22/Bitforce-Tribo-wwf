public with sharing class MPSubscriptionController {
    @InvocableMethod(label='Cancelar o Pausar Subscripción' description='Cancela o pausa subscripción en Mercado Pago según el valor del campo action (\'cancel\' o \'pause\') en cada elemento de tipo InputVariablesClass. Devuelve una Lista de tipo OutputVariableSubscriptionClass con el estado status igual a \'success\' o status \'error\' + \'message\'' )
    public static List<OutputVariableSubscriptionClass> cancelOrPauseSubscription(List<InputVariableSubscriptionClass> inputVariables) {
        List<OutputVariableSubscriptionClass> outputVariablesList = new List<OutputVariableSubscriptionClass>();
	
        if(inputVariables.size() > 100) {
            OutputVariableSubscriptionClass outputItem = new OutputVariableSubscriptionClass();
            outputItem.status = 'error';
            outputItem.message = 'Error: Cantidad de registros a procesar supera el máximo permitido (100)';
            outputVariablesList.add(outputItem);
            return outputVariablesList;
            
        } else {
            for (InputVariableSubscriptionClass input : inputVariables) {
                String body;                
                OutputVariableSubscriptionClass outputItem = new OutputVariableSubscriptionClass();
                outputItem.recordId = input.recordId;

                if(input.action == 'cancel') {
                    body = '{"status":"cancelled"}'; 
                } else if(input.action == 'pause') {
                    body = '{"status":"paused"}';
                }
                String endpoint = 'callout:MP_Subscription/' + input.subscriptionId;
                
                Map<String, Object> subscription =  APICalloutController.handleCallout(endpoint, 'PUT', body);
                Map<String, Object> llamadaApi = (Map<String,Object>) subscription.get('llamadaApi');
                APICalloutController.prepareToCallToCreateLlamadaAPIRecord(llamadaApi, null, input.recordId,  'https://api.mercadopago.com/preapproval/', null);
                outputItem.status = (String) subscription.get('status');
                outputItem.message = (String) subscription.get('message');
                outputVariablesList.add(outputItem);
        	}
        	return outputVariablesList;  
        }        
    }

        /**
     * @description Get the subscription information from Mercado Pago
     * @param Id The subscription ID
     * @return Map<String, Object> The response from the Mercado Pago API
     */
    public static Map<String, Object> getMPSubscription(String Id) {
        String endpoint = 'callout:MP_Subscription/' + Id;
        return APICalloutController.handleCallout(endpoint, 'GET', null);
    }
}