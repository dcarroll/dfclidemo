public class Home4Controller{

    public List<User_App_Data__c> myApps {
        get {
            return [Select Id, Name From User_App_Data__c];
        } set;
    }
}