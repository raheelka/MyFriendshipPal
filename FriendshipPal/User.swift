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
    var profilePic : String?
}

class User {
    
    var friends : [User] = []
    var name : String!
    var profilePic : String?
    
    init(){}
    
    init(name : String, profilePic : String)
    {
        self.name = name
        self.profilePic = profilePic
    }
    
    
    func addFriend(name : String, profilePic : String)
    {
        var f : User = User(name: name, profilePic: profilePic)
        friends.append(f)
    }
    
    
}
