//
//  ContactViewController.swift
//  TourGuideTracking
//
//  Created by Quoc Huy Ngo on 11/1/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController {

    let text = "LabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabel LabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabel"
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = text
        label.sizeToFit()
        let h = label.frame.origin.y + label.frame.height
        print(label.frame.origin.y)
        print(label.frame.height)
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, h, 0)
        // Do any additional setup after loading the view.
    }

}
