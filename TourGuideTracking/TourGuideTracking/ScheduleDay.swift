//
//  ScheduleDay.swift
//  TourGuideTracking
//
//  Created by Quoc Huy Ngo on 11/4/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import UIKit

class ScheduleDay{
    var schedules:[Schedule]?
    var date:Date?
    
    init(){
        self.schedules = [Schedule]()
        self.date = Date()
    }
    static func getSchdulesDay(allSchedules:[Schedule], tour:Tour) -> [ScheduleDay]{
        var schedulesDay:[ScheduleDay] = [ScheduleDay]()
        var day = tour.day
        var departure = tour.departureDate
        while(day! > 0){
            let scheduleDay = ScheduleDay()
            scheduleDay.date = departure
            for schedule in allSchedules{
                if (schedule.getDate() == tour.getDate(date: departure!)){
                    scheduleDay.schedules?.append(schedule)
                }
            }
            schedulesDay.append(scheduleDay)
            departure = departure?.addingTimeInterval(24*60*60)
            day = day! - 1
        }
        return schedulesDay
    }
    
    func getDateString() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.string(from: date!)
    }
}
