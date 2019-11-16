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
        
    }

    // MARK: - Interface
    
    func configure(withProduct product: Product) {
        productNameLabel.text = product.name
        let summary = product.quantity * product.price
        totalPriceLabel.text = "\(String(format: "%.2f", summary))$"
        quantityAndSinglePriceLabel.text = "\(Int(product.quantity)) x \(product.price)$"
        configureButtons(withState: product.state)
    }
    
    private func configureButtons(withState state: ProductState) {
        
        utilizeButton.layer.borderWidth = 2
        utilizeButton.layer.borderColor = Constants.Colors.theme.cgColor
        wastedButton.layer.borderWidth = 2
        wastedButton.layer.borderColor = Constants.Colors.theme.cgColor
        doneButton.layer.borderWidth = 2
        doneButton.layer.borderColor = Constants.Colors.theme.cgColor
        doneButton.setTitleColor(.black, for: .normal)
        wastedButton.setTitleColor(.black, for: .normal)
        utilizeButton.setTitleColor(.black, for: .normal)
        switch state {
        case .none:
            utilizeButton.backgroundColor = .clear
            wastedButton.backgroundColor = .clear
            doneButton.backgroundColor = .clear
        case .done:
            utilizeButton.backgroundColor = .clear
            wastedButton.backgroundColor = .clear
            doneButton.backgroundColor = Constants.Colors.theme
            doneButton.setTitleColor(.white, for: .normal)
        case .utilized:
            utilizeButton.backgroundColor = Constants.Colors.theme
            utilizeButton.setTitleColor(.white, for: .normal)
            wastedButton.backgroundColor = .clear
            doneButton.backgroundColor = .clear
        case .wasted:
            utilizeButton.backgroundColor = .clear
            wastedButton.backgroundColor = Constants.Colors.theme
            wastedButton.setTitleColor(.white, for: .normal)
            doneButton.backgroundColor = .clear
        }
        
    }
    
    // MARK: - Actions
    
    @IBAction private func utilizeButtonAction(_ sender: UIButton) {
        delegate?.didSelectUtilize(fromCell: self)
        configureButtons(withState: .utilized)
    }
    @IBAction private func wastedButtonAction(_ sender: UIButton) {
        delegate?.didSelectWasted(fromCell: self)
        configureButtons(withState: .wasted)
    }
    @IBAction private func doneButtonAction(_ sender: UIButton) {
        delegate?.didSelectDone(fromCell: self)
        configureButtons(withState: .done)
    }
    
}
