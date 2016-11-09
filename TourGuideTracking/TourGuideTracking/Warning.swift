//
//  Warning.swift
//  TourGuideTracking
//
//  Created by Quoc Huy Ngo on 11/8/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import UIKit

@IBDesignable class Warning: UIView {

    
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var confirmButton: UIButton!
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubview()
    }
    
    func initSubview(){
        let nib = UINib(nibName: Xibs.WARNING, bundle: nil)
        let object = nib.instantiate(withOwner: self , options: nil)
        //let popup = object.last as! UIView
        
        //confirmButton.titleLabel?.text = "Hide"
        contentView.frame = bounds
        addSubview(contentView)

    }

}
