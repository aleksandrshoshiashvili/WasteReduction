// Created for WasteReduction in 2019
// Using Swift 5.0
// Running on macOS 10.15

import UIKit

class HistoryReceiptSectionHeaderView: UIView {

    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    // MARK: - Outlets
    
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var domesticTitleLabel: UILabel!
    @IBOutlet private weak var domesticDetailsLabel: UILabel!
    @IBOutlet private weak var wasteTitleLabel: UILabel!
    @IBOutlet private weak var wasteDetailsLabel: UILabel!
    @IBOutlet private weak var carbonTitleLabel: UILabel!
    @IBOutlet private weak var carbonDetailsLabel: UILabel!
    
    // MARK: - Interace
    
    func configure(withReceipt receipt: Receipt) {
        
        domesticTitleLabel.text = receipt.domesticStat.type.shortTitle
        domesticDetailsLabel.text = receipt.domesticStat.details
        domesticDetailsLabel.textColor = receipt.domesticStat.type.color
        wasteTitleLabel.text = receipt.wasteStat.type.shortTitle
        wasteDetailsLabel.text = receipt.wasteStat.details
        wasteDetailsLabel.textColor = receipt.wasteStat.type.color
        carbonTitleLabel.text = receipt.carbonStat.type.shortTitle
        carbonDetailsLabel.text = receipt.carbonStat.details
        carbonDetailsLabel.textColor = receipt.carbonStat.type.color
        dateLabel.text = receipt.date.historyReceiptHeaderDate
    }

}
