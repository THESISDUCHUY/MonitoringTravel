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
    
    var place:Place!{
        didSet{
            self.nameLabel.text = place.name
        }
    }
}
