//
//  FBFriendDetailViewController.swift
//  FriendshipPal
//
//  Created by Raheel Kazi on 9/1/15.
//  Copyright (c) 2015 Raheel Kazi. All rights reserved.
//

import UIKit


class FBFriendDetailViewController: UIViewController {

    @IBOutlet weak var profilePic: UIImageView!
    var userProfile : User?
    
    @IBOutlet weak var dislikeButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonAbility()
        setProfilePic()
        // Do any additional setup after loading the view.
    }
    
    func setProfilePic(){
        profilePic.image = userProfile?.image
        
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
        if !User.currentUser.liked_friends.contains(userProfile!)
        {
            enableLikeButton()
        }
        else
        {
            enableDislikeButton()
        }
    }
    
    
    @IBAction func likeFriend(sender: UIButton) {
        
        if !User.currentUser.liked_friends.contains(self.userProfile!){
            User.currentUser.me_likey(userProfile!)
            setButtonAbility()
        }
        
    }
    
    @IBAction func unlikeFriend(sender: UIButton) {
        if User.currentUser.liked_friends.contains(self.userProfile!){
            User.currentUser.liked_friends.removeObject(self.userProfile!)
            setButtonAbility()
        }
    }



}
