//
//  LikedFriendsListViewController.swift
//  FriendshipPal
//
//  Created by Raheel Kazi on 9/3/15.
//  Copyright (c) 2015 Raheel Kazi. All rights reserved.
//

import UIKit

class LikedFriendsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var likedFriendsTable: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchActive : Bool = false
    
    
    var filteredFriendList:[User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    override func viewDidAppear(animated: Bool) {
        self.setSearchActivity()
        filteredFriendList=self.calculateFilteredFriendList(searchBar.text)
        self.likedFriendsTable.reloadData()
    }
    
    func setSearchActivity(){
        if (searchBar.text != ""){
            searchActive = true
        }
        else {
            searchActive = false
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive)
        {
            return filteredFriendList.count
        }
        else
        {
            return User.currentUser.liked_friends.count
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showLikedFriend"{
            if let destination = segue.destinationViewController as? LikedFriendDetailViewController {
                
                if let userIndexPath = self.likedFriendsTable.indexPathForSelectedRow(){
                    if(searchActive){
                        destination.userProfile = filteredFriendList[userIndexPath.row]
                    }
                    else{
                        destination.userProfile = User.currentUser.liked_friends[userIndexPath.row]
                    }
                }
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("likedfriendCell", forIndexPath: indexPath) as! UITableViewCell
        
        
        var friend : User!
        if(searchActive){
            friend = filteredFriendList[indexPath.row]
        }
        else{
            friend = User.currentUser.liked_friends[indexPath.row]
        }
        
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        var cellImageLayer: CALayer = cell.roundCell()
        cell.textLabel?.text = friend.name
        cell.imageView?.image = friend.image
        
        
        return cell
    }
    
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        setSearchActivity()
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        setSearchActivity()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        setSearchActivity()
        self.view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        setSearchActivity()
        self.view.endEditing(true)
    }
    
    func calculateFilteredFriendList(searchText : String) -> [User]{
        if (searchActive){
            var allFriends:[User] = User.currentUser.liked_friends
            
            filteredFriendList = allFriends.filter( { (friend: User) -> Bool in
                return friend.name.contains(searchText)
            })
            
            return filteredFriendList
            
        }
        return []
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.setSearchActivity()
        
        filteredFriendList = calculateFilteredFriendList(searchText)
        
        self.likedFriendsTable.reloadData()
    }
    


}
