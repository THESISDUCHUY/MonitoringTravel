//
//  ScheduleDay.swift
//  TourGuideTracking
//
//  Created by Quoc Huy Ngo on 11/4/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import UIKit

class ScheduleDay{
    var schedules:[Schedule]?// = [Schedule]()
    var tour:Tour?
    var date:Date?
    init(schedules: [Schedule], tour:Tour) {
        self.schedules = schedules
        self.tour = tour
    }
    
    func get(){
        var schedulesDay:[[Schedule]] = [[Schedule]]()
        var day = tour?.day
        while(day! > 0){
            var temp:[Schedule] = [Schedule]()
            for schedule in schedules!{
                if schedule.date == tour?.departureDateString{
                    temp.append(schedule)
                }
            }
            schedulesDay.append(temp)
            day = day! - 1
        }
        
        //schedules[0].
    }
}
