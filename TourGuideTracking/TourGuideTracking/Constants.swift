//
//  Constants.swift
//  TourGuideTracking
//
//  Created by Quoc Huy Ngo on 10/11/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

struct URLs {
    static let URL_BASE:String = "http://localhost/tourtracking"
    static let URL_LOGIN:String = URL_BASE + "/login"
    static let URL_GET_TOURGUIDE = URL_BASE + "/tourguides"
    static func makeURL(url:String, param:Int )->String{
        return String(format: url + "/%d", param)
    }
}
