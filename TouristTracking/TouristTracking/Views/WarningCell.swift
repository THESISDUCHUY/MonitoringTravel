//
//  WarningCell.swift
//  TouristTracking
//
//  Created by Quoc Huy Ngo on 12/26/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import UIKit

class WarningCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var timeLabel: UILabel!

    @IBOutlet weak var warningImage: UIImageView!
    
    var warning:Warning!{
        didSet{
            titleLabel.text = warning.name
            if warning.status == "Opening"{
                warningImage.image = UIImage(named: "warning_uncheck")
            }
            else{
                warningImage.image = UIImage(named: "warning_check")
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
