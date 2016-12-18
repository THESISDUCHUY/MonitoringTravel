//
//  ViewRoundCorner.swift
//  TouristTracking
//
//  Created by Quoc Huy Ngo on 12/10/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import UIKit
class ViewRoundCorner: UIView {
    
    @IBInspectable var borderWidth: CGFloat = 0{
        didSet{
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor : UIColor?{
        didSet{
            layer.borderColor = borderColor?.cgColor
        }
    }
    @IBInspectable var cornerRadius : CGFloat = 0{
        didSet{
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
        
    }
    
}
