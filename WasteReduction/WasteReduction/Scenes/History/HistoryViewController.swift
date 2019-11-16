//
//  ViewController.swift
//  WasteReduction
//
//  Created by Alexander Shoshiashvili on 15.11.2019.
//  Copyright © 2019 Junction. All rights reserved.
//

import UIKit

class HistoryViewController: UITableViewController {
    
    // MARK: - Mock data
    
    static var mockReceiptConsumptionsStats: ConsumptionsStats {
        return ConsumptionsStats(domesticDetails: "33% of purchases", wasteDetails: "11% of waste", carbonDetails: "8 kg CO2 / product")
    }
    
    static var mockProducts: [Product] {
        return [Product(id: UUID().uuidString, name: "Manka", price: 7, quantity: 1),
                Product(id: UUID().uuidString, name: "Gre4a", price: 99.99, quantity: 2),
                Product(id: UUID().uuidString, name: "Milk", price: 2, quantity: 2.5),
                Product(id: UUID().uuidString, name: "Strawberry", price: 3, quantity: 1.3),
                Product(id: UUID().uuidString, name: "Manka", price: 7, quantity: 1),
                Product(id: UUID().uuidString, name: "Gre4a", price: 99.99, quantity: 2),
                Product(id: UUID().uuidString, name: "Milk", price: 2, quantity: 2.5),
                Product(id: UUID().uuidString, name: "Strawberry", price: 3, quantity: 1.3),
                Product(id: UUID().uuidString, name: "Manka", price: 7, quantity: 1),
                Product(id: UUID().uuidString, name: "Gre4a", price: 99.99, quantity: 2),
                Product(id: UUID().uuidString, name: "Milk", price: 2, quantity: 2.5),
                Product(id: UUID().uuidString, name: "Strawberry", price: 3, quantity: 1.3),
                Product(id: UUID().uuidString, name: "Manka", price: 7, quantity: 1),
                Product(id: UUID().uuidString, name: "Gre4a", price: 99.99, quantity: 2),
                Product(id: UUID().uuidString, name: "Milk", price: 2, quantity: 2.5),
                Product(id: UUID().uuidString, name: "Strawberry", price: 3, quantity: 1.3),
                Product(id: UUID().uuidString, name: "Manka", price: 7, quantity: 1),
                Product(id: UUID().uuidString, name: "Gre4a", price: 99.99, quantity: 2),
                Product(id: UUID().uuidString, name: "Milk", price: 2, quantity: 2.5),
                Product(id: UUID().uuidString, name: "Strawberry", price: 3, quantity: 1.3)]
    }
    
    static var mockReceipt: Receipt {
        return Receipt(id: UUID().uuidString,
                       domesticStat: mockReceiptConsumptionsStats.domestic,
                       wasteStat: mockReceiptConsumptionsStats.waste,
                       carbonStat: mockReceiptConsumptionsStats.carbon,
                       products: self.mockProducts,
                       date: Date())
    }
    
    var cellsData: [HistorySectionModel] = [HistorySectionModel(type: .stats,
                                                                consumptionsStats: ConsumptionsStats(domesticDetails: "76% of purchases",
                                                                                                     wasteDetails: "34% of waste",
                                                                                                     carbonDetails: "123 kg CO2 / product")),
                                            HistorySectionModel(type: .receipt,
                                                                receipt: HistoryViewController.mockReceipt)]
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.registerCells(with: [ConsumptionsStatsTableViewCell.cellIdentifier, HistoryProductCell.cellIdentifier])
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .clear
        tableView.registerReuseFootHeaderViews(with: [HistoryReceiptSectionHeaderView.reuseIdentifier])
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = cellsData[indexPath.section].cellType.dequeueFromTableView(tableView, indexPath: indexPath)
        
        if let consumptionCell = cell as? ConsumptionsStatsTableViewCell,
            let consumptionStats = cellsData[indexPath.section].consumptionStats {
            consumptionCell.configure(withModel: consumptionStats)
        }
        
        if let productCell = cell as? HistoryProductCell,
            let product = cellsData[indexPath.section].receipt?.products[safe: indexPath.row] {
            productCell.configure(withProduct: product)
            productCell.delegate = self
        }
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return cellsData.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellsData[section].cellsCount
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if (cell as? HistoryProductCell) != nil {
            cell.layer.removeAllAnimations()
            if let receipt = cellsData[indexPath.section].receipt {
                let product = receipt.products[indexPath.row]
                if product.shouldBeAnimated {
                    product.shouldBeAnimated = false
                    cell.alpha = 0
                    UIView.animate(withDuration: 0.3, delay: 0.05 * Double(indexPath.row), options: .curveEaseInOut, animations: {
                        cell.alpha = 1
                    }, completion: nil)
                }
            }
        }
        
        guard let consumtionCell = cell as? ConsumptionsStatsTableViewCell,
            let model = cellsData[indexPath.section].consumptionStats else {
                return
        }
        consumtionCell.animate(withModel: model)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        (tableView.cellForRow(at: indexPath) as? ConsumptionsStatsTableViewCell)?.reset()
        //        (tableView.cellForRow(at: indexPath) as? ConsumptionsStatsTableViewCell)?.animate()
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = cellsData[section].headerViewType?.instantiateView()
        if let receiptHeaderView = view as? HistoryReceiptSectionHeaderView,
            let receipt = cellsData[section].receipt {
            receiptHeaderView.configure(withReceipt: receipt)
        }
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellsData[section].heightForHeader
    }
    
}

// MARK: - HistoryProductCellDelegate

extension HistoryViewController: HistoryProductCellDelegate {
    func didSelectWasted(fromCell cell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell),
            let receipt = cellsData[indexPath.section].receipt  else {return}
        print("Wasted: \(receipt.products[indexPath.row].name)")
        receipt.products[indexPath.row].state = .wasted
    }
    func didSelectUtilize(fromCell cell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell),
            let receipt = cellsData[indexPath.section].receipt  else {return}
        print("Utilize: \(receipt.products[indexPath.row].name)")
        receipt.products[indexPath.row].state = .utilized
    }
    func didSelectDone(fromCell cell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell),
            let receipt = cellsData[indexPath.section].receipt  else {return}
        print("Done: \(receipt.products[indexPath.row].name)")
        receipt.products[indexPath.row].state = .done
    }
}
