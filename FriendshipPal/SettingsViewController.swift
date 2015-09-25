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
            FBSDKLoginManager().logOut()
            _ = UIStoryboard(name: "Main", bundle: nil)
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
        let task = session.dataTaskWithURL(User.currentUser.profilePic) { (data, response, error) -> Void in
            
            let img = UIImage(data: data!)
            
            dispatch_async(dispatch_get_main_queue(), {
               self.profilePic.image = img
            })
        }
        task.resume()
    }
    
    func setUserLabel(){
        currentUserName.text = User.currentUser.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
