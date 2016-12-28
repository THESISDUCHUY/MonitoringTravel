//
//  WarningDetailViewController.swift
//  TouristTracking
//
//  Created by Quoc Huy Ngo on 12/26/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import UIKit
import GoogleMaps
class WarningDetailViewController: UIViewController {
    
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    
    var warning:Warning?
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmButton.addTarget(self, action: #selector(onConfirmButton(_:)), for: .touchDown)
        if(self.warning != nil)
        {
            
            titleLabel.text = warning?.name
            typeLabel.text = warning?.type
            descriptionLabel.text = warning?.description
            levelLabel.text = "Normal"
            
            let ivMarkerWarning = UIImage(named: "ic_marker_warning")
            
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: (warning?.location?.latitude)!, longitude: (warning?.location?.longitude)!)
            marker.icon = ivMarkerWarning
            marker.map = mapView
            marker.title = "Warning"
            
            let camera = GMSCameraPosition.camera(withLatitude: (warning?.location?.latitude)!, longitude: (warning?.location?.longitude)!, zoom: 12.0)
            mapView.animate(to: camera)
            
            if warning?.status != "Opening"{
                confirmButton.isEnabled = false
            }
        }

    }
    
    func onConfirmButton(_ sender: UIButton){
        print("confirm button")
    }
}
