// Created for WasteReduction in 2019
// Using Swift 5.0
// Running on macOS 10.15

import UIKit

class SearchProductCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var productImageView: UIImageView!
    @IBOutlet private weak var productNameLabel: UILabel!
    @IBOutlet private weak var productPriceLabel: UILabel!
    
    // MARK: - Interface
    
    func configure(withProduct product: Product) {
        
        productImageView.setImage(urlString: product.iconUrl)
        productNameLabel.text = product.name
        productPriceLabel.text = String(format: "%.2f", product.price) + "€"
    }
    
}
