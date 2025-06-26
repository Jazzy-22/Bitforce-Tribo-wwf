global class MPSubscriptionCalloutMock implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        String method = req.getMethod();
        String endpoint = req.getEndpoint();
        String Id = endpoint.right(6);
        res.setHeader('Content-Type', 'application/json');
        System.debug(Id);
        if(method == 'PUT'){
            if(Id == 'SubsOk') {
            res.setBody('{"id": "SubsOk" }');
            res.setStatusCode(200);
            } else if(Id == 'SubErr') {
                res.setBody('Error updating the subscription');
				res.setStatusCode(500);
            } else if(Id == 'SubExc') {
                throw new CalloutException('Error Server updating subscription');
            }
        }
        if(method == 'GET') {
            if(Id == 'SubsOk') {
                res.setStatusCode(200);
                res.setBody('{"id": "SubsOk"}');
            } else if (Id == 'SubErr') {
                res.setStatusCode(500);
                res.setBody('Error getting the subscription');
            } else if (Id == 'SubExc') {
                throw new CalloutException('Error getting the subscription');
            }
        }
        return res;
        
    }
}