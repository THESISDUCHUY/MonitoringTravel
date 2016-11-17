//
//  Location.swift
//  TourGuideTracking
//
//  Created by Quoc Huy Ngo on 10/6/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import ObjectMapper
class Location:Mappable{
    var latitude:Double?
    var longitude:Double?
    
    init(){
        
    }
    
    init(latitude:Double, longitude:Double){
        self.latitude = latitude
        self.longitude = longitude
    }
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        latitude <- map["latitude"]
        longitude <- map["longitude"]
    }
}
