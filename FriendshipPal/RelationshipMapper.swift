//
//  RelationshipMapper.swift
//  FriendshipPal
//
//  Created by Raheel Kazi on 10/17/15.
//  Copyright © 2015 Raheel Kazi. All rights reserved.
//

import Foundation
import Parse


class RelationshipMapper
{
    func likeAFriend(user : PFUser, friend : PFUser)
    {
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
                liked_friends.append(friend)
                
                user_relation["liked_friends"] = liked_friends
                
                self.updateFriendMutualLikes(friend)
                
                user_relation.saveInBackground()
            }
            
        }
    }
    
    
    func dislikeAFriend(user : PFUser, friend : PFUser)
    {
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
                disliked_friends.append(friend)
                
                user_relation["disliked_friends"] = disliked_friends
                user_relation.saveInBackground()
            }
            
        }

    }
    
    
    func updateCurrentUserMutualFriend(friend : PFUser){
        
        var mutually_liked_friends : [PFUser] = []
        
        let currentUser : PFUser = PFUser.currentUser()!
        let relation_query = PFQuery(className: "Relations")
        relation_query.whereKey("user", equalTo: currentUser)
        
        relation_query.getFirstObjectInBackgroundWithBlock {
            (user_relation: PFObject?, error: NSError?) -> Void in
            if error != nil {
                print("In updateCurrentUserMutualFriend a Friend, Failed to get user")
            }
            else if let user_relation = user_relation {
                mutually_liked_friends = user_relation.valueForKey("mutually_liked_friends") as! [PFUser]
                mutually_liked_friends.append(friend)
                user_relation["mutually_liked_friends"] = mutually_liked_friends
                user_relation.saveInBackground()
            }
            
        }
        
        
    }
    
    
    func updateFriendMutualLikes(friend : PFUser){
        
        var liked_friends : [PFUser] = []
        var userInFocus_mutually_liked_friends : [PFUser] = []
        
        let currentUser : PFUser = PFUser.currentUser()!
        let relation_query = PFQuery(className: "Relations")
        relation_query.whereKey("user", equalTo: friend)
        
        relation_query.getFirstObjectInBackgroundWithBlock {
            (user_relation: PFObject?, error: NSError?) -> Void in
            if error != nil {
                print("In updateMutualLikes a Friend, Failed to get user")
            }
            else if let user_relation = user_relation {
                liked_friends = user_relation.valueForKey("liked_friends") as! [PFUser]
                if liked_friends.contains(currentUser){
                    userInFocus_mutually_liked_friends = user_relation.valueForKey("mutually_liked_friends") as! [PFUser]
                    userInFocus_mutually_liked_friends.append(currentUser)
                    user_relation["mutually_liked_friends"] = userInFocus_mutually_liked_friends
                    user_relation.saveInBackground()
                    
                    self.updateCurrentUserMutualFriend(friend)
                    
                    print ("Found mutual like")
                }
                else{
                    print("No mutual like yet")
                }
            }
            
        }
        
    }
    
    
}
