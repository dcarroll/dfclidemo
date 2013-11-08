public class GetDETokenController{
	private string cons_key = '3MVG9A2kN3Bn17hupqqk7YYhDRhd_5YKxa9QBx0VtGMqCZw5uZ7_3cV.Y95QnhhjwU1NUtdeZ9k.B4n9uHhE8';
    private string client_secret = '8315426209586567694';
    private string callback_url = 'https://dooder-dev-ed.my.salesforce.com/apex/GetDEToken';
    public string Consumer_Key { 
        get { return cons_key; }
        set; 
    }
    
    public Boolean doRedirect { get; set; }
    public String restCall { get; set; }
    public String restData { get; set; }
    
    public PageReference loadHandler() {
    	return null;
    }
    
    public GetDETokenController() {
        doRedirect = true;
     	// Check to see if this is the callback
        Map<String, String> params = ApexPages.currentPage().getParameters();
        if (params.containsKey('code')) {
            doRedirect = false;
			// This is the callback, we will need to save the token and refresh token
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://login.salesforce.com/services/oauth2/token');
            req.setMethod('POST');
            String body = 'grant_type=authorization_code&code=' +
                params.get('code') + '&client_id=' +
                cons_key + '&client_secret=' +
                client_secret + '&redirect_uri=' +
                callback_url;
            req.setBody(body);
            Http h = new Http();
            HttpResponse resp = h.send(req);
            System.debug(resp.getBody());
            // Need to redirect to another page so we don't try to do this again.
            Map<String, Object> data = (Map<String, Object>)JSON.deserializeUntyped(resp.getBody());
            String token = (String)data.get('access_token');
            System.debug('Token: ' + token);
            String userdataUri = (String)data.get('instance_url');
           	System.debug('Userdata ep: ' + userdataUri);

            userdataUri += '/services/data/v28.0/sobjects/User/' +
                token.split('!')[0];
           	System.debug('Userdata ep: ' + userdataUri);
            
            req.setEndpoint(userdataUri);
            req.setMethod('GET');
            req.setHeader('Authorization', 'Bearer ' + (String)data.get('access_token'));
            
            restData = (String)data.get('access_token');
            restCall = userdataUri;
            
            //resp = h.send(req);
            System.debug(resp.getBody() + '\n\n' + resp.getStatus());
            
            List<User_DE_Data__c> userData = [Select Id, Name, OAuthId__c, IssuedAt__c, InstanceUrl__c, RefreshToken__c, Signature__c, AccessToken__c, Scope__c From User_DE_Data__c Where User__c = :UserInfo.getUserId()];

            if (userData.isEmpty()) {
                User_DE_Data__c userDataNew = new User_DE_Data__c(User__c = Userinfo.getUserId(),
                    					Name=Userinfo.getUserName(), 
                                        OAuthId__c = (String)data.get('id'), 
                                        IssuedAt__c = (String)data.get('issued_at'), 
                                        InstanceUrl__c = (String)data.get('instance_url'), 
                                        RefreshToken__c = (String)data.get('refresh_token'), 
                                        Signature__c = (String)data.get('signature'), 
                                        AccessToken__c = (String)data.get('access_token'), 
                                        Scope__c = (String)data.get('scope'));
                insert userDataNew;
            } else {
                // need to update, which I should do later I think.
            }
		    /*
            	"id":"https://login.salesforce.com/id/00Di0000000KpdAEAS/005i0000000NsyKAAS",
				"issued_at":"1372442984256",
				"scope":"full web refresh_token",
				"instance_url":"https://dooder-dev-ed.my.salesforce.com",
				"refresh_token":"5Aep861z80Xevi74eUTzrHkPziB0ZZIV3uZEx.1P8nuzG1gMxELrmUyFi0v8EH7OpUDF65SJNsJsPl1ZK3x4d3j",
				"signature":"aRBq12WYdyLk9mCGT8rv5wzdHTCXYgxS2bB8GiGOn2c=",
				"access_token":"00Di0000000KpdA!ARQAQIi5vNAG_TdYf73z9advdur4J9Ia8HzcRK1cwGKIqZGawmSTkENGJ0R4l_ihOyiITZ7Z4hk.Uobi5KLh2Sfh81_sNeni"
			*/
        } 
    }
}