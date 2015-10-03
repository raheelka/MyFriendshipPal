//
//  DetailViewController.swift
//  FriendshipPal
//
//  Created by Raheel Kazi on 8/24/15.
//  Copyright (c) 2015 Raheel Kazi. All rights reserved.
//

import UIKit
import CoreImage

class FBFriendListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    
    //====================================================================================
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("friendCell", forIndexPath: indexPath)
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
    }
    
    
    //========================================================================================================
    
//    var searchActive : Bool = false
//    var filteredFriendList : [User] = []
//    
//    let pendingOperations = PendingOperations()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//    }
//    
//    override func viewDidAppear(animated: Bool) {
//        self.setSearchActivity()
//        filteredFriendList=self.calculateFilteredFriendList(searchBar.text!)
//        if (searchActive){
//            self.tableView.reloadData()
//        }
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    func setSearchActivity(){
//        if (searchBar.text != "") {
//            searchActive = true
//        }
//        else {
//            searchActive = false
//        }
//    }
//    
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if(searchActive) {
//            return filteredFriendList.count
//        }
//        else {
//            return User.currentUser.friends.count
//        }
//    }
//    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "showFBFriend"{
//            if let destination = segue.destinationViewController as? FBFriendDetailViewController {
//            if let userIndexPath = self.tableView.indexPathForSelectedRow{
//                if (searchActive){
//                        destination.userProfile = filteredFriendList[userIndexPath.row]
//                    }
//                else{
//                        destination.userProfile = User.currentUser.friends[userIndexPath.row]
//                    }
//                }
//            }
//        
//        }
//    }
//    
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("friendCell", forIndexPath: indexPath) 
//        
//        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
//        var friend = User()
//        
//        if (searchActive){
//            friend = filteredFriendList[indexPath.row]
//        }
//        else{
//            friend = User.currentUser.friends[indexPath.row]
//        }
//        
//        cell.roundCell()
//
//        cell.textLabel?.text = friend.name
//
//        cell.imageView?.image = friend.image
//        
//
//        switch (friend.profilePicState){
//        case .Failed:
//            cell.textLabel?.text = "Failed to load"
//        case .New:
//            self.startOperationsForPhotoRecord(friend,indexPath:indexPath)
//        default:
//            break
//        }
//        return cell
//    }
//    
//    
//    
//    func startOperationsForPhotoRecord(friend: User, indexPath: NSIndexPath){
//        switch (friend.profilePicState) {
//        case .New:
//            startDownloadForRecord(friend, indexPath: indexPath)
//        default:
//            NSLog("do nothing")
//        }
//    }
//
//    func startDownloadForRecord(friend: User, indexPath: NSIndexPath){
//        if let _ = pendingOperations.downloadsInProgress[indexPath] {
//            return
//        }
//        let downloader = ImageDownloader(user_photoRecord: friend)
//        downloader.completionBlock = {
//            if downloader.cancelled {
//                return
//            }
//            dispatch_async(dispatch_get_main_queue(), {
//                self.pendingOperations.downloadsInProgress.removeValueForKey(indexPath)
//                
//                if (indexPath.row < self.tableView.numberOfRowsInSection(0)){
//                    self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
//                }
//                
//            })
//        }
//        pendingOperations.downloadsInProgress[indexPath] = downloader
//        pendingOperations.downloadQueue.addOperation(downloader)
//    }
//    
//    func calculateFilteredFriendList(searchText : String) -> [User]{
//        if (searchActive){
//            let allFriends:[User] = User.currentUser.friends
//            filteredFriendList = allFriends.filter( { (friend: User) -> Bool in
//                return friend.name.contains(searchText)
//            })
//            return filteredFriendList
//        }
//        return []
//    }
//    
//    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
//        self.setSearchActivity()
//        self.view.endEditing(true)
//        
//    }
//    
//    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
//        self.setSearchActivity()
//        self.view.endEditing(true)
//    }
//    
//    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
//        self.setSearchActivity()
//        filteredFriendList = calculateFilteredFriendList(searchText)
//        self.tableView.reloadData()
//        
//    }
    



}
