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
    var selectedTour = Tour()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //toursTableView.delegate = self
        self.navigationItem.hidesBackButton = true
        tourGuideGet()
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
        cell.coverImageView.setImageWith(URL(string:(Singleton.sharedInstance.tours?[row].coverPhoto)!)!)
        return cell
    }
    
     //naviagate to MyTours View
    func tableView(_ tableView: UITableView, didSelectRowAt: IndexPath){
       
    
        //let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        //let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: ViewIdentifier.TAB_BAR) as! UITabBarController
        //let myToursVC = self.storyboard?.instantiateViewController(withIdentifier:ViewIdentifier.MYTOURS_VIEW)
        //self.navigationController?.pushViewController(tabBarController, animated: true)
        //let rootViewController = mainStoryBoard.instantiateInitialViewController(performSegue(withIdentifier: <#T##String#>, sender: self))
        //let navController = UINavigationController(rootViewController: myToursVC!)
        //self.present(tabBarController, animated: true)
       
        

        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //appDelegate.window?.rootViewController = tabBarController
        performSegue(withIdentifier: SegueIdentifier.TO_TAB_BAR, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let index = toursTableView.indexPathForSelectedRow?.row
        let tabBar = segue.destination as! UITabBarController
        let nav = tabBar.viewControllers?[0] as! UINavigationController
        let tourDetails = nav.topViewController as! MapViewController
        tourDetails.tour = Singleton.sharedInstance.tours?[index!]
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
        MBProgressHUD.showAdded(to: self.view, animated: true)
        NetworkService<Tour>.makeGetRequest(URL: URLs.makeURL_EXTEND(url:URLs.URL_GET_TOURGUIDE, extend: URL_EXTEND.TOURS, param: (Singleton.sharedInstance.tourguide?.tourGuideId)!)){
            response, error in
            if error == nil{
                let message = response?.message
                if message == nil{
                    let tours:[Tour] = (response?.listData)!
                    Singleton.sharedInstance.tours = tours
                    self.toursTableView.reloadData()
                }
                else{
                    //do something with message
                }
                
            }
            else{
                
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
}
