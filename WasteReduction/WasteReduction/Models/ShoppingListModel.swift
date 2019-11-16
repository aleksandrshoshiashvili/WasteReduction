// Created for WasteReduction in 2019
// Using Swift 5.0
// Running on macOS 10.15

import Foundation

class ShoppingListModel {
    
    let id: String
    var name: String
    
    var shouldBeAnimated: Bool = true
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}
