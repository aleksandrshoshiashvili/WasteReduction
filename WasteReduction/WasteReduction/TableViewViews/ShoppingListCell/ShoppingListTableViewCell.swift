// Created for WasteReduction in 2019
// Using Swift 5.0
// Running on macOS 10.15

import UIKit

class ShoppingListTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var shoppingListLabel: UILabel!

    // MARK: - Interface
    
    func configure(withName name: String) {
        shoppingListLabel.text = name
    }
    
}
