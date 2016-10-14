//
//  MyToursViewController.swift
//  TourGuideTracking
//
//  Created by Quoc Huy Ngo on 10/11/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import UIKit
import MBProgressHUD
import AFNetworking

class MyToursViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{


    @IBOutlet weak var toursTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //toursTableView.delegate = self
        self.navigationItem.hidesBackButton = true
        
        //get tourguide info
        toursGet()
        self.toursTableView.dataSource = self
        self.toursTableView.delegate = self
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
        cell.coverImageView.setImageWith(URL(string:URLs.URL_IMAGE_BASE+(Singleton.sharedInstance.tours?[row].coverPhoto)!)!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt: IndexPath){
        //naviagate to MyTours View
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = mainStoryBoard.instantiateViewController(withIdentifier: ViewIdentifier.TAB_BAR) as! UITabBarController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = tabBarController
    }
    func toursGet(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        NetworkService<Tour>.makeGetRequest(URL: URLs.makeURL_EXTEND(url:URLs.URL_GET_TOURGUIDE, extend: URL_EXTEND.EX_TOURS, param: (Singleton.sharedInstance.tourguide?.tourGuideId)!)){
            response, error in
            if error == nil{
                let message = response?.message
                if message == nil{
                    let tours:[Tour] = (response?.listData)!
                    Singleton.sharedInstance.tours = tours
                    self.toursTableView.reloadData()
                    MBProgressHUD.hide(for: self.view, animated: true)
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
