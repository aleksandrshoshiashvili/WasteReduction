//
//  ConcreteShoppingListVC.swift
//  WasteReduction
//
//  Created by Alexander Shoshiashvili on 16.11.2019.
//  Copyright © 2019 Junction. All rights reserved.
//

import UIKit
import NotificationBannerSwift

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
    
    var data: [[Product]] = [[], [.dummy, .dummy, .dummy], [.dummy, .dummy, .dummy]]
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
        
        let dummyData = [
            CreateShoppingListSectionModel(header: "Name", descrHeader: nil, id: .name, rows: [
                InputFieldViewModel(text: shoppingList.name)
            ]),
            CreateShoppingListSectionModel(header: "Added", descrHeader: sumText, id: .added,
                                           rows: shoppingList.products.map({ $0.toViewModel })),
            CreateShoppingListSectionModel(header: "Recommendation", descrHeader: nil, id: .recommendations, rows: [
                
                ProductViewModel(id: "1", name: "Milk", price: 70, quantity: 5, carbonLevel: "6 kg CO^2", isDomestic: true, productIcon: "https://k-file-storage-qa.imgix.net/f/k-ruoka/product/0490000312492"),
                ProductViewModel(id: "1", name: "Coca-Cola", price: 15, quantity: 1, carbonLevel: "5 kg CO^2", isDomestic: false, productIcon: "https://k-file-storage-qa.imgix.net/f/k-ruoka/product/0490000312492"),
                ProductViewModel(id: "1", name: "Juice", price: 1, quantity: 1, carbonLevel: "11 kg CO^2", isDomestic: true, productIcon: "https://k-file-storage-qa.imgix.net/f/k-ruoka/product/0490000312492")
            ])
        ]
        
        cellsData = dummyData
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
        
        let sections = [
            CreateShoppingListSectionModel(header: "Shopping list name", descrHeader: "", id: .name, rows: [
                InputFieldViewModel(text: "")
            ]),
            CreateShoppingListSectionModel(header: "Added", descrHeader: "", id: .added, rows: [
                ]),
            CreateShoppingListSectionModel(header: "Recommendation", descrHeader: "", id: .recommendations, rows: [
            ])
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
            
            var currentRows = self.cellsData[1].rows
            
            let vm = product.toViewModel
            currentRows.insert(vm, at: 0)
            self.cellsData[1].rows = currentRows
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
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
        return cellsData[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = cellsData[indexPath.section]
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
                return cell
            } else if let model = viewModel as? ProductViewModel {
                let cell = ProductTableViewCell.dequeueFromTableView(tableView, indexPath: indexPath)
                cell.configure(withProduct: model)
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

// MARK: - ProductSelectionTableViewCellDelegate

extension ConcreteShoppingListVC: ProductSelectionTableViewCellDelegate {
    
    func productSelectionTableViewCellDidPressSwitch(_ cell: ProductSelectionTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        let currentData = data[indexPath.section][indexPath.row]
        var currentRowsInSelectedSection = cellsData[indexPath.section].rows
        currentRowsInSelectedSection.remove(at: indexPath.row)
        cellsData[indexPath.section].rows = currentRowsInSelectedSection
     
        let vm = currentData.toViewModel
        var currentRowsInSecitonOne = self.cellsData[1].rows
        currentRowsInSecitonOne.insert(vm, at: 0)
        self.cellsData[1].rows = currentRowsInSecitonOne
        
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
        
        let sectionVM = cellsData[1]
        let title = sectionVM.header
        (self.tableView.headerView(forSection: 1) as? TitleHeaderTableViewHeaderFooterView)?.configure(withTitle: title, descr: sumText)
        self.tableView.insertRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
        
        self.tableView.endUpdates()
        CATransaction.commit()
        
        self.updateSaveButtonState()
    }
    
}
