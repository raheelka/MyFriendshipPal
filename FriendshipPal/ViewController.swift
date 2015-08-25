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
        // Do any additional setup after loading the view, typically from a nib.
        
        if FBSDKAccessToken.currentAccessToken() == nil {
            println("Not logged in")
        }
        else{
            println("Logged in")
        }
        
        var loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile","email","user_friends"]
        loginButton.center = self.view.center
        loginButton.delegate = self
        self.view.addSubview(loginButton)
        
        FBSDKProfile.enableUpdatesOnAccessTokenChange(true)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onProfileUpdated:", name:FBSDKProfileDidChangeNotification, object: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onProfileUpdated(notification: NSNotification){
        println("Profile was updated")
        if FBSDKAccessToken.currentAccessToken() == nil {
            println("Not logged in")
        }
        else{
            var firstName : String! = FBSDKProfile.currentProfile().name
            println("My Name is  \(firstName)")
            //performSegueWithIdentifier("detailView", sender: self)
            
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
    
    func getAllFriendsData() -> AnyObject{
        var request = FBSDKGraphRequest(graphPath:"/me/taggable_friends", parameters: nil);
        request.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
            if error == nil {
                    println("Friends are : \(result)")
                } else {
                            println("Error Getting Friends \(error)");
                        }
                    }
        
        return request
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        println("User logged out")
    }


}

