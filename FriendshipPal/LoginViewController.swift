//
//  ViewController.swift
//  FriendshipPal
//
//  Created by Raheel Kazi on 8/23/15.
//  Copyright (c) 2015 Raheel Kazi. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController {
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    /* MARK - Core functions start here */
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        if(isUserLoggedIn()){
            showFacebookFriendList()
        }
    }
    
    @IBAction func loginUser(sender: UIButton) {
        if let accessToken: FBSDKAccessToken = FBSDKAccessToken.currentAccessToken() {
            self.loginWithAccessToken(accessToken)
        } else {
            let permissions = ["public_profile", "email","user_friends"]
            loginWithReadPermissions(permissions)
        }
    }

    
    func isUserLoggedIn() -> Bool {
        if (PFUser.currentUser()?.sessionToken != nil)
        {
            return true
        }
        else{
            return false
        }
    }
    
    
    func loginWithAccessToken(accessToken : FBSDKAccessToken){
        PFFacebookUtils.logInInBackgroundWithAccessToken(accessToken, block: {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                self.getCurrentUserData(user!)
                print("Access token present ... User logged in through Facebook!")
                self.showFacebookFriendList()
            } else {
                print("Uh oh. There was an error logging in.")
            }
        })
    }
    
    
    func loginWithReadPermissions(permissions : [String]){
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions, block: {
            (user: PFUser?, error: NSError?) -> Void in
            if let user = user {
            
                self.getCurrentUserData(user)
                self.showFacebookFriendList()
                print("User logged in through facebook")
                
            } else {
                print("Uh oh. The user cancelled the Facebook login.")
            }
        })
    }
    
    
    
    func showFacebookFriendList()
    {
            let tabBarController = self.storyboard!.instantiateViewControllerWithIdentifier("tabBarController") as! TabBarViewController
            self.presentViewController(tabBarController, animated: true, completion: nil)

    }
    
    
    // TODO This function should run only on first login
    // TODO This function sets liked and disliked friends to []
    func getCurrentUserData(user : PFUser){
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                if (error == nil){
                    let valueDict : NSDictionary = result as! NSDictionary
                    //print(valueDict)
                    let profilePicStr = valueDict.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as? String
                    let email = valueDict.objectForKey("email") as? String
                    let liked_friends : [String] = []
                    let disliked_friends : [String] = []
                    user.email = email
                    user["name"] = valueDict.objectForKey("name") as? String
                    user["profile_pic_url"] = profilePicStr
                    user["user_id"] = valueDict.objectForKey("id") as? String
                    user["liked_friends"] = liked_friends
                    user["disliked_friends"] = disliked_friends
                    user.saveInBackground()
                }
            })
        }
    }
    


}

