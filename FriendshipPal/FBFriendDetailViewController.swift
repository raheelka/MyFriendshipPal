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
    
    @IBOutlet weak var dislikeButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    //Note this will only have 100 at max. Change query to get more if needed
    var allUsers : [PFObject] = []
    var userInFocus : PFObject?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.getNearByUsers()
        
    }
    
    func setProfilePic(){
        
//        profilePic.image = userProfile?.image
        
    }
    
    func getNearByUsers(){
            let userQuery = PFQuery(className: "_User")
            userQuery.findObjectsInBackgroundWithBlock({(objects : [PFObject]?, error : NSError?) in
                self.allUsers = objects!
                self.displayUserInFocus()
            })
    }
    
    func displayUserInFocus(){
        self.userInFocus = self.allUsers[1]
        let profilePicUrl : String = self.userInFocus?.valueForKey("profile_pic_url") as! String
        self.setImageFromRemoteLocation(profilePicUrl, imageView: profilePic)
        
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
    
    
    func setButtonAbility()
    {
//        if !User.currentUser.liked_friends.contains(userProfile!)
//        {
//            enableLikeButton()
//        }
//        else
//        {
//            enableDislikeButton()
//        }
    }
    
    
    @IBAction func likeFriend(sender: UIButton) {
        
//        if !User.currentUser.liked_friends.contains(self.userProfile!){
//            User.currentUser.me_likey(userProfile!)
//            setButtonAbility()
//        }
        
    }
    
    @IBAction func unlikeFriend(sender: UIButton) {
//        if User.currentUser.liked_friends.contains(self.userProfile!){
//            User.currentUser.liked_friends.removeObject(self.userProfile!)
//            setButtonAbility()
//        }
    }



}
