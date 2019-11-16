//
//  ProductTableViewCell.swift
//  WasteReduction
//
//  Created by Alexander Shoshiashvili on 16.11.2019.
//  Copyright © 2019 Junction. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var productImageView: UIImageView!
    @IBOutlet private weak var productNameLabel: UILabel!
    @IBOutlet private weak var totalPriceLabel: UILabel!
    @IBOutlet private weak var detailPriceLabel: UILabel!
    @IBOutlet private weak var stepper: UIStepper!
    @IBOutlet private weak var domesticStatusLabel: UILabel!
    @IBOutlet private weak var carbonLevelLabel: UILabel!
    
    // MARK: - Stored
    
    var viewModel: ProductWithRecommendaitonViewModel?
    
    // MARK: - Reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        alpha = 1
    }
    
    // MARK: - Object Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    // MARK: - Interface
    
    func configure(withProduct product: ProductWithRecommendaitonViewModel) {
        self.viewModel = product
        productNameLabel.text = product.name
        
        if product.isDomestic {
            domesticStatusLabel.text = "Domestic 🇫🇮"
        } else {
            domesticStatusLabel.text = nil
        }
        domesticStatusLabel.isHidden = !product.isDomestic
        
        carbonLevelLabel.text = product.carbonLevel
        
        recalculatePrices()
    }
    
    // MARK: - Actions
    
    @IBAction func handleChangeQuanityAction(_ sender: Any) {
        viewModel?.quantity += 1
        recalculatePrices()
    }
    
    // MARK: - Helpers
    
    private func recalculatePrices() {
        
        guard let product = viewModel else {
            return
        }
        
        let summary = product.quantity * product.price
        totalPriceLabel.text = "\(String(format: "%.2f", summary))$"
        detailPriceLabel.text = "\(Int(product.quantity)) x \(product.price)$"
    }
}
