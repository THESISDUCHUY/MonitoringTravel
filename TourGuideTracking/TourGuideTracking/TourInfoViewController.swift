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
    var isHeaderTapped:Bool = false
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
            if(schedulesDay[section - 1].isHidden){
                return 0
            }
            else{
                return (schedulesDay[section - 1].schedules?.count)!
            }
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
        if indexPath.section == 0{
            return
        }
        
        let place_id = schedulesDay[indexPath.section - 1].schedules?[indexPath.row].place_id
        for place in Singleton.sharedInstance.places{
            if place.placeId == place_id{
                self.currentPlaceSelected = place
                break
            }
        }
        self.performSegue(withIdentifier: SegueIdentifier.PLACE_DETAIL, sender: self)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var titleHeader:String =  ""
        if section != 0{
            titleHeader = schedulesDay[section - 1].getDateString()
        }

        let  headerCell = UIView(frame: CGRect(x: 0   , y: 0, width: tableView.frame.size.width , height: 50 ))
        headerCell.backgroundColor = UIColor.gray
        
        let titleLabel = UILabel(frame: CGRect(x: 15, y: 0, width: 320, height: 30))
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont(name: "Helvetica", size: 15)
        titleLabel.text = titleHeader
        headerCell.addSubview(titleLabel)
        headerCell.tag = section
        //let headerCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.SCHEDULE_CELL) as! ScheduleCell
        //headerCell.headerCellSection = section
        
        // Add gesture
    
        let headerTapGesture = UITapGestureRecognizer()
        headerTapGesture.addTarget(self, action:  #selector(onHeaderSectionTapped))
        headerCell.addGestureRecognizer(headerTapGesture)
        
        return headerCell
    }
    
    func onHeaderSectionTapped (sender: UITapGestureRecognizer) {
        let headerCell = sender.view! as UIView
        let section = headerCell.tag
        if(schedulesDay[section - 1].isHidden){
            schedulesDay[section - 1].isHidden = false
        }
        else{
             schedulesDay[section - 1].isHidden = true
        }
        tourInfoTableView.reloadSections(IndexSet(integer:section), with: .automatic)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 400
        default:
            return 70
        }
    }
}
