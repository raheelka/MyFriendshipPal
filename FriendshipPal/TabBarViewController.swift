//
//  TabBarViewController.swift
//  FriendshipPal
//
//  Created by Raheel Kazi on 8/30/15.
//  Copyright (c) 2015 Raheel Kazi. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    var uf : User?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        var friendListView = self.viewControllers![0] as! DetailViewController
        friendListView.userProfile = uf!
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        var friendListView = self.viewControllers![0] as! DetailViewController
        friendListView.userProfile = uf!
    }
    

}
