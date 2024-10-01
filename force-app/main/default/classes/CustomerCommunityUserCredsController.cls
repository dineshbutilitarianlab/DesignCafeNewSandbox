public without sharing class CustomerCommunityUserCredsController {
    public String mUserId;
    public String mUserName;
    public String mPassword;
    
    public static String sUserName;
    public static String sPassword;
    
    public void setmUserId(String arg) {
        mUserId = arg;
    }
    
    public String getmUserId() {
        return mUserId;
    }
    
    public String getmUserName() {
        return sUserName;
    }
    
    public String getmPassword() {
        return sPassword;
    }
    
    public static void setPassword(String aUserId) {
        if(String.isNotBlank(aUserId)) {
            User lUser = [SELECT id, Username FROM User WHERE id=:aUserId];
            ResetPasswordResult lPswd = System.resetPassword(aUserId, false);
            sUserName = lUser.Username;
            sPassword = lPswd.getPassword();
        }
    }
}