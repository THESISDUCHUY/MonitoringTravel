//
//  WarningDetailViewController.swift
//  TourGuideTracking
//
//  Created by Duc Nguyen on 11/19/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import UIKit
import GoogleMaps
import SwiftR

class WarningDetailViewController: BaseViewController {

    @IBOutlet weak var vMapView: GMSMapView!
    

    
    @IBOutlet weak var btnNeedHelp: ButtonRoundCorner!
    
    @IBOutlet weak var lbPriorityWarning: UILabel!
    @IBOutlet weak var lbCategoryWarning: UILabel!
    @IBOutlet weak var lbWarningName: UILabel!
    @IBOutlet weak var lbDescriptionWarning: UILabel!
    @IBOutlet weak var btnConfirmWarning: ButtonRoundCorner!
    
    
    var warningData : Dictionary<String, Any>?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var warningId : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if(self.warningData != nil)
        {
            let warningName = warningData?["WarningName"] as? String
            let categoryWarnig = warningData?["CategoryWarnig"] as? String
            let descriptiontionWarning = warningData?["DescriptionWarning"] as? String
            
            print( "data warning  \(warningData!)");
            
            let lat = warningData?["Lat"] as? Double
            let long = warningData?["Long"] as? Double
            let distance = warningData?["Distance"] as! Double
            
            warningId = warningData?["WarningId"] as? String
            
            self.lbWarningName.text = warningName
            self.lbCategoryWarning.text = categoryWarnig
            self.lbDescriptionWarning.text = descriptiontionWarning
            self.lbPriorityWarning.text = "Normal"
            
            let ivMarkerWarning = UIImage(named: "ic_marker_warning")
            
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
            marker.icon = ivMarkerWarning
            marker.map = self.vMapView
            marker.title = "Warning"
            
            
            let circ = GMSCircle(position: CLLocationCoordinate2D(latitude: lat!, longitude: long!), radius: distance * 1000)
            circ.fillColor = UIColor(red: 255/255, green: 153/255, blue: 51/255, alpha: 0.2)
            
            circ.strokeColor = UIColor(red: 255/255, green: 153/255, blue: 51/255, alpha: 0.5)
            circ.strokeWidth = 1;
            circ.map = self.vMapView;
            
            let camera = GMSCameraPosition.camera(withLatitude: lat!, longitude: long!, zoom: 12.0)
            vMapView.animate(to: camera)

        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    @IBAction func confirmWarning(_ sender: Any) {
        
        appDelegate.tourguideHub?.invoke("confirmWarning", arguments: [warningId, Singleton.sharedInstance.tourguide.tourGuideId] ) { (result, error) in
            if let e = error {
                #if DEBUG
                    
                    self.showMessage("Error confirmWarning: \(e)")
                    
                #else
                    
                #endif
                
            } else {
                print("Success!")
                if let r = result {
                    print("Result: \(r)")
                }
            }
        }
    }

    @IBAction func needHelp(_ sender: Any) {
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
