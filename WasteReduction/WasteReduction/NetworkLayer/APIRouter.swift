//
//  APIRouter.swift
//  WasteReduction
//
//  Created by Alexander Shoshiashvili on 17.11.2019.
//  Copyright © 2019 Junction. All rights reserved.
//

import UIKit
import Alamofire

struct ProductionServer {
    static let baseURL = "http://84.201.160.239:9395/data"
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

enum ContentType: String {
    case json = "application/json"
}


enum APIRouter: URLRequestConvertible {
    
    case recommendations
    case productRecommendations(productId: String)
    case receipts
    
    // MARK: - HTTPMethod
    
    private var method: HTTPMethod {
        return .get
    }
    
    // MARK: - Path
    
    private var path: String {
        switch self {
        case .recommendations:
            return "/recomindations"
        case .productRecommendations(let productId):
            return "/\(productId)/recomindation"
        case .receipts:
            return "/receipts"
        }
    }
    
    // MARK: - Parameters
    private var parameters: Parameters? {
        return nil
    }
    
    // MARK: - URLRequestConvertible
    
    func asURLRequest() -> URLRequest {
        let url = URL(string: ProductionServer.baseURL)!
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
 
        // Parameters
        if let parameters = parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                print(AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error)))
            }
        }
        
        return urlRequest
    }
}
