//
//  Tourist.swift
//  TourGuideTracking
//
//  Created by Quoc Huy Ngo on 10/18/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import ObjectMapper

class Tourist: User, Mappable{
    
    var touristID:Int?
    var location:Location?
    var statusConnection:StatusConnection!
    //var name:String?
    //var displayPhoto:String?
    override init() {
        
    }
    required init?(map: Map) {
        statusConnection = StatusConnection.connected
    }
    
    func mapping(map: Map) {
        self.touristID <- map["tourist_id"]
        self.location <- map["location"]
        self.displayPhoto <- map["display_photo"]
        self.name <- map["tourist_name"]
        self.phone <- map["phone"]
        self.email <- map["email"]
    }
}
