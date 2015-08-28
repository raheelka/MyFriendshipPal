//
//  DetailViewController.swift
//  FriendshipPal
//
//  Created by Raheel Kazi on 8/24/15.
//  Copyright (c) 2015 Raheel Kazi. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var userProfile : User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userProfile!.friends.count
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("CELL") as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "CELL")
        }
        
        cell!.textLabel!.text = "\(userProfile!.friends[indexPath.row].name)"
        cell!.imageView!.image = userProfile!.friends[indexPath.row].profilePic
        return cell!
    }
    
    
    



}
