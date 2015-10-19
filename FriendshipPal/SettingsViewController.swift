//
//  SettingsViewController.swift
//  FriendshipPal
//
//  Created by Raheel Kazi on 8/31/15.
//  Copyright (c) 2015 Raheel Kazi. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var currentUserName: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    
    
    @IBAction func logoutUser(sender: AnyObject) {
        if PFUser.currentUser()?.sessionToken != nil {
            PFUser.logOut()
            self.presentLoginScreen()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setProfilePic()
        setUserLabel()
    }
    
    func presentLoginScreen()
    {
        let loginVC = self.storyboard!.instantiateViewControllerWithIdentifier("loginViewController") as! LoginViewController
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.rootViewController = loginVC
    }
    
    func setProfilePic(){
        let profilePicUrl : String = PFUser.currentUser()?.valueForKey("profile_pic_url") as! String
        self.setImageFromRemoteLocation(profilePicUrl, imageView: profilePic)
    
    }
    
    func setUserLabel(){
        currentUserName.text = PFUser.currentUser()?.valueForKey("name") as? String
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
