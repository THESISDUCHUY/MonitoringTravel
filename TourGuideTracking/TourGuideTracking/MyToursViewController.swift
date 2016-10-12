//
//  MyToursViewController.swift
//  TourGuideTracking
//
//  Created by Quoc Huy Ngo on 10/11/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import UIKit

class MyToursViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        
        //get tourguide info
        tourGuideInfoGet()
    }
    
    func tourGuideInfoGet(){
        NetworkService<TourGuide>.makeGetRequest(URL: URLs.makeURL(url: URLs.URL_GET_TOURGUIDE, param: Settings.tourguide_id!) ){
            response, error in
            if error == nil{
                let message = response?.message
                if message == nil{
                    let tourguide = response?.data
                    Singleton.sharedInstance.tourguide = tourguide
                }
                else{
                    
                }
            }
            else{
                
            }
        }
    }
}
