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
            
            vInfo.layer.cornerRadius = 5
            vInfo.layer.masksToBounds = true
            vInfo.clipsToBounds = true

            
            self.nameLabel.text = place.name
            
            
           self.layoutIfNeeded()
        }
    }
}
