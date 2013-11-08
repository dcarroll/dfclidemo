public class HerokuAPI{
	
    public String appId { get; set; }
    public String appSecret { get; set; }
    public String authUrl { get; set; }
    public String scopes { get; set; }
    public String raw { get; set; }
    
    public PageReference init() {
        doOAuth();
        return null;
    }
    
    public void doOAuth() {
        HerokuAPP__c ha = HerokuAPP__c.getInstance('FDCClient');
    	appId = ha.appId__c;
        appSecret = ha.Secret__c;
        scopes = 'global';
        authUrl = 'https://id.heroku.com/oauth/authorize?client_id=' + appId + '&response_type=code&scope=' + scopes;
    }
    
    private HttpRequest getRequest(String url, String method) {
        url = 'https://api.heroku.com' + url;
        HerokuAPP__c ha = HerokuAPP__c.getInstance('FDCClient');
		HttpRequest r = new HttpRequest();
        r.setEndpoint(url);
        r.setMethod(method);
        r.setHeader('Accept', 'application/vnd.heroku+json; version=3');
        r.setHeader('Authorization', ha.token_type__c + ' ' + ha.access_token__c);
        System.debug(r);
        return r;
    }
    
    private HttpResponse sendRequest(HttpRequest req) {
        Http h = new Http();
        HttpResponse resp = h.send(req);
		raw = resp.getBody();
		return resp;
    }
    
    public String getAccountFeatures_JSON() {
        HttpRequest req = getRequest('/account/features', 'GET');
        return sendRequest(req).getBody();
    }
    
    public String getApps_JSON() {
        return sendRequest(getRequest('/apps', 'GET')).getBody();
    }
    
    public String getDynos(String appId) {
        return sendRequest(getRequest('/apps/' + appId + '/dynos', 'GET')).getBody();
    }
    
    public String getLogSession(String appId) {
        return sendRequest(getRequest('/apps/' + appId + '/log-sessions', 'POST')).getBody();
    }
}