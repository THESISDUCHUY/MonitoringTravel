//
//  Tourist.swift
//  TourGuideTracking
//
//  Created by Quoc Huy Ngo on 10/18/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import ObjectMapper

class Tourist: Mappable{
    
    var touristID:Int?
    var location:Location?
    var name:String?
    var displayPhoto:String?
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        self.touristID <- map["tourist_id"]
        self.location <- map["location"]
        self.displayPhoto <- map["display_photo"]
        self.name <- map["name"]
    }
}
