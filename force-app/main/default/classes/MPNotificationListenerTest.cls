@isTest
private class MPNotificationListenerTest {

    @isTest
    static void testNotificationWithSubSuccess() {
        Test.setMock(HttpCalloutMock.class, new MPNotificationCalloutMock());
        RestContext.response = new RestResponse();
        RestRequest req = new RestRequest();
        
        req.requestUri = '/payment-notification';
        req.httpMethod = 'POST';
        req.params.put('type', 'payment');
        req.params.put('data.id', 'PSubOk');
        RestContext.request = req;
        Test.startTest();
        MPNotificationListener.receiveMPNotification();
        Test.stopTest();
        
        System.assertEquals(200, RestContext.response.statusCode);
    }
    
    @isTest
    static void testNotificationWithoutSubSuccess() {
        Test.setMock(HttpCalloutMock.class, new MPNotificationCalloutMock());
        
        RestContext.response = new RestResponse();
        RestRequest req = new RestRequest();
        
        req.requestUri = '/payment-notification';
        req.httpMethod = 'POST';
        req.params.put('type', 'payment');
        req.params.put('data.id', 'PNoSub');
        RestContext.request = req;
        Test.startTest();
        MPNotificationListener.receiveMPNotification();
        Test.stopTest();
        
        System.assertEquals(200, RestContext.response.statusCode);
        
    }
    
    @isTest
    static void testNotificationWithErrorInSub() {
        Test.setMock(HttpCalloutMock.class, new MPNotificationCalloutMock());
        
        RestContext.response = new RestResponse();
        RestRequest req = new RestRequest();
        
        req.requestUri = '/payment-notification';
        req.httpMethod = 'POST';
        req.params.put('type', 'payment');
        req.params.put('data.id', 'PSubEr');
        RestContext.request = req;
        Test.startTest();
        MPNotificationListener.receiveMPNotification();
        Test.stopTest();
        
        System.assertEquals(500, RestContext.response.statusCode);
    }
    
    @isTest
    static void testNotificationWithErrorInPayment() {
        Test.setMock(HttpCalloutMock.class, new MPNotificationCalloutMock());
        
        RestContext.response = new RestResponse();
        RestRequest req = new RestRequest();
        
        req.requestUri = '/payment-notification';
        req.httpMethod = 'POST';
        req.params.put('type', 'payment');
        req.params.put('data.id', 'PIdErr');
        RestContext.request = req;
        Test.startTest();
        MPNotificationListener.receiveMPNotification();
        Test.stopTest();
        
        System.assertEquals(500, RestContext.response.statusCode);
    }
    
    @isTest
    static void testNotificationWithoutTypePayment(){
        Test.setMock(HttpCalloutMock.class, new MPNotificationCalloutMock());
        
        RestContext.response = new RestResponse();
        RestRequest req = new RestRequest();
        
        req.requestUri = '/payment-notification';
        req.httpMethod = 'POST';
        req.params.put('type', 'subscription');
        req.params.put('data.id', '123456');
        RestContext.request = req;
        Test.startTest();
        MPNotificationListener.receiveMPNotification();
        Test.stopTest();
        
        System.assertEquals(200, RestContext.response.statusCode);
    }
    
    @isTest
    static void testNotificationWithPaymentValidation() {
       	Test.setMock(HttpCalloutMock.class, new MPNotificationCalloutMock());
       	RestContext.response = new RestResponse();
        RestRequest req = new RestRequest();
        
        req.requestUri = '/payment-notification';
        req.httpMethod = 'POST';
        req.params.put('type', 'payment');
        req.params.put('data.id', 'PValid');
        RestContext.request = req;
        Test.startTest();
        MPNotificationListener.receiveMPNotification();
        Test.stopTest();
        
        System.assertEquals(200, RestContext.response.statusCode);
    }
    
    @isTest
    static void testGetPaymentException() {
        Test.setMock(HttpCalloutMock.class, new MPNotificationCalloutMock());
       	RestContext.response = new RestResponse();
        RestRequest req = new RestRequest();
        
        req.requestUri = '/payment-notification';
        req.httpMethod = 'POST';
        req.params.put('type', 'payment');
        req.params.put('data.id', 'PIdExc');
        RestContext.request = req;
        Test.startTest();
        MPNotificationListener.receiveMPNotification();
        Test.stopTest();
        
        System.assertEquals(500, RestContext.response.statusCode);
    }
    
    @isTest
    static void testGetSubscriptionException() {
        Test.setMock(HttpCalloutMock.class, new MPNotificationCalloutMock());
       	RestContext.response = new RestResponse();
        RestRequest req = new RestRequest();
        
        req.requestUri = '/payment-notification';
        req.httpMethod = 'POST';
        req.params.put('type', 'payment');
        req.params.put('data.id', 'SIdExc');
        RestContext.request = req;
        Test.startTest();
        MPNotificationListener.receiveMPNotification();
        Test.stopTest();
        
        System.assertEquals(500, RestContext.response.statusCode);
    }
}