//
//  ScheduleCell.swift
//  TourGuideTracking
//
//  Created by Quoc Huy Ngo on 11/1/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import UIKit

class ScheduleCell: UITableViewCell {



    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    var schedule:Schedule!{
        didSet{
            nameLabel.text = schedule.place_name
            timeLabel.text = schedule.getTime()
            descriptionLabel.text = schedule.description
            for place in Singleton.sharedInstance.places{
                if schedule.place_id == place.placeId{
                    coverImageView.setImageWith(URL(string:place.coverPhoto)!)
                    break
                }
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
