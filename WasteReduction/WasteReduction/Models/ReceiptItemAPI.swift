//
//  ReceiptItemAPI.swift
//  WasteReduction
//
//  Created by Alexander Shoshiashvili on 17.11.2019.
//  Copyright © 2019 Junction. All rights reserved.
//

import UIKit

struct ReceiptItemAPI: Codable {
    
    let receiptItemId: Int
    var quantity: Int
    var price: Double
    let productId: String
    let product: ProductSearchAPI

}
