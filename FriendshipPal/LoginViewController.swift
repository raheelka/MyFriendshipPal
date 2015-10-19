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
        if ((PFUser.currentUser()) != nil)
        {
            self.showFacebookFriendList()
        }
    }
    
    @IBAction func loginUser(sender: UIButton) {
            let permissions = ["public_profile", "email","user_friends"]
            loginWithReadPermissions(permissions)
    }
    
    
    
    func loginWithReadPermissions(permissions : [String]){
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions, block: {
            (user: PFUser?, error: NSError?) -> Void in
            if let user = user {
                self.getCurrentUserFacebookData(user)
                print("User logged in through facebook")
                
            } else {
                print("Uh oh. The user cancelled the Facebook login.")
            }
        })
    }
    
    
    
    func showFacebookFriendList()
    {
        let tabBarController = self.storyboard!.instantiateViewControllerWithIdentifier("tabBarController") as! TabBarViewController
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.rootViewController = tabBarController
    }
    
    
    func getCurrentUserFacebookData(user : PFUser){
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                if (error == nil){
                    let valueDict : NSDictionary = result as! NSDictionary
                    
                    self.setUserProfileFromJson(valueDict, user: user)
                    if(user["user_id"] == nil){
                        user["user_id"] = valueDict.objectForKey("id") as? String
                        self.createEmptyRelation(user)
                    }
                    else{
                        //Database validations should be done before proceeding. Make sure relations exists for the user
                        self.saveUserAndShowFriends(user)
                    }
                }
            })
        }
    }
    
    func setUserProfileFromJson(valueDict : NSDictionary, user: PFUser)
    {
        let profilePicStr = valueDict.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as? String
        let email = valueDict.objectForKey("email") as? String
        user.email = email
        user["name"] = valueDict.objectForKey("name") as? String
        user["profile_pic_url"] = profilePicStr
    }
    
    func saveUserAndShowFriends(user : PFUser)
    {
        user.saveInBackgroundWithBlock({ (success, error) -> Void in
            if(success){
                self.showFacebookFriendList()
            }
            else
            {
                print("Error in saving user to parse")
            }
            
        })

    }
    
    func createEmptyRelation(user : PFUser){
        let relation = PFObject(className: "Relations")
        relation["user"] = user
        let liked_friends : [PFUser] = []
        let disliked_friends : [PFUser] = []
        let mutually_liked_friends : [PFUser] = []
        relation["liked_friends"] = liked_friends
        relation["disliked_friends"] = disliked_friends
        relation["mutually_liked_friends"] = mutually_liked_friends
        
        relation.saveInBackgroundWithBlock({(success, error) -> Void in
            if(success){
                self.saveUserAndShowFriends(user)
            }
            else{
                print("Could not save Relations")
            }
        })
        
    }
    


}

