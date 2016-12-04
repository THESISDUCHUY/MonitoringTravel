//
//  WarningViewController.swift
//  TourGuideTracking
//
//  Created by Quoc Huy Ngo on 11/24/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import UIKit
import MBProgressHUD

class WarningViewController: UIViewController {

    @IBOutlet weak var warningTableView: UITableView!
    var tour:Tour!
    var warnings:[Warning]!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tour = (tabBarController as! CustomTabBarController).currentTour
        warnings = [Warning]()
        warningTableView.delegate = self
        warningTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        getWarnings()
    }
    
    func getWarnings(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let url = URLs.makeURL_EXTEND(url: URLs.URL_GET_TOURS, extend: URL_EXTEND.WARNING, param: tour.tourId!)
        NetworkService<Warning>.makeGetRequest(URL: url){
            response, error in
            if error == nil{
                let message = response?.message
                if message == nil{
                    self.warnings = (response?.listData)!
                    self.warningTableView.reloadData()
                }
                else{
                    Alert.showAlertMessage(userMessage: message!, vc: self)
                }
            }
            else {
                Alert.showAlertMessage(userMessage: ERROR_MESSAGE.CONNECT_SERVER , vc: self)
            }
            MBProgressHUD.hide(for: self.view, animated: true)

        }
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let index = warningTableView.indexPathForSelectedRow?.row
        let WarningDetailVC = segue.destination as! WarningDetailViewController
        WarningDetailVC.warning = warnings[index!]
    }
}

extension WarningViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return warnings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.WARNING_CELL) as! WarningCell
        cell.warning = warnings[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: SegueIdentifier.TO_WARNING_DETAIL, sender: self)
    }
}
