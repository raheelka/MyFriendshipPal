//
//  FBFriendDetailViewController.swift
//  FriendshipPal
//
//  Created by Raheel Kazi on 9/1/15.
//  Copyright (c) 2015 Raheel Kazi. All rights reserved.
//

import UIKit
import Parse


class FBFriendDetailViewController: UIViewController {

    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var name_userInFocus: UILabel!
    
    @IBOutlet weak var dislikeButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    //Note this will only have 100 at max. Change query to get more if needed
    var allUsers : [PFObject] = []
    
    var userInFocus : PFObject?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.getNearByUsers()
        
    }
    
    
    func getNearByUsers(){
        // Get all those users who are
        // 1. Not Disliked
        // 2. Not Present in already liked list
        // 3. Are near by 50 miles for now
        
            let userQuery = PFQuery(className: "_User")
            userQuery.findObjectsInBackgroundWithBlock({(objects : [PFObject]?, error : NSError?) in
                self.allUsers = objects!
                self.displayUserInFocus()
            })
    }
    
    func displayUserInFocus(){
        if (!self.allUsers.isEmpty){
            self.userInFocus = self.allUsers[0]
            let profilePicUrl : String = self.userInFocus?.valueForKey("profile_pic_url") as! String
            self.setImageFromRemoteLocation(profilePicUrl, imageView: profilePic)
            name_userInFocus.text = self.userInFocus?.valueForKey("name") as? String
        }
        else
        {
            //Display a dummy image and grey out the like buttons
            //Display no more users to like and handle that case
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func enableLikeButton(){
        likeButton.enabled = true
        likeButton.alpha = 1
        dislikeButton.enabled = false
        dislikeButton.alpha = 0.5
    }
    
    func enableDislikeButton(){
        likeButton.enabled = false
        likeButton.alpha = 0.5
        dislikeButton.enabled = true
        dislikeButton.alpha = 1
    }
    
    
    
    @IBAction func likeFriend(sender: UIButton) {
        
        if (!self.allUsers.isEmpty){
            self.allUsers.removeAtIndex(0)
            self.displayUserInFocus()
        
        //Add to users liked list
        }
        
    }
    
    @IBAction func unlikeFriend(sender: UIButton) {
        
        if (!self.allUsers.isEmpty){
            self.allUsers.removeAtIndex(0)
            self.displayUserInFocus()
            
            //Add to users disliked list
        }
        
    }



}
