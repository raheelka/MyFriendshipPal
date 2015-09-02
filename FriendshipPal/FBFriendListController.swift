//
//  DetailViewController.swift
//  FriendshipPal
//
//  Created by Raheel Kazi on 8/24/15.
//  Copyright (c) 2015 Raheel Kazi. All rights reserved.
//

import UIKit
import CoreImage

class FBFriendListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var userProfile : User = User()
    let pendingOperations = PendingOperations()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userProfile.friends.count
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showFBFriend"{
            if let destination = segue.destinationViewController as? FBFriendDetailViewController {
            if let userIndexPath = self.tableView.indexPathForSelectedRow(){
                    destination.userProfile = self.userProfile.friends[userIndexPath.row]
                }
            }
        
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("friendCell", forIndexPath: indexPath) as! UITableViewCell
        
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator

        let friend = self.userProfile.friends[indexPath.row]
        

        cell.textLabel?.text = friend.name
        cell.imageView?.image = friend.image
        

        switch (friend.profilePicState){
        case .Failed:
            cell.textLabel?.text = "Failed to load"
        case .New:
            self.startOperationsForPhotoRecord(friend,indexPath:indexPath)
        default:
            break
            //Do Nothing
        }
        
        return cell
    }
    
    
    
    func startOperationsForPhotoRecord(friend: User, indexPath: NSIndexPath){
        switch (friend.profilePicState) {
        case .New:
            startDownloadForRecord(friend, indexPath: indexPath)
        default:
            NSLog("do nothing")
        }
    }

    func startDownloadForRecord(friend: User, indexPath: NSIndexPath){

        if let downloadOperation = pendingOperations.downloadsInProgress[indexPath] {
            return
        }
        

        let downloader = ImageDownloader(user_photoRecord: friend)

        downloader.completionBlock = {
            if downloader.cancelled {
                return
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.pendingOperations.downloadsInProgress.removeValueForKey(indexPath)
                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            })
        }

        pendingOperations.downloadsInProgress[indexPath] = downloader

        pendingOperations.downloadQueue.addOperation(downloader)
    }
    
    
    



}
