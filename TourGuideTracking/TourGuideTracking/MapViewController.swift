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
import MBProgressHUD
import UIColor_Hex_Swift
import SDWebImage
import Alamofire

class MapViewController: BaseViewController {
    
    @IBOutlet weak var ivCoverPhotoPlace: UIImageView!
    @IBOutlet weak var lbDistanceTourist: UILabel!
    @IBOutlet weak var lbTouristName: UILabel!
    @IBOutlet weak var lbContactPlacePopup: UILabel!
    @IBOutlet weak var lbNamePlacePopup: UILabel!
    @IBOutlet weak var lbUserName: UILabel!
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
    @IBOutlet weak var warning_help_ContentTextView: UITextView!
    @IBOutlet weak var warning_help_titleLabel: UILabel!
    @IBOutlet weak var warning_help_icon: ViewRoundCorner!
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
    
    
    var locationManager:CLLocationManager = CLLocationManager();
    var markerSelected: GMSMarker?
    var markerSelectedWarning: GMSMarker?
    var tour:Tour!
    var isConnected: Bool?
    var isUpdateLocation: Bool = false
    var isDisconnect:Bool = false
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var touristMarkers = [GMSMarker]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.hidesBottomBarWhenPushed = true
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        
        let tabBar = (self.tabBarController as! CustomTabBarController)
        
        tabBar.currentTour = tour
        appDelegate.tourShare = tour
        connectServer()
        fakeTouristLocation()
        
        let gestPan = UIPanGestureRecognizer(target: self, action: #selector(MapViewController.didDragMap))
        gestPan.delaysTouchesEnded = true
        
        self.mapView.addGestureRecognizer(gestPan)
        self.mapView.settings.consumesGesturesInView = false
        
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        
        self.mapView.delegate = self
        
        InitView()
        syncTracking()
    }
    

