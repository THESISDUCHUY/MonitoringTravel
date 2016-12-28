
//
//  File.swift
//  TouristTracking
//
//  Created by Quoc Huy Ngo on 12/5/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import Foundation
struct URLs {
    //static let URL_BASE:String = "http://localhost/tourtracking"
    static let URL_BASE:String = "http://tourtracking.esy.es/tourtracking"
    static let URL_IMAGE_BASE:String = "http://tourtrackingv2.azurewebsites.net/Content/Images/"//"http://localhost/tourtracking/images"
    static let URL_LOGIN:String = URL_BASE + "/tourist_login"
    static let URL_GET_TOURIST = URL_BASE + "/tourists"
    static let URL_GET_TOURS:String = URL_BASE + "/tours"
    static let URL_TRACKING_UPDATE = URL_BASE + "/tracking_update"
    static let SERVER_REALTIME:String = "http://tourtrackingv2.azurewebsites.net/signalr/hubs"
    //static let SERVER_REALTIME:String = "http://192.168.0.104:3407/signalr/hubs"
    
    static func makeURL(url:String, param:Int )->String{
        return String(format: url + "/%d", param)
    }
    
    static func makeURL_EXTEND(url:String, extend:String,param:Int )->String{
        return String(format: url + "/%d" + extend, param)
    }
}

struct URL_EXTEND{
    static let TOURS:String = "/tours"
    static let PLACES:String = "/places"
    static let SCHEDULE:String = "/schedules"
    static let WARNING:String = "/warnings"
}

struct ERROR_MESSAGE{
    static let CONNECT_SERVER:String = "Connect server problems"
}

public enum StatusConnection {
    case connected
    case disconnected
    case reconnected
    case reconnecting
    case error
    case starting
    case slow
}

