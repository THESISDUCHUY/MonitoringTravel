//
//  Settings.swift
//  TourGuideTracking
//
//  Created by Quoc Huy Ngo on 10/11/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

struct Settings{
    static var tourguide_id:Int?
    static var tourguide_accesstoken:String?
    
    static func toDictionary() -> Dictionary<String, AnyObject>{
        return [
            Keys.TOURGUIDE_ID: self.tourguide_id as AnyObject,
            Keys.TOURGUIDE_ACCESSTOKEN : self.tourguide_accesstoken as AnyObject
        ]
    }
    
    static func fromDictionary(dictionary:Dictionary<String, AnyObject>){
        
        if let tourguide_id = dictionary[Keys.TOURGUIDE_ID] as? Int{
            self.tourguide_id = tourguide_id
        }
        
        if let tourguide_accesstoken = dictionary[Keys.TOURGUIDE_ACCESSTOKEN] as? String{
            self.tourguide_accesstoken = tourguide_accesstoken
        }
    }

}