    func timerUpdateLocation(){
        Timer.scheduledTimer(withTimeInterval: 30, repeats: true, block: { (Timer) in
            self.isUpdateLocation = true
        })
    }
    override func viewDidAppear(_ animated: Bool) {
        
        if (Singleton.sharedInstance.places?.count == 0)
        {
           getPlacesLocation()
        }
        if(Singleton.sharedInstance.tourists?.count == 0)
        {
           touristGet()
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
    
    func InitView()
    {
        warning_help_ContentTextView.layer.borderColor = UIColor.lightGray.cgColor
        warning_help_ContentTextView.layer.borderWidth = 0.5
        warning_help_ContentTextView.layer.cornerRadius = 5
        warning_help_ContentTextView.layer.masksToBounds = true
        setRecognizer()
        btnSendWarning.addTarget(self, action: #selector(warning_help_Send(_:)), for: .touchDown)
        NotificationCenter.default.addObserver(self, selector: #selector(MapViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MapViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func warning_help_Send(_ sender: UIButton){
         self.hiddenWarningHelpPopup()
        let lat = String(format: "%f", (locationManager.location?.coordinate.latitude)!)
        let long = String(format: "%f", (locationManager.location?.coordinate.longitude)!)
        let content = warning_help_ContentTextView.text
        let tourguide_id = Singleton.sharedInstance.tourguide.tourGuideId
        let manager_id = "MG_1"
        appDelegate.tourguideHub?.invoke("needHelp", arguments: [tourguide_id, lat, long, content, manager_id]) { (result, error) in
            
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
    
    func keyboardWillShow(notification: NSNotification) {
        UIView.animate(withDuration: 0.5, animations:
            {
                //self.vWarning.isHidden = false
                self.consTopVWarning.constant = 50
                self.view.layoutIfNeeded();
        })
    }
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.5, animations:
            {
                //self.vWarning.isHidden = false
                self.consTopVWarning.constant = 100
                self.view.layoutIfNeeded();
        })
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
        
        //SwiftR.stopAll()
        
    }
    @IBAction func displayLocationSegmentedValueChanged(_ sender: AnyObject) {
        
        hiddenPopupInfoPlace()
        hiddenPopupInfoTourist()
        if(markerSelected != nil)
        {
            markerSelected = nil
        }
        
        if displaySegmented.selectedSegmentIndex == 0
        {
            
            if (Singleton.sharedInstance.places?.count != 0)
            {
                self.setMapView(lat: (Singleton.sharedInstance.places?[0].location?.latitude)!, long: (Singleton.sharedInstance.places?[0].location?.longitude)!)
            }
            
        }
        else
        {
            if(Singleton.sharedInstance.tourists?.count != 0)
            {
                self.setMapView(lat: (Singleton.sharedInstance.tourists?[0].location?.latitude)!, long: (Singleton.sharedInstance.tourists?[0].location?.longitude)!)
            }
            else
            {
                
            }
        }
    }
    
    //get tour location
    func getPlacesLocation(){
        
        //MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let url = URLs.makeURL_EXTEND(url: URLs.URL_GET_TOURS, extend: URL_EXTEND.PLACES, param: tour.tourId!)
        NetworkService<Place>.makeGetRequest(URL: url){
            response, error in
            if error == nil{
                let message = response?.message
                if message == nil{
                    let places = response?.listData
                    Singleton.sharedInstance.places = places
                    self.displayPlacesOnMap()
                    //MBProgressHUD.hide(for: self.view, animated: true)
                }
                else{
                    self.showMessage(message!)
                }
            }
            else {
                self.showMessage(ERROR_MESSAGE.CONNECT_SERVER, title: "Error")
            }
            //MBProgressHUD.hide(for: self.view, animated: true)
        }

    }
    
    func touristGet(){
        //MBProgressHUD.showAdded(to: self.view, animated: true)
        let url = URLs.makeURL_EXTEND(url: URLs.URL_GET_TOURS, extend: URL_EXTEND.TOURISTS_INFO, param: tour.tourId!)
        NetworkService<Tourist>.makeGetRequest(URL: url){
            response, error in
            if error == nil{
                let message = response?.message
                if message == nil{
                    let tourists = response?.listData
                    Singleton.sharedInstance.tourists = tourists
                }
                else{
                    Alert.showAlertMessage(userMessage: message!, vc: self)
                }
            }
            else{
                Alert.showAlertMessage(userMessage: ERROR_MESSAGE.CONNECT_SERVER , vc: self)
            }
            //MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    func syncTracking(){
        let trackingJsonArray = NSMutableArray()
        let objects = try! realm.objects(Tracking.self)
        if objects.count > 0{
            for tracking in objects{
                trackingJsonArray.add(tracking.convertToJson())
            }
            
            //Convert to Data
            let jsonData = try! JSONSerialization.data(withJSONObject: trackingJsonArray, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            //Convert back to string. Usually only do this for debugging
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                print(JSONString)
                let params:Parameters = ["data": JSONString]
                NetworkService<Tour>.makePostRequestAuthen(URL: URLs.URL_TRACKING_UPDATE, data: params){
                    response, error in
                    if error == nil{
                        let message = response?.message
                        if message == nil{
                            print("Update tracking location successful")
                            try! realm.write {
                                realm.deleteAll()
                            }
                        }
                        else{
                            Alert.showAlertMessage(userMessage: message!, vc: self)
                        }
                    }
                }
            }
        }
    }
    
    func displayPlacesOnMap(){
   
        let places = Singleton.sharedInstance.places
        for place in places!{
            createMarker(latitude: place.location.latitude, longitude: place.location.longitude, data:place, isTourist: false).map = mapView
        }
        self.setMapView(lat: (places?[0].location?.latitude)!, long: (places?[0].location?.longitude)!)
    }
    
    
//    func displayTouristOnMap(){
//        
//        let tourists = Singleton.sharedInstance.tourists
//        
//        for tourist in tourists!{
//            
//            if (try? Data(contentsOf: NSURL(string: tourist.displayPhoto!) as! URL)) != nil{
//            }
//            else
//            {
//                tourist.displayPhoto = nil
//            }
//            
//            let marker = createMarker(latitude: tourist.location!.latitude, longitude: tourist.location!.longitude, data:tourist, isTourist: true)
//            
//            touristMarkers.append(marker)
//            marker.map = mapView
//        }
//       
//    }
    func timerFakeTouristLocation(){
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (Timer) in
            self.touristMarkers[0].position.latitude += 0.0001
            self.touristMarkers[0].map = self.mapView
        })
    }
    func fakeTouristLocation(){
        let la = 1.348144
        let long = 103.921686
        let tourist:Tourist = Tourist()
        tourist.statusConnection = StatusConnection.connected
        let marker = createMarker(latitude: la, longitude: long, data: tourist, isTourist: true)
            touristMarkers.append(marker)
                    marker.map = mapView
        touristMarkers.append(marker)
        timerFakeTouristLocation()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(markerSelectedWarning?.title == "WARNING")
        {
            hiddenPopupWarning()
            let warningData =  markerSelectedWarning?.userData
            //print("data select \(warningData)")
            let warningViewController = segue.destination as! WarningDetailViewController
            warningViewController.warning = Warning(warningData: warningData as! Dictionary<String, Any>)
            // markerSelected = nil
        }
    }
    
    
    //MARK: Realtime Server
    func searchTourist(touristId:Int) -> Tourist{
        var result:Tourist? = nil
        for tourist in Singleton.sharedInstance.tourists{
            guard tourist.touristID == touristId else{
                break
            }
            result = tourist
        }
        return result!
    }
    func connectServer(){
        
        SwiftR.useWKWebView = false
        
        SwiftR.signalRVersion = .v2_2_1
        
        //let urlServerRealtime = "http://tourtrackingv2.azurewebsites.net/signalr/hubs"
        
        let urlServerRealtime = "http://192.168.0.105:3407/signalr/hubs"
        
        appDelegate.connection = SwiftR.connect(urlServerRealtime) { [weak self]
            connection in
            connection.queryString = ["USER_POSITION" : "TG", "MANAGER_ID" : "MG_" + String(describing: (self?.tour.managerId!)!) , "USER_ID" : "TG_" + String(describing: Singleton.sharedInstance.tourguide.tourGuideId!), "USER_NAME" : String(describing: Singleton.sharedInstance.tourguide.name!)]
            self?.appDelegate.tourguideHub = connection.createHubProxy("hubServer")
            self?.lbUserName.text = Singleton.sharedInstance.tourguide.name!
            
            
            self?.appDelegate.tourguideHub?.on("updateNumberOfOnline"){ args in
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
            
            self?.appDelegate.tourguideHub?.on("initTouristConnected"){ args in
                let latitude = args?[0] as! Double
                let longitude = args?[1] as! Double
                let touristName = args?[2] as! String
                let touristId = args?[3] as! Int
                var data:Tourist!
                
                //second connected
                for marker in (self?.touristMarkers)!{
                    
                    let tourist = marker.userData as! Tourist
                    guard tourist.touristID ==  touristId else{
                        break
                    }
                    let index = self?.touristMarkers.index(of: marker)
                    tourist.statusConnection = StatusConnection.connected
                    self?.touristMarkers[index!].map = nil
                    let reconnectMarker = self?.createMarker(latitude: marker.position.latitude, longitude: marker.position.longitude, data: tourist, isTourist: true)
                    //self?.touristMarkers.remove(at: index!)
                    reconnectMarker?.map = self?.mapView
                    //self?.touristMarkers.append(newMarker!)
                    
                    self?.touristConnected(usernameTourist: touristName)
                    
                    return;
                }
                
                
                //first connected.
                data = self?.searchTourist(touristId: touristId)
                if let data = data{
                    
                    let marker = self?.createMarker(latitude: latitude , longitude: longitude, data: data, isTourist: true)
                    marker?.map = self?.mapView
                    self?.touristMarkers.append(marker!)
                    self?.touristConnected(usernameTourist: touristName)
                }
                
            }
            
            self?.appDelegate.tourguideHub?.on("managerOnline"){ args in
                self?.initCurrentLocation(receiver: "MG_" + String(describing: (self?.tour.managerId)!), tourguide: Singleton.sharedInstance.tourguide!, tour: (self?.tour)!)
            }
            
            self?.appDelegate.tourguideHub?.on("receiveLoactionTourist"){ args in
                let touristId = args![0] as! Int
                let latitude = args![1] as! String
                let longitude = args![2] as! String
                for marker in (self?.touristMarkers)!{
                    let tourist = marker.userData as! Tourist
                    if(tourist.touristID == touristId){
                        
                        let index = self?.touristMarkers.index(of: marker)
                        let position = CLLocationCoordinate2D(latitude: Double(latitude)!, longitude: Double(longitude)!)
                        self?.touristMarkers[index!].position = position

                    }
                }
                //Alert.showAlertMessage(userMessage: "\(latitude) + \(longitude)" , vc: self!)
            }
            self?.appDelegate.tourguideHub?.on("receiverWarning"){ args in
                
                let objectData: AnyObject = args![0] as AnyObject!

                
                let warningName = objectData["WarningName"] as? String
                let categoryWarnig = objectData["CategoryWarnig"] as? String
                let descriptiontionWarning = objectData["DescriptionWarning"] as? String
                let lat = objectData["Lat"] as? Double
                let long = objectData["Long"] as? Double
                let distance = objectData["Distance"] as! Double
                let warning_id = objectData["WarningId"] as! Int
                
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
                marker.title = "WARNING"
                
         
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
                
                self?.markerSelectedWarning = marker
                
            }
            
            self?.appDelegate.tourguideHub?.on("removeUserDisconnection"){ args in
                let touristId = args?[0] as! Int
                for marker in (self?.touristMarkers)!{
                    let tourist = marker.userData as! Tourist
                    guard tourist.touristID ==  touristId else{
                        break
                    }
                    let index = self?.touristMarkers.index(of: marker)
                    tourist.statusConnection = StatusConnection.disconnected
                    self?.touristMarkers[index!].map = nil
                    
                    let newMarker = self?.createMarker(latitude: marker.position.latitude, longitude: marker.position.longitude, data: tourist, isTourist: true)
                    
                    //self?.touristMarkers.remove(at: index!)
                    
                    newMarker?.map = self?.mapView
                    //self?.touristMarkers.append(newMarker!)
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
            
            self?.initCurrentLocation(receiver: "MG_" + String(describing: (self?.tour.managerId)!), tourguide: Singleton.sharedInstance.tourguide!, tour: (self?.tour)!)
        }
        
        appDelegate.connection!.reconnected = { [weak self] in
            
            print("Reconnected. Connection ID: \(self?.appDelegate.connection?.connectionID!)")
            self?.updateStatusConnection(status: StatusConnection.reconnected)
            self?.isDisconnect = false
        }
        
        appDelegate.connection!.disconnected = { [weak self] in
            print("Disconnected...")
            self?.isDisconnect = true
            self?.timerUpdateLocation()
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
        lbStatusConnection.textColor = UIColor(rgba: "#259360")
        lbStatusConnection.text = "Connected - " + number + " Tourist"
    }
    
    func updateStatusConnection(status: StatusConnection )
    {
        if(status == .starting)
        {
            
            vStatusConnection.backgroundColor = UIColor(rgba: "#FFFFFF")
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
        if(locationManager.location != nil)
        {
            let user_lat = String(format: "%f", (locationManager.location?.coordinate.latitude)!)
            let user_long = String(format: "%f", (locationManager.location?.coordinate.longitude)!)
            
            
            appDelegate.tourguideHub?.invoke("initMarkerNewConection", arguments: [user_lat, user_long, receiver, tourguide.tourGuideId!, tourguide.name!, tour.tourId!] ) { (result, error) in
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
    }
    
    
    func alertDisconnection(receiver: String, sender: String, senderUserName: String)
    {
        appDelegate.tourguideHub?.invoke("removeUserDisconnection", arguments: [receiver, sender, senderUserName] ) { (result, error) in
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
        let tourId = self.tour.tourId
        
        appDelegate.tourguideHub?.invoke("updatePositionTourGuide", arguments: [senderId, tourId, latitude, longitude, receiver])
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
        self.hiddenWarningHelpPopup()
        
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
    
    func hiddenWarningHelpPopup() {
        
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
        self.setupWarningHelpPopup(isWarning: true)
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
        
        let buttonThree = UIAlertAction(title: "Yêu cầu trợ giúp", style: .default, handler: { (action) -> Void in
            self.setupWarningHelpPopup(isWarning: false)
            self.ShowWarningPopup()
            //self.performSegue(withIdentifier: SegueIdentifier.TO_HELP, sender: self)
        })
        let buttonCancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            
        }
        alertController.addAction(buttonOne)
        alertController.addAction(buttonTwo)
        alertController.addAction(buttonThree)
        alertController.addAction(buttonCancel)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func setupWarningHelpPopup(isWarning:Bool){
        //warning popup
        if isWarning {
            warning_help_icon.backgroundColor = UIColor.orange
            btnSendWarning.backgroundColor = UIColor.orange
            warning_help_titleLabel.text = "Cảnh báo!"
            warning_help_ContentTextView.text = "Nội dung cảnh báo."
        }
        //help popup
        else{
            warning_help_icon.backgroundColor = UIColor.red
            btnSendWarning.backgroundColor = UIColor.red
            warning_help_titleLabel.text = "Yêu cầu trợ giúp!"
            warning_help_ContentTextView.text = "Nội dung trợ giúp"
            
        }
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
            if (markerSelected?.title == "PLACE")
            {
                removeMarkerSelect(marker: markerSelected!, latitude: (markerSelected?.position.latitude)!, longitude: (markerSelected?.position.longitude)!, data: markerSelected?.userData as AnyObject?, isTourist: false).map = mapView
            }
            else if(markerSelected?.title == "TOURIST")
            {
                removeMarkerSelect(marker: markerSelected!, latitude: (markerSelected?.position.latitude)!, longitude: (markerSelected?.position.longitude)!, data: markerSelected?.userData as AnyObject?, isTourist: true).map = mapView
            }
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            
            mapView.selectedMarker = nil
            let positionMarker = mapView.projection.point(for: marker.position)
            let newPositionMarker = CGPoint(x: positionMarker.x, y: positionMarker.y - 100)
            let camera = GMSCameraUpdate.setTarget(mapView.projection.coordinate(for:newPositionMarker))
            mapView.animate(with: camera)

        })
        
        
        if(marker.title == "WARNING")
        {
            
            let dataMarker = marker.userData as! Dictionary<String, Any>
            showPopupWaring(dataWarning: dataMarker)
            print(dataMarker)
            markerSelectedWarning = marker
        
        }
        else if(marker.title == "PLACE")
        {
            if(markerSelected != nil)
            {
                if(markerSelected?.title == "PLACE")
                {
                    removeMarkerSelect(marker: markerSelected!, latitude: (markerSelected?.position.latitude)!, longitude: (markerSelected?.position.longitude)!, data: markerSelected?.userData as AnyObject?, isTourist: false).map = mapView
                }
                else if(marker.title == "TOURIST")
                
                {
                    removeMarkerSelect(marker: markerSelected!, latitude: (markerSelected?.position.latitude)!, longitude: (markerSelected?.position.longitude)!, data: markerSelected?.userData as AnyObject?, isTourist: true).map = mapView
                }
            }
            updateMarkerSelect(marker: marker, latitude: marker.position.latitude, longitude: marker.position.longitude, data: marker.userData as AnyObject?, isTourist: false).map = mapView
            
            let dataPlacePopup = marker.userData as! Place
            lbNamePlacePopup.text = dataPlacePopup.name
            lbContactPlacePopup.text = dataPlacePopup.contact
            if let data = try? Data(contentsOf: NSURL(string: dataPlacePopup.coverPhoto!) as! URL)
            {
                
                let coverPhotoImage = UIImage(data: data)
                ivCoverPhotoPlace.image = coverPhotoImage
            }
            else
            {
                let coverPhotoImage = UIImage(named: "default")
                ivCoverPhotoPlace.image = coverPhotoImage
            }
            hiddenPopupInfoTourist()
            hiddenPopupWarning()
            showPopupInfoPlace()
            
            
            
        }
        else if(marker.title == "TOURIST")
        {
            if(markerSelected != nil)
            {
                if(markerSelected?.title == "TOURIST")
                {
                    removeMarkerSelect(marker: markerSelected!, latitude: (markerSelected?.position.latitude)!, longitude: (markerSelected?.position.longitude)!, data: markerSelected?.userData as AnyObject?, isTourist: true).map = mapView
                }
                else if(markerSelected?.title == "PLACE")
                {
                    removeMarkerSelect(marker: markerSelected!, latitude: (markerSelected?.position.latitude)!, longitude: (markerSelected?.position.longitude)!, data: markerSelected?.userData as AnyObject?, isTourist: false).map = mapView
                }
            }
            updateMarkerSelect(marker: marker, latitude: marker.position.latitude, longitude: marker.position.longitude, data: marker.userData as AnyObject?, isTourist: true).map = mapView
            
            
            
            let dataTourist = marker.userData as! Tourist
            lbTouristName.text = dataTourist.name
            
            let markerLocation: CLLocation =  CLLocation(latitude: marker.position.latitude, longitude: marker.position.longitude)
           
            lbDistanceTourist.text = String(describing: distanceBetweenTwoLocations(source: locationManager.location!, destination: markerLocation)) + "m"
            
            hiddenPopupInfoPlace()
            hiddenPopupWarning()
            showPopupInfoTourist()
          
        }
        
        markerSelected = marker
        return true
    }
    func distanceBetweenTwoLocations(source:CLLocation,destination:CLLocation) -> Int{
        
        let distanceMeters = destination.distance(from: source)
        return Int(distanceMeters)
        
    }
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        hiddenPopupInfoTourist()
        hiddenPopupInfoPlace()
        if(markerSelected != nil)
        {
            if(markerSelected?.title == "PLACE")
            {
                removeMarkerSelect(marker: markerSelected!, latitude: (markerSelected?.position.latitude)!, longitude: (markerSelected?.position.longitude)!, data: markerSelected?.userData as AnyObject?, isTourist: false).map = mapView
            }
            else if(markerSelected?.title == "TOURIST")
            {
                removeMarkerSelect(marker: markerSelected!, latitude: (markerSelected?.position.latitude)!, longitude: (markerSelected?.position.longitude)!, data: markerSelected?.userData as AnyObject?, isTourist: true).map = mapView
            }
        }
        
    }
    
    
//    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
//        if self.displaySegmented.selectedSegmentIndex == 0{
//            self.performSegue(withIdentifier: "SeguePlaceDetails", sender: self)
//        }
//    }
//    
    
    func setMapView(lat:Double = 0, long:Double = 0) {
        
//      mapView.clear()
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 12.0)
        mapView.animate(to: camera)
//      mapView.isMyLocationEnabled = true
        
    }
    
    func createMarker(latitude:Double, longitude:Double, data:AnyObject?, isTourist: Bool) -> GMSMarker{
       
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.userData = data
        
        
        if isTourist{
            
            marker.title = "TOURIST"
            let tourist = data as! Tourist
            var ivmarker:UIImage!
            switch tourist.statusConnection!{
                case .connected:
                    ivmarker = UIImage(named: "ic_markerConnected")
                case .disconnected:
                    ivmarker = UIImage(named: "ic_markerDisconnected")
                default:
                    break
            }
            
            
            let infoData = data as! Tourist
            
            
            
            if(infoData.displayPhoto != nil)
            {
             
                if (try? Data(contentsOf: NSURL(string: infoData.displayPhoto!) as! URL)) != nil{
                    
                    downloadAndDrawMarke(marker: marker, imageURL: infoData.displayPhoto!, markerImage: ivmarker!, isTourist: isTourist)
                }
                else
                {
                    let ivAvatar = UIImage(named: "default")
                    drawMarker(marker: marker, image: ivAvatar!, markerImage: ivmarker!, isTourist: isTourist)
                }
            }
            else
            {
                let ivAvatar = UIImage(named: "default")
                drawMarker(marker: marker, image: ivAvatar!, markerImage: ivmarker!, isTourist: isTourist)
            }
            
        }else{
            
            marker.title = "PLACE"
            let ivmarker = UIImage(named: "ic_flag")
            let ivAvatar = UIImage(named: "ic_flag")
            drawMarker(marker: marker, image: ivAvatar!, markerImage: ivmarker!, isTourist: isTourist)
        }
        
        return marker
    }
    
    func updateMarkerSelect(marker: GMSMarker ,latitude:Double, longitude:Double, data:AnyObject?, isTourist: Bool) -> GMSMarker{
        
        marker.map = nil
        
        if isTourist{
            
            marker.title = "TOURIST"
            let ivmarker = UIImage(named: "4")
            let infoData = marker.userData as! Tourist
            
            if(infoData.displayPhoto != nil)
            {
                downloadAndDrawMarke(marker: marker, imageURL: infoData.displayPhoto!, markerImage: ivmarker!, isTourist: isTourist)
            }
            else
            {
                let ivAvatar = UIImage(named: "default")
                drawMarker(marker: marker, image: ivAvatar!, markerImage: ivmarker!, isTourist: isTourist)
            }
            
        }else{
            
            let ivmarker = UIImage(named: "ic_flag")
            let ivAvatar = UIImage(named: "ic_flag")
            
           drawMarker(marker: marker, image: ivAvatar!, markerImage: ivmarker!, isTourist: isTourist)
        }
        return marker
    }
    
    func removeMarkerSelect(marker: GMSMarker ,latitude:Double, longitude:Double, data:AnyObject?, isTourist: Bool) -> GMSMarker{
        
        marker.map = nil
        
        if isTourist{
            
            marker.title = "TOURIST"
            
            var ivmarker:UIImage!
            
            let infoData = marker.userData as! Tourist
            
            switch infoData.statusConnection!{
                
                case .connected:
                    ivmarker = UIImage(named: "ic_markerConnected")
                case .disconnected:
                    ivmarker = UIImage(named: "ic_markerDisconnected")
                default:
                    break
                
            }
            
            if(infoData.displayPhoto != nil)
            {
                downloadAndDrawMarke(marker: marker, imageURL: infoData.displayPhoto!, markerImage: ivmarker!, isTourist: isTourist)
            }
            else
            {
                let ivAvatar = UIImage(named: "default")
                drawMarker(marker: marker, image: ivAvatar!, markerImage: ivmarker!, isTourist: isTourist)
            }
            
            
        }else{
            
            let ivmarker = UIImage(named: "ic_flag")
            let ivAvatar = UIImage(named: "ic_flag")
            
            drawMarker(marker: marker, image: ivAvatar!, markerImage: ivmarker!, isTourist: isTourist)
        }
        markerSelected = nil
        return marker
    }
    
    
    
    func drawMarker(marker: GMSMarker ,image: UIImage, markerImage: UIImage, isTourist: Bool) {
        
        if(isTourist)
        {
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
            ivPhoto.layer.cornerRadius = ivPhoto.frame.size.width / 2
            ivPhoto.layer.masksToBounds = true

            
            vTemp.addSubview(ivPhoto)
            vTemp.addSubview(ivMarker)
            
            ivMarker.image = markerImage
            ivPhoto.image = image
            
            UIGraphicsBeginImageContextWithOptions(vTemp.bounds.size, false, 0)
            vTemp.layer.render(in: UIGraphicsGetCurrentContext()!)
            
            let finalImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            marker.icon = finalImage
        }
        
        else
        {
            let markerWidth  = 65
            let markerHeight = 60
            
            let vTemp = UIView(frame: CGRect(x: 0, y: 0, width: markerWidth, height: markerHeight))
            vTemp.backgroundColor = UIColor.clear
            
            let ivMarker = UIImageView(frame: CGRect(x: 27, y: 20, width: 40, height: 40))
            ivMarker.backgroundColor = UIColor.clear
      
            vTemp.addSubview(ivMarker)
            
            ivMarker.image = markerImage
            
            UIGraphicsBeginImageContextWithOptions(vTemp.bounds.size, false, 0)
            vTemp.layer.render(in: UIGraphicsGetCurrentContext()!)
            
            let finalImage = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            
            marker.icon = finalImage
        }
        
    }
    
    func downloadAndDrawMarke(marker: GMSMarker, imageURL: String, markerImage: UIImage,  isTourist: Bool)
    {
        let cacheImage = SDWebImageManager.shared().imageCache.imageFromMemoryCache(forKey: imageURL)
        if(cacheImage == nil)
        {
            SDWebImageManager.shared().downloadImage(with: Foundation.URL(string: imageURL), options: [SDWebImageOptions.lowPriority,  SDWebImageOptions.continueInBackground], progress: { (receivedSize, expectedSize) in
            }, completed: { (image, Error, cacheType, finish, urlImage) in
                
                self.drawMarker(marker: marker, image: image!, markerImage: markerImage, isTourist: isTourist)
                
            })
        }
        else
        {
            drawMarker(marker: marker, image: cacheImage!, markerImage: markerImage, isTourist: isTourist)
            
        }
        
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
        if(locations != nil)
        {
            updateLocation(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude);
            let location = Location(latitude:locations[0].coordinate.latitude, longitude:locations[0].coordinate.longitude)
            let tracking = Tracking(tour_id:tour.tourId!, location:location)
            if isDisconnect{
                if isUpdateLocation {
                    try! realm.write {
                        realm.add(tracking)
                        isUpdateLocation = false
                    }
                }
            }
        }
    }
}
