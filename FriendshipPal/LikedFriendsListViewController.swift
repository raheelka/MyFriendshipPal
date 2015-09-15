//
//  LikedFriendsListViewController.swift
//  FriendshipPal
//
//  Created by Raheel Kazi on 9/3/15.
//  Copyright (c) 2015 Raheel Kazi. All rights reserved.
//

import UIKit

class LikedFriendsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var likedFriendsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        self.likedFriendsTable.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return User.currentUser.liked_friends.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("likedfriendCell", forIndexPath: indexPath) as! UITableViewCell
        
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        let friend = User.currentUser.liked_friends[indexPath.row]
        
        
        cell.textLabel?.text = friend.name
        cell.imageView?.image = friend.image
        
        
        return cell
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
