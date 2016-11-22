//
//  BaseViewController.swift
//  TourGuideTracking
//
//  Created by Duc Nguyen on 11/13/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import UIKit
import SwiftR

class BaseViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showConfirmWithTitle(_ title: String, message: String, acceptHandler: @escaping (() -> Void), cancelHandler:@escaping (() -> Void)) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let acceptAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) { (action) in
            acceptHandler()
        }
        let cancelAction = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel) { (action) in
            alertController.dismiss(animated: true, completion: {
                cancelHandler()
            })
        }
        alertController.addAction(acceptAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showMessage(_ message: String?) {
        if let message = message {
            let alertController = UIAlertController(title: "", message:
                message, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func showMessage(_ message: String?, title: String?) {
        if let message = message {
            let alertController = UIAlertController(title: title, message:
                message, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
}
