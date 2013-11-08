public class HerokuAPICallbackController{
	
    public pageReference init() {
     	String code = ApexPages.currentPage().getParameters().get('code');
        HerokuAPP__c ha = HerokuAPP__c.getInstance('FDCClient');
        String appSecret = ha.Secret__c;
        this.getToken(code, ha);
        return new PageReference('/apex/' + ha.StartPage__c);
    }
    
    private void getToken(String code, HerokuAPP__c ha) {
        System.debug('Starting');
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://id.heroku.com/oauth/token');
        req.setMethod('POST');
        req.setBody('grant_type=authorization_code&code=' + code + '&client_secret=' + ha.Secret__c);
        System.debug('ready to post');
        Http h = new Http();
        HttpResponse resp = h.send(req);
        System.debug('posted\n' + resp.getBody());
        Map<String, Object> data = (Map<String, Object>)JSON.deserializeUntyped(resp.getBody());
        ha.access_token__c = (String)data.get('access_token');
  		ha.expires_in__c = Integer.valueOf(data.get('expires_in'));
	  	ha.refresh_token__c = (String)data.get('refresh_token');
	  	ha.token_type__c = (String)data.get('token_type');
		ha.user_id__c = (String)data.get('user_id');
		ha.session_nonce__c = (String)data.get('session_nonce');
        System.debug('ready to update');
        update ha;
        System.debug('updated');
    }
}