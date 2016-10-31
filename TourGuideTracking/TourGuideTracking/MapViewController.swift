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

class MapViewController: UIViewController {


    @IBOutlet weak var displaySegmented: UISegmentedControl!
    var tour:Tour!
    var markerSelected:Any!
    @IBOutlet weak var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tabBar = (self.tabBarController as! CustomTabBarController)
        tabBar.currentTour = tour
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
            creteMarker(latitude: place.location.latitude!, longitude: place.location.longitude!, data:place).map = mapView
        }

    }
    
    func displayTouristOnMap(){
        let tourists = Singleton.sharedInstance.tourists
        self.setMapView(lat: (tourists?[0].location?.latitude!)!, long: (tourists?[0].location?.longitude!)!)
        for tourist in tourists!{
            creteMarker(latitude: tourist.location!.latitude!, longitude: tourist.location!.longitude!, data:tourist).map = mapView
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if self.displaySegmented.selectedSegmentIndex == 0{
            let placeDetailsVC = segue.destination as! PlaceDetailsViewController
            placeDetailsVC.place = markerSelected as! Place
        }
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
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 12.0)
        mapView.camera = camera
        mapView.isMyLocationEnabled = true
    }
    
    func creteMarker(latitude:Double, longitude:Double, data:AnyObject?) -> GMSMarker{
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.userData = data
        return marker
    }

}
