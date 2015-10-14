//
//  FBFriendDetailViewController.swift
//  FriendshipPal
//
//  Created by Raheel Kazi on 9/1/15.
//  Copyright (c) 2015 Raheel Kazi. All rights reserved.
//

import UIKit
import Parse
import Koloda


class FBFriendDetailViewController: UIViewController {

    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var name_userInFocus: UILabel!
    
    @IBOutlet weak var dislikeButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    //We need to have an info button showing more pics of the users
    
    //Note this will only have 100 at max. Change query to get more if needed
    var allUsers : [PFUser] = []
    
    var userInFocus : PFUser?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.getNearByUsers()
        
    }
    
    
    func getNearByUsers(){
        // Get all those users who are
        // 1. Not Disliked
        // 2. Not Present in already liked list
        // 3. Are near by 50 miles for now
        
        let relation_query = PFQuery(className: "Relations")
        relation_query.whereKey("user", equalTo: PFUser.currentUser()!)
        
        
        var liked_friends : [PFUser] = []
        var disliked_friends : [PFUser] = []
        
        
        relation_query.getFirstObjectInBackgroundWithBlock {
            (user_relation: PFObject?, error: NSError?) -> Void in
            if error != nil {
                print("Failed to get user from relation class")
            }
            else if let user_relation = user_relation {
                liked_friends = user_relation["liked_friends"] as! [PFUser]
                disliked_friends = user_relation["disliked_friends"] as! [PFUser]
            }
        }
    
        //This logic is messed up. Need to rethink on how to do this
        
        let excludeLikedDislikedUserQuery = PFQuery(className: "Relations")
        excludeLikedDislikedUserQuery.whereKey("user", notContainedIn: liked_friends + disliked_friends)
        excludeLikedDislikedUserQuery.whereKey("user", notEqualTo: PFUser.currentUser()!)
    
        excludeLikedDislikedUserQuery.findObjectsInBackgroundWithBlock{
            (objects : [PFObject]?, error : NSError?) -> Void in
            if(error != nil){
                print("Failed to execute query excludeLikedDisLikedUser")
            }
            else if let objects = objects{
                for object in objects{
                    self.allUsers.append(object["user"] as! PFUser)
                }
                self.displayUserInFocus()
            }
            
        }
        
        
        
    }
    
    func displayUserInFocus(){
        if (!self.allUsers.isEmpty){
            self.userInFocus = self.allUsers[0]
            
            userInFocus?.fetchInBackgroundWithBlock {
                (object : PFObject?, error : NSError?) -> Void in
                
                let profilePicUrl : String = object?.valueForKey("profile_pic_url") as! String
                self.setImageFromRemoteLocation(profilePicUrl, imageView: self.profilePic)
                self.name_userInFocus.text = self.userInFocus?.valueForKey("name") as? String
            
            }

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
            
            let relation_query = PFQuery(className: "Relations")
            relation_query.whereKey("user", equalTo: user)
            
            var liked_friends : [PFUser] = []
            
            relation_query.getFirstObjectInBackgroundWithBlock {
                (user_relation: PFObject?, error: NSError?) -> Void in
                if error != nil {
                    print("In Like a Friend, Failed to get user")
                }
                else if let user_relation = user_relation {
                    liked_friends = user_relation.valueForKey("liked_friends") as! [PFUser]
                    liked_friends.append(self.userInFocus!)
                    
                    user_relation["liked_friends"] = liked_friends
                    user_relation.saveInBackground()
                    
                    self.allUsers.removeAtIndex(0)
                    self.displayUserInFocus()
                }
                
            }
            
            //TODO... In the background check if current user is present in the userInFocus's liked friends
            // If yes,  then add him to both of our mutually liked tables
        }
        
    }
    
    @IBAction func unlikeFriend(sender: UIButton) {
        
        if (!self.allUsers.isEmpty){
            
            let user : PFUser = PFUser.currentUser()!
            
            let relation_query = PFQuery(className: "Relations")
            relation_query.whereKey("user", equalTo: user)
            
            var disliked_friends : [PFUser] = []
            
            relation_query.getFirstObjectInBackgroundWithBlock {
                (user_relation: PFObject?, error: NSError?) -> Void in
                if error != nil {
                    print("In DisLike a Friend, Failed to get user")
                }
                else if let user_relation = user_relation {
                    disliked_friends = user_relation.valueForKey("disliked_friends") as! [PFUser]
                    disliked_friends.append(self.userInFocus!)
                    
                    user_relation["disliked_friends"] = disliked_friends
                    user_relation.saveInBackground()
                    
                    self.allUsers.removeAtIndex(0)
                    self.displayUserInFocus()
                }
                
            }
        }

        
    }



}
