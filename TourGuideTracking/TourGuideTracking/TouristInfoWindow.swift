//
//  TouristInfoWindow.swift
//  TourGuideTracking
//
//  Created by Quoc Huy Ngo on 10/21/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import UIKit
import AFNetworking

class TouristInfoWindow: UIView {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var tourist:Tourist!{
        didSet{
            if tourist.displayPhoto != nil{
                self.avatarImageView.setImageWith(URL(string:tourist.displayPhoto!)!)
            }
            self.nameLabel.text = "Quoc Huy Ngo"//tourist.name
        }
    }
}
