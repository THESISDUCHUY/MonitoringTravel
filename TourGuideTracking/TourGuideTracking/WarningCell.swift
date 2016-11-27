//
//  WarningCell.swift
//  TourGuideTracking
//
//  Created by Quoc Huy Ngo on 11/24/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import UIKit
import AFNetworking

class WarningCell: UITableViewCell {

    @IBOutlet weak var warningNameLabel: UILabel!
    @IBOutlet weak var statusImageView: ImageRound!
    
    var warning:Warning!{
        didSet{
            warningNameLabel.text = warning.name
            if warning.status == "Confirmed"{
                statusImageView.image = UIImage(named: "warning-check")
            }
            else{
                statusImageView.image = UIImage(named: "warning-uncheck")
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
