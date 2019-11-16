// Created for WasteReduction in 2019
// Using Swift 5.0
// Running on macOS 10.15

import UIKit

enum HistoryCellType {
    case stats
    case receipt
    
    var cellType: UITableViewCell.Type {
        switch self {
        case .stats: return ConsumptionsStatsTableViewCell.self
        case .receipt: return HistoryProductCell.self
        }
    }
    
    var headerViewType: UIView.Type? {
        switch self {
        case .stats: return nil
        case .receipt: return HistoryReceiptSectionHeaderView.self
        }
    }
}


class HistorySectionModel {
    
    let type: HistoryCellType
    
    var consumptionStats: ConsumptionsStats?
    var headerViewType: UIView.Type?
    var cellType: UITableViewCell.Type
    var receipt: Receipt?
    
    var cellsCount: Int {
        switch type {
        case .stats:
            return 1
        case .receipt:
            return receipt?.products.count ?? 0
        }
    }
    
    var heightForHeader: CGFloat {
        switch type {
        case .stats:    return CGFloat.leastNonzeroMagnitude
        case .receipt:  return 90
        }
    }
        
    init(type: HistoryCellType, consumptionsStats: ConsumptionsStats? = nil, receipt: Receipt? = nil) {
        self.type = type
        self.consumptionStats = consumptionsStats
        self.headerViewType = type.headerViewType
        self.cellType = type.cellType
        self.receipt = receipt
    }
    
}
