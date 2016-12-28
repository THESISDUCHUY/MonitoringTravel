//
//  WarningViewController.swift
//  TouristTracking
//
//  Created by Quoc Huy Ngo on 12/26/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import UIKit
import MBProgressHUD
class WarningViewController: UIViewController {
    @IBOutlet weak var warningTableView: UITableView!
    var warnings:[Warning]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getWarnings()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! WarningDetailViewController
        let index = warningTableView.indexPathForSelectedRow?.row
        vc.warning = warnings[index!]
    }
    func getWarnings(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let url = URLs.makeURL_EXTEND(url: URLs.URL_GET_TOURIST, extend: URL_EXTEND.WARNING, param: Singleton.sharedInstance.tourist.touristId!)
        NetworkClient<Warning>.makeGetRequest(URL: url){
            response, error in
            if error == nil{
                let message = response?.message
                if message == nil{
                    self.warnings = (response?.listData)!
                    self.warnings.reverse()
                    self.warningTableView.delegate = self
                    self.warningTableView.dataSource = self
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
}

extension WarningViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return warnings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WarningCell") as! WarningCell
        cell.warning = warnings[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: SegueIdentifier.SegueWarningDetail, sender: self)
    }
}
