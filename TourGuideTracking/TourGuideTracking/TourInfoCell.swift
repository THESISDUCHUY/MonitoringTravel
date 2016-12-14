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

  
    @IBOutlet weak var dayLeftLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var touristQuantityLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    
    var tour:Tour!{
        didSet{
            touristQuantityLabel.text = String(format:"%d", tour.quantity!)
            timeLabel.text = tour.getDate(date:tour.departureDate!) + " - " + tour.getDate(date: tour.returnDate!)
            nameLabel.text = tour.name
            dayLabel.text = String(format: "%d ngày", tour.day!)
            descriptionLabel.text = tour.description
            if(tour.coverPhoto != ""){
                coverImageView.setImageWith(URL(string:tour.coverPhoto!)!)
            }
            let dayLeft = tour.countDown(departureDate: tour.departureDate!, currentDate: Date())
            if dayLeft > 0{
                dayLeftLabel.text = "Còn \(dayLeft) ngày"
            }
            else{
                dayLeftLabel.text = "Đang hoạt động"
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
