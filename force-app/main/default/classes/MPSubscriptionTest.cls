@isTest
private class MPSubscriptionTest {
    @isTest
    static void  testCancelSubscriptionSuccess() {
        Test.setMock(HttpCalloutMock.class, new MPSubscriptionCalloutMock());

        List<InputVariableSubscriptionClass> inputVariables = new List<InputVariableSubscriptionClass>();
        InputVariableSubscriptionClass inputItem = new InputVariableSubscriptionClass();
        inputItem.action = 'cancel';
        inputItem.subscriptionId = 'SubsOk';
        inputVariables.add(inputItem);

        Test.startTest();
        List<OutputVariableSubscriptionClass> response= MPSubscriptionController.cancelOrPauseSubscription(inputVariables);
        Test.stopTest();
		
        Llamada_API__c[] apiRecord = [SELECT C_digo_respuesta__c, Solicitud__c, Con_error__c, Respuesta__c FROM Llamada_API__c LIMIT 1];
        System.assertEquals(response[0].status, 'success');
        System.assertEquals(apiRecord[0].C_digo_respuesta__c, 200);
		System.assertEquals(apiRecord[0].Con_error__c, false);
		System.assertEquals(apiRecord[0].Respuesta__c, '{"id": "SubsOk" }');
        System.assertEquals(apiRecord[0].Solicitud__c, '{"status":"cancelled"}');
    }
    
    @isTest
    static void  testPauseSubscriptionSuccess() {
        Test.setMock(HttpCalloutMock.class, new MPSubscriptionCalloutMock());

        List<InputVariableSubscriptionClass> inputVariables = new List<InputVariableSubscriptionClass>();
        InputVariableSubscriptionClass inputItem = new InputVariableSubscriptionClass();
        inputItem.action = 'pause';
        inputItem.subscriptionId = 'SubsOk';
        inputVariables.add(inputItem);

        Test.startTest();
        List<OutputVariableSubscriptionClass> response= MPSubscriptionController.cancelOrPauseSubscription(inputVariables);
        Test.stopTest();
		
        Llamada_API__c[] apiRecord = [SELECT C_digo_respuesta__c, Solicitud__c, Con_error__c, Respuesta__c FROM Llamada_API__c LIMIT 1];
        System.assertEquals(response[0].status, 'success');
        System.assertEquals(apiRecord[0].C_digo_respuesta__c, 200);
		System.assertEquals(apiRecord[0].Con_error__c, false);
		System.assertEquals(apiRecord[0].Respuesta__c, '{"id": "SubsOk" }');
        System.assertEquals(apiRecord[0].Solicitud__c, '{"status":"paused"}');
    }
    
    @isTest
    static void  testCancelSubscriptionError() {
        Test.setMock(HttpCalloutMock.class, new MPSubscriptionCalloutMock());

        List<InputVariableSubscriptionClass> inputVariables = new List<InputVariableSubscriptionClass>();
        InputVariableSubscriptionClass inputItem = new InputVariableSubscriptionClass();
        inputItem.action = 'cancel';
        inputItem.subscriptionId = 'SubErr';
        inputVariables.add(inputItem);

        Test.startTest();
        List<OutputVariableSubscriptionClass> response= MPSubscriptionController.cancelOrPauseSubscription(inputVariables);
        Test.stopTest();
		
        Llamada_API__c[] apiRecord = [SELECT C_digo_respuesta__c, Solicitud__c, Con_error__c, Respuesta__c FROM Llamada_API__c LIMIT 1];
        System.assertEquals(response[0].status, 'error');
        System.assertEquals(apiRecord[0].C_digo_respuesta__c, 500);
		System.assertEquals(apiRecord[0].Con_error__c, true);
		System.assertEquals(apiRecord[0].Respuesta__c, 'Error updating the subscription');
        System.assertEquals(apiRecord[0].Solicitud__c, '{"status":"cancelled"}');
    }
    
