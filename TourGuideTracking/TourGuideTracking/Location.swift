//
//  Location.swift
//  TourGuideTracking
//
//  Created by Quoc Huy Ngo on 10/6/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import ObjectMapper
import RealmSwift
import Realm

class Location:Object, Mappable{
    dynamic var latitude:Double = 0
    dynamic var longitude:Double = 0
    
//    convenience required init(){
//        super.init()
//    }
    
    convenience init(latitude:Double, longitude:Double){
        self.init()
        self.latitude = latitude
        self.longitude = longitude
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        latitude <- map["latitude"]
        longitude <- map["longitude"]
    }
}
