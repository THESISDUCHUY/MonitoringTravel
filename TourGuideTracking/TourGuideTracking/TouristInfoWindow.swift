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
    
    @IBOutlet weak var btnWarning: UIButton!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var vAvatar: UIView!

    @IBAction func TestClick(_ sender: Any) {
        print("warning click")
    }
    @IBOutlet weak var vInfo: UIView!
    @IBOutlet weak var ivAvatar: UIImageView!
    var tourist:Tourist!{
        didSet{
            
            //vAvatar.layer.cornerRadius = vAvatar.bounds.size.width / 2
           // vAvatar.layer.masksToBounds  = true
            
            //ivAvatar.layer.cornerRadius = ivAvatar.bounds.size.width / 2
            //ivAvatar.layer.masksToBounds  = true
            
            vInfo.layer.cornerRadius = 5
            vInfo.layer.masksToBounds = true
            vInfo.clipsToBounds = true
            
            
            if tourist.displayPhoto != nil{
                self.avatarImageView.setImageWith(URL(string:tourist.displayPhoto!)!)
            }
            //self.nameLabel.text = "Quoc Huy Ngo"//tourist.name

        }
    }
}
