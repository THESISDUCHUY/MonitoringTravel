//
//  WarningPopup.swift
//  TouristTracking
//
//  Created by Quoc Huy Ngo on 12/15/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import UIKit

class InformWarningPopup: UIView {

    
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubview()
    }
    func initSubview(){
        let nib = UINib(nibName: "InformWarningPopup", bundle: nil)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        addSubview(view)
        view.backgroundColor = UIColor.red
    }
}
