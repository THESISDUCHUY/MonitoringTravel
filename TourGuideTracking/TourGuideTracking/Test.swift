//
//  Test.swift
//  TourGuideTracking
//
//  Created by Duc Nguyen on 11/8/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import UIKit

class Test: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var ivTest: UIImageView!
    @IBOutlet weak var vTest: UIView!
    @IBOutlet weak var sclMain: UIScrollView!
    
    @IBOutlet weak var vHightlightSchedule: UIView!
    @IBOutlet weak var vHightLightInfo: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sclMain.delegate = self
    }

    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = sclMain.contentOffset.x / sclMain.frame.width
        updateHightlight(page: integer_t(page))
    }
    
    
    
    func updateHightlight(page: integer_t)
    {
        vHightLightInfo.layer.opacity = 0
        vHightlightSchedule.layer.opacity = 0
        
        if(page == 0)
        {
            vHightLightInfo.layer.opacity = 1
        }
        else if(page == 1)
        {
            vHightlightSchedule.layer.opacity = 1
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
