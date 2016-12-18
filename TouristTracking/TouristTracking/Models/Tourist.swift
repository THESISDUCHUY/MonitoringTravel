//
//  Tourist.swift
//  TouristTracking
//
//  Created by Quoc Huy Ngo on 12/5/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import ObjectMapper

class Tourist: Mappable{
    
    var touristId:Int!
    var accessToken:String!
    var tourId:Int?
    var location:Location?
    var name:String!
    var displayPhoto:String?
    var phone:String!
    var email:String?
    
    required init(){
        
    }
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        self.touristId <- map["tourist_id"]
        self.accessToken <- map["access_token"]
        self.location <- map["location"]
        self.displayPhoto <- map["display_photo"]
        self.name <- map["name"]
        self.tourId <- map["tour_id"]
        self.phone <- map["phone"]
        self.email <- map["email"]
    }
}
