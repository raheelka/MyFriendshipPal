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
        if FBSDKAccessToken.currentAccessToken() != nil {
            PFUser.logOut()
            let loginViewController = self.storyboard!.instantiateViewControllerWithIdentifier("loginViewController") as! LoginViewController
            presentViewController(loginViewController, animated: true, completion: nil)
            
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setProfilePic()
        setUserLabel()
        

        // Do any additional setup after loading the view.
    }
    
    func setProfilePic(){
        let session = NSURLSession.sharedSession()
        let current_user_profile_pic = NSURL(string: PFUser.currentUser()?.valueForKey("profile_pic_url") as! String)
        let task = session.dataTaskWithURL(current_user_profile_pic!) { (data, response, error) -> Void in
            
            let img = UIImage(data: data!)
            
            dispatch_async(dispatch_get_main_queue(), {
               self.profilePic.image = img
            })
        }
        task.resume()
    }
    
    func setUserLabel(){
        print(PFUser.currentUser()?.valueForKey("name") as? String)
        currentUserName.text = PFUser.currentUser()?.valueForKey("name") as? String
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
