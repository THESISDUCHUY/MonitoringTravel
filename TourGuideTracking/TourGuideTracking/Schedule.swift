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
    var timestamp:NSDate?
    var timestampString:String?
    var description:String?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        self.place_id <- map["place_id"]
        self.place_name <- map["place_name"]
        self.vehicle <- map["vehicle"]
        self.description <- map["description"]
        self.timestampString <- map["time"]
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.timestamp = formatter.date(from: timestampString!)! as NSDate?
    }
    
    func getTime() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: timestamp! as Date)
    }
    
    func getDate() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.string(from: timestamp! as Date)
    }
}
