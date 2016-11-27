//
//  Warning.swift
//  TourGuideTracking
//
//  Created by Quoc Huy Ngo on 11/24/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import ObjectMapper

class Warning: Mappable{
    var warning_id:Int?
    var name:String?
    var isGroup:Int?
    var type:String?
    var description:String?
    var status:String?
    var latitude:Double?
    var longitude:Double?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        self.warning_id <- map["warning_id"]
        self.name <- map["name"]
        self.isGroup <- map["isGroup"]
        self.type <- map["type"]
        self.description <- map["description"]
        self.status <- map["status"]
        self.latitude <- map["latitude"]
        self.longitude <- map["longitude"]
    }
}
