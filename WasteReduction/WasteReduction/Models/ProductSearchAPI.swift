//
//  ProductSearchAPI.swift
//  WasteReduction
//
//  Created by Alexander Shoshiashvili on 16.11.2019.
//  Copyright © 2019 Junction. All rights reserved.
//

import UIKit

struct ProductSearchAPI: Codable {
    
    let name: String
    let pictureUrl: String
    let productId: String
    let manufacturerCountry: String?
    let isWasted: Bool
    let isFinished: Bool
    let co2: String?
    var price: Double?
    var quantity: Int?

}

extension ProductSearchAPI {
    
    var isDomestic: Bool {
        return manufacturerCountry == "FI"
    }
    
    var toProduct: Product {
        return Product(id: productId,
                       name: name,
                       price: price ?? .zero,
                       quantity: Double(quantity ?? 0),
                       carbonLevel: Double(co2 ?? "") ?? .zero,
                       isDomestic: isDomestic,
                       iconUrl: pictureUrl)
    }
    
}
