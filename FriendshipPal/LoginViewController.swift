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
import Parse

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    var uf = User()
    
    @IBOutlet weak var loadMsg: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createLoginButton()
    }
    
    @IBOutlet weak var getFriendsActivityIndicator: UIActivityIndicatorView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /* MARK - Core functions start here */
    
    func createLoginButton(){
        var loginButton = FBSDKLoginButton()
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
        //Get all friends if user has logged in
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
            println("Log in complete")
        }
        else{
            println(error.localizedDescription)
        }
    }
    
    func getAllTaggableFriendsData(afterStr afts : String = ""){
        
            FBSDKGraphRequest(graphPath: "me/taggable_friends", parameters: ["fields":"name, email, picture", "before" : "", "after" : afts, "next" : ""]).startWithCompletionHandler({ (connection, result, error) -> Void in
                if (error == nil){
                    var resultDict = result as! NSDictionary
                    var data : NSArray = resultDict.objectForKey("data") as! NSArray
                    if data.count > 0 {
                        for i in 0...data.count-1 {
                            let valueDict : NSDictionary = data[i] as! NSDictionary
                            var name = valueDict.objectForKey("name") as? String
                            var profilePicStr = valueDict.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as? String
                            var profilePicLink = NSURL(string: profilePicStr!)
                            self.uf.addFriend(name!, profilePic: profilePicLink!)

                        }
                    }
                    
                    var pagingDict : NSDictionary? = resultDict.objectForKey("paging") as? NSDictionary
                    var cursorsDict : NSDictionary? = pagingDict?.objectForKey("cursors") as? NSDictionary
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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = self.storyboard!.instantiateViewControllerWithIdentifier("tabBarController") as! TabBarViewController
        tabBarController.uf = self.uf
        presentViewController(tabBarController, animated: true, completion: nil)
        
        
//        let uiTabController = self.storyboard!.instantiateViewControllerWithIdentifier("tabBarController") as! TabBarViewController
//        uiTabController.uf = self.uf
//        self.navigationController!.pushViewController(uiTabController, animated: true)
        
    }
    
    func getCurrentUserData(){
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                if (error == nil){
                    var fullname : String! = FBSDKProfile.currentProfile().name
                    self.uf.name = fullname
                }
            })
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        println("User logged out")
    }


}

