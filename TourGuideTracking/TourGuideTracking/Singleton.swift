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
    var tourguide:TourGuide!
    var tours:[Tour]!
    var places:[Place]!
    var tourists:[Tourist]!
    var schedules:[Schedule]!
    var manager:Manager!
    private init(){
        self.tourguide = TourGuide()
        self.manager = Manager()
        self.tours = [Tour]()
        self.places = [Place]()
        self.tourists = [Tourist]()
        self.schedules = [Schedule]()
    }
}
