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
    
    @IBOutlet weak var titleBar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setProfilePic()
        // Do any additional setup after loading the view.
    }
    
    func setProfilePic(){
        profilePic.image = userProfile?.image
        titleBar.title = userProfile?.name
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addFriendToLikedList(sender: AnyObject) {
        User.currentUser.me_likey(userProfile!)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