    @isTest
    static void  testPauseSubscriptionError() {
        Test.setMock(HttpCalloutMock.class, new MPSubscriptionCalloutMock());

        List<InputVariableSubscriptionClass> inputVariables = new List<InputVariableSubscriptionClass>();
        InputVariableSubscriptionClass inputItem = new InputVariableSubscriptionClass();
        inputItem.action = 'pause';
        inputItem.subscriptionId = 'SubErr';
        inputVariables.add(inputItem);

        Test.startTest();
        List<OutputVariableSubscriptionClass> response= MPSubscriptionController.cancelOrPauseSubscription(inputVariables);
        Test.stopTest();
		
        Llamada_API__c[] apiRecord = [SELECT C_digo_respuesta__c, Solicitud__c, Con_error__c, Respuesta__c FROM Llamada_API__c LIMIT 1];
        System.assertEquals(response[0].status, 'error');
        System.assertEquals(apiRecord[0].C_digo_respuesta__c, 500);
		System.assertEquals(apiRecord[0].Con_error__c, true);
		System.assertEquals(apiRecord[0].Respuesta__c, 'Error updating the subscription');
        System.assertEquals(apiRecord[0].Solicitud__c, '{"status":"paused"}');
    }
    
    @isTest
    static void  testCancelSubscriptionException() {
        Test.setMock(HttpCalloutMock.class, new MPSubscriptionCalloutMock());

        List<InputVariableSubscriptionClass> inputVariables = new List<InputVariableSubscriptionClass>();
        InputVariableSubscriptionClass inputItem = new InputVariableSubscriptionClass();
        inputItem.action = 'cancel';
        inputItem.subscriptionId = 'SubExc';
        inputVariables.add(inputItem);

        Test.startTest();
        List<OutputVariableSubscriptionClass> response= MPSubscriptionController.cancelOrPauseSubscription(inputVariables);
        Test.stopTest();
		
        Llamada_API__c[] apiRecord = [SELECT C_digo_respuesta__c, Solicitud__c, Con_error__c, Respuesta__c FROM Llamada_API__c LIMIT 1];
        System.assertEquals(response[0].status, 'error');
        System.assertEquals(apiRecord[0].C_digo_respuesta__c, null);
		System.assertEquals(apiRecord[0].Con_error__c, true);
		System.assertEquals(apiRecord[0].Respuesta__c.contains('Error Server updating subscription'), true);
        System.assertEquals(apiRecord[0].Solicitud__c, '{"status":"cancelled"}');
    }
    
    @isTest
    static void  testGetSubscriptionSuccess() {
        Test.setMock(HttpCalloutMock.class, new MPSubscriptionCalloutMock());
		String Id = 'SubsOk';
 
        Test.startTest();
        Map<String, Object> resp = MPSubscriptionController.getMPSubscription(Id);
        Test.stopTest();
		
        System.assertEquals(resp.get('status'), 'success');
		System.assertEquals(resp.get('body').toString(), '{id=SubsOk}');
		System.assertEquals(resp.containsKey('llamadaApi'), true);
    }
    
    @isTest
    static void  testGetSubscriptionError() {
        Test.setMock(HttpCalloutMock.class, new MPSubscriptionCalloutMock());
		String Id = 'SubErr';
 
        Test.startTest();
        Map<String, Object> resp = MPSubscriptionController.getMPSubscription(Id);
        Test.stopTest();
		
        System.assertEquals(resp.get('status'), 'error');
		System.assertEquals((resp.get('message').toString()).contains('Error getting the subscription'), true);
		System.assertEquals(resp.containsKey('llamadaApi'), true);
    }
    
    @isTest
    static void  testGetSubscriptionExc() {
        Test.setMock(HttpCalloutMock.class, new MPSubscriptionCalloutMock());
		String Id = 'SubExc';
 
        Test.startTest();
        Map<String, Object> resp = MPSubscriptionController.getMPSubscription(Id);
        Test.stopTest();
		
        System.assertEquals(resp.get('status'), 'error');
		System.assertEquals(resp.get('message').toString(), 'Error getting the subscription');
		System.assertEquals(resp.containsKey('llamadaApi'), true);
    }
}