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

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var departureTimeLabel: UILabel!
    @IBOutlet weak var tourCodeLabel: UILabel!
    @IBOutlet weak var returnTimeLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var touristQuantityLabel: UILabel!
    
    var tour:Tour!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tour = (tabBarController as! CustomTabBarController).currentTour
        setTourInfo()
        getTourSchedule()
    }
    
    func setTourInfo(){
        self.coverImageView.setImageWith(URL(string:tour.coverPhoto!)!)
        self.departureTimeLabel.text = tour.departureDate
        self.returnTimeLabel.text = tour.returnDate
        self.tourCodeLabel.text = tour.code
        self.dayLabel.text = "5"
        self.touristQuantityLabel.text = String(format: "%d",tour.quantity!)
    }
    
    func getTourSchedule(){
        let url = URLs.makeURL_EXTEND(url: URLs.URL_GET_TOURS, extend: URL_EXTEND.SCHEDULE, param: tour.tourId!)
         NetworkService<Schedule>.makeGetRequest(URL: url){
            response, error in
            if error == nil{
                let message = response?.message
                if message == nil{
                    let schedules = response?.listData
                    Singleton.sharedInstance.schedules = schedules
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
