//
//  NetworkService.swift
//  WasteReduction
//
//  Created by Alexander Shoshiashvili on 17.11.2019.
//  Copyright © 2019 Junction. All rights reserved.
//

import UIKit
import Alamofire

class NetworkService {

    static let shared = NetworkService()
    
    func request<T: Codable>(router: APIRouter, completion: @escaping (Result<T>) -> Void) {
        Alamofire.request(router.asURLRequest()).responseData { (dataResponse) in
            let decoder = JSONDecoder()
            let model: Result<T> = decoder.decodeResponse(from: dataResponse)
            completion(model)
        }  .responseJSON { (resp) in
            print(resp)
        }
    }
    
}

extension JSONDecoder {
    func decodeResponse<T: Decodable>(from response: DataResponse<Data>) -> Result<T> {
        guard response.error == nil else {
            print(response.error!)
            return .failure(response.error!)
        }
        
        guard let responseData = response.data else {
            print("didn't get any data from API")
            let err = NSError(domain: "", code: 400, userInfo: ["error": "Did not get data in response"])
            return .failure(err)
        }
        
        do {
            let item = try decode(T.self, from: responseData)
            return .success(item)
        } catch {
            print("error trying to decode response")
            print(error)
            return .failure(error)
        }
    }
}
