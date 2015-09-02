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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setProfilePic()
        // Do any additional setup after loading the view.
    }
    
    func setProfilePic(){
        profilePic.image = userProfile?.image
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
