//
//  Singleton.swift
//  TouristTracking
//
//  Created by Quoc Huy Ngo on 12/5/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import Foundation

class Singleton{
    static let sharedInstance = Singleton()
    var tourist:Tourist!
    var places:[Place]!
    var tour:Tour!
    
    private init(){
        self.tourist = Tourist()
        self.places = [Place]()
        tour = Tour()
    }
}
