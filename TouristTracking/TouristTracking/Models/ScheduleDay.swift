//
//  ScheduleDay.swift
//  TouristTracking
//
//  Created by Quoc Huy Ngo on 12/6/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//
import UIKit
class ScheduleDay{
    var schedules:[Schedule]?
    var date:Date?
    var isHidden:Bool = false
    
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
                print(schedule.getDate())
                print(tour.getDate(date: departure!))
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

