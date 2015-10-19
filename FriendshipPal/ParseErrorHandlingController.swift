//
//  ParseErrorHandlingController.swift
//  FriendshipPal
//
//  Created by Raheel Kazi on 10/17/15.
//  Copyright © 2015 Raheel Kazi. All rights reserved.
//

import Foundation
import Parse
import UIKit


class ParseErrorHandlingController {
    
    class func handleInvalidSessionTokenError(){
        let alert = UIAlertController(title: "Please log in again!", message:"Your session has timed out. Please log in again", preferredStyle: .Alert)
        let action = UIAlertAction(title: "Logout Now", style: .Default) { _ in
            PFUser.logOut()
        }
        alert.addAction(action)
    }
    
    class func handleParseError(error: NSError) {
        if error.domain != PFParseErrorDomain {
            return
        }
        
        switch (error.code) {
        case 209:
            handleInvalidSessionTokenError()
        default:
            print("Could not handle error")
        }
        
        
    }
    
}
