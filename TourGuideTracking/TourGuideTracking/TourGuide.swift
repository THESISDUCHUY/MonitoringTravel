//
//  TourGuide.swift
//  TourGuideTracking
//
//  Created by Quoc Huy Ngo on 10/11/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import ObjectMapper

class TourGuide: Mappable {
    var tourGuideId:Int?
    var accessToken:String?
    var name:String? = ""
    var phone:String? = ""
    var email:String? = ""
    var displayPhoto:String? = ""
    var location:Location?
    
    required init?(map: Map) {
    }
    init(){
        
    }
    func mapping(map: Map) {
        self.tourGuideId <- map["tourguide_id"]
        self.accessToken <- map["access_token"]
        self.name <- map["tourguide_name"]
        self.phone <- map["phone"]
        self.email  <- map["email"]
        self.displayPhoto <- map["display_photo"]
        self.location <- map["location"]
    }
}
