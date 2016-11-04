//
//  TourInfoCell.swift
//  TourGuideTracking
//
//  Created by Quoc Huy Ngo on 11/3/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import UIKit
import AFNetworking

class TourInfoCell: UITableViewCell {

    @IBOutlet weak var touristQuantityLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var returnDateLabel: UILabel!
    @IBOutlet weak var departureDateLabel: UILabel!
    @IBOutlet weak var tourCodeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tourCoverImageView: UIImageView!
    
    var tour:Tour!{
        didSet{
            touristQuantityLabel.text = String(format:"%d", tour.quantity!)
            departureDateLabel.text = tour.departureDate
            returnDateLabel.text = tour.returnDate
            tourCodeLabel.text = tour.code
            nameLabel.text = tour.name
            dayLabel.text = String(format: "%d ngày", tour.day!)
            if(tour.coverPhoto != ""){
                tourCoverImageView.setImageWith(URL(string:tour.coverPhoto!)!)
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
