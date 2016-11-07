//
//  TourInfoViewController.swift
//  TourGuideTracking
//
//  Created by Quoc Huy Ngo on 10/14/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import UIKit
import AFNetworking

class TourInfoViewController: UIViewController {
    
    @IBOutlet weak var tourInfoTableView: UITableView!
    var tour:Tour!
    //var schedules:[Schedule]!
    var schedulesDay:[ScheduleDay]!
    var selectedArray : [NSMutableArray] = []
    var currentPlaceSelected:Place!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set row height dynamic
        //self.tourInfoTableView.rowHeight = UITableViewAutomaticDimension
        //self.tourInfoTableView.estimatedRowHeight = 140
        schedulesDay = [ScheduleDay]()
        tourInfoTableView.delegate = self
        tourInfoTableView.dataSource = self
        tourInfoTableView.reloadData()
        self.tour = (tabBarController as! CustomTabBarController).currentTour
        getTourSchedule()
    }
    
    
    func getTourSchedule(){
        let url = URLs.makeURL_EXTEND(url: URLs.URL_GET_TOURS, extend: URL_EXTEND.SCHEDULE, param: tour.tourId!)
         NetworkService<Schedule>.makeGetRequest(URL: url){
            response, error in
            if error == nil{
                let message = response?.message
                if message == nil{
                    let schedules = response?.listData
                    //Singleton.sharedInstance.schedules = schedules
                    self.schedulesDay = ScheduleDay.getSchdulesDay(allSchedules: schedules!, tour: self.tour)
                    self.tourInfoTableView.reloadData()
                }
                else{
                    Alert.showAlertMessage(userMessage: message!, vc: self)
                }
            }
            else {
                Alert.showAlertMessage(userMessage: ERROR_MESSAGE.CONNECT_SERVER , vc: self)
            }

        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailsVC = segue.destination as! PlaceDetailsViewController
        detailsVC.place = currentPlaceSelected
    }
}

extension TourInfoViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.TOUR_INFO_CELL) as! TourInfoCell
            cell.tour = tour
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.SCHEDULE_CELL) as! ScheduleCell
            cell.schedule = schedulesDay[indexPath.section - 1].schedules?[indexPath.row]
            return cell
        }
       
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return schedulesDay.count + 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        else{
            return (schedulesDay[section - 1].schedules?.count)!
        }
        //return 2//schedules?.count ?? 0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return ""
        }
        else{
            return schedulesDay[section - 1].getDateString()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let place_id = schedulesDay[indexPath.section - 1].schedules?[indexPath.row].place_id
        for place in Singleton.sharedInstance.places{
            if place.placeId == place_id{
                self.currentPlaceSelected = place
                break
            }
        }
        self.performSegue(withIdentifier: SegueIdentifier.PLACE_DETAIL, sender: self)
    }

    /*func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let titleHeader =  "Ngày 1 - 20/01/2017" // Also set on button
        let  headerCell = UIView(frame: CGRect(x: 0   , y: 0, width: tableView.frame.size.width , height: 40 ))
        headerCell.backgroundColor = UIColor.gray
        let button  = UIButton(frame: headerCell.frame)
        button.addTarget(self, action: Selector(("selectedSectionStoredButtonClicked:")), for: UIControlEvents.touchUpInside)
        button.setTitle(titleHeader, for: UIControlState.normal)
        
        button.tag = section
        headerCell.addSubview(button)
        
        return headerCell
    }
    
    func selectedSectionStoredButtonClicked (sender : UIButton) {
       
    }*/
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 400
        default:
            return 70
        }
    }
}
