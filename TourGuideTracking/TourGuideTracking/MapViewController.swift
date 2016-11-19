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
import UIColor_Hex_Swift

public enum StatusConnection {
    case connected
    case disconnected
    case reconnected
    case reconnecting
    case error
    case starting
    case slow
}

class MapViewController: BaseViewController {
    
    @IBOutlet weak var vIconStatusConnection: ViewRoundCorner!
    @IBOutlet weak var vStatusConnection: ViewRoundCorner!
    
    @IBOutlet weak var consVTopStatusTourist: NSLayoutConstraint!
    @IBOutlet weak var lbStatusTourist: UILabel!
    @IBOutlet weak var vStatusTourist: UIView!
    @IBOutlet weak var consTopVStatusConnection: NSLayoutConstraint!
    @IBOutlet weak var lbStatusConnection: UILabel!
    @IBOutlet weak var vInfoPlace: ViewRoundCorner!
    @IBOutlet weak var displaySegmented: UISegmentedControl!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var vWarning: UIView!
    @IBOutlet weak var tvWarning: UITextView!
    @IBOutlet weak var btnSendWarning: UIButton!
    @IBOutlet weak var consTopVWarning: NSLayoutConstraint!
    @IBOutlet weak var vBackgroundWarning: UIView!
    @IBOutlet weak var vMenu: UIView!
    @IBOutlet weak var vInfoTourist: UIView!
    @IBOutlet weak var consTopMenu: NSLayoutConstraint!
    
    
    @IBOutlet weak var vPopupWarning: ViewRoundCorner!
    @IBOutlet weak var lbWarningName: UILabel!
    
    @IBOutlet weak var lbCateWarning: UILabel!
    @IBOutlet weak var lbDescriptionWarning: UILabel!
    @IBOutlet weak var lbPriotiryWarning: UILabel!
    
    @IBOutlet weak var btnDetailWarning: UIButton!
    
    var tour:Tour!
    var tourguideHub: Hub?
    var connection: SignalR?
    var locationManager:CLLocationManager = CLLocationManager();
    var markerSelected: GMSMarker?
    
    var isConnected: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.hidesBottomBarWhenPushed = true
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        
        let tabBar = (self.tabBarController as! CustomTabBarController)
        tabBar.currentTour = tour
        connectServer()
        //displaySegmented.selectedSegmentIndex = 0
        
        let gestPan = UIPanGestureRecognizer(target: self, action: #selector(MapViewController.didDragMap))
        gestPan.delaysTouchesEnded = true
        
        self.mapView.addGestureRecognizer(gestPan)
        self.mapView.settings.consumesGesturesInView = false
        
        
        self.mapView.delegate = self
        InitView()
        //getPlacesLocation()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if (Singleton.sharedInstance.places?.count == 0)
        {
            getPlacesLocation()
        }
    }
    
    
    
    
    func InitView()
    {
        tvWarning.layer.borderColor = UIColor.lightGray.cgColor
        tvWarning.layer.borderWidth = 0.5
        tvWarning.layer.cornerRadius = 5
        tvWarning.layer.masksToBounds = true
    }
    
    @IBAction func showMenu(_ sender: Any) {
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        UIView.animate(withDuration: 0.3, animations:
            {
                self.consTopMenu.constant = -64
                self.view.layoutIfNeeded()
        })
        
    }
    
    @IBAction func hiddenMenu(_ sender: Any) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        UIView.animate(withDuration: 0.3, animations:
            {
                self.consTopMenu.constant = -536
                self.view.layoutIfNeeded()
                
        })
        
