public class FDClientController{

    HerokuAPI api = new HerokuAPI();
    
    public String rawResponse { 
        get {
            return api.raw;
        } set; }
    
    public PageReference init() {
     	//api.getAccountFeatures_JSON();
        api.getApps_JSON();
        List<Object> appMap = (List<Object>)JSON.deserializeUntyped(rawResponse);
        List<Heroku_App__c> hApps = new List<Heroku_App__c>();
        for (Object obj : appMap) {
            Map<String, Object> app = (Map<String, Object>)obj;
            hApps.add(new Heroku_App__c(
                Name = (String)app.get('name'), 
                Heroku_App_Id__c = (String)app.get('id'), 
                Web_Url__c = (String)app.get('web_url'),
                Region__c = (String)((Map<String, Object>)app.get('region')).get('name'),
                Stack__c = (String)app.get('stack'),
                Framework__c = (String)app.get('buildpack_provided_description')
            ));
        }
        upsert hApps Heroku_App_Id__c;
        return null;
    }
}