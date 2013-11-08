/**
 * An apex page controller that takes the user to the right start page based on credentials or lack thereof
 */
public with sharing class CommunitiesLandingController {
    
    // Code we will invoke on page load.
    public PageReference forwardToStartPage() {
        String profId = UserInfo.getProfileId();
        String profName = [Select Id, Name From Profile Where Id = :profId].Name;
        System.debug(profName);
        return Network.communitiesLanding();
    }
    
    public CommunitiesLandingController() {
        String profId = UserInfo.getProfileId();
        String profName = [Select Id, Name From Profile Where Id = :profId].Name;
        System.debug(profName);
    
    }
}