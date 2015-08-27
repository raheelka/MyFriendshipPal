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
    
    var friends : [Person] = []
    var name : String = ""
    
    func addFriend(name : String, profilePic : UIImage)
    {
        var f : Person = Person(name: name, profilePic: profilePic)
        friends.append(f)
    }
    
    
}
