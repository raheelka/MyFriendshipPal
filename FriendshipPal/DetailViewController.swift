//
//  DetailViewController.swift
//  FriendshipPal
//
//  Created by Raheel Kazi on 8/24/15.
//  Copyright (c) 2015 Raheel Kazi. All rights reserved.
//

import UIKit
import CoreImage

class DetailViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {

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
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userProfile.friends.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CellIdentifier", forIndexPath: indexPath) as! UITableViewCell
        
        //1
        if cell.accessoryView == nil {
            let indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
            cell.accessoryView = indicator
        }
        let indicator = cell.accessoryView as! UIActivityIndicatorView
        
        //2
        let friend = self.userProfile.friends[indexPath.row]
        
        //3
        cell.textLabel?.text = friend.name
        cell.imageView?.image = friend.image
        
        //4
        switch (friend.profilePicState){
        case .Downloaded:
            indicator.stopAnimating()
        case .Failed:
            indicator.stopAnimating()
            cell.textLabel?.text = "Failed to load"
        case .New:
            indicator.startAnimating()
            self.startOperationsForPhotoRecord(friend,indexPath:indexPath)
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
        //1
        if let downloadOperation = pendingOperations.downloadsInProgress[indexPath] {
            return
        }
        
        //2
        let downloader = ImageDownloader(user_photoRecord: friend)
        //3
        downloader.completionBlock = {
            if downloader.cancelled {
                return
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.pendingOperations.downloadsInProgress.removeValueForKey(indexPath)
                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            })
        }
        //4
        pendingOperations.downloadsInProgress[indexPath] = downloader
        //5
        pendingOperations.downloadQueue.addOperation(downloader)
    }
    
    
    



}
