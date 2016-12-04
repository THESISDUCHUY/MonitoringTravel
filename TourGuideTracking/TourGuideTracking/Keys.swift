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
    static let TO_WARNING_DETAIL:String = "SegueToDetailWarning"
    static let TO_HELP:String = "SegueToHelp"
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
    static let WARNING_CELL:String = "WarningCell"
}

struct API_KEYs{
    static let GoogleMap:String = "AIzaSyCmmZj3F82dTWCuFOi416A-fX1gXNC2ZzM"
}
