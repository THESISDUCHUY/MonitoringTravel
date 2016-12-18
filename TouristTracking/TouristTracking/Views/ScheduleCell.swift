//
//  ScheduleCell.swift
//  TouristTracking
//
//  Created by Quoc Huy Ngo on 12/7/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import UIKit

class ScheduleCell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
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
