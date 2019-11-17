//
//  ReceiptAPI.swift
//  WasteReduction
//
//  Created by Alexander Shoshiashvili on 17.11.2019.
//  Copyright © 2019 Junction. All rights reserved.
//

import UIKit

struct ReceiptAPI: Codable {
    
    let receiptId: String
    let transactionDate: String
    let price: Double?
    let receiptItems: [ReceiptItemAPI]

}

extension ReceiptAPI {
    
    var date: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-ddTHH:mm:ss"
        return dateFormatter.date(from: transactionDate) ?? Date()
    }
    
}
