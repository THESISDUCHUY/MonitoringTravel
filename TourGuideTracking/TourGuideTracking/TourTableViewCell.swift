//
//  TourTableViewCell.swift
//  TourGuideTracking
//
//  Created by Quoc Huy Ngo on 10/12/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import UIKit

class TourTableViewCell: UITableViewCell {

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var tourNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
