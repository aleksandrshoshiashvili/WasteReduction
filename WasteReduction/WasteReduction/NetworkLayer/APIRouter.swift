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
    case search(query: String)
    
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
        case .search:
            return "/products"
        }
    }
    
    // MARK: - Parameters
    private var parameters: Parameters? {
        switch self {
        case .search(let query):
            return ["name": query, "amount": "10"]
        default:
            return nil
        }
    }
    
    // MARK: - URLRequestConvertible
    
    func asURLRequest() -> URLRequest {
        
        var components = URLComponents()
        components.scheme = "http"
        components.host = "84.201.160.239"
        components.port = 9395
        components.path = "/data" + path
        
//        let url = URL(string: ProductionServer.baseURL)!
        
//        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        // Parameters
        if let parameters = parameters {
            let aa = parameters.map({ URLQueryItem(name: $0.key, value: $0.value as? String) })
            components.queryItems = aa
        }
        
        var urlRequest = URLRequest(url: components.url!)
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        
        return urlRequest
    }
}
