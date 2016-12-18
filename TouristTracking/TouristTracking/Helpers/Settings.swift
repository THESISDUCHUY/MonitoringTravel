//
//  Settings.swift
//  TouristTracking
//
//  Created by Quoc Huy Ngo on 12/6/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import Foundation

struct Settings{
    static var tourist_id:Int?
    static var tourist_accesstoken:String?
    
    static func toDictionary() -> Dictionary<String, AnyObject>{
        return [
            SettingKeys.TOURIST_ID: self.tourist_id as AnyObject,
            SettingKeys.TOURIST_ACCESSTOKEN : self.tourist_accesstoken as AnyObject
        ]
    }
    
    static func fromDictionary(dictionary:Dictionary<String, AnyObject>){
        
        if let tourist_id = dictionary[SettingKeys.TOURIST_ID] as? Int{
            self.tourist_id = tourist_id
        }
        
        if let tourist_accesstoken = dictionary[SettingKeys.TOURIST_ACCESSTOKEN] as? String{
            self.tourist_accesstoken = tourist_accesstoken
        }
    }

}
