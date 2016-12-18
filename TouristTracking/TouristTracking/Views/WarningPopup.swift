//
//  WarningPopup.swift
//  TouristTracking
//
//  Created by Quoc Huy Ngo on 12/16/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import UIKit

class WarningPopup: UIView{
    
    @IBOutlet weak var panel: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubview()
    }
    func initSubview(){

        let nib = UINib(nibName: "WarningPopup", bundle: nil)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        //view.backgroundColor = UIColor.clear
        addSubview(view)
        
        panel.layer.cornerRadius = 6
        panel.layer.shadowColor = UIColor.black.cgColor
        panel.layer.shadowOpacity = 1
        panel.layer.shadowRadius = 5
    }

}
