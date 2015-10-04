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
    
    //We need to have an info button showing more pics of the users
    
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

        let currentUserId = PFUser.currentUser()?.valueForKey("user_id") as? String
        let liked_friends = (PFUser.currentUser()?.valueForKey("liked_friends") as? [String])!
        let disliked_friends = (PFUser.currentUser()?.valueForKey("disliked_friends") as? [String])!
    
        let excludeLikedDislikedUserQuery = PFQuery(className: "_User")
        excludeLikedDislikedUserQuery.whereKey("user_id", notContainedIn: liked_friends + disliked_friends)
        excludeLikedDislikedUserQuery.whereKey("user_id", notEqualTo: currentUserId!)
    
        excludeLikedDislikedUserQuery.findObjectsInBackgroundWithBlock({(objects : [PFObject]?, error : NSError?) in
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
            
            let user : PFUser = PFUser.currentUser()!
            
            var liked_friends : [String] = user["liked_friends"] as! [String]
            liked_friends.append(userInFocus?.valueForKey("user_id") as! String)
            user["liked_friends"] = liked_friends
            user.saveInBackground()
            self.allUsers.removeAtIndex(0)
            self.displayUserInFocus()
        
        //Add to users liked list
        }
        
    }
    
    @IBAction func unlikeFriend(sender: UIButton) {
        
        if (!self.allUsers.isEmpty){
            
            let user : PFUser = PFUser.currentUser()!
            
            var disliked_friends : [String] = user["disliked_friends"] as! [String]
            disliked_friends.append(userInFocus?.valueForKey("user_id") as! String)
            user["disliked_friends"] = disliked_friends
            user.saveInBackground()
            self.allUsers.removeAtIndex(0)
            self.displayUserInFocus()
            
            //Add to users disliked list
        }
        
    }



}
