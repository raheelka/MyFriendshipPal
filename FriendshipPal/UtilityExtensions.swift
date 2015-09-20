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

extension UIImage {
    func resize(scale:CGFloat)-> UIImage {
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: size.width*scale, height: size.height*scale)))
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContext(imageView.bounds.size)
        imageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    func resizeToWidth(width:CGFloat)-> UIImage {
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContext(imageView.bounds.size)
        imageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    
    func imageResize (image:UIImage, thumbnail : Bool)-> UIImage{
        
        var sizeChange = CGSizeMake(500, 500)
        
        if (thumbnail){
            sizeChange = CGSizeMake(150, 150)
        }
        
        let hasAlpha = true
        let scale: CGFloat = 0.0 // Use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        image.drawInRect(CGRect(origin: CGPointZero, size: sizeChange))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage
    }
    
}


