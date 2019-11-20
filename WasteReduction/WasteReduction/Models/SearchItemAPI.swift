//
//  SearchItemAPI.swift
//  WasteReduction
//
//  Created by Alexander Shoshiashvili on 17.11.2019.
//  Copyright © 2019 Junction. All rights reserved.
//

import UIKit

struct SearchItemAPI: Codable {
    
    let price: Double?
    let product: ProductSearchAPI?
    let productId: String?
    let quantity: Int?
    let recomindationId: Int?
    let title: String?
    
}
