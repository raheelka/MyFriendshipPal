//
//  User.swift
//  FriendshipPal
//
//  Created by Raheel Kazi on 8/26/15.
//  Copyright (c) 2015 Raheel Kazi. All rights reserved.
//

import Foundation
import UIKit

// This enum contains all the possible states a photo record can be in
enum PhotoRecordState {
    case New, Downloaded, Failed
}

extension Array {
    mutating func removeObject<U: Equatable>(object: U) -> Bool {
        for (idx, objectToCompare) in enumerate(self) {
            if let to = objectToCompare as? U {
                if object == to {
                    self.removeAtIndex(idx)
                    return true
                }
            }
        }
        return false
    }
}

func ==(lhs: User, rhs: User) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

class User : Hashable, Printable{
    static let currentUser = User()
    
    var friends : [User] = []
    var liked_friends : [User] = []
    var name : String
    var profilePic : NSURL
    var profilePicState = PhotoRecordState.New
    var image = UIImage(named: "Placeholder")
    
    var description: String {
        return "Name: \(name)"
    }
    
    var hashValue: Int {
        return self.name.hashValue
    }

    
    init()
    {
        self.name = "Unknown"
        self.profilePic = NSURL()
    }
    
    init(name : String, profilePic : NSURL)
    {
        self.name = name
        self.profilePic = profilePic
    }
    
    
    func addFriend(name : String, profilePic : NSURL)
    {
        var f : User = User(name: name, profilePic: profilePic)
        friends.append(f)
    }
    
    func me_likey(friend : User){
        liked_friends.append(friend)
    }
    
    
    
}

class PendingOperations {
    lazy var downloadsInProgress = [NSIndexPath:NSOperation]()
    lazy var downloadQueue:NSOperationQueue = {
        var queue = NSOperationQueue()
        queue.name = "Download queue"
        queue.maxConcurrentOperationCount = 1
        return queue
        }()
}


class ImageDownloader: NSOperation {

    let user_photoRecord: User
    

    init(user_photoRecord: User) {
        self.user_photoRecord = user_photoRecord
    }
    

    override func main() {
        //4
        if self.cancelled {
            return
        }

        let imageData = NSData(contentsOfURL:self.user_photoRecord.profilePic)
        

        if self.cancelled {
            return
        }
        

        if imageData?.length > 0 {
            self.user_photoRecord.image = UIImage(data:imageData!)!
            self.user_photoRecord.profilePicState = .Downloaded
        }
        else
        {
            self.user_photoRecord.profilePicState = .Failed
            self.user_photoRecord.image = UIImage(named: "Failed")!
        }
    }
}
