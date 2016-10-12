//
//  Singleton.swift
//  TourGuideTracking
//
//  Created by Quoc Huy Ngo on 10/12/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import Foundation

class Singleton{
    static let sharedInstance = Singleton()
    var tourguide:TourGuide?
    private init(){
    }
}
