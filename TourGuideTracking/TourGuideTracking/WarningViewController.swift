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

class WarningViewController: BaseViewController {

    @IBOutlet weak var mapView: GMSMapView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        self.tabBarController?.hidesBottomBarWhenPushed = true
        setRecognizer()
        NotificationCenter.default.addObserver(self, selector: #selector(WarningViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(WarningViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

    }
    @IBAction func sendWarning(_ sender: Any) {
        
            appDelegate.tourguideHub?.invoke("updatePositionTourGuide", arguments: ["TG_1", "1234", "24324324", "MG_1"] ) { (result, error) in
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
