//
//  ConcreteShoppingListVC.swift
//  WasteReduction
//
//  Created by Alexander Shoshiashvili on 16.11.2019.
//  Copyright © 2019 Junction. All rights reserved.
//

import UIKit
import NotificationBannerSwift
import SwipeCellKit

class ConcreteShoppingListVC: UIViewController {

    // MARK: - Handler
    
    var shoppingList: ShoppingList!
    var changedShoppingList: ShoppingList!
    var didUpdated: ((_ shoppingList: ShoppingList) -> Void)?
    
    // MARK: - Outlets
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var buttonShadowingView: ShadowingView!
    @IBOutlet private weak var buttonSave: UIButton!
    
    // MARK: - Mock data
    
    var data: [[Product]] = [[], [.dummy, .dummy, .dummyWithRecomendation], [.dummy, .dummy, .dummy]]
    var cellsData: [CreateShoppingListSectionModel] = []
    
    var sumText: String? {
        guard !shoppingList.products.isEmpty else {
            return nil
        }
        let totalSum = shoppingList.products.map({ $0.price * $0.quantity }).reduce(0, +)
        return "Σ: \(totalSum)"
    }
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        changedShoppingList = shoppingList
        cellsData = self.getViewModelsFromData()
        tableView.reloadData()
        updateSaveButtonState()
        
        title = shoppingList.name
        
        let imageSearchImage = UIImage(named: "search")?.withTintColor(Constants.Colors.theme)
        let navBarAction = UIBarButtonItem(image: imageSearchImage,
                                           style: .plain,
                                           target: self,
                                           action: #selector(handleSearchAction))
        navigationItem.rightBarButtonItem = navBarAction
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        setupTableView()
        buttonSave.isHidden = true
        buttonSave.backgroundColor = Constants.Colors.theme
    }
    
    private func setupTableView() {
        // 8 - spacing to bottm
        // 60 - button height
        let newInsets = UIEdgeInsets(top: view.safeAreaInsets.top, left: 0, bottom: view.safeAreaInsets.bottom + 20 + 60, right: 0)
        tableView.contentInset = newInsets
        tableView.scrollIndicatorInsets = newInsets
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerReuseFootHeaderViews(with: [TitleHeaderTableViewHeaderFooterView.reuseIdentifier])
        tableView.registerCells(with: [ProductWithRecommendaitonTableViewCell.cellIdentifier,
                                       ProductTableViewCell.cellIdentifier,
                                       InputFieldTableViewCell.cellIdentifier,
                                       ProductSelectionTableViewCell.cellIdentifier])
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func updateSaveButtonState() {
        buttonShadowingView.isHidden = changedShoppingList == shoppingList
        buttonSave.isHidden = changedShoppingList == shoppingList
        let nameIsEmpty = ((self.cellsData[0].rows[0] as? InputFieldViewModel)?.text ?? "").isEmpty
        let productsIsEmpty = data[1].isEmpty
        buttonSave.isEnabled = !nameIsEmpty && !productsIsEmpty
    }
    
    // MARK: - Prepare data
    
    private func getViewModelsFromData() -> [CreateShoppingListSectionModel] {
        
        let addedModels = data[1].map({ $0.toViewModel })
        let recommendedModels = data[2].map({ $0.toViewModel })
        
        let sections = [
            CreateShoppingListSectionModel(header: "Shopping list name", descrHeader: "", id: .name, rows: [
                InputFieldViewModel(text: changedShoppingList.name)
            ]),
            CreateShoppingListSectionModel(header: "Added", descrHeader: "", id: .added, rows: addedModels),
            CreateShoppingListSectionModel(header: "Recommendation", descrHeader: "", id: .recommendations, rows: recommendedModels)
        ]
        
        return sections
    }

    // MARK: - Actions
    
    @IBAction private func saveButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        didUpdated?(changedShoppingList)
    }
    
    @objc private func handleSearchAction() {
        let vc = SearchVC.instantiate()
        vc.didSelectProduct = { [weak self] product in
            guard let self = self else { return }
            
            let previousData = self.data[1]
            var currentData = self.data[1]
            currentData.insert(product, at: 0)
            self.data[1] = currentData
            self.cellsData = self.getViewModelsFromData()
            
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
            
            if previousData.isEmpty, !currentData.isEmpty {
                self.tableView.deleteRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
            }
            
            self.tableView.endUpdates()
            self.updateSaveButtonState()
        }
        present(vc, animated: true, completion: nil)
    }
    
}

// MARK: - UITableViewDataSource

