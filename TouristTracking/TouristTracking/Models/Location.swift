//
//  Location.swift
//  TouristTracking
//
//  Created by Quoc Huy Ngo on 12/5/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import ObjectMapper

class Location:Mappable{
    var latitude:Double = 0
    var longitude:Double = 0
    
    //    convenience required init(){
    //        super.init()
    //    }
    
    init(latitude:Double, longitude:Double){
        self.latitude = latitude
        self.longitude = longitude
    }
    init() {
        
    }
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        latitude <- map["latitude"]
        longitude <- map["longitude"]
    }
}
