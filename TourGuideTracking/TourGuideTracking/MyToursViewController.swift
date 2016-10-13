//
//  MyToursViewController.swift
//  TourGuideTracking
//
//  Created by Quoc Huy Ngo on 10/11/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import UIKit

class MyToursViewController: UIViewController, UITableViewDataSource{

    @IBOutlet weak var toursTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //toursTableView.delegate = self
        self.navigationItem.hidesBackButton = true
        
        //get tourguide info
        tourGuideGet()
        
        //toursGet()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows:Int = (Singleton.sharedInstance.tours?.count)!
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.TOUR_CELL, for: indexPath) as! TourTableViewCell
        
        let row = (indexPath as NSIndexPath).row
        cell.tourNameLabel.text = Singleton.sharedInstance.tours?[row].name
        return cell
    }

    func tourGuideGet(){
        NetworkService<TourGuide>.makeGetRequest(URL: URLs.makeURL(url: URLs.URL_GET_TOURGUIDE, param: Settings.tourguide_id!) ){
            response, error in
            if error == nil{
                let message = response?.message
                if message == nil{
                    let tourguide = response?.data
                    Singleton.sharedInstance.tourguide = tourguide
                    self.toursGet()
                }
                else{
                    
                }
            }
            else{
                
            }
        }
    }
    
    func toursGet(){
        NetworkService<Tour>.makeGetRequest(URL: URLs.makeURL_EXTEND(url:URLs.URL_GET_TOURGUIDE, extend: URL_EXTEND.EX_TOURS, param: (Singleton.sharedInstance.tourguide?.tourGuideId)!)){
            response, error in
            if error == nil{
                let message = response?.message
                if message == nil{
                    let tours:[Tour] = (response?.listData)!
                    Singleton.sharedInstance.tours = tours
                    self.toursTableView.dataSource = self
                    self.toursTableView.reloadData()
                }
                else{
                    //do something with message
                }
                
            }
            else{
                
            }
        }
    }
}
