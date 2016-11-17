//
//  ContactViewController.swift
//  TourGuideTracking
//
//  Created by Quoc Huy Ngo on 11/1/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var vHightlightManager: UIView!
    
    @IBOutlet weak var vHightlightTourist: UIView!
    
    @IBOutlet weak var vHightlightTourGuide: UIView!
    
    @IBOutlet weak var sclMain: UIScrollView!
    
//    
//    let text = "LabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabel LabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabel"
//    @IBOutlet weak var label: UILabel!
//    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        sclMain.delegate = self
        
//        label.text = text
//        label.sizeToFit()
//        let h = label.frame.origin.y + label.frame.height
//        print(label.frame.origin.y)
//        print(label.frame.height)
//        scrollView.contentInset = UIEdgeInsetsMake(0, 0, h, 0)
        // Do any additional setup after loading the view.
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = sclMain.contentOffset.x / sclMain.frame.width
        updateHightlight(page: integer_t(page))
    }
    
    
    
    func updateHightlight(page: integer_t)
    {
        vHightlightManager.layer.opacity = 0
        vHightlightTourist.layer.opacity = 0
        vHightlightTourGuide.layer.opacity = 0
        
        if(page == 0)
        {
            vHightlightManager.layer.opacity = 1
        }
        else if(page == 1)
        {
            vHightlightTourist.layer.opacity = 1
        }
        else if(page == 2)
        {
            vHightlightTourGuide.layer.opacity = 1
        }
    }

}
