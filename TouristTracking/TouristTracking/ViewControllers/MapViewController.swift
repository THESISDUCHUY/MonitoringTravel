//
//  MapViewController.swift
//  TouristTracking
//
//  Created by Quoc Huy Ngo on 12/13/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import UIKit
import GoogleMaps
import SwiftR
import UIColor_Hex_Swift
import MBProgressHUD

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var vIconStatusConnection: ViewRoundCorner!
    @IBOutlet weak var vStatusConnection: ViewRoundCorner!
    @IBOutlet weak var statusConnectionLabel: UILabel!
    @IBOutlet weak var statusNameLabel: UILabel!

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var locationManager:CLLocationManager = CLLocationManager();
    var isConnected: Bool?
    var isUpdateLocation: Bool = false
    var isDisconnect:Bool = false
    var tour:Tour!
    
    override func viewDidLoad() {
        self.tabBarController?.hidesBottomBarWhenPushed = true
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        tour = Tour()
        touristInfoGet()
        
        super.viewDidLoad()
    }
    
    @IBAction func rightBarButtonTouch(_ sender: Any) {
        let warningPopup = InformWarningPopup() //frame: CGRect(x: 10, y: 100, width: 300, height: 200)
        warningPopup.frame = view.bounds
        //let w  = WarningPopup()
        //w.frame = view.bounds
        view.addSubview(warningPopup)
    }
    
    func tourInfoGet(){
        let url = URLs.makeURL(url: URLs.URL_GET_TOURS, param: Singleton.sharedInstance.tourist.tourId!)
        NetworkClient<Tour>.makeGetRequest(URL: url){
            response, error in
            if error == nil{
                let message = response?.message
                if message == nil{
                    self.tour = response?.data
                    Singleton.sharedInstance.tour = self.tour
                    self.connectServer()
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
    
    func touristInfoGet(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let url = URLs.makeURL(url: URLs.URL_GET_TOURIST, param: Settings.tourist_id!)
        NetworkClient<Tourist>.makeGetRequest(URL: url){
            response, error in
            if error == nil{
                let message = response?.message
                if message == nil{
                    let tourist = response?.data
                    Singleton.sharedInstance.tourist = tourist
                    self.tourInfoGet()
                }
                else{
                    Alert.showAlertMessage(userMessage: message!, vc: self)
                }
            }
            else{
                Alert.showAlertMessage(userMessage: ERROR_MESSAGE.CONNECT_SERVER, vc: self)
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    func connectServer(){
        
        SwiftR.useWKWebView = false
        
        SwiftR.signalRVersion = .v2_2_1
        
        let urlServerRealtime = "http://tourtrackingv2.azurewebsites.net/signalr/hubs"
        
        //let urlServerRealtime = "http://192.168.1.190:3407/signalr/hubs"
        
        appDelegate.connection = SwiftR.connect(urlServerRealtime) { [weak self]
            connection in
            let tr = Singleton.sharedInstance.tourist
            connection.queryString = ["USER_POSITION" : "TR", "MANAGER_ID" : "TG_" + String(describing: (self?.tour.tourguideId)!) , "USER_ID" : "TR_" + String(describing: Singleton.sharedInstance.tourist.touristId!), "USER_NAME" : String(describing: Singleton.sharedInstance.tourist.name!)]
            self?.appDelegate.touristHub = connection.createHubProxy("hubServer")
            self?.statusNameLabel.text = Singleton.sharedInstance.tourist.name!
            
            
            self?.appDelegate.touristHub?.on("updateNumberOfOnline"){ args in
                let groupName = args![0] as! String
                let numberOfOnline = args![1] as! String
                
                if(groupName.contains("GROUP_MANAGER"))
                {
                    
                }
                else
                {
                    self?.updateNumberOfOnline(number: numberOfOnline)
                    print("Message: \(groupName)\nDetail: \(numberOfOnline)")
                    
                }
            }
        }
        
        appDelegate.connection!.starting = { [weak self] in
            print("Starting...")
            self?.updateStatusConnection(status: StatusConnection.starting)
        }
        
        appDelegate.connection!.reconnecting = { [weak self] in
            print("Reconnecting...")
            self?.updateStatusConnection(status: StatusConnection.reconnecting)
        }
        
        appDelegate.connection!.connected = { [weak self] in
            
            print("Connection ID: \(self?.appDelegate.connection!.connectionID!)")
            self?.updateStatusConnection(status: StatusConnection.connected)
            
            self?.initCurrentLocation(receiver: "TG_" + String(describing: (self?.tour.tourguideId)!), tourist: Singleton.sharedInstance.tourist!, tour: (self?.tour)!)
        }
        
        appDelegate.connection!.reconnected = { [weak self] in
            
            print("Reconnected. Connection ID: \(self?.appDelegate.connection?.connectionID!)")
            self?.updateStatusConnection(status: StatusConnection.reconnected)
            self?.isDisconnect = false
        }
        
        appDelegate.connection!.disconnected = { [weak self] in
            print("Disconnected...")
            self?.isDisconnect = true
            //self?.timer()
            self?.updateStatusConnection(status: StatusConnection.disconnected)
        }
        
        appDelegate.connection!.connectionSlow = { print("Connection slow...") }
        
        appDelegate.connection!.error = { error in
            
            print("Error: \(error)")
            if let source = error?["source"] as? String, source == "TimeoutException" {
                print("Connection timed out. Restarting...")
                self.appDelegate.connection!.start()
            }
        }
    }
    
    func updateNumberOfOnline(number: String) {
        vStatusConnection.backgroundColor = UIColor(rgba: "#D9F7D7")
        statusConnectionLabel.textColor = UIColor(rgba: "#259360")
        statusConnectionLabel.text = "Connected - " + number + " Tourist"
    }
    
    func updateStatusConnection(status: StatusConnection )
    {
        if(status == .starting)
        {
            
            vStatusConnection.backgroundColor = UIColor(rgba: "#FFFFFF")
            statusConnectionLabel.textColor = UIColor(rgba: "#6BA1C8")
            statusConnectionLabel.text = "Staring connection..."
            vIconStatusConnection.backgroundColor = UIColor(rgba: "#D7EBF9")
            
            UIView.animate(withDuration: 1, animations: {
                //self.consTopVStatusConnection.constant = 5
                self.view.layoutIfNeeded()
            })
            
        }
        if(status == .connected)
        {
            //view.layer.backgroundColor
            vStatusConnection.backgroundColor = UIColor(rgba: "#D9F7D7")
            statusConnectionLabel.textColor = UIColor(rgba: "#259360")
            statusConnectionLabel.text = "Connected"
            vIconStatusConnection.backgroundColor = UIColor(rgba: "#259360")
        }
        else if(status == .disconnected)
        {
            vStatusConnection.backgroundColor = UIColor(rgba: "#F5DDDD")
            statusConnectionLabel.textColor = UIColor(rgba: "#CC3A3A")
            statusConnectionLabel.text = "Disconnect"
            vIconStatusConnection.backgroundColor = UIColor(rgba: "#CC3A3A")
            
            
        }
        else if(status == .reconnecting)
        {
            vStatusConnection.backgroundColor = UIColor(rgba: "#D7EBF9")
            statusConnectionLabel.textColor = UIColor(rgba: "#6BA1C8")
            statusConnectionLabel.text = "Reconnecting..."
            
            vIconStatusConnection.backgroundColor = UIColor(rgba: "#6BA1C8")
        }
        else if(status == .reconnected)
        {
            vStatusConnection.backgroundColor = UIColor(rgba: "#D7EBF9")
            statusConnectionLabel.textColor = UIColor(rgba: "#6BA1C8")
            statusConnectionLabel.text = "Reconnected"
            vIconStatusConnection.backgroundColor = UIColor(rgba: "#6BA1C8")
            
        }
        else if(status == .error)
        {
            vStatusConnection.backgroundColor = UIColor(rgba: "#F5DDDD")
            statusConnectionLabel.textColor = UIColor(rgba: "#CC3A3A")
            statusConnectionLabel.text = "Not found server"
            vIconStatusConnection.backgroundColor = UIColor(rgba: "#CC3A3A")
            
        }
        
    }

    func touristConnected(usernameTourist: String)
    {
        
        vStatusConnection.backgroundColor = UIColor(rgba: "#D9F7D7")
        statusConnectionLabel.textColor = UIColor(rgba: "#259360")
        statusConnectionLabel.text = usernameTourist + " Has just Connected"
        
        UIView.animate(withDuration: 1, animations: {
            //self.consVTopStatusTourist.constant = 0
            self.view.layoutIfNeeded()
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: {
            UIView.animate(withDuration: 1, animations: {
                //self.consVTopStatusTourist.constant = -40
                self.view.layoutIfNeeded()
            })
        })
    }
    
    func updateLocation(latitude:Double, longitude:Double){
        
        let receiver = "TG_" + String(describing: (self.tour.tourguideId)!)
        let senderId =  Singleton.sharedInstance.tourist.touristId
        let tourId = self.tour.tourId
        
        appDelegate.touristHub?.invoke("updatePositionTourGuide", arguments: [senderId, tourId, latitude, longitude, receiver])
    }
    
    
    func initCurrentLocation(receiver: String, tourist: Tourist, tour: Tour)
    {
        if(locationManager.location != nil)
        {
            let user_lat = locationManager.location?.coordinate.latitude
            let user_long = locationManager.location?.coordinate.longitude
            
            appDelegate.touristHub?.invoke("initTouristConnection", arguments: [user_lat, user_long, receiver, tourist.name, tourist.touristId!,] ) { (result, error) in
                if let e = error {
                    #if DEBUG
                        
                        Alert.showAlertMessage(userMessage: "Error initTouristConnection: \(e)", vc: self)
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
    }

}

extension MapViewController : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if(tour.tourId != nil && Singleton.sharedInstance.tourist != nil){
            updateLocation(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        }
   
    }
}
