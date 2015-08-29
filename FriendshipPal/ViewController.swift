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

class ViewController: UIViewController, FBSDKLoginButtonDelegate {

    var uf = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createLoginButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "detailView") {
            var detailViewController = segue.destinationViewController as! DetailViewController
            detailViewController.userProfile = uf
        }
    }
    
//    override func performSegueWithIdentifier(identifier: String?, sender: AnyObject?) {
//        if(identifier == "detailView") {
//            UIStoryboardSegue
//            UIStoryboardSegue
//            var detailViewController = self.destinationViewController as! DetailViewController
//            detailViewController.userProfile = uf
//        }
//    }
    
    
    
    /* MARK - Core functions start here */
    
    func createLoginButton(){
        var loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile","email","user_friends"]
        loginButton.center = self.view.center
        loginButton.delegate = self
        self.view.addSubview(loginButton)
        
        FBSDKProfile.enableUpdatesOnAccessTokenChange(true)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onProfileUpdated:", name:FBSDKProfileDidChangeNotification, object: nil)
        
        if FBSDKAccessToken.currentAccessToken() == nil {
            println("Please Log in")
        }
        else
        {
            self.downloadAllData()
            //self.performSegueWithIdentifier(<#identifier: String?#>, sender: <#AnyObject?#>)
        }
    }
    
    
    func onProfileUpdated(notification: NSNotification){
        println("Profile was updated")
        if FBSDKAccessToken.currentAccessToken() == nil {
            println("User not logged in")
        }
        else{
            self.downloadAllData()
        }
    }
    
    func downloadAllData()
    {
        var fullname : String! = FBSDKProfile.currentProfile().name
        println("Logged in user is  \(fullname)")
        uf.name = fullname
        self.getAllFriendsData(afterStr: "")
        println("Finished adding all friends")
        
        
    }

    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if error == nil {
            println("Log in complete")
        }
        else{
            println(error.localizedDescription)
        }
    }
    
    func getAllFriendsData(afterStr afts : String = ""){
        
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
                            println("Added "+name!)

                        }
                    }
                    
                    var pagingDict : NSDictionary? = resultDict.objectForKey("paging") as? NSDictionary
                    var cursorsDict : NSDictionary? = pagingDict?.objectForKey("cursors") as? NSDictionary
                    if let afterS: AnyObject  = cursorsDict?.objectForKey("after"){
                        self.getAllFriendsData(afterStr: "\(afterS as! String)")
                    }
                
                    
                }
            })
        
        
        
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                if (error == nil){
                    println(result)
                }
            })
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        println("User logged out")
    }


}

