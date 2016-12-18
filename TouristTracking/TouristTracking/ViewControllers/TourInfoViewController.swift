//
//  TouInfoViewController.swift
//  TouristTracking
//
//  Created by Quoc Huy Ngo on 12/6/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import UIKit
import MBProgressHUD

class TourInfoViewController: UIViewController {

    @IBOutlet weak var tourScheduleTableView: UITableView!
    @IBOutlet weak var tourInfoTableView: UITableView!
    @IBOutlet weak var vHightLightInfo: UIView!
    @IBOutlet weak var vHightLightSchedule: UIView!
    @IBOutlet weak var sclMain: UIScrollView!
    var tour:Tour!
    var schedulesDay:[ScheduleDay]!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadNib()
        
        tourInfoTableView.estimatedRowHeight = 250
        tourInfoTableView.rowHeight = UITableViewAutomaticDimension
        tourScheduleTableView.estimatedRowHeight = 250
        tourScheduleTableView.rowHeight = UITableViewAutomaticDimension
        
        sclMain.delegate = self
        
        tour = Singleton.sharedInstance.tour
        schedulesDay = [ScheduleDay]()
        placesInfoGet()
    }
    
    @IBAction func onLichTrinhButton(_ sender: Any) {
        sclMain.contentOffset.x  =  sclMain.frame.width
        updateHightlight(page:1)
    }
    
    @IBAction func onThongTinButton(_ sender: Any) {
        sclMain.contentOffset.x  =  0
        updateHightlight(page:0)
    }
    
    func loadNib(){
        tourInfoTableView.register(UINib(nibName: "TourInfoCell", bundle: nil), forCellReuseIdentifier: "TourInfoCell")
        tourScheduleTableView.register(UINib(nibName: "ScheduleCell", bundle: nil), forCellReuseIdentifier: "ScheduleCell")
    }
    
    func placesInfoGet(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let url = URLs.makeURL_EXTEND(url: URLs.URL_GET_TOURS, extend: URL_EXTEND.PLACES, param: (tour?.tourId!)!)
        NetworkClient<Place>.makeGetRequest(URL: url){
            response, error in
            if error == nil{
                let message = response?.message
                if message == nil{
                    let places = response?.listData
                    Singleton.sharedInstance.places = places
                    self.tourScheduleGet()
                }
                else{
                    Alert.showAlertMessage(userMessage: message!, vc: self)
                }
            }
            else {
                Alert.showAlertMessage(userMessage: ERROR_MESSAGE.CONNECT_SERVER, vc: self)
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }
        
    }
    
    func tourScheduleGet(){
        let url = URLs.makeURL_EXTEND(url: URLs.URL_GET_TOURS, extend: URL_EXTEND.SCHEDULE, param: (tour?.tourId!)!)
        NetworkClient<Schedule>.makeGetRequest(URL: url){
            response, error in
            if error == nil{
                let message = response?.message
                if message == nil{
                    let schedules = response?.listData
                    self.schedulesDay = ScheduleDay.getSchdulesDay(allSchedules: schedules!, tour: self.tour!)
                    self.tourScheduleTableView.delegate = self
                    self.tourScheduleTableView.dataSource = self
                    self.tourScheduleTableView.reloadData()
                    
                    self.tourInfoTableView.delegate = self
                    self.tourInfoTableView.dataSource = self
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
}

extension TourInfoViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == tourInfoTableView{
            return 1
        }
        else{
            return (schedulesDay?.count)!
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tourInfoTableView{
            return 1
        }
        else{
            if (schedulesDay?[section].isHidden)!{
                return 0
            }
            else{
                return schedulesDay![section].schedules!.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tourInfoTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.TourInfoCell, for: indexPath) as! TourInfoCell
            cell.tour = tour
            return cell

        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.ScheduleCell) as! ScheduleCell
            let schedule = schedulesDay?[indexPath.section].schedules?[indexPath.row]
            cell.schedule = schedule
            return cell

        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == tourScheduleTableView{
            return schedulesDay?[section].getDateString()
        }
        else{
            return ""
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == tourScheduleTableView{
            var titleHeader:String =  ""
            titleHeader = (schedulesDay?[section].getDateString())!
            
            let  headerCell = UIView(frame: CGRect(x: -5   , y: 0, width: tableView.frame.size.width , height: 40 ))
            headerCell.backgroundColor = UIColor.white
            
            let headerBackground = UIView(frame: CGRect(x: 0   , y: 0, width: 130 , height: 25 ))
            headerBackground.backgroundColor = UIColor(colorLiteralRed: 64/255, green: 165/255, blue: 226/255, alpha: 0.85)
            
            headerBackground.layer.cornerRadius = 5
            
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
        if(schedulesDay?[section].isHidden)!{
            schedulesDay?[section].isHidden = false
        }
        else{
            schedulesDay?[section].isHidden = true
        }
        tourScheduleTableView.reloadSections(IndexSet(integer:section), with: .automatic)
    }
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
