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
    
    @IBOutlet weak var likeDislikeLabel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonLabel()
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
    
    func setButtonLabel(){
        if !User.currentUser.liked_friends.contains(userProfile!)
        {
            likeDislikeLabel.setTitle("Like", forState: UIControlState.Normal)
        }
        else
        {
            likeDislikeLabel.setTitle("Unlike", forState: UIControlState.Normal)
        }
        
    }
    
    func toggleButtonLabel(){
        if likeDislikeLabel.titleLabel?.text == "Like"
        {
            likeDislikeLabel.setTitle("Unlike", forState: UIControlState.Normal)
        }
        else
        {
            likeDislikeLabel.setTitle("Like", forState: UIControlState.Normal)
        }
    }
    
    @IBAction func addFriendToLikedList(sender: AnyObject) {
        if (likeDislikeLabel.titleLabel?.text == "Like")
        {
            User.currentUser.me_likey(userProfile!)
        }
        else
        {
            User.currentUser.liked_friends.removeObject(self.userProfile!)
        }
        
        self.toggleButtonLabel()
        
    }


}
