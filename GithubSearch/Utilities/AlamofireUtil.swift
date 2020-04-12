//
//  AlamofireUtil.swift
//  GithubSearch
//
//  Created by jaewon on 2020/04/11.
//  Copyright © 2020 jaewon. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

class AlamofireUtil {
    static let shared: AlamofireUtil = AlamofireUtil()
    
    let defaultHeader = ["Authorization": BasicConstants.GITHUB_TOKEN]
    
    func getDataRequest(_ api: API,
                        headers: HTTPHeaders? = nil) -> DataRequest {
        return Alamofire.request(api.url,
                                 method: api.method,
                                 parameters: api.parameters,
                                 encoding: URLEncoding.default,
                                 headers: headers ?? self.defaultHeader)
    }
    
    func requestObject<T: Mappable>(_ api: API,
                                    headers: HTTPHeaders? = nil,
                                    onSuccess: @escaping (_ response: T) -> (),
                                    onError: @escaping (_ error: Error) -> ()) {
        
        guard #available(iOS 13, *) else {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            return
        }
        
        self.getDataRequest(api, headers: headers)
            .responseObject { (dataResponse: DataResponse<T>) in
                guard #available(iOS 13, *) else {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    return
                }
                switch dataResponse.result {
                case .success(let data):
                    onSuccess(data)
                case .failure(let error):
                    onError(error)
                }
        }
    }
}
