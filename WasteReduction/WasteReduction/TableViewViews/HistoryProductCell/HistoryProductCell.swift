// Created for WasteReduction in 2019
// Using Swift 5.0
// Running on macOS 10.15

import UIKit

protocol HistoryProductCellDelegate: class {
    func didSelectUtilize(fromCell cell: UITableViewCell)
    func didSelectWasted(fromCell cell: UITableViewCell)
    func didSelectDone(fromCell cell: UITableViewCell)
}

class HistoryProductCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var productImageView: UIImageView!
    @IBOutlet private weak var productNameLabel: UILabel!
    @IBOutlet private weak var totalPriceLabel: UILabel!
    @IBOutlet private weak var quantityAndSinglePriceLabel: UILabel!
    @IBOutlet private weak var utilizeButton: UIButton!
    @IBOutlet private weak var wastedButton: UIButton!
    @IBOutlet private weak var doneButton: UIButton!
    
    // MARK: - Delegate
    
    weak var delegate: HistoryProductCellDelegate?
    
    // MARK: - Reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        alpha = 1
    }
    
    // MARK: - Object Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    // MARK: - Interface
    
    func configure(withProduct product: Product) {
        productNameLabel.text = product.name
        let summary = product.quantity * product.price
        totalPriceLabel.text = "\(String(format: "%.2f", summary))$"
        quantityAndSinglePriceLabel.text = "\(Int(product.quantity)) x \(product.price)$"
    }
    
    // MARK: - Actions
    
    @IBAction private func utilizeButtonAction(_ sender: UIButton) {
        delegate?.didSelectUtilize(fromCell: self)
    }
    @IBAction private func wastedButtonAction(_ sender: UIButton) {
        delegate?.didSelectWasted(fromCell: self)
    }
    @IBAction private func doneButtonAction(_ sender: UIButton) {
        delegate?.didSelectDone(fromCell: self)
    }
    
}
