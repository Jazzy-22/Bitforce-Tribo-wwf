global class MPNotificationCalloutMock implements HttpCalloutMock  {
	global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        String endpoint = req.getEndpoint();
                String pagoId = endpoint.right(6);
        String Id = endpoint.right(6);
        res.setHeader('Content-Type', 'application/json');
        if(endpoint.startsWith('callout:MP_Payment/') == true){
            if(Id == 'PSubOk') {
                res.setStatusCode(200);
                res.setBody('{"metadata": {"preapproval_id": "SubSuc"}, "id": "123456" }');
            } else if(Id == 'PNoSub') {
                res.setStatusCode(200);
                res.setBody('{"id": "123450" }');
            } else if (Id == 'PSubEr') {
                res.setStatusCode(200);
                res.setBody('{"metadata": {"preapproval_id": "SubErr"}, "id": "123456" }');
            } else if(Id == 'PIdErr') {
                res.setStatusCode(500);
            } else if(Id == 'PValid') {
                res.setStatusCode(200);
                res.setBody('{"external_reference": "Recurring payment validation", "id": "12345--" }');
            } else if(Id == 'PIdExc') {
                throw new CalloutException('Error Server gettin Payment');
            } else if(Id == 'SIdExc') {
                res.setStatusCode(200);
                res.setBody('{"metadata": {"preapproval_id": "SubExc"}, "id": "123456" }');
            }
        } else if (endpoint.startsWith('callout:MP_Subscription/') == true){
			if(Id == 'SubSuc') {
                res.setStatusCode(200);
                res.setBody('{"id": "123456"}');
            } else if(Id == 'SubErr') {
                 res.setStatusCode(500);
            } else if(Id == 'SubExc') {
                throw new CalloutException('Error Server getting Payment');
            }
        }
		return res;
    }
}