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
import SwiftR

class MapViewController: UIViewController {


    @IBOutlet weak var displaySegmented: UISegmentedControl!
    @IBOutlet weak var mapView: GMSMapView!
    var tour:Tour!
    var markerSelected:Any!
    var chatHub: Hub?
    var connection: SignalR?
    var cameraZoom:Float = 12.0
    
    var locationManager:CLLocationManager = CLLocationManager();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        //set timer
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.onTimer), userInfo: nil, repeats: true)
        
        let tabBar = (self.tabBarController as! CustomTabBarController)
        tabBar.currentTour = tour
        connectServer()
        //displaySegmented.selectedSegmentIndex = 0
        self.mapView.delegate = self
        getPlacesLocation()
    }
    @IBAction func displayLocationSegmentedValueChanged(_ sender: AnyObject) {
        if displaySegmented.selectedSegmentIndex == 0{
            if (Singleton.sharedInstance.places?.count == 0){
                getPlacesLocation()
            }
            else{
                displayPlacesOnMap()
            }
        }
        else{
            if Singleton.sharedInstance.tourists?.count == 0{
                getTouristsLocation()
            }
            else{
                displayTouristOnMap()
            }
        }
    }
    
    
    //get tour location
    func getPlacesLocation(){
        let url = URLs.makeURL_EXTEND(url: URLs.URL_GET_TOURS, extend: URL_EXTEND.PLACES, param: tour.tourId!)
        NetworkService<Place>.makeGetRequest(URL: url){
            response, error in
            if error == nil{
                let message = response?.message
                if message == nil{
                    let places = response?.listData
                    Singleton.sharedInstance.places = places
                    self.displayPlacesOnMap()
                    self.popupWarning()
                }
                else{
                    Alert.showAlertMessage(userMessage: message!, vc: self)
                }
            }
            else {
                Alert.showAlertMessage(userMessage: ERROR_MESSAGE.CONNECT_SERVER , vc: self)
            }
        }
    }
    
    func getTouristsLocation(){
        let url = URLs.makeURL_EXTEND(url: URLs.URL_GET_TOURS, extend: URL_EXTEND.TOURISTS_LOCATION, param: tour.tourId!)
        NetworkService<Tourist>.makeGetRequest(URL: url){
            response, error in
            if error == nil{
                let message = response?.message
                if message == nil{
                    let tourists = response?.listData
                    Singleton.sharedInstance.tourists = tourists
                    self.displayTouristOnMap()
                    //self.fakeLocation()
                    self.updateLocation(latitude: (tourists?[0].location?.latitude)!, longitude: (tourists?[0].location?.longitude)!)
                }
                else{
                    Alert.showAlertMessage(userMessage: message!, vc: self)
                }
            }
            else{
                Alert.showAlertMessage(userMessage: ERROR_MESSAGE.CONNECT_SERVER, vc: self)
            }
        }
    }
    
    func displayPlacesOnMap(){
        let places = Singleton.sharedInstance.places
        if (places?.count)! > 0{
            self.setMapView(lat: (places?[0].location?.latitude!)!, long: (places?[0].location?.longitude!)!)
            for place in places!{
                createMarker(latitude: place.location.latitude!, longitude: place.location.longitude!, data:place).map = mapView
            }
        }


    }
    
    func displayTouristOnMap(){
        let tourists = Singleton.sharedInstance.tourists
        if (tourists?.count)! > 0{
            self.setMapView(lat: (tourists?[0].location?.latitude!)!, long: (tourists?[0].location?.longitude!)!)
            for tourist in tourists!{
                createMarker(latitude: tourist.location!.latitude!, longitude: tourist.location!.longitude!, data:tourist).map = mapView
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if self.displaySegmented.selectedSegmentIndex == 0{
            let placeDetailsVC = segue.destination as! PlaceDetailsViewController
            placeDetailsVC.place = markerSelected as! Place
        }
    }
    
    func connectServer(){
        SwiftR.useWKWebView = false
    
        SwiftR.signalRVersion = .v2_2_0
        
        connection = SwiftR.connect("http://192.168.0.104:3407/signalr/hubs") { [weak self] connection in
            connection.queryString = ["MANAGER_ID" : "1", "USER_ID" : "TOURGUIDE_1"]
            self?.chatHub = connection.createHubProxy("hubServer")
           
            self?.chatHub?.on("broadcastMessage") { args in
                
                }
            }
        connection?.starting = { [weak self] in
            //self?.statusLabel.text = "Starting..."
            //self?.startButton.isEnabled = false
            //self?.sendButton.isEnabled = false
        }
        
        connection?.reconnecting = { [weak self] in
            //self?.statusLabel.text = "Reconnecting..."
            //self?.startButton.isEnabled = false
            //self?.sendButton.isEnabled = false
        }
        
        connection?.connected = { [weak self] in
            print("Connection ID: \(self?.connection?.connectionID!)")
            //self?.statusLabel.text = "Connected"
            //self?.startButton.isEnabled = true
            //self?.startButton.title = "Stop"
            //self?.sendButton.isEnabled = true
        }
        
        connection?.error = { error in
            print("Error connect1: \(error)")
            
            // Here's an example of how to automatically reconnect after a timeout.
            //
            // For example, on the device, if the app is in the background long enough
            // for the SignalR connection to time out, you'll get disconnected/error
            // notifications when the app becomes active again.
            
            if let source = error?["source"] as? String, source == "TimeoutException" {
                print("Connection timed out. Restarting...")
                self.connection?.start()
            }
        }

    }
    
    func updateLocation(latitude:Double, longitude:Double){
            chatHub?.invoke("updateLocation", arguments: [latitude, longitude])
    }

    func fakeLocation(){
        //while(true){
            for i in (0 ..< Singleton.sharedInstance.tourists.count){
                if i % 2 == 0{
                     Singleton.sharedInstance.tourists[i].location?.longitude =  (Singleton.sharedInstance.tourists[i].location?.longitude)! + 0.0001
                }
                else{
                    Singleton.sharedInstance.tourists[i].location?.latitude =  (Singleton.sharedInstance.tourists[i].location?.latitude)! + 0.0001
                }
               
            }
            displayTouristOnMap()
        //}
    }
    
    func onTimer() {
        if displaySegmented.selectedSegmentIndex == 1{
            cameraZoom = mapView.camera.zoom
            self.fakeLocation()
        }
       
    }
    var popup:Warning!
    func popupWarning(){
        popup = Warning(frame: CGRect(x: 10, y: 240, width: UIScreen.main.bounds.width - 50, height: 180))
        popup.contentLabel.text = "This is warning"
        popup?.confirmButton.addTarget(self, action: #selector(onConfirmTouchUp(_:)), for: .touchUpInside)
        createWarningMarker(latitude: 1.3368652, longitude: 103.7007477).map = mapView
        let camera = GMSCameraPosition.camera(withLatitude: 1.3368652, longitude: 1.3368652, zoom: self.cameraZoom)
        mapView.camera = camera
        self.view.addSubview(popup!)
    }
    
    func onConfirmTouchUp(_ sender: UIButton){
        popup?.contentView.removeFromSuperview()
    }
}

extension MapViewController: GMSMapViewDelegate{
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        var customInfoWindow:Any!
        if self.displaySegmented.selectedSegmentIndex == 0{
            let data = marker.userData as! Place
            self.markerSelected = data
            customInfoWindow = Bundle.main.loadNibNamed("CustomInfoWindow", owner: self, options: nil)?[0] as!  CustomInfoWindow
            (customInfoWindow as! CustomInfoWindow).place = data
        }
        else{
            let data = marker.userData as! Tourist
            self.markerSelected = data
            customInfoWindow = Bundle.main.loadNibNamed("TouristInfoWindow", owner: self, options: nil)?[0] as!  TouristInfoWindow
            (customInfoWindow as! TouristInfoWindow).tourist = data

        }
        
        return customInfoWindow as! UIView?
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        if self.displaySegmented.selectedSegmentIndex == 0{
            self.performSegue(withIdentifier: "SeguePlaceDetails", sender: self)
        }
    }
    func setMapView(lat:Double = 0, long:Double = 0) {
        mapView.clear()
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: self.cameraZoom)
        mapView.camera = camera
        mapView.isMyLocationEnabled = true
        
    }
    
    func createMarker(latitude:Double, longitude:Double, data:AnyObject?) -> GMSMarker{
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.userData = data
        return marker
    }
    
    func createWarningMarker(latitude:Double, longitude:Double)-> GMSMarker{
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.icon = createMarkerIcon()
        return marker
    }

    func createMarkerIcon() -> UIImage{
        return UIImage(named: "warning1")!
    }

}

extension MapViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        //setMapView(lat: (location?.coordinate.latitude)!, long: (location?.coordinate.longitude)!)
        //creteMarker(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, data: nil).map = mapView
        //print(location?.coordinate.latitude)
        //print(location?.coordinate.longitude)
        //locationManager.stopUpdatingLocation()
        //updateLocation(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude);
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location " + error.localizedDescription)
    }
}
