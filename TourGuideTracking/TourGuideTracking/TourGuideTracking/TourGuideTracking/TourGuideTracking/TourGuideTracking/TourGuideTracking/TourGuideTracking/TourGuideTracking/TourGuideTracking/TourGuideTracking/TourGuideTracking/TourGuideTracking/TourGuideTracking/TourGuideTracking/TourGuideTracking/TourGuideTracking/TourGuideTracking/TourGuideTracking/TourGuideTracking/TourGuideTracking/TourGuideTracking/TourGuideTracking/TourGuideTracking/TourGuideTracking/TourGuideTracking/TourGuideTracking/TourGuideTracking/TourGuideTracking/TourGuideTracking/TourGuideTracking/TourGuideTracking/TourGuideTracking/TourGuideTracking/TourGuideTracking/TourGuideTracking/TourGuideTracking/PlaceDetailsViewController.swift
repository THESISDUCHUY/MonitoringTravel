//
//  PlaceDetailsViewController.swift
//  TourGuideTracking
//
//  Created by Quoc Huy Ngo on 10/21/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import UIKit
import AFNetworking
class PlaceDetailsViewController: UIViewController {

    var place:Place!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setValue()
    }
    
    func setValue(){
        if place.coverPhoto != ""{
            self.coverImageView.setImageWith(URL(string:place.coverPhoto)!)
        }
        self.nameLabel.text = place.name
        self.contactLabel.text = place.contact
        self.addressLabel.text = place.address
        self.descriptionLabel.text = place.description
        self.descriptionLabel.sizeToFit()
        let h = descriptionLabel.frame.size.height + descriptionLabel.frame.origin.y
        self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, h, 0)
        
    }
}
