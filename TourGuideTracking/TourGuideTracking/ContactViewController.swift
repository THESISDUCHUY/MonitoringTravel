//
//  ContactViewController.swift
//  TourGuideTracking
//
//  Created by Quoc Huy Ngo on 11/1/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import UIKit
import MBProgressHUD
class ContactViewController: UIViewController{

    @IBOutlet weak var contactTableView: UITableView!
    var tour:Tour!
    override func viewDidLoad() {
        super.viewDidLoad()
        contactTableView.estimatedRowHeight = 100
        contactTableView.rowHeight = UITableViewAutomaticDimension
        loadNib()
        let tabBar = (self.tabBarController as! CustomTabBarController)
        tour = tabBar.currentTour
        managerGet()
    }
    
    func loadNib(){
        contactTableView.register(UINib(nibName: "ContactCell", bundle: nil), forCellReuseIdentifier: "ContactCell")
    }
    
    func touristGet(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let url = URLs.makeURL_EXTEND(url: URLs.URL_GET_TOURS, extend: URL_EXTEND.TOURISTS_INFO, param: tour.tourId!)
        NetworkService<Tourist>.makeGetRequest(URL: url){
          response, error in
            if error == nil{
                let message = response?.message
                if message == nil{
                    let tourists = response?.listData
                    Singleton.sharedInstance.tourists = tourists
                    self.contactTableView.delegate = self
                    self.contactTableView.dataSource = self
                    self.contactTableView.reloadData()
                }
                else{
                     Alert.showAlertMessage(userMessage: message!, vc: self)
                }
            }
            else{
                Alert.showAlertMessage(userMessage: ERROR_MESSAGE.CONNECT_SERVER , vc: self)
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    func managerGet(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let url = URLs.makeURL(url: URLs.URL_GET_MANAGER, param: tour.managerId!)
        NetworkService<Manager>.makeGetRequest(URL: url){
            response, error in
            if error == nil{
                let message = response?.message
                if message == nil{
                    let manager = response?.data
                    Singleton.sharedInstance.manager = manager
                    self.contactTableView.delegate = self
                    self.contactTableView.dataSource = self
                    self.contactTableView.reloadData()
                    //self.touristGet()
                }
                else{
                    Alert.showAlertMessage(userMessage: message!, vc: self)
                }
            }
            else{
                Alert.showAlertMessage(userMessage: ERROR_MESSAGE.CONNECT_SERVER , vc: self)
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
}

extension ContactViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
            case 0:
                return 1
            case 1:
                return  Singleton.sharedInstance.tourists.count
            default:
                return 0
        }
       
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.CONTACT_CELL) as! ContactCell
        let user:User!
        if indexPath.section == 0{
            user = Singleton.sharedInstance.manager
        }
        else{
            user = Singleton.sharedInstance.tourists[indexPath.row]
        }
        cell.user = user
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var titleHeader:String =  ""
        if section == 0{
            titleHeader = "Quản lý"
        }
        else{
            titleHeader = "Du khách"
        }
        
        
        let  headerCell = UIView(frame: CGRect(x: 0 , y: 0, width: tableView.frame.size.width , height: 40 ))
        headerCell.backgroundColor = UIColor.white
        
        let headerBackground = UIView(frame: CGRect(x: 0   , y: 0, width: tableView.frame.size.width , height: 30 ))
        headerBackground.backgroundColor = UIColor(colorLiteralRed: 64/255, green: 165/255, blue: 226/255, alpha: 0.85)
        headerCell.addSubview(headerBackground)
        
        let titleLabel = UILabel(frame: CGRect(x: 15, y: 2, width: 160, height: 25))
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont(name: "Helvetica", size: 15)
        titleLabel.text = titleHeader
        titleLabel.textColor = UIColor.white
        headerBackground.addSubview(titleLabel)
        return headerCell
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Quản lý"
        }
        else{
            return "Du khách"
        }
        
    }
}
