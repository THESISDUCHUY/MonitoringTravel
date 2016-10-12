//
//  Place.swift
//  TourGuideTracking
//
//  Created by Quoc Huy Ngo on 10/6/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import UIKit
import ObjectMapper
class Place:Mappable{
    
    var placeId:Int = 0
    var provinceId:Int = 0
    var placeName:String = ""
    var contact:String = ""
    var address:String = ""
    var coverPhoto:String = ""

    required init?(map: Map) {
    
    }
    
    func mapping(map: Map) {
        self.placeId <- map["place_id"]
        self.provinceId <- map["province_id"]
        self.placeName <- map["place_name"]
        self.contact <- map["contact"]
        self.address <- map["address"]
        self.coverPhoto <- map["cover_photo"]
    }
}
