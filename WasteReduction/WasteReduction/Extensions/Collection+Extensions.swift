//
//  ConsumptionsStatsTableViewCell.swift
//  WasteReduction
//
//  Created by Dmytro Antonchenko on 16.11.2019.
//  Copyright © 2019 Junction. All rights reserved.
//

import Foundation

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Iterator.Element? {
        return index >= startIndex && index < endIndex ? self[index] : nil
    }
}

extension Dictionary {
    mutating func update(_ other: Dictionary) {
        for (key,value) in other {
            self.updateValue(value, forKey: key)
        }
    }
}

extension Array where Element: Equatable  {
    mutating func delete(element: Iterator.Element) {
            self = self.filter({ $0 != element })
    }
}
