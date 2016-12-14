//
//  Manager.swift
//  TourGuideTracking
//
//  Created by Quoc Huy Ngo on 12/11/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import ObjectMapper

class Manager: User, Mappable{
    
    override init(){
        
    }
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        name <- map["manager_name"]
        phone <- map["phone_number"]
        email <- map["email"]
        displayPhoto <- map["display_photo"]
    }
}