        alertDisconnection(receiver: "MG_" + String(describing: self.tour.managerId!), sender: "TG_" + String(describing: Singleton.sharedInstance.tourguide.tourGuideId!), senderUserName: Singleton.sharedInstance.tourguide.name!)
        
        
        SwiftR.stopAll()
        
    }
    @IBAction func displayLocationSegmentedValueChanged(_ sender: AnyObject) {
        
        hiddenPopupInfoPlace()
        hiddenPopupInfoTourist()
        if(markerSelected != nil)
            
        {
            markerSelected = nil
        }
        
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
        self.setMapView(lat: (places?[0].location?.latitude!)!, long: (places?[0].location?.longitude!)!)
        
        for place in places!{
            createMarker(latitude: place.location.latitude!, longitude: place.location.longitude!, data:place, isTourist: false).map = mapView
        }
        
    }
    
    
    func displayTouristOnMap(){
        let tourists = Singleton.sharedInstance.tourists
        self.setMapView(lat: (tourists?[0].location?.latitude!)!, long: (tourists?[0].location?.longitude!)!)
        
        for tourist in tourists!{
            createMarker(latitude: tourist.location!.latitude!, longitude: tourist.location!.longitude!, data:tourist, isTourist: true).map = mapView
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if self.displaySegmented.selectedSegmentIndex == 0{
            let placeDetailsVC = segue.destination as! PlaceDetailsViewController
            placeDetailsVC.place = markerSelected as! Place
        }
    }

    
    
    //MARK: Realtime Server
    
    func connectServer(){
        SwiftR.useWKWebView = false
        
        SwiftR.signalRVersion = .v2_2_1
        
        //let urlServerRealtime = "http://tourtrackingv2.azurewebsites.net/signalr/hubs"
        
        let urlServerRealtime = "http://192.168.0.104:3407/signalr/hubs"
        
        connection = SwiftR.connect(urlServerRealtime) { [weak self]
            connection in
            connection.queryString = ["USER_POSITION" : "TG", "MANAGER_ID" : "MG_" + String(describing: (self?.tour.managerId!)!) , "USER_ID" : "TG_" + String(describing: Singleton.sharedInstance.tourguide.tourGuideId!), "USER_NAME" : String(describing: Singleton.sharedInstance.tourguide.name!)]
            self?.tourguideHub = connection.createHubProxy("hubServer")
            
            self?.tourguideHub?.on("updateNumberOfOnline"){ args in
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
            
            self?.tourguideHub?.on("initTouristConnected"){ args in
                let touristName = args![2] as! String
                self?.touristConnected(usernameTourist: touristName)
                
            }
            
            self?.tourguideHub?.on("managerOnline"){ args in
                self?.initCurrentLocation(receiver: "MG_" + String(describing: (self?.tour.managerId)!), tourguide: Singleton.sharedInstance.tourguide!, tour: (self?.tour)!)
            }
            
            self?.tourguideHub?.on("receiverWarning"){ args in
                
                let objectData: AnyObject = args![0] as AnyObject!
                
                print(objectData)

                
                let warningName = objectData["WarningName"] as? String
                let categoryWarnig = objectData["CategoryWarnig"] as? String
                let descriptiontionWarning = objectData["DescriptionWarning"] as? String
                let lat = objectData["Lat"] as? Double
                let long = objectData["Long"] as? Double
                let distance = objectData["Distance"] as! Double
                
                self?.lbWarningName.text = warningName
                self?.lbCateWarning.text = categoryWarnig
                self?.lbDescriptionWarning.text = descriptiontionWarning
                self?.lbPriotiryWarning.text = "Normal"
                

                let ivMarkerWarning = UIImage(named: "ic_marker_warning")
                
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
                marker.icon = ivMarkerWarning
                marker.map = self?.mapView
                marker.userData = objectData
                marker.title = "Warning"
                
         
                let circ = GMSCircle(position: CLLocationCoordinate2D(latitude: lat!, longitude: long!), radius: distance * 1000)
                circ.fillColor = UIColor(red: 255/255, green: 153/255, blue: 51/255, alpha: 0.2)
                
                circ.strokeColor = UIColor(red: 255/255, green: 153/255, blue: 51/255, alpha: 0.5)
                circ.strokeWidth = 1;
                circ.map = self?.mapView;
               
                
                let positionMarker = self?.mapView.projection.point(for: marker.position)
                
                let newPositionMarker = CGPoint(x: (positionMarker?.x)!, y: (positionMarker?.y)! - 100)
                
                let camera = GMSCameraUpdate.setTarget((self?.mapView.projection.coordinate(for:newPositionMarker))!)
                
                self?.mapView.animate(with: camera)
                
                UIView.animate(withDuration: 1, animations: { 
                    
                    self?.vPopupWarning.isHidden = false
                    self?.view.layoutIfNeeded()
                })
                
            }
            
        }
        
        connection!.starting = { [weak self] in
            print("Starting...")
            self?.updateStatusConnection(status: StatusConnection.starting)
        }
        
        connection!.reconnecting = { [weak self] in
            print("Reconnecting...")
            self?.updateStatusConnection(status: StatusConnection.reconnecting)
        }
        
        connection!.connected = { [weak self] in
            
            print("Connection ID: \(self?.connection!.connectionID!)")
            self?.updateStatusConnection(status: StatusConnection.connected)
            
            self?.initCurrentLocation(receiver: "MG_" + String(describing: (self?.tour.managerId)!), tourguide: Singleton.sharedInstance.tourguide!, tour: (self?.tour)!)
        }
        
        connection!.reconnected = { [weak self] in
            
            print("Reconnected. Connection ID: \(self?.connection?.connectionID!)")
            self?.updateStatusConnection(status: StatusConnection.reconnected)
        }
        
        connection!.disconnected = { [weak self] in
            print("Disconnected...")
            self?.updateStatusConnection(status: StatusConnection.disconnected)
        }
        
        connection!.connectionSlow = { print("Connection slow...") }
        
        connection!.error = { error in
            
            print("Error: \(error)")
            // Here's an example of how to automatically reconnect after a timeout.
            //
            // For example, on the device, if the app is in the background long enough
            // for the SignalR connection to time out, you'll get disconnected/error
            // notifications when the app becomes active again.
            
            if let source = error?["source"] as? String, source == "TimeoutException" {
                print("Connection timed out. Restarting...")
                self.connection!.start()
            }
        }
        
        
    }
    
    func updateNumberOfOnline(number: String) {
        
        vStatusConnection.backgroundColor = UIColor(rgba: "#D9F7D7")
        lbStatusConnection.textColor = UIColor(rgba: "#259360")
        lbStatusConnection.text = "Connected: " + number + " Tourist"
    }
    
    func updateStatusConnection(status: StatusConnection )
    {
        if(status == .starting)
        {
            
            vStatusConnection.backgroundColor = UIColor(rgba: "#D7EBF9")
            lbStatusConnection.textColor = UIColor(rgba: "#6BA1C8")
            lbStatusConnection.text = "Staring connection..."
            vIconStatusConnection.backgroundColor = UIColor(rgba: "#D7EBF9")

            
            UIView.animate(withDuration: 1, animations: {
                self.consTopVStatusConnection.constant = 5
                self.view.layoutIfNeeded()
            })
            
        }
        if(status == .connected)
        {
            //view.layer.backgroundColor
            vStatusConnection.backgroundColor = UIColor(rgba: "#D9F7D7")
            lbStatusConnection.textColor = UIColor(rgba: "#259360")
            lbStatusConnection.text = "Connected"
            vIconStatusConnection.backgroundColor = UIColor(rgba: "#259360")
        }
        else if(status == .disconnected)
        {
            vStatusConnection.backgroundColor = UIColor(rgba: "#F5DDDD")
            lbStatusConnection.textColor = UIColor(rgba: "#CC3A3A")
            lbStatusConnection.text = "Disconnect"
            
            vIconStatusConnection.backgroundColor = UIColor(rgba: "#CC3A3A")
            
            //self.alertDisconnection(receiver: "MG_" + String(describing: self.tour.managerId!), sender: "TG_" + String(describing: Singleton.sharedInstance.tourguide.tourGuideId!), senderUserName: Singleton.sharedInstance.tourguide.name!)
            
            
            //            self.alertDisconnection(receiver:
            //                "MG_" + (self.tour.managerId! as! String), sender: "TG_" + (Singleton.sharedInstance.tourguide.tourGuideId! as! String))
            
        }
        else if(status == .reconnecting)
        {
            vStatusConnection.backgroundColor = UIColor(rgba: "#D7EBF9")
            lbStatusConnection.textColor = UIColor(rgba: "#6BA1C8")
            lbStatusConnection.text = "Reconnecting..."
            
            vIconStatusConnection.backgroundColor = UIColor(rgba: "#6BA1C8")
        }
        else if(status == .reconnected)
        {
            vStatusConnection.backgroundColor = UIColor(rgba: "#D7EBF9")
            lbStatusConnection.textColor = UIColor(rgba: "#6BA1C8")
            lbStatusConnection.text = "Reconnected"
            vIconStatusConnection.backgroundColor = UIColor(rgba: "#6BA1C8")
            
        }
        else if(status == .error)
        {
            vStatusConnection.backgroundColor = UIColor(rgba: "#F5DDDD")
            lbStatusConnection.textColor = UIColor(rgba: "#CC3A3A")
            lbStatusConnection.text = "Not found server"
            vIconStatusConnection.backgroundColor = UIColor(rgba: "#CC3A3A")
            
        }
        
    }
    
    // Send location for Manager
    func initCurrentLocation(receiver: String, tourguide: TourGuide, tour: Tour)
    {
        
        let user_lat = String(format: "%f", (locationManager.location?.coordinate.latitude)!)
        let user_long = String(format: "%f", (locationManager.location?.coordinate.longitude)!)
        
        
        tourguideHub?.invoke("initMarkerNewConection", arguments: [user_lat, user_long, receiver, tourguide.tourGuideId!, tourguide.name!, tour.tourId!] ) { (result, error) in
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
    
    
    func alertDisconnection(receiver: String, sender: String, senderUserName: String)
    {
        tourguideHub?.invoke("removeUserDisconnection", arguments: [receiver, sender, senderUserName] ) { (result, error) in
            if let e = error {
                #if DEBUG
                    
                    self.showMessage("Error removeUserDisconnection: \(e)")
                    
                #else
                    
                #endif
                
            } else {
                print("Success!")
                if let r = result {
                    print("Result: \(r)")
                }
            }
        }
        
        SwiftR.stopAll()
    }
    
    func updateLocation(latitude:Double, longitude:Double){
        
        let receiver = "MG_" + String(describing: (self.tour.managerId)!)
        let senderId =  Singleton.sharedInstance.tourguide!.tourGuideId
        tourguideHub?.invoke("updatePositionTourGuide", arguments: [senderId, latitude, longitude, receiver])
    }
    
    // MARK: Tourist
    
    func touristConnected(usernameTourist: String)
    {
        
        vStatusTourist.backgroundColor = UIColor(rgba: "#D9F7D7")
        lbStatusTourist.textColor = UIColor(rgba: "#259360")
        lbStatusTourist.text = usernameTourist + " Has just Connected"
        
        UIView.animate(withDuration: 1, animations: {
            self.consVTopStatusTourist.constant = 0
            self.view.layoutIfNeeded()
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: {
            UIView.animate(withDuration: 1, animations: {
                self.consVTopStatusTourist.constant = -40
                self.view.layoutIfNeeded()
            })
        })
    }
    
    func touristDisconnected(usernameTourist: String)
    {
        vStatusTourist.backgroundColor = UIColor(rgba: "#F5DDDD")
        lbStatusTourist.textColor = UIColor(rgba: "#CC3A3A")
        lbStatusTourist.text = usernameTourist + " Has just Connected"
        
        UIView.animate(withDuration: 1, animations: {
            self.consVTopStatusTourist.constant = 0
            self.view.layoutIfNeeded()
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: {
            UIView.animate(withDuration: 1, animations: {
                self.consVTopStatusTourist.constant = -40
                self.view.layoutIfNeeded()
            })
        })
    }
    
    // MARK: Popup warning
    
    @IBAction func closeWarningPopup(_ sender: Any) {
        HiddenWarningPopup()
        
    }
    
    func ShowWarningPopup() {
        
        vBackgroundWarning.isHidden = false
        UIView.animate(withDuration: 0.5, animations:
            {
                //self.vWarning.isHidden = false
                self.consTopVWarning.constant = 100
                self.view.layoutIfNeeded();
        })
    }
    
    func HiddenWarningPopup() {
        
        UIView.animate(withDuration: 0.5, animations:
            {
                self.consTopVWarning.constant = -300
                self.view.layoutIfNeeded();
        }, completion: { finished in
            self.vBackgroundWarning.isHidden = true
        })
        
        view.endEditing(true)
        
    }
    @IBAction func warningForTourist(_ sender: Any) {
        
        self.hiddenPopupInfoTourist()
        self.ShowWarningPopup()
    }
    
    
    // MARK: Alert Inform Warning Option
    @IBAction func showWarningInformOption(_ sender: Any) {
        
        alertInformWarningOption();
    }
    var alertController = UIAlertController();
    
    func alertInformWarningOption()
    {
        self.alertController = UIAlertController(title: "Menu", message: "Vui lòng chọn cảnh báo hoặc thông báo", preferredStyle: .alert)
        let buttonOne = UIAlertAction(title: "Cảnh báo chung", style: .default, handler: { (action) -> Void in
            self.performSegue(withIdentifier: "warningSegue", sender: self)
        })
        let buttonTwo = UIAlertAction(title: "Thông báo chung", style: .default, handler: { (action) -> Void in
            self.performSegue(withIdentifier: "informSegue", sender: self)
        })
        let buttonCancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            
        }
        alertController.addAction(buttonOne)
        alertController.addAction(buttonTwo)
        alertController.addAction(buttonCancel)
        
        present(alertController, animated: true, completion: nil)
    }
    
}

extension MapViewController: GMSMapViewDelegate{
    
    func didDragMap()
    {
        hiddenPopupInfoTourist()
        hiddenPopupInfoPlace()
        hiddenPopupWarning()
        if(markerSelected != nil)
        {
            if self.displaySegmented.selectedSegmentIndex == 0
            {
                removeMarkerSelect(marker: markerSelected!, latitude: (markerSelected?.position.latitude)!, longitude: (markerSelected?.position.longitude)!, data: markerSelected?.userData as AnyObject?, isTourist: false).map = mapView
            }
            else
            {
                removeMarkerSelect(marker: markerSelected!, latitude: (markerSelected?.position.latitude)!, longitude: (markerSelected?.position.longitude)!, data: markerSelected?.userData as AnyObject?, isTourist: true).map = mapView
            }
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        mapView.selectedMarker = marker
       
        
        let positionMarker = mapView.projection.point(for: marker.position)
        
        let newPositionMarker = CGPoint(x: positionMarker.x, y: positionMarker.y - 100)
        
        let camera = GMSCameraUpdate.setTarget(mapView.projection.coordinate(for:newPositionMarker))
        
        mapView.animate(with: camera)

        print(marker.title)
        
        if(marker.title == "Warning")
        {
            let dataMarker = marker.userData as! Dictionary<String, Any>
            showPopupWaring(dataWarning: dataMarker)
            print(dataMarker)
        
        }
        else
        {
            if self.displaySegmented.selectedSegmentIndex == 0
            {
                if(markerSelected != nil)
                {
                    removeMarkerSelect(marker: markerSelected!, latitude: (markerSelected?.position.latitude)!, longitude: (markerSelected?.position.longitude)!, data: markerSelected?.userData as AnyObject?, isTourist: false).map = mapView
                }
                updateMarkerSelect(marker: marker, latitude: marker.position.latitude, longitude: marker.position.longitude, data: marker.userData as AnyObject?, isTourist: false).map = mapView
                showPopupInfoPlace()
            }
                
            else
            {
                if(markerSelected != nil)
                {
                    removeMarkerSelect(marker: markerSelected!, latitude: (markerSelected?.position.latitude)!, longitude: (markerSelected?.position.longitude)!, data: markerSelected?.userData as AnyObject?, isTourist: true).map = mapView
                }
                updateMarkerSelect(marker: marker, latitude: marker.position.latitude, longitude: marker.position.longitude, data: marker.userData as AnyObject?, isTourist: true).map = mapView
                showPopupInfoTourist()
            }
            
            markerSelected = marker
        
        }
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        hiddenPopupInfoTourist()
        hiddenPopupInfoPlace()
        if(markerSelected != nil)
        {
            if self.displaySegmented.selectedSegmentIndex == 0
            {
                removeMarkerSelect(marker: markerSelected!, latitude: (markerSelected?.position.latitude)!, longitude: (markerSelected?.position.longitude)!, data: markerSelected?.userData as AnyObject?, isTourist: false).map = mapView
            }
            else
            {
                removeMarkerSelect(marker: markerSelected!, latitude: (markerSelected?.position.latitude)!, longitude: (markerSelected?.position.longitude)!, data: markerSelected?.userData as AnyObject?, isTourist: true).map = mapView
            }
        }
        
    }
    
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        if self.displaySegmented.selectedSegmentIndex == 0{
            self.performSegue(withIdentifier: "SeguePlaceDetails", sender: self)
        }
    }
    
    
    func setMapView(lat:Double = 0, long:Double = 0) {
        
//        mapView.clear()
//        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 12.0)
//        mapView.animate(to: camera)
//        mapView.isMyLocationEnabled = true
        
    }
    
    func createMarker(latitude:Double, longitude:Double, data:AnyObject?, isTourist: Bool) -> GMSMarker{
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.userData = data
        
        if isTourist{
            
            let ivmarker = UIImage(named: "2")
            let ivAvatar = UIImage(named: "ic_avatar")
            
            drawMarker(marker: marker, image: ivAvatar!, markerImage: ivmarker!)
            
            
        }else{
            
            let ivmarker = UIImage(named: "3")
            let ivAvatar = UIImage(named: "ic_avatar")
            
            drawMarker(marker: marker, image: ivAvatar!, markerImage: ivmarker!)
        }
        
        return marker
    }
    
    func updateMarkerSelect(marker: GMSMarker ,latitude:Double, longitude:Double, data:AnyObject?, isTourist: Bool) -> GMSMarker{
        
        marker.map = nil
        
        if isTourist{
            
            let ivmarker = UIImage(named: "4")
            let ivAvatar = UIImage(named: "ic_avatar")
            
            drawMarker(marker: marker, image: ivAvatar!, markerImage: ivmarker!)
            
            
        }else{
            
            let ivmarker = UIImage(named: "4")
            let ivAvatar = UIImage(named: "ic_avatar")
            
            drawMarker(marker: marker, image: ivAvatar!, markerImage: ivmarker!)
        }
        return marker
    }
    
    func removeMarkerSelect(marker: GMSMarker ,latitude:Double, longitude:Double, data:AnyObject?, isTourist: Bool) -> GMSMarker{
        
        marker.map = nil
        
        if isTourist{
            
            let ivmarker = UIImage(named: "2")
            let ivAvatar = UIImage(named: "ic_avatar")
            
            drawMarker(marker: marker, image: ivAvatar!, markerImage: ivmarker!)
            
            
        }else{
            
            let ivmarker = UIImage(named: "3")
            let ivAvatar = UIImage(named: "ic_avatar")
            
            drawMarker(marker: marker, image: ivAvatar!, markerImage: ivmarker!)
        }
        markerSelected = nil
        return marker
    }
    
    
    
    func drawMarker(marker: GMSMarker ,image: UIImage, markerImage: UIImage ) {
        
        let markerWidth  = 64
        let markerHeight = 76
        
        let imageWith = 58
        let topSpace = 3
        
        if(image == nil && markerImage == nil)
        {
            return
        }
        
        let vTemp = UIView(frame: CGRect(x: 0, y: 0, width: markerWidth, height: markerHeight))
        vTemp.backgroundColor = UIColor.clear
        
        let ivMarker = UIImageView(frame: CGRect(x: 0, y: 0, width: markerWidth, height: markerHeight))
        ivMarker.backgroundColor = UIColor.clear
        
        
        
        let ivPhoto = UIImageView(frame: CGRect(x: topSpace, y: topSpace, width: imageWith, height: imageWith))
        ivPhoto.backgroundColor = UIColor.clear
        ivPhoto.contentMode = UIViewContentMode.scaleAspectFill
        ivPhoto.clipsToBounds = true
        ivPhoto.layer.cornerRadius = ivPhoto.frame.size.width / 2
        ivPhoto.layer.masksToBounds = true
        
        
        vTemp.addSubview(ivPhoto)
        vTemp.addSubview(ivMarker)
        
        ivMarker.image = markerImage
        ivPhoto.image = image
        
        UIGraphicsBeginImageContextWithOptions(vTemp.bounds.size, false, image.scale)
        vTemp.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        marker.icon = finalImage
        
    }
    
    func showPopupWaring(dataWarning: Dictionary<String, Any>)
    {
        
        
        let warningName = dataWarning["WarningName"] as? String
        let categoryWarnig = dataWarning["CategoryWarnig"] as? String
        let descriptiontionWarning = dataWarning["DescriptionWarning"] as? String
        self.lbWarningName.text = warningName
        self.lbCateWarning.text = categoryWarnig
        self.lbDescriptionWarning.text = descriptiontionWarning
        self.lbPriotiryWarning.text = "Normal"
        
        UIView.animate(withDuration: 1, animations: {
            
            self.vPopupWarning.isHidden = false
            self.view.layoutIfNeeded()
        })
        
    }
    
    func hiddenPopupWarning()
    {
        UIView.animate(withDuration: 1, animations: {
            
            self.vPopupWarning.isHidden = true
            self.view.layoutIfNeeded()
        })
    }
    
    func showPopupInfoTourist()
    {
        UIView.animate(withDuration: 0.3, animations:
            {
                self.vInfoTourist.isHidden = false
                self.view.layoutIfNeeded()
        })
    }
    
    func hiddenPopupInfoTourist()
    {
        UIView.animate(withDuration: 0.3, animations:
            {
                self.vInfoTourist.isHidden = true
                self.view.layoutIfNeeded()
        })
    }
    
    func showPopupInfoPlace()
    {
        UIView.animate(withDuration: 0.3, animations:
            {
                self.vInfoPlace.isHidden = false
                self.view.layoutIfNeeded()
        })
    }
    
    func hiddenPopupInfoPlace()
    {
        UIView.animate(withDuration: 0.3, animations:
            {
                self.vInfoPlace.isHidden = true
                self.view.layoutIfNeeded()
        })
    }
    
    
}


extension MapViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print(locations[0].coordinate.latitude)
        
//                if let hub = chatHub, {
//                    hub.invoke("updateLocation", arguments: ["37.121300", "-95.416603"])
//                }
                updateLocation(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude);
    }
}


