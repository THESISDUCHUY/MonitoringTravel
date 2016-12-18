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
    static func makePostRequestAuthen(URL:String, data:Parameters,completionHandle:@escaping (ResponseData<T>?, NSError?)->()){
        let user:String! = String(format:"%d", Settings.tourguide_id!)
        let password:String! = Settings.tourguide_accesstoken!
        var headers: HTTPHeaders = [:]
        if let authorizationHeader = Request.authorizationHeader(user: user, password: password) {
            headers[authorizationHeader.key] = authorizationHeader.value
        }

        Alamofire.request(URL, method: .post ,parameters: data, headers:headers).responseObject{(
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
    
    static func getHeaders()->HTTPHeaders{
        let user:String! = String(format:"%d", Settings.tourguide_id!)
        let password:String! = Settings.tourguide_accesstoken!
        var headers: HTTPHeaders = [:]
        if let authorizationHeader = Request.authorizationHeader(user: user, password: password) {
            headers[authorizationHeader.key] = authorizationHeader.value
        }
        return headers
    }
}
