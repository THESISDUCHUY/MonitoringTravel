//
//  Tracking.swift
//  TourGuideTracking
//
//  Created by Quoc Huy Ngo on 12/1/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

class Tracking: Object{
    dynamic var tour_id:Int = 0
    dynamic var time:String! = "2016-12-01 00:00:00"
    dynamic var location:Location! = Location()
    
    convenience init(tour_id:Int, location:Location) {
        self.init()
        self.tour_id = tour_id
        self.location = location
        self.time = getCurrentTimeString()
    }
    
    func getCurrentTimeString() -> String{
        let date = Date()
        //let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: date)
    }
    
    func convertToJson() -> NSMutableDictionary{
        let jsonObject = NSMutableDictionary()
        jsonObject.setValue(tour_id, forKey: "tour_id")
        jsonObject.setValue(time, forKey: "time")
        jsonObject.setValue(location.latitude, forKey: "latitude")
        jsonObject.setValue(location.longitude, forKey: "longitude")
        return jsonObject
    }
    
}


