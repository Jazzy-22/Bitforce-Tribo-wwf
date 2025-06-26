@RestResource(urlMapping='/payment-notification/*')
global with sharing class MPNotificationListener {
    @HttpPost
    global static void receiveMPNotification() {
        RestRequest req = RestContext.request;            
        RestResponse res = RestContext.response;
        System.debug(req.params);
        Map<String, Object> handleNotification = MPNotificationController.handleNotification(req);
        System.debug('Status: ' + handleNotification.get('status'));
        System.debug('Payment: ' + handleNotification.get('payment'));
        System.debug('Subscription: ' + handleNotification.get('subscription'));
        System.debug('Preference: ' + handleNotification.get('preference'));
        System.debug('Message: ' + handleNotification.get('message'));
		if(handleNotification.get('status') != 'error'){
            res.statusCode = 200;
        } else {
            res.statusCode = 500;
        }
    }
}