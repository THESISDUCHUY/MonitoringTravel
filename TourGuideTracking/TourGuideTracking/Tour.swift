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
    var departureDate:String?
    var returnDate:String?
    
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
        self.departureDate <- map["departure_date"]
        self.returnDate <- map["return_date"]
    }
    
    func convertDate(){
        let strTime = "2015-07-27 19:29:50"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.date(from: strTime)
    
    }
}
