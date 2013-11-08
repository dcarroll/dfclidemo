public class DynoController{

    HerokuAPI api = new HerokuAPI();

    public PageReference init() {
        
        return null;
    }
    
    private Heroku_App__c record;
    
    public DynoController(ApexPages.StandardController controller) {
    	record = (Heroku_App__c)controller.getRecord();
    }
}