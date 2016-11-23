//
//  Tour.swift
//  TourGuideTracking
//
//  Created by Quoc Huy Ngo on 10/11/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import ObjectMapper

class Tour:Mappable{
    var tourId:Int?
    var managerId:Int?
    var quantity:Int?
    var code:String?
    var name:String?
    var status:String?
    var description:String?
    var coverPhoto:String?
    var departureDate:Date?
    var departureDateString:String?
    var returnDate:Date?
    var returnDateString:String?
    var day:Int?
    
    init(){
        
    }
    
    required init(map:Map){
        
    }
    
    func mapping(map: Map) {
        self.tourId <- map["tour_id"]
        self.managerId <- map["manager_id"]
        self.quantity <- map["quantity"]
        self.status <- map["status"]
        self.code <- map["tour_code"]
        self.name <- map["tour_name"]
        self.description <- map["description"]
        self.coverPhoto <- map["cover_photo"]
        self.departureDateString <- map["departure_date"]
        self.returnDateString <- map["return_date"]
        self.day <- map["day"]
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.departureDate = formatter.date(from: departureDateString!)!
        self.returnDate = formatter.date(from: returnDateString!)
        
    }
    
    func getDate(date:Date) -> String{
        let formatter = DateFormatter()
        //formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.string(from: date)
    }
}
