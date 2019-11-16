//
//  ViewController.swift
//  WasteReduction
//
//  Created by Alexander Shoshiashvili on 15.11.2019.
//  Copyright © 2019 Junction. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var feedbackEntries: Set<Product> = []
    
    // MARK: - Outlets
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var buttonShadowingView: ShadowingView!
    @IBOutlet private weak var buttonCreate: UIButton!
    
    // MARK: - Mock data
    
    static var mockReceiptConsumptionsStats: ConsumptionsStats {
        return ConsumptionsStats(domesticDetails: "33% of purchases", wasteDetails: "11% of waste", carbonDetails: "8 kg CO2 / product")
    }
    
    static var mockProducts: [Product] {
        return [Product(id: UUID().uuidString, name: "Manka", price: 7, quantity: 1, iconUrl: ""),
                Product(id: UUID().uuidString, name: "Gre4a", price: 99.99, quantity: 2, iconUrl: ""),
                Product(id: UUID().uuidString, name: "Milk", price: 2, quantity: 2.5, iconUrl: ""),
                Product(id: UUID().uuidString, name: "Strawberry", price: 3, quantity: 1.3, iconUrl: ""),
                Product(id: UUID().uuidString, name: "Manka", price: 7, quantity: 1, iconUrl: ""),
                Product(id: UUID().uuidString, name: "Gre4a", price: 99.99, quantity: 2, iconUrl: ""),
                Product(id: UUID().uuidString, name: "Milk", price: 2, quantity: 2.5, iconUrl: ""),
                Product(id: UUID().uuidString, name: "Strawberry", price: 3, quantity: 1.3, iconUrl: ""),
                Product(id: UUID().uuidString, name: "Manka", price: 7, quantity: 1, iconUrl: ""),
                Product(id: UUID().uuidString, name: "Gre4a", price: 99.99, quantity: 2, iconUrl: ""),
                Product(id: UUID().uuidString, name: "Milk", price: 2, quantity: 2.5, iconUrl: ""),
                Product(id: UUID().uuidString, name: "Strawberry", price: 3, quantity: 1.3, iconUrl: ""),
                Product(id: UUID().uuidString, name: "Manka", price: 7, quantity: 1, iconUrl: ""),
                Product(id: UUID().uuidString, name: "Gre4a", price: 99.99, quantity: 2, iconUrl: ""),
                Product(id: UUID().uuidString, name: "Milk", price: 2, quantity: 2.5, iconUrl: ""),
                Product(id: UUID().uuidString, name: "Strawberry", price: 3, quantity: 1.3, iconUrl: ""),
                Product(id: UUID().uuidString, name: "Manka", price: 7, quantity: 1, iconUrl: ""),
                Product(id: UUID().uuidString, name: "Gre4a", price: 99.99, quantity: 2, iconUrl: ""),
                Product(id: UUID().uuidString, name: "Milk", price: 2, quantity: 2.5, iconUrl: ""),
                Product(id: UUID().uuidString, name: "Strawberry", price: 3, quantity: 1.3, iconUrl: "")]
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
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerReuseFootHeaderViews(with: [HistoryReceiptSectionHeaderView.reuseIdentifier])
    }
    
    // MARK: - Actions

    @IBAction private func sendFeedback(_ sender: UIButton) {
        if feedbackEntries.contains(where: { $0.state == ProductState.utilized }) {
            let optionAlert = UIAlertController(title: "How would you rather utilize your products?",
                                                message: nil,
                                                preferredStyle: .actionSheet)
            
            let manuallyAction = UIAlertAction(title: "Find location", style: .default) { _ in
                let vc = TrashMapsVC.instantiate()
                self.present(vc, animated: true, completion: nil)
            }
            optionAlert.addAction(manuallyAction)
            
            let automaticallyAction = UIAlertAction(title: "Post on Facebook", style: .default) { _ in
                let facebookAlert = UIAlertController(title: "Successfully posted!",
                                                      message: "Post about your products successfully posted on Facebook group.",
                                                      preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Great!", style: .cancel, handler: nil)
                facebookAlert.addAction(okAction)
                facebookAlert.view.tintColor = Constants.Colors.theme
                self.present(facebookAlert, animated: true, completion: nil)
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            optionAlert.addAction(cancelAction)
            
            optionAlert.addAction(automaticallyAction)
            optionAlert.view.tintColor = Constants.Colors.theme
            self.present(optionAlert, animated: true, completion: nil)
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellsData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellsData[section].cellsCount
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        (tableView.cellForRow(at: indexPath) as? ConsumptionsStatsTableViewCell)?.reset()
        //        (tableView.cellForRow(at: indexPath) as? ConsumptionsStatsTableViewCell)?.animate()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = cellsData[section].headerViewType?.instantiateView()
        if let receiptHeaderView = view as? HistoryReceiptSectionHeaderView,
            let receipt = cellsData[section].receipt {
            receiptHeaderView.configure(withReceipt: receipt)
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellsData[section].heightForHeader
    }
    
}

// MARK: - HistoryProductCellDelegate

extension HistoryViewController: HistoryProductCellDelegate {
    func didSelectWasted(fromCell cell: HistoryProductCell) {
        updateState(toState: .wasted, cell: cell)
    }
    func didSelectUtilize(fromCell cell: HistoryProductCell) {
        updateState(toState: .utilized, cell: cell)
    }
    func didSelectDone(fromCell cell: HistoryProductCell) {
        updateState(toState: .done, cell: cell)
    }
    
    private func updateState(toState state: ProductState, cell: HistoryProductCell) {
        guard let indexPath = tableView.indexPath(for: cell),
            let receipt = cellsData[indexPath.section].receipt else { return }
        
        print("\(receipt.products[indexPath.row].name)")
//        if receipt.products[indexPath.row].state == ProductState.none  {
//            receipt.products[indexPath.row].state = state
//            cell.configureButtons(withState: state)
//            feedbackEntries.append(receipt.products[indexPath.row])
//            tableView.beginUpdates()
//            tableView.endUpdates()
//        } else if receipt.products[indexPath.row].state == state {
//            receipt.products[indexPath.row].state = .none
//            cell.configureButtons(withState: .none)
//            if feedbackEntries.contains(receipt.products[indexPath.row]) {
//                feedbackEntries.delete(element: receipt.products[indexPath.row])
//            }
//        } else {
//
//        }
        receipt.products[indexPath.row].state = state
        cell.configureButtons(withState: state)
        feedbackEntries.insert(receipt.products[indexPath.row])
        tableView.beginUpdates()
        tableView.endUpdates()
        updateSendFeedbackButtonState()
    }
    
    private func updateSendFeedbackButtonState() {
        buttonShadowingView.isHidden = feedbackEntries.isEmpty
    }
}
