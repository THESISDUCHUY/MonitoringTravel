//
//  ContactCell.swift
//  TourGuideTracking
//
//  Created by Quoc Huy Ngo on 12/11/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import UIKit
import AFNetworking
class ContactCell: UITableViewCell {

    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    
    var user:User!{
        didSet{
            profileImageView.image = nil
            profileImageView.setImageWith(URL(string:user.displayPhoto!)!)
            nameLabel.text = user.name
            phoneLabel.text = user.phone
        }
    }
    override func awakeFromNib() {
        profileImageView.layer.cornerRadius = 30
        profileImageView.clipsToBounds = true
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
