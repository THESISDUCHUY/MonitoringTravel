//
//  User.swift
//  TourGuideTracking
//
//  Created by Quoc Huy Ngo on 12/11/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import UIKit
class User{
    var name:String?
    var phone:String?
    var status:String?
    var email:String?
    var displayPhoto:String?
    init() {
        self.status = "Offline"
    }
}
