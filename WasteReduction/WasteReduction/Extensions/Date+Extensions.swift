// Created for WasteReduction in 2019
// Using Swift 5.0
// Running on macOS 10.15

import Foundation

extension Date {
    
    var historyReceiptHeaderDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM, HH:MM"
        return formatter.string(from: self)
    }
}
