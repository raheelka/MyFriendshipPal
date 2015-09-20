//
//  UtilityExtensions.swift
//  FriendshipPal
//
//  Created by Raheel Kazi on 9/16/15.
//  Copyright (c) 2015 Raheel Kazi. All rights reserved.
//

import Foundation
import UIKit


extension String {
    
    func contains(find: String) -> Bool{
        return self.rangeOfString(find) != nil
    }
}


extension Array {
    mutating func removeObject<U: Equatable>(object: U) -> Bool {
        for (idx, objectToCompare) in self.enumerate() {
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

extension UITableViewCell{
    func roundCell() -> CALayer{
        let cellImageLayer: CALayer?  = self.imageView!.layer
        cellImageLayer!.cornerRadius = 20
        cellImageLayer!.masksToBounds = true
        return cellImageLayer!
    }
}