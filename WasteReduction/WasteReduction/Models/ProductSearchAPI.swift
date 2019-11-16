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
    let ean: String
    let manufacturerCountry: String

}

extension ProductSearchAPI {
    
    var isDomestic: Bool {
        return manufacturerCountry == "FI"
    }
    
    var toProduct: Product {
        return Product(id: ean,
                       name: name,
                       price: .zero,
                       quantity: .zero,
                       carbonLevel: .zero,
                       isDomestic: isDomestic,
                       iconUrl: pictureUrl)
    }
    
}
