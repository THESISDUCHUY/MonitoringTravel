//
//  InformPopup.swift
//  TouristTracking
//
//  Created by Quoc Huy Ngo on 12/17/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import UIKit

class InformPopup: UIView {

    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var panel: UIView!
    
    var warning:Warning!{
        didSet{
            categoryLabel.text = warning.type
            titleLabel.text = warning.name
            contentLabel.text = warning.description
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubview()
    }
    func initSubview(){
        let nib = UINib(nibName: "InformPopup", bundle: nil)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        addSubview(view)
        panel.layer.cornerRadius = 6
    }
    
    @IBAction func confirmButtonTap(_ sender: Any) {
        removeFromSuperview()
    }
    func hide() {
        removeFromSuperview()
    }
    
    func setData(title:String!){
        contentLabel.text = title
    }
}
