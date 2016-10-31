//
//  Schedule.swift
//  TourGuideTracking
//
//  Created by Quoc Huy Ngo on 10/27/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import ObjectMapper

class Schedule: Mappable{
    var place_id:Int?
    var place_name:String?
    var vehicle:String?
    var time:String?
    var description:String?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        self.place_id <- map["place_id"]
        self.place_name <- map["place_name"]
        self.vehicle <- map["vehicle"]
        self.time <- map["time"]
        self.description <- map["description"]
    }
}
