//
//  FriendCellTableViewCell.swift
//  FriendshipPal
//
//  Created by Raheel Kazi on 9/13/15.
//  Copyright (c) 2015 Raheel Kazi. All rights reserved.
//

import UIKit

class FriendTableViewCell: UITableViewCell {

    @IBOutlet weak var demoImage: UIImageView!
    
    @IBOutlet weak var friendImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
