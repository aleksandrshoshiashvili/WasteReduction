//
//  ProductTableViewCell.swift
//  WasteReduction
//
//  Created by Alexander Shoshiashvili on 16.11.2019.
//  Copyright © 2019 Junction. All rights reserved.
//

import UIKit
import SwipeCellKit

class ProductViewModel: ViewModel, ProductViewModelProtocol {
    
    var id: String
    var name: String
    var price: Double
    var quantity: Double
    var carbonLevel: String
    var isDomestic: Bool
    var productIcon: String
    
    init(id: String, name: String, price: Double, quantity: Double, carbonLevel: String, isDomestic: Bool, productIcon: String) {
        self.id = id
        self.name = name
        self.price = price
        self.quantity = quantity
        self.carbonLevel = carbonLevel
        self.isDomestic = isDomestic
        self.productIcon = productIcon
    }
}


class ProductTableViewCell: SwipeTableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var productImageView: UIImageView!
    @IBOutlet private weak var productNameLabel: UILabel!
    @IBOutlet private weak var totalPriceLabel: UILabel!
    @IBOutlet private weak var detailPriceLabel: UILabel!
    @IBOutlet private weak var stepper: UIStepper!
    @IBOutlet private weak var domesticStatusLabel: UILabel!
    @IBOutlet private weak var carbonLevelLabel: UILabel!
    
    // MARK: - Stored
    
    var viewModel: ProductViewModel?
    
    // MARK: - Reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        alpha = 1
        productImageView.backgroundColor = .clear
    }
    
    // MARK: - Object Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    // MARK: - Interface
    
    func configure(withProduct product: ProductViewModel) {
        self.viewModel = product
        productNameLabel.text = product.name
        productImageView.setImage(urlString: product.productIcon)
        
        if product.isDomestic {
            domesticStatusLabel.text = "Domestic 🇫🇮"
        } else {
            domesticStatusLabel.text = nil
        }
        domesticStatusLabel.isHidden = !product.isDomestic
        
        carbonLevelLabel.text = product.carbonLevel
        
        stepper.value = product.quantity
        
        recalculatePrices()
    }
    
    // MARK: - Actions
    
    @IBAction func handleChangeQuanityAction(_ sender: Any) {
        viewModel?.quantity = stepper.value
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
