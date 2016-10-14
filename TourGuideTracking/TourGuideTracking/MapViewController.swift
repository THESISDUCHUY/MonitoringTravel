//
//  MapViewController.swift
//  TourGuideTracking
//
//  Created by Quoc Huy Ngo on 10/14/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

class MapViewController: UIViewController, CLLocationManagerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func loadView() {
        
        //get current location
        let curentLocation = getCurrentLocation()
        
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: curentLocation.latitude!, longitude: curentLocation.latitude!, zoom: 12.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        view = mapView

        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: curentLocation.latitude!, longitude: curentLocation.longitude!)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
    }
    
    func getCurrentLocation()->Location{
        let locManager = CLLocationManager()
        locManager.requestWhenInUseAuthorization()
        var currentLocation = CLLocation()
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            currentLocation = locManager.location!
        }
        return Location(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
    }
}
