//
//  ProductWithRecommendaitonTableViewCell.swift
//  WasteReduction
//
//  Created by Alexander Shoshiashvili on 16.11.2019.
//  Copyright © 2019 Junction. All rights reserved.
//

import UIKit
import SwipeCellKit

protocol ProductViewModelProtocol {
    var id: String { get set }
    var name: String { get set }
    var price: Double { get set }
    var quantity: Double { get set }
    var carbonLevel: String { get set }
    var isDomestic: Bool { get set }
    var productIcon: String { get set }
}

class ProductWithRecommendaitonViewModel: ViewModel, ProductViewModelProtocol {
    
    var id: String
    var name: String
    var price: Double
    var quantity: Double
    var carbonLevel: String
    var isDomestic: Bool
    var recommendedTitle: String
    var recommendedProductName: String
    var recommendedProductIcon: String
    var productIcon: String
    
    init(id: String, name: String, price: Double, quantity: Double, carbonLevel: String, isDomestic: Bool, productIcon: String, recommendedTitle: String, recommendedProductName: String, recommendedProductIcon: String) {
        self.id = id
        self.name = name
        self.price = price
        self.quantity = quantity
        self.carbonLevel = carbonLevel
        self.isDomestic = isDomestic
        self.productIcon = productIcon
        self.recommendedTitle = recommendedTitle
        self.recommendedProductName = recommendedProductName
        self.recommendedProductIcon = recommendedProductIcon
    }
}

protocol ProductWithRecommendaitonTableViewCellDelegate: class {
    func productWithRecommendaitonTableViewCellDidPressReplace(_ cell: ProductWithRecommendaitonTableViewCell)
}

class ProductWithRecommendaitonTableViewCell: SwipeTableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var productImageView: UIImageView!
    @IBOutlet private weak var productNameLabel: UILabel!
    @IBOutlet private weak var totalPriceLabel: UILabel!
    @IBOutlet private weak var detailPriceLabel: UILabel!
    @IBOutlet private weak var stepper: UIStepper!
    @IBOutlet private weak var replaceButton: UIButton!
    @IBOutlet private weak var domesticStatusLabel: UILabel!
    @IBOutlet private weak var carbonLevelLabel: UILabel!
    @IBOutlet private weak var recommendedTitleLabel: UILabel!
    @IBOutlet private weak var recommendedNameLabel: UILabel!
    @IBOutlet private weak var recommendedIconImageView: UIImageView!
    
    // MARK: - Delegate
    
    weak var cellDelegate: ProductWithRecommendaitonTableViewCellDelegate?
    
    // MARK: - Stored
    
    var viewModel: ProductWithRecommendaitonViewModel?
    
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
        replaceButton.cornerRadius = replaceButton.bounds.height / 2.0
    }

    // MARK: - Interface
    
    func configure(withProduct product: ProductWithRecommendaitonViewModel) {
        self.viewModel = product
        
        productNameLabel.text = product.name
        recommendedTitleLabel.text = product.recommendedTitle
        recommendedNameLabel.text = product.recommendedProductName
        recommendedIconImageView.cornerRadius = recommendedIconImageView.bounds.height / 2.0
        stepper.value = product.quantity
        
        if product.isDomestic {
            domesticStatusLabel.text = "Local 🇫🇮"
        } else {
            domesticStatusLabel.text = nil
        }
        domesticStatusLabel.isHidden = !product.isDomestic
        
        carbonLevelLabel.text = product.carbonLevel
        
        recalculatePrices()
    }
    
    // MARK: - Actions
    
    @IBAction private func replaceButtonAction(_ sender: UIButton) {
        cellDelegate?.productWithRecommendaitonTableViewCellDidPressReplace(self)
    }
    
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
