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
    case error
    case starting
}

class MapViewController: BaseViewController {
    
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
        
        SwiftR.signalRVersion = .v2_2_0
        
        //let urlServerRealtime = "http://tourtrackingv2.azurewebsites.net/signalr/hubs"
        
        let urlServerRealtime = "http://192.168.0.104:3407/signalr/hubs"
        
        connection = SwiftR.connect(urlServerRealtime) { [weak self]
            connection in
            connection.queryString = ["USER_POSITION" : "TG", "MANAGER_ID" : "MG_" + String(describing: (self?.tour.managerId!)!) , "USER_ID" : "TG_" + String(describing: Singleton.sharedInstance.tourguide.tourGuideId!)]
            self?.tourguideHub = connection.createHubProxy("hubServer")
            
            self?.tourguideHub?.on("broadcastMessage") { args in
                
            }
            
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
            
        }
        connection?.starting = { [weak self] in
            self?.updateStatusConnection(status: StatusConnection.starting)
            
        }
        
        connection?.reconnecting = { [weak self] in
            self?.updateStatusConnection(status: StatusConnection.reconnected)
        }
        
        connection?.connected = { [weak self] in
            
            self?.isConnected = true
            print("Connection ID: \(self?.connection?.connectionID!)")
            self?.updateStatusConnection(status: StatusConnection.connected)
            
            self?.initCurrentLocation(receiver: "MG_" + String(describing: (self?.tour.managerId)!), tourguide: Singleton.sharedInstance.tourguide!, tour: (self?.tour)!)
        }
        
        connection?.disconnected = { [weak self] in
            self?.updateStatusConnection(status: StatusConnection.disconnected)
            
            
        }
        
        connection?.reconnected = { [weak self] in
            self?.updateStatusConnection(status: StatusConnection.connected)
        }
        connection?.error = { error in
            print("Error connect1: \(error)")
            
            self.updateStatusConnection(status: StatusConnection.error)
            
            if let source = error?["source"] as? String, source == "TimeoutException" {
                print("Connection timed out. Restarting...")
                self.connection?.start()
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
            
            UIView.animate(withDuration: 1, animations: {
                self.consTopVStatusConnection.constant = 0
                self.view.layoutIfNeeded()
            })
            
        }
        if(status == .connected)
        {
            //view.layer.backgroundColor
            vStatusConnection.backgroundColor = UIColor(rgba: "#D9F7D7")
            lbStatusConnection.textColor = UIColor(rgba: "#259360")
            lbStatusConnection.text = "Connected"
        }
        else if(status == .disconnected)
        {
            vStatusConnection.backgroundColor = UIColor(rgba: "#F5DDDD")
            lbStatusConnection.textColor = UIColor(rgba: "#CC3A3A")
            lbStatusConnection.text = "Disconnect"
            
            alertDisconnection(receiver: "MG_" + String(describing: self.tour.managerId!), sender: "TG_" + String(describing: Singleton.sharedInstance.tourguide.tourGuideId!), senderUserName: Singleton.sharedInstance.tourguide.name!)
            
            
            //            self.alertDisconnection(receiver:
            //                "MG_" + (self.tour.managerId! as! String), sender: "TG_" + (Singleton.sharedInstance.tourguide.tourGuideId! as! String))
            
        }
        else if(status == .reconnected)
        {
            vStatusConnection.backgroundColor = UIColor(rgba: "#D7EBF9")
            lbStatusConnection.textColor = UIColor(rgba: "#6BA1C8")
            lbStatusConnection.text = "Reconnecting"
            
        }
        else if(status == .error)
        {
            vStatusConnection.backgroundColor = UIColor(rgba: "#F5DDDD")
            lbStatusConnection.textColor = UIColor(rgba: "#CC3A3A")
            lbStatusConnection.text = "Not found server"
            
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
        
        mapView.clear()
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 12.0)
        mapView.animate(to: camera)
        mapView.isMyLocationEnabled = true
        
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
        //        if let hub = chatHub, {
        //            hub.invoke("updateLocation", arguments: ["37.121300", "-95.416603"])
        //        }
        //        updateLocation(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude);
    }
}
