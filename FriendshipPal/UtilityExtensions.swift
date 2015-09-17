//
//  UtilityExtensions.swift
//  FriendshipPal
//
//  Created by Raheel Kazi on 9/16/15.
//  Copyright (c) 2015 Raheel Kazi. All rights reserved.
//

import Foundation


extension String {
    
    func contains(find: String) -> Bool{
        return self.rangeOfString(find) != nil
    }
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