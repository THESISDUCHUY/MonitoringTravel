//
//  WarningViewController.swift
//  TourGuideTracking
//
//  Created by Duc Nguyen on 11/11/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import UIKit
import GoogleMaps

import SwiftR

class WarningTouristViewController: BaseViewController {

    @IBOutlet weak var contentTextView: TextViewRoundConner!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var locationTextFiled: UITextField!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        self.tabBarController?.hidesBottomBarWhenPushed = true
        setRecognizer()
        NotificationCenter.default.addObserver(self, selector: #selector(WarningTouristViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(WarningTouristViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

    }
    @IBAction func sendWarning(_ sender: Any) {
        let latitude = mapView.camera.target.latitude
        let longitude = mapView.camera.target.longitude
        let name:String = titleTextField.text!
        let content:String = contentTextView.text
        var tourists_id:[Int] = [Int]()
        for tourist in Singleton.sharedInstance.tourists{
            tourists_id.append(tourist.touristID!)
        }
        let informData = [
            "lat": latitude,
            "long": longitude,
            "informName": name,
            "description": content,
            "tourist": tourists_id
        ] as [String : Any]

       // tourguideHub?.invoke("updatePositionTourGuide", arguments: [senderId, latitude, longitude, receiver])
            appDelegate.tourguideHub?.invoke("informForTourist", arguments: [informData] ) { (result, error) in
                if let e = error {
                    #if DEBUG
                        
                        self.showMessage("Error initMarkerNewConection: \(e)")
                        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onWarningButton(_ sender: Any) {
        
    }
    func setRecognizer(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTapScreen(_ : )))
        // Attach it to a view of your choice. If it's a UIImageView, remember to enable user interaction
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @IBAction func onTapScreen(_ sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        /*bottomConstraint.constant = 250
         UIView.animate(withDuration: 0.3) {
         self.view.layoutIfNeeded()
         }*/
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height/1.5
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        /*bottomConstraint.constant = 149
         UIView.animate(withDuration: 0.3) {
         self.view.layoutIfNeeded()
         }*/
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height/1.5
            }
        }
    }
}

extension WarningTouristViewController:  GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        locationTextFiled.text = "\(mapView.camera.target.latitude), \(mapView.camera.target.longitude)"
    }
}
