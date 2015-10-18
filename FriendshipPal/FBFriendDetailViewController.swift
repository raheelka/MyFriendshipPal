//
//  FBFriendDetailViewController.swift
//  FriendshipPal
//
//  Created by Raheel Kazi on 9/1/15.
//  Copyright (c) 2015 Raheel Kazi. All rights reserved.
//

import UIKit
import Parse
import Koloda
import pop

private var numberOfCards: UInt = 100

class FBFriendDetailViewController: UIViewController, KolodaViewDataSource, KolodaViewDelegate  {
    
    @IBOutlet weak var name_userInFocus: UILabel!
    @IBOutlet weak var kolodaView: KolodaView!
    
    
    var allUsers : [PFUser] = []
    let currentUser = PFUser.currentUser()!
    var relationshipMapper = RelationshipMapper()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.getNearByUsers()
        self.kolodaView.dataSource = self
        self.kolodaView.delegate = self
        self.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
    }
    
    func setDisplayNameForCardAtIndex(index : Int)
    {
        if (index < allUsers.count)
        {
            let userInFocus : PFUser = self.allUsers[index]
            userInFocus.fetchInBackgroundWithBlock {
                (object : PFObject?, error : NSError?) -> Void in
                if(error == nil){
                    self.name_userInFocus.text = userInFocus.valueForKey("name") as? String
                }
            }
        }
        else
        {
            self.name_userInFocus.text = ""
        }
    }
    
    func getNearByUsers(){
        
        let relation_query = PFQuery(className: "Relations")
        relation_query.whereKey("user", equalTo: PFUser.currentUser()!)
        
        
        var liked_friends : [PFUser] = []
        var disliked_friends : [PFUser] = []
        
        
        relation_query.getFirstObjectInBackgroundWithBlock {
            (user_relation: PFObject?, error: NSError?) -> Void in
            if error != nil {
                print("Failed to get user from relation class")
            }
            else if let user_relation = user_relation {
                liked_friends = user_relation["liked_friends"] as! [PFUser]
                disliked_friends = user_relation["disliked_friends"] as! [PFUser]
                self.excludeLikedDislikedFriends(liked_friends, disliked_friends: disliked_friends)
                
            }
        }
        
        
    }
    
    func excludeLikedDislikedFriends(liked_friends : [PFUser], disliked_friends : [PFUser])
    {
        let excludeLikedDislikedUserQuery = PFQuery(className: "Relations")
        excludeLikedDislikedUserQuery.whereKey("user", notContainedIn: liked_friends + disliked_friends)
        excludeLikedDislikedUserQuery.whereKey("user", notEqualTo: PFUser.currentUser()!)
        
        excludeLikedDislikedUserQuery.findObjectsInBackgroundWithBlock{
            (objects : [PFObject]?, error : NSError?) -> Void in
            if(error != nil){
                print("Failed to execute query excludeLikedDisLikedUser")
            }
            else if let objects = objects{
                for object in objects{
                    self.allUsers.append(object["user"] as! PFUser)
                }
                self.initializeKolodaView()
            }
            
        }
    }

    
    func initializeKolodaView(){
        self.kolodaView.dataSource = self
        self.kolodaView.delegate = self
        self.setDisplayNameForCardAtIndex(0)
    }
    
    

    
    //MARK ************** KOLODA *********************
    
    //MARK: IBActions
    @IBAction func leftButtonTapped() {
        kolodaView?.swipe(SwipeResultDirection.Left)
    }
    
    @IBAction func rightButtonTapped() {
        kolodaView?.swipe(SwipeResultDirection.Right)
    }

    
    //MARK: KolodaViewDataSource
    func kolodaNumberOfCards(koloda: KolodaView) -> UInt {
        return UInt(allUsers.count)
    }
    
    func kolodaViewForCardAtIndex(koloda: KolodaView, index: UInt) -> UIView {
        let userInFocus : PFUser = self.allUsers[Int(index)]
        let profilePicImageView : UIImageView = UIImageView()
        userInFocus.fetchInBackgroundWithBlock {
            (object : PFObject?, error : NSError?) -> Void in
            if(error == nil){
                let profilePicUrl : String = object?.valueForKey("profile_pic_url") as! String
                self.setImageFromRemoteLocation(profilePicUrl, imageView: profilePicImageView)
            }
        }
        return profilePicImageView
    }
    
    func kolodaViewForCardOverlayAtIndex(koloda: KolodaView, index: UInt) -> OverlayView? {
        return NSBundle.mainBundle().loadNibNamed("OverlayView",
            owner: self, options: nil)[0] as? OverlayView
    }
    
    //MARK: KolodaViewDelegate
    
    func kolodaDidSwipedCardAtIndex(koloda: KolodaView, index: UInt, direction: SwipeResultDirection) {
        //TODO ** DO NOT DELETE **
        // kolodaView.reloadData() should be a possibility here. This reloads all the items from the datasource
        // Once all 100 are empty, we should reload the datasource from here
        
        self.setDisplayNameForCardAtIndex(Int(index)+1)
        
        if (direction == SwipeResultDirection.Left){
            relationshipMapper.dislikeAFriend(PFUser.currentUser()!, friend: self.allUsers[Int(index)])
        }
        else if (direction == SwipeResultDirection.Right){
            relationshipMapper.likeAFriend(PFUser.currentUser()!, friend: self.allUsers[Int(index)])
        }
        
        
    }
    
    func kolodaDidRunOutOfCards(koloda: KolodaView) {
        //Example: reloading
        //This function is called when kolodaView runs out of cards
        //Not sure what this does yet kolodaView.resetCurrentCardNumber()
    }
    
    func kolodaDidSelectCardAtIndex(koloda: KolodaView, index: UInt) {
        //This gets called when the current card is selected
    }
    
    func kolodaShouldApplyAppearAnimation(koloda: KolodaView) -> Bool {
        return true
    }
    
    func kolodaShouldMoveBackgroundCard(koloda: KolodaView) -> Bool {
        return true
    }
    
    func kolodaShouldTransparentizeNextCard(koloda: KolodaView) -> Bool {
        return true
    }
    
    func kolodaBackgroundCardAnimation(koloda: KolodaView) -> POPPropertyAnimation? {
        return nil
    }




}
