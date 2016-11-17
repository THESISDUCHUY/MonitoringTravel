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
    
    @IBOutlet weak var sclMain: UIScrollView!

    @IBOutlet weak var vHightLightSchedule: UIView!
    @IBOutlet weak var vHightLightInfo: UIView!
    @IBOutlet weak var tourInfoTableView: UITableView!
    @IBOutlet weak var tourScheduleTableView: UITableView!

    var tour:Tour!
    var schedulesDay:[ScheduleDay]!
    var selectedArray : [NSMutableArray] = []
    var currentPlaceSelected:Place!
    var isHeaderTapped:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
         schedulesDay = [ScheduleDay]()
        loadNib()
        
        sclMain.delegate = self
        //set row height dynamic
        tourInfoTableView.estimatedRowHeight = 280
        tourInfoTableView.rowHeight = UITableViewAutomaticDimension
        
        tourInfoTableView.delegate = self
        tourInfoTableView.dataSource = self
        tourInfoTableView.reloadData()
        
        tourScheduleTableView.estimatedRowHeight = 140
        tourScheduleTableView.rowHeight = UITableViewAutomaticDimension
        tourScheduleTableView.delegate = self
        tourScheduleTableView.dataSource = self
        tourScheduleTableView.reloadData()
        
        self.tour = (tabBarController as! CustomTabBarController).currentTour
        getTourSchedule()
    }
    
    func loadNib(){
         tourInfoTableView.register(UINib(nibName: "TourInfoCell", bundle: nil), forCellReuseIdentifier: "TourInfoCell")
        tourScheduleTableView.register(UINib(nibName: "ScheduleCell", bundle: nil), forCellReuseIdentifier: "ScheduleCell")
    }
    
    func getTourSchedule(){
        let url = URLs.makeURL_EXTEND(url: URLs.URL_GET_TOURS, extend: URL_EXTEND.SCHEDULE, param: tour.tourId!)
         NetworkService<Schedule>.makeGetRequest(URL: url){
            response, error in
            if error == nil{
                let message = response?.message
                if message == nil{
                    let schedules = response?.listData
                    self.schedulesDay = ScheduleDay.getSchdulesDay(allSchedules: schedules!, tour: self.tour)
                    self.tourInfoTableView.reloadData()
                    self.tourScheduleTableView.reloadData()
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
    
    @IBAction func onThongTinButton(_ sender: AnyObject) {
        sclMain.contentOffset.x  =  0
        updateHightlight(page:0)

    }
    
    @IBAction func onLichTrinhButton(_ sender: AnyObject) {
        sclMain.contentOffset.x  =  sclMain.frame.width
        updateHightlight(page:1)

    }
}

extension TourInfoViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tourInfoTableView{
    
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.TOUR_INFO_CELL, for: indexPath) as! TourInfoCell
            cell.tour = tour
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.SCHEDULE_CELL) as! ScheduleCell
            cell.schedule = schedulesDay[indexPath.section].schedules?[indexPath.row]
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == tourInfoTableView{
            return 1
        }
        else{
            return schedulesDay.count
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tourInfoTableView{
            return 1
        }
        else{
            if schedulesDay[section].isHidden{
                return 0
            }
            else{
                  return schedulesDay[section].schedules!.count
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == tourScheduleTableView{
            return schedulesDay[section].getDateString()
        }
        else{
            return ""
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == tourScheduleTableView{
            var titleHeader:String =  ""
            titleHeader = schedulesDay[section].getDateString()
            
            let  headerCell = UIView(frame: CGRect(x: 0   , y: 0, width: tableView.frame.size.width , height: 40 ))
            headerCell.backgroundColor = UIColor.white
            
            let headerBackground = UIView(frame: CGRect(x: 0   , y: 0, width: 160 , height: 25 ))
            headerBackground.backgroundColor = UIColor(colorLiteralRed: 64/255, green: 165/255, blue: 226/255, alpha: 0.85)
            headerCell.addSubview(headerBackground)
            
            let titleLabel = UILabel(frame: CGRect(x: 15, y: 0, width: 160, height: 25))
            titleLabel.textColor = UIColor.black
            titleLabel.font = UIFont(name: "Helvetica", size: 15)
            titleLabel.text = titleHeader
            titleLabel.textColor = UIColor.white
            headerBackground.addSubview(titleLabel)
            headerCell.tag = section
            //let headerCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.SCHEDULE_CELL) as! ScheduleCell
            //headerCell.headerCellSection = section
            
            // Add gesture
            
            let headerTapGesture = UITapGestureRecognizer()
            headerTapGesture.addTarget(self, action:  #selector(onHeaderSectionTapped))
            headerCell.addGestureRecognizer(headerTapGesture)
            
            return headerCell

        }
        else{
            return UIView()
        }
    }
    
    func onHeaderSectionTapped (sender: UITapGestureRecognizer) {
        let headerCell = sender.view! as UIView
        let section = headerCell.tag
        if(schedulesDay[section].isHidden){
            schedulesDay[section].isHidden = false
        }
        else{
            schedulesDay[section].isHidden = true
        }
        tourScheduleTableView.reloadSections(IndexSet(integer:section), with: .automatic)
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        switch indexPath.section {
//        case 0:
//            return 382
//        case 1:
//            return 96
//        default:
//            return 0
//        }
//    }
}
extension TourInfoViewController: UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = sclMain.contentOffset.x / sclMain.frame.width
        updateHightlight(page: integer_t(page))
    }
    
    
    
    func updateHightlight(page: integer_t)
    {
        vHightLightInfo.layer.opacity = 0
        vHightLightSchedule.layer.opacity = 0
        
        if(page == 0)
        {
            vHightLightInfo.layer.opacity = 1
        }
        else if(page == 1)
        {
            vHightLightSchedule.layer.opacity = 1
        }
    }

}
