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

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var loadMsg: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createLoginButton()
    }
    
    @IBOutlet weak var getFriendsActivityIndicator: UIActivityIndicatorView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    /* MARK - Core functions start here */
    
    func createLoginButton(){
        let loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile","email","user_friends"]
        loginButton.center = self.view.center
        loginButton.delegate = self
        self.view.addSubview(loginButton)
        
        FBSDKProfile.enableUpdatesOnAccessTokenChange(true)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onProfileUpdated:", name:FBSDKProfileDidChangeNotification, object: nil)
        
        if FBSDKAccessToken.currentAccessToken() != nil {
            self.downloadAllData()
        }
    }
    
    
    func onProfileUpdated(notification: NSNotification){
        if FBSDKAccessToken.currentAccessToken() != nil {
            self.downloadAllData()
        }
    }
    
    func downloadAllData()
    {
        self.getCurrentUserData()
        self.getFriendsActivityIndicator.startAnimating()
        self.loadMsg.text = "Getting Friend List"
        self.getAllTaggableFriendsData(afterStr: "")
        
    }

    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if error == nil {
            print("Log in complete")
        }
        else{
            print(error.localizedDescription)
        }
    }
    
    func getAllTaggableFriendsData(afterStr afts : String = ""){
        
            FBSDKGraphRequest(graphPath: "me/taggable_friends", parameters: ["fields":"name, picture.type(large)", "before" : "", "after" : afts, "next" : ""]).startWithCompletionHandler({ (connection, result, error) -> Void in
                if (error == nil){
                    let resultDict = result as! NSDictionary
                    let data : NSArray = resultDict.objectForKey("data") as! NSArray
                    if data.count > 0 {
                        for i in 0...data.count-1 {
                            let valueDict : NSDictionary = data[i] as! NSDictionary
                            let name = valueDict.objectForKey("name") as? String
                            let profilePicStr = valueDict.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as? String
                            let profilePicLink = NSURL(string: profilePicStr!)
                            User.currentUser.addFriend(name!, profilePic: profilePicLink!)

                        }
                    }
                    
                    let pagingDict : NSDictionary? = resultDict.objectForKey("paging") as? NSDictionary
                    let cursorsDict : NSDictionary? = pagingDict?.objectForKey("cursors") as? NSDictionary
                    if let afterS: AnyObject  = cursorsDict?.objectForKey("after"){
                        self.getAllTaggableFriendsData(afterStr: "\(afterS as! String)")
                    }
                    else
                    {
                        self.showTaggableFriendList()
                    }
                
                    
                }
            })
        
        
        
    }
    
    
    func showTaggableFriendList()
    {
        self.loadMsg.text = ""
        self.getFriendsActivityIndicator.stopAnimating()
        let tabBarController = self.storyboard!.instantiateViewControllerWithIdentifier("tabBarController") as! TabBarViewController
        presentViewController(tabBarController, animated: true, completion: nil)

        
    }
    
    func getCurrentUserData(){
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                if (error == nil){
                    User.currentUser.name = FBSDKProfile.currentProfile().name!
                    let valueDict : NSDictionary = result as! NSDictionary
                    let profilePicStr = valueDict.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as? String
                    User.currentUser.profilePic = NSURL(string: profilePicStr!)!
                }
            })
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User logged out")
    }


}

