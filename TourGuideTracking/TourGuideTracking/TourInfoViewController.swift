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
    var schedules:[Schedule]!
    var selectedArray : [NSMutableArray] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set row height dynamic
        //self.tourInfoTableView.rowHeight = UITableViewAutomaticDimension
        //self.tourInfoTableView.estimatedRowHeight = 140
        
        tourInfoTableView.delegate = self
        tourInfoTableView.dataSource = self
        tourInfoTableView.reloadData()
        self.tour = (tabBarController as! CustomTabBarController).currentTour
        self.schedules = [Schedule]()
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
                    self.schedules = schedules
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
        detailsVC.place = Singleton.sharedInstance.places[7]
    }
}

extension TourInfoViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.TOUR_INFO_CELL) as! TourInfoCell
            cell.tour = tour
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.SCHEDULE_CELL) as! ScheduleCell
            cell.schedule = schedules[indexPath.row]
            return cell

        default:
            return UITableViewCell()
        }
       
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return schedules?.count ?? 0
        default:
            return 0
            
        }
        //return 2//schedules?.count ?? 0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "Ngày 1 - 20/01/2017"
        default:
            return ""
        }
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
            return 382
        case 1:
            return 96
        default:
            return 0
        }
    }
}
