//
//  ProductSearchAPI.swift
//  WasteReduction
//
//  Created by Alexander Shoshiashvili on 16.11.2019.
//  Copyright © 2019 Junction. All rights reserved.
//

import UIKit

struct ProductSearchAPI: Codable {
    
    var name: String? {
        willSet {
            if newValue == nil {
                name = "Product"
            }
        }
    }
    var pictureUrl: String? {
        willSet {
            if newValue == nil {
                pictureUrl = "https://www.mv.org.ua/image/news_small/2015/06/06_073953_81923.jpg"
            }
        }
    }
    let productId: String
    let manufacturerCountry: String?
    let isWasted: Bool
    let isFinished: Bool
    let co2: String?
    var price: Double?
    let quantity: Int?

}

extension ProductSearchAPI {
    
    var isDomestic: Bool {
        return manufacturerCountry == "FI"
    }
    
    var toProduct: Product {
        return Product(id: productId,
                       name: name ?? "Product",
                       price: .zero,
                       quantity: .zero,
                       carbonLevel: Double(co2 ?? "") ?? .zero,
                       isDomestic: isDomestic,
                       iconUrl: pictureUrl ?? "https://www.mv.org.ua/image/news_small/2015/06/06_073953_81923.jpg")
    }
    
}
