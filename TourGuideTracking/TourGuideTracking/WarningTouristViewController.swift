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
    var tour:Tour!
    var content:String = "Nội dung cảnh báo!"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentTextView.delegate = self
        contentTextView.text = content
        setMap()
        self.tabBarController?.hidesBottomBarWhenPushed = true
        setRecognizer()
        NotificationCenter.default.addObserver(self, selector: #selector(WarningTouristViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(WarningTouristViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

    }
    
    func setMap(){
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        if Singleton.sharedInstance.places.count > 0{
            if Singleton.sharedInstance.places?[0] != nil {
                let lat = (Singleton.sharedInstance.places?[0].location?.latitude)!
                let long = (Singleton.sharedInstance.places?[0].location?.longitude)!
                let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 12.0)
                mapView.animate(to: camera)
            }
        }
    }
    
    @IBAction func sendWarning(_ sender: Any) {
        let latitude = mapView.camera.target.latitude
        let longitude = mapView.camera.target.longitude
        let title:String = titleTextField.text!
        let content:String = contentTextView.text
        let tourguide_id = Singleton.sharedInstance.tourguide.tourGuideId
        appDelegate.tourguideHub?.invoke("warningForTourist", arguments: [tourguide_id, latitude, longitude, content, title]) { (result, error) in
            if let e = error {
                #if DEBUG
                    self.showMessage("Error initMarkerNewConection: \(e)")
                #else
                    
                #endif
                
            } else {
                print("Send Warning Success!")
                Alert.showAlertMessageAndDismiss(userMessage: "Da gui canh bao!", vc: self)
                //self.navigationController?.popViewController(animated: true)
                //self.dismiss(animated: true, completion: nil)
                if let r = result {
                    
                }
            }

        }
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
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 64{
                self.view.frame.origin.y -= keyboardSize.height/1.5
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
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

extension WarningTouristViewController: UITextViewDelegate{
    public func textViewDidBeginEditing(_ textView: TextViewRoundConner) {
        if textView.text == content {
            contentTextView.text = ""
            contentTextView.textColor = UIColor.black
        }
    }
    @nonobjc public func textViewDidEndEditing(_ textView: TextViewRoundConner){
        if textView.text == ""{
            contentTextView.text = content
            contentTextView.textColor = UIColor.gray
        }
    }

}