extension ConcreteShoppingListVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if cellsData[2].rows.isEmpty {
            return cellsData.count - 1
        } else {
            return cellsData.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let itemsCount = cellsData[section].rows.count
        if section == 1, itemsCount == 0 {
            return 1
        } else {
            return itemsCount
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = cellsData[indexPath.section]
        
        guard !section.rows.isEmpty else {
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.text = "You can add items by pressing search icon or by choosing recommended items"
            cell.textLabel?.numberOfLines = 0
            return cell
        }
        
        let viewModel = section.rows[indexPath.row]
        
        switch section.id {
        case .name:
            guard let model = viewModel as? InputFieldViewModel else {
                return .init()
            }
            let cell = InputFieldTableViewCell.dequeueFromTableView(tableView, indexPath: indexPath)
            cell.configure(with: model)
            cell.delegate = self
            return cell
        case .added:
            if let model = viewModel as? ProductWithRecommendaitonViewModel {
                let cell = ProductWithRecommendaitonTableViewCell.dequeueFromTableView(tableView, indexPath: indexPath)
                cell.configure(withProduct: model)
                cell.delegate = self
                cell.cellDelegate = self
                return cell
            } else if let model = viewModel as? ProductViewModel {
                let cell = ProductTableViewCell.dequeueFromTableView(tableView, indexPath: indexPath)
                cell.configure(withProduct: model)
                cell.delegate = self
                return cell
            } else {
                return .init()
            }
        case .recommendations:
            if let model = viewModel as? ProductViewModel {
                let cell = ProductSelectionTableViewCell.dequeueFromTableView(tableView, indexPath: indexPath)
                cell.configure(withProduct: model)
                cell.delegate = self
                return cell
            } else {
                return .init()
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionVM = cellsData[section]
        let title = sectionVM.header
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TitleHeaderTableViewHeaderFooterView.reuseIdentifier) as? TitleHeaderTableViewHeaderFooterView
        header?.configure(withTitle: title, descr: sumText)
        return header
    }
    
}

// MARK: - UITableViewDelegate

extension ConcreteShoppingListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
}

// MARK: - InputFieldTableViewCellDelegate

extension ConcreteShoppingListVC: InputFieldTableViewCellDelegate {
    
    func inputFieldTableViewCellDidChangeText(_ cell: InputFieldTableViewCell, newText: String) {
        (cellsData[0].rows[0] as? InputFieldViewModel)?.text = newText
        changedShoppingList.name = newText
        self.updateSaveButtonState()
    }
    
}

// MARK: - ProductWithRecommendaitonTableViewCellDelegate

extension ConcreteShoppingListVC: ProductWithRecommendaitonTableViewCellDelegate {
    
    func productWithRecommendaitonTableViewCellDidPressReplace(_ cell: ProductWithRecommendaitonTableViewCell) {
        
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        let currentData = data[indexPath.section][indexPath.row]
        data[indexPath.section][indexPath.row] = currentData.recomendation!
        cellsData = getViewModelsFromData()
        
        changedShoppingList.products = data[indexPath.section]
        
        CATransaction.begin()
        
        CATransaction.setCompletionBlock {
            let banner = FloatingNotificationBanner(title: "Item is changed",
                                                    subtitle: "\(currentData.name) is added to \(currentData.recomendation!.name)", style: .success)
            banner.show(queuePosition: .front,
                        bannerPosition: .top,
                        cornerRadius: 12,
                        shadowColor: UIColor.black.withAlphaComponent(0.4),
                        shadowBlurRadius: 8)
        }
        
        self.tableView.beginUpdates()
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
        self.tableView.endUpdates()
        CATransaction.commit()
        
        self.updateSaveButtonState()
    }
    
}
// MARK: - ProductSelectionTableViewCellDelegate

extension ConcreteShoppingListVC: ProductSelectionTableViewCellDelegate {
    
    func productSelectionTableViewCellDidPressSwitch(_ cell: ProductSelectionTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        let currentData = data[indexPath.section][indexPath.row]
        var currentDataInSelectedSection = data[indexPath.section]
        currentDataInSelectedSection.remove(at: indexPath.row)
        data[indexPath.section] = currentDataInSelectedSection
     
        let previousDataInSecitonOne = self.data[1]
        var currentDataInSecitonOne = self.data[1]
        currentDataInSecitonOne.insert(currentData, at: 0)
        self.data[1] = currentDataInSecitonOne
        
        changedShoppingList.products = currentDataInSecitonOne
        
        self.cellsData = self.getViewModelsFromData()
        
        CATransaction.begin()
        
        CATransaction.setCompletionBlock {
            let banner = FloatingNotificationBanner(title: "Item is added",
                                                    subtitle: "\(currentData.name) is added to your shopping list",
                style: .success)
            banner.show(queuePosition: .front,
                        bannerPosition: .top,
                        cornerRadius: 12,
                        shadowColor: UIColor.black.withAlphaComponent(0.4),
                        shadowBlurRadius: 8)
        }
        
        self.tableView.beginUpdates()
        
        if self.cellsData[2].rows.isEmpty {
            self.tableView.deleteSections(IndexSet(integer: 2), with: .automatic)
        } else {
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        if previousDataInSecitonOne.isEmpty, !currentDataInSecitonOne.isEmpty {
            self.tableView.deleteRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
        }
        
        self.tableView.insertRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
        
        self.tableView.endUpdates()
        CATransaction.commit()
        
        self.updateSaveButtonState()
    }
    
}

// MARK: - SwipeTableViewCellDelegate

extension ConcreteShoppingListVC: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }
        let action = SwipeAction(style: .destructive, title: "Delete") { [weak self] action, indexPath in
            guard let self = self else { return }
            
            let previousData = self.data[indexPath.section]
            var currentData = self.data[indexPath.section]
            currentData.remove(at: indexPath.row)
            self.data[indexPath.section] = currentData
            
            self.cellsData = self.getViewModelsFromData()
            
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            if !previousData.isEmpty, currentData.isEmpty {
                self.tableView.insertRows(at: [IndexPath(row: 0, section: indexPath.section)], with: .automatic)
            }
            
            self.tableView.endUpdates()
        }
        action.backgroundColor = .systemBackground
        action.transitionDelegate = ScaleTransition(duration: 0.3,
                                                    initialScale: 0.5,
                                                    threshold: 0.5)

        action.image = UIImage(named: "delete")
        action.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        action.textColor = Constants.Colors.textColor
        return [action]
    }
    
}
