//
//  WarningViewController.swift
//  TourGuideTracking
//
//  Created by Duc Nguyen on 11/11/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import UIKit
import GoogleMaps

class WarningViewController: UIViewController {

    @IBOutlet weak var contentTextView: TextViewRoundConner!
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var locationTextFiled: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        self.tabBarController?.hidesBottomBarWhenPushed = true
        setRecognizer()
        NotificationCenter.default.addObserver(self, selector: #selector(WarningViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(WarningViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

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
                self.view.frame.origin.y -= keyboardSize.height/2
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
                self.view.frame.origin.y += keyboardSize.height/2
            }
        }
    }
}

extension WarningViewController:  GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        locationTextFiled.text = "\(mapView.camera.target.latitude), \(mapView.camera.target.longitude)"
    }
}
