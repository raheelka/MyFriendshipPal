//
//  User.swift
//  FriendshipPal
//
//  Created by Raheel Kazi on 8/26/15.
//  Copyright (c) 2015 Raheel Kazi. All rights reserved.
//

import Foundation
import UIKit


struct Person {
    var name : String!
    var profilePic : UIImage?
}

class User {
    
    var friends : [User] = []
    var name : String!
    var profilePic : UIImage?
    
    init(){}
    
    init(name : String, profilePic : UIImage)
    {
        self.name = name
        self.profilePic = profilePic
    }
    
    
    func addFriend(name : String, profilePic : UIImage)
    {
        var f : User = User(name: name, profilePic: profilePic)
        friends.append(f)
    }
    
    
}
