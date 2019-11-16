//
//  ProductSelectionTableViewCell.swift
//  WasteReduction
//
//  Created by Alexander Shoshiashvili on 16.11.2019.
//  Copyright © 2019 Junction. All rights reserved.
//

import UIKit
import AIFlatSwitch

protocol ProductSelectionTableViewCellDelegate: class {
    func productSelectionTableViewCellDidPressSwitch(_ cell: ProductSelectionTableViewCell)
}

class ProductSelectionTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var productImageView: UIImageView!
    @IBOutlet private weak var productNameLabel: UILabel!
    @IBOutlet private weak var totalPriceLabel: UILabel!
    @IBOutlet private weak var detailPriceLabel: UILabel!
    @IBOutlet private weak var domesticStatusLabel: UILabel!
    @IBOutlet private weak var carbonLevelLabel: UILabel!
    @IBOutlet private weak var checkmarkSwitch: AIFlatSwitch!
    
    // MARK: - Delegate
    
    weak var delegate: ProductSelectionTableViewCellDelegate?
    
    // MARK: - Stored
    
    var viewModel: ProductViewModel?
    
    // MARK: - Reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.backgroundColor = .clear
    }
    
    // MARK: - Object Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    // MARK: - Interface
    
    func configure(withProduct product: ProductViewModel) {
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
    
    @IBAction func handleSwitchValueChange(sender: Any) {
        if let flatSwitch = sender as? AIFlatSwitch {
            flatSwitch.setSelected(true, animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.delegate?.productSelectionTableViewCellDidPressSwitch(self)
            }
        }
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
