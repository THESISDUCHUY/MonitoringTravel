//
//  Keys.swift
//  TourGuideTracking
//
//  Created by Quoc Huy Ngo on 10/11/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import Foundation

struct Keys{
    static let TOURGUIDE_ID:String = "tourguide_id"
    static let TOURGUIDE_ACCESSTOKEN:String = "tourguide_accessstoken"
    
}

struct SegueIdentifier{
    static let TO_MY_TOURS:String = "SegueToMyTours"
    static let TO_TAB_BAR:String = "SegueToTabBar"
}

struct ViewIdentifier{
    static let LOGIN_VIEW:String = "LoginView"
    static let MYTOURS_VIEW:String = "MyToursView"
    static let MAP_VIEW:String = "MapView"
    static let TOURINFO_VIEW:String = "TourInfoView"
    static let TAB_BAR:String = "TabBarTourDetailsView"
}

struct CellIdentifier{
    static let TOUR_CELL:String = "TourTableViewCell"
    static let SCHEDULE_CELL:String = "ScheduleCell"
    static let TOUR_INFO_CELL:String = "TourInfoCell"
}

struct API_KEYs{
    static let GoogleMap:String = "AIzaSyDCN4X9NUjNF_WX1sHq1WSUVK9PObdIC-s"
}
