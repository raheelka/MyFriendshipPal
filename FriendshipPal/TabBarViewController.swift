//
//  TabBarViewController.swift
//  FriendshipPal
//
//  Created by Raheel Kazi on 8/30/15.
//  Copyright (c) 2015 Raheel Kazi. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
