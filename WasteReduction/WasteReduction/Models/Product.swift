// Created for WasteReduction in 2019
// Using Swift 5.0
// Running on macOS 10.15

import Foundation

class Product: Equatable {
    
    var id: String
    var name: String
    var price: Double
    var quantity: Double
    var shouldBeAnimated: Bool = true
    
    init(id: String, name: String, price: Double, quantity: Double) {
        self.id = id
        self.name = name
        self.price = price
        self.quantity = quantity
    }
    
    static func ==(lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
    }
}
