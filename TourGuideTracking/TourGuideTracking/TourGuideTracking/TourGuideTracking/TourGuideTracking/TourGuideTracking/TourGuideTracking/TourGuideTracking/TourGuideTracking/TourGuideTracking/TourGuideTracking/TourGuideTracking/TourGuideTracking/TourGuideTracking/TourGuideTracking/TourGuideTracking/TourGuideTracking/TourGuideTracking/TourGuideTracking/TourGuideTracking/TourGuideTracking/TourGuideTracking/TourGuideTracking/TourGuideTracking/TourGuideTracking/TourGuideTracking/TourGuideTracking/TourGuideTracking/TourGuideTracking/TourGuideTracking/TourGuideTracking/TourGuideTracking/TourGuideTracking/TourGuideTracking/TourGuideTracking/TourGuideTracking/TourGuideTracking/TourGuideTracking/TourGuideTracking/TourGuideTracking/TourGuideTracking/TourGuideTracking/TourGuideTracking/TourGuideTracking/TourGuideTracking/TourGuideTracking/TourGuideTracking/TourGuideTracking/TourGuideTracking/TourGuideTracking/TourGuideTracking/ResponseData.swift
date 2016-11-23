//
//  ResponseData.swift
//  TourGuideTracking
//
//  Created by Quoc Huy Ngo on 10/10/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import ObjectMapper

class ResponseData<T:Mappable>: Mappable{
    var status:String?
    var message:String?
    var data:T?
    var listData:[T]?
    
    required init?(map:Map){
        
    }
    func mapping(map: Map) {
        self.status <- map["status"]
        self.message <- map["message"]
        self.data <- map["data"]
        self.listData <- map["data"]
    }
}
