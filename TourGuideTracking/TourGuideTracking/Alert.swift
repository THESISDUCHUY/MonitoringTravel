//
//  Alert.swift
//  TourGuideTracking
//
//  Created by Quoc Huy Ngo on 10/11/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import UIKit

class Alert{
    static func showAlertMessage(userMessage:String, vc:UIViewController){
        let alert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alert.addAction(okAction)
        vc.present(alert, animated: true, completion: nil)
    }
    
    static func showAlertMessageAndDismiss(userMessage:String, vc:UIViewController){
        let alert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{ ( action:UIAlertAction) in
            vc.navigationController?.popViewController(animated: true)
        })
        alert.addAction(okAction)
        vc.present(alert, animated: true, completion: nil)
    }
}
