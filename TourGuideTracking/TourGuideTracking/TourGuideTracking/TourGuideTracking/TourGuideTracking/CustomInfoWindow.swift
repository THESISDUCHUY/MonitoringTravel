//
//  CustomInfoWindow.swift
//  TourGuideTracking
//
//  Created by Quoc Huy Ngo on 10/19/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import UIKit

class CustomInfoWindow: UIView {

    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var vCoverPhoto: UIView!

    @IBOutlet weak var vInfo: UIView!
    @IBOutlet weak var ivCoverPhoto: UIImageView!
    var place:Place!{
        didSet{
            ivCoverPhoto.layer.cornerRadius = ivCoverPhoto.bounds.size.width / 2
            ivCoverPhoto.layer.masksToBounds  = true
            
            vCoverPhoto.layer.cornerRadius = vCoverPhoto.bounds.size.width / 2
            vCoverPhoto.layer.masksToBounds  = true
            
            vInfo.layer.cornerRadius = 5
            vInfo.layer.masksToBounds = true

            
            self.nameLabel.text = place.name
            
            if let url = URL(string: "http://dulichhanoi.vn/wp-content/uploads/2014/04/ba-na-hills-da-nang.jpg") {
                if let data = NSData(contentsOf: url) {
                    self.ivCoverPhoto.image = UIImage(data: data as Data)
                }        
            }
            
           self.layoutIfNeeded()
        }
    }
}
