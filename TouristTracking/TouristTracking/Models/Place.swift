//
//  Place.swift
//  TouristTracking
//
//  Created by Quoc Huy Ngo on 12/8/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import UIKit
import ObjectMapper

class Place:Mappable{
    
    var placeId:Int!
    var provinceId:Int!
    var name:String!
    var contact:String!
    var address:String!
    var coverPhoto:String!
    var location:Location!
    var description:String!
    
    required init(){
        
    }
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.placeId <- map["place_id"]
        self.provinceId <- map["province_id"]
        self.name <- map["place_name"]
        self.contact <- map["contact"]
        self.address <- map["address"]
        self.coverPhoto <- map["cover_photo"]
        self.location <- map["location"]
        self.description <- map["description"]
    }
}
