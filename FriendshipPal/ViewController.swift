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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createLoginButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println(segue.identifier!)
        if(segue.identifier == "detailView") {
            var detailViewController = segue.destinationViewController as! DetailViewController
            //detailViewController.receiver = FBSDKProfile.currentProfile().name
        }
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
    }
    
    
    func onProfileUpdated(notification: NSNotification){
        println("Profile was updated")
        if FBSDKAccessToken.currentAccessToken() == nil {
            println("User not logged in")
        }
        else{
            var firstName : String! = FBSDKProfile.currentProfile().name
            println("Logged in user is  \(firstName)")
            getAllFriendsData(afterStr: "")
            
        }
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

        
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            FBSDKGraphRequest(graphPath: "me/taggable_friends", parameters: ["fields":"name", "before" : "", "after" : afts, "next" : ""]).startWithCompletionHandler({ (connection, result, error) -> Void in
                if (error == nil){
                    var resultDict = result as! NSDictionary
                    var data : NSArray = resultDict.objectForKey("data") as! NSArray
                    if data.count > 0 {
                        for i in 0...data.count-1 {
                            let valueDict : NSDictionary = data[i] as! NSDictionary
                            let name = valueDict.objectForKey("name") as! String
                            println("the name is \(name)")
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

