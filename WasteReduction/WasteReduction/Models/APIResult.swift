// Created for WasteReduction in 2019
// Using Swift 5.0
// Running on macOS 10.15

import Foundation

struct APIResult<T: Codable>: Codable {
    
    let result: T
}
