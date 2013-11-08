/**
 * An apex page controller that supports self registration of users in communities that allow self registration
 */
public with sharing class CommunitiesSelfRegController {

    public String firstName {get; set;}
    public String lastName {get; set;}
    public String email {get; set;}
    public String username {get; set;}
    public String password {get; set {password = value == null ? value : value.trim(); } }
    public String confirmPassword {get; set { confirmPassword = value == null ? value : value.trim(); } }
    public String communityNickname {get; set { communityNickname = value == null ? value : value.trim(); } }
    
    public CommunitiesSelfRegController() {}
    
    private boolean isValidPassword() {
        return password == confirmPassword;
    }

    public PageReference registerUser() {
    
           // it's okay if password is null - we'll send the user a random password in that case
        if (!isValidPassword()) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.site.passwords_dont_match);
            ApexPages.addMessage(msg);
            return null;
        }    

        String profileId = [Select Id From Profile Where Name = 'Developer Profile'][0].Id; // To be filled in by customer.
        String roleEnum = ''; // To be filled in by customer.
        String accountId = '001D000000JRD2k'; // To be filled in by customer.
        
        User u = new User();
        u.Username = userName;
        u.Email = email;
        u.FirstName = firstName;
        u.LastName = lastName;
        u.CommunityNickname = communityNickname;
        u.ProfileId = profileId;
        
        String userId = Site.createPortalUser(u, accountId, password);
      
        if (userId != null) { 
            if (password != null && password.length() > 1) {
                return Site.login(userName, password, null);
            }
            else {
                PageReference page; // = System.Page.CommunitiesSelfRegConfirm;
                page.setRedirect(true);
                return page;
            }
        }
        return null;
    }

    // Code we will invoke on page load.
    public PageReference forwardToStartPage() {
        Id pfId = [Select Id From Profile Where Name = 'Developer Profile'][0].Id;
        if (UserInfo.getProfileId() == pfId) {
            // User is logged in, redirect
            PageReference page; // = System.Page.Home;
            page.setRedirect(true);
            return page;
        } else {
            return null;
        }
    }

}