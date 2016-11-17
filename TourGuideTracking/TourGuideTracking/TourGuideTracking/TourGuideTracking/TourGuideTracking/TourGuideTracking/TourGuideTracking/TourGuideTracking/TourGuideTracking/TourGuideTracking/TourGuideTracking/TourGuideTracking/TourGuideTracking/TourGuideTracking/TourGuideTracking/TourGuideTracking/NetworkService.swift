//
//  NetworkService.swift
//  TourGuideTracking
//
//  Created by Quoc Huy Ngo on 10/11/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper
import ObjectMapper

class NetworkService<T:Mappable>{
    
    static func makePostRequest(URL:String, data:Parameters,completionHandle:@escaping (ResponseData<T>?, NSError?)->()){
        Alamofire.request(URL, method: .post, parameters: data).responseObject{(
            response: DataResponse<ResponseData<T>>) in
            switch response.result{
            case .success(let value):
                completionHandle(value, nil)
            case.failure(let error):
                completionHandle(nil, error as NSError?)
            }
        }
    }
    
    static func makeGetRequest(URL:String, completionHandle:@escaping (ResponseData<T>?, NSError?)->()){
        Alamofire.request(URL, method:.get).responseObject{(
            response:DataResponse<ResponseData<T>>) in
            switch response.result{
            case .success(let value):
                completionHandle(value, nil)
            case.failure(let error):
                completionHandle(nil, (error as NSError?)!)
            }
        }
    }
}
/* func getPlace()->{
 Alamofire.request(URLs.URL_LOGIN).responseObject{ (response: DataResponse<ResponseData<Tour>>) in
 let result = response.result.value
 print(result?.status)
 var datas = result?.listData
 }
 }*/
