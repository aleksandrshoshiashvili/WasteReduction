//
//  ViewController.swift
//  WasteReduction
//
//  Created by Alexander Shoshiashvili on 15.11.2019.
//  Copyright © 2019 Junction. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var feedbackEntries: Set<Product> = []
    
    // MARK: - Outlets
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var buttonShadowingView: ShadowingView!
    @IBOutlet private weak var buttonCreate: UIButton!
    
//    private var acitvityIndicatorView: NVActivityIndicatorView!
    
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
        let insets = UIEdgeInsets(top: view.safeAreaInsets.top,
                                  left: 0,
                                  bottom: 80,
                                  right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
        
        self.showActivityIndicator()
        NetworkService.shared.request(router: .receipts) { (result: Result<APIResult<[ReceiptAPI]>>) in
            switch result {
            case .success(let receiptResult):
                
                let objects = receiptResult.result
                var receipts: [Receipt] = []


                for object in objects {

                    let stats = ConsumptionsStats(domesticDetails: "\(Int.random(in: 10...98))% of purchases",
                        wasteDetails: "\(Int.random(in: 5...70))% of waste",
                        carbonDetails: "\(Int.random(in: 5...65)) kg CO2 / product")

                    var products = [Product] ()
                    for item in object.receiptItems {
                        let product = Product(id: UUID().uuidString, name: item.product.name ?? "Product",
                                              price: item.price, quantity: Double(item.quantity),
                                              carbonLevel: Double(Int.random(in: 10...33)), isDomestic: Bool.random(), iconUrl: item.product.pictureUrl ?? "https://www.mv.org.ua/image/news_small/2015/06/06_073953_81923.jpg")
                        products.append(product)
                    }
                    var receipt = Receipt(id: UUID().uuidString, domesticStat: stats.domestic, wasteStat: stats.waste, carbonStat: stats.carbon, products: products, date: object.date)
                    receipts.append(receipt)
                }
                
                var newCellsData = [HistorySectionModel(type: .stats,
                                                        consumptionsStats: ConsumptionsStats(domesticDetails: "\(Int.random(in: 10...33))% of purchases",
                                                            wasteDetails: "\(Int.random(in: 30...77))% of waste",
                                                            carbonDetails: "\(Int.random(in: 22...99)) kg CO2 / product"))]
                for receipt in receipts {
                    let cons = ConsumptionsStats(domesticDetails: receipt.domesticStat.details, wasteDetails: receipt.wasteStat.details, carbonDetails: receipt.carbonStat.details)
                    newCellsData.append(HistorySectionModel(type: .receipt, consumptionsStats: cons, receipt: receipt))
                }
                self.cellsData = newCellsData
                self.tableView.reloadData()
                self.hideActivityIndicator()
                print(objects)
            case .failure(let error):
                print(error)
                self.hideActivityIndicator()
            }
        }
    }
    
    // MARK: - Actions

    @IBAction private func sendFeedback(_ sender: UIButton) {
        if feedbackEntries.contains(where: { $0.state == ProductState.utilized }) {
            let optionAlert = UIAlertController(title: "How would you rather utilize your products?",
                                                message: nil,
                                                preferredStyle: .actionSheet)
            
            let manuallyAction = UIAlertAction(title: "Find location", style: .default) { _ in
                let vc = TrashMapsVC.instantiate()
                self.present(vc, animated: true, completion: {
                    self.feedbackEntries = []
                    self.updateSendFeedbackButtonState()
                })
            }
            optionAlert.addAction(manuallyAction)
            
            let automaticallyAction = UIAlertAction(title: "Post on Facebook", style: .default) { _ in
                let facebookAlert = UIAlertController(title: "Successfully posted!",
                                                      message: "Post about your products successfully posted on Facebook group.",
                                                      preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Great!", style: .cancel, handler: nil)
                facebookAlert.addAction(okAction)
                facebookAlert.view.tintColor = Constants.Colors.theme
                self.present(facebookAlert, animated: true, completion: {
                    self.feedbackEntries = []
                    self.updateSendFeedbackButtonState()
                })
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


import NVActivityIndicatorView

// MARK: - NVActivityIndicatorViewable

extension UIViewController: NVActivityIndicatorViewable {
  
  private struct AssociatedKeys {
    static var isIndicatorShowed = false
    static var activityLoadingIndicator: NVActivityIndicatorView?
  }
  
  var isIndicatorShowed: Bool {
    get {
      return (objc_getAssociatedObject(self, &AssociatedKeys.isIndicatorShowed) as? Bool) ?? false
    }
    set {
      objc_setAssociatedObject(
        self,
        &AssociatedKeys.isIndicatorShowed,
        newValue as Bool,
        .OBJC_ASSOCIATION_RETAIN_NONATOMIC
      )
    }
  }
  
  func showActivityIndicator() {
    let bcgrColor = UIColor.black.withAlphaComponent(0.5)
    let indicatorSize = CGSize(width: 100, height: 100)
    let indicatorColor = Constants.Colors.theme
    
    let type: NVActivityIndicatorType = .ballScale
    startAnimating(indicatorSize, message: nil, messageFont: nil, type: type, color: indicatorColor, padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: bcgrColor, textColor: nil)
    isIndicatorShowed = true
  }
  
  func hideActivityIndicator() {
    if isIndicatorShowed {
      stopAnimating()
      isIndicatorShowed = false
    }
  }
  
  // MARK: In view
  
  var activityLoadingIndicator: NVActivityIndicatorView? {
    get {
      guard let indicator = (objc_getAssociatedObject(self, &AssociatedKeys.activityLoadingIndicator) as? NVActivityIndicatorView) else {
        return nil
      }
      return indicator
    }
    set {
      objc_setAssociatedObject(
        self,
        &AssociatedKeys.activityLoadingIndicator,
        newValue,
        .OBJC_ASSOCIATION_RETAIN_NONATOMIC
      )
    }
  }
  
  func showActivityIndicatorInView() {
    view.isUserInteractionEnabled = false
    
    if let indicator = activityLoadingIndicator {
      view.bringSubviewToFront(indicator)
      indicator.startAnimating()
    } else {
      let indicatorSize = CGSize(width: 50, height: 50)
    let indicatorColor = Constants.Colors.theme
      
      let type: NVActivityIndicatorType = .ballClipRotate
      
      let viewCenter = CGPoint(x: UIScreen.main.bounds.width / 2.0, y: UIScreen.main.bounds.height / 2.0)
      let indicatorFrame = CGRect(x: viewCenter.x - indicatorSize.width / 2.0,
                                  y: viewCenter.y - indicatorSize.height / 2.0 - 2 * (UIScreen.main.bounds.height - view.frame.height),
                                  width: indicatorSize.width,
                                  height: indicatorSize.height)
      
      let indicatorView = NVActivityIndicatorView(frame: indicatorFrame, type: type, color: indicatorColor, padding: nil)
      activityLoadingIndicator = indicatorView
      view.addSubview(indicatorView)
      indicatorView.startAnimating()
    }
  }
  
  func hideActivityIndicatorInView() {
    view.isUserInteractionEnabled = true
    activityLoadingIndicator?.stopAnimating()
  }
  
}
