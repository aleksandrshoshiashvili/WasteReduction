//
//  CreateShoppingListVC.swift
//  WasteReduction
//
//  Created by Alexander Shoshiashvili on 16.11.2019.
//  Copyright © 2019 Junction. All rights reserved.
//

import UIKit

class ViewModel {}

enum CreateShoppingListSectionType: String {
    case name
    case added
    case recommendations
}

struct CreateShoppingListSectionModel {
    
    let header: String
    let id: CreateShoppingListSectionType
    var rows: [ViewModel]
    
}

class CreateShoppingListVC: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var buttonShadowingView: ShadowingView!
    @IBOutlet private weak var buttonCreate: UIButton!
    
    // MARK: - Mock data
    
    let dummyData = [
        CreateShoppingListSectionModel(header: "Name", id: .name, rows: [
            InputFieldViewModel(text: "")
        ]),
        CreateShoppingListSectionModel(header: "Added", id: .added, rows: [
            ProductViewModel(id: "1", name: "Milk", price: 7, quantity: 1, carbonLevel: "30 kg CO^2", isDomestic: true, productIcon: "https://k-file-storage-qa.imgix.net/f/k-ruoka/product/0490000312492"),
            ProductViewModel(id: "1", name: "Milk", price: 1, quantity: 3, carbonLevel: "6 kg CO^2", isDomestic: false, productIcon: "https://k-file-storage-qa.imgix.net/f/k-ruoka/product/0490000312492"),
            ProductWithRecommendaitonViewModel(id: "1", name: "Kefir", price: 12.5, quantity: 1, carbonLevel: "1 kg CO^2", isDomestic: true, recommendedTitle: "You can reduce Carbon level buying similar product:", recommendedProductName: "Kefir 2.0", recommendedProductIcon: "https://k-file-storage-qa.imgix.net/f/k-ruoka/product/0490000312492")
            ]),
        CreateShoppingListSectionModel(header: "Recommendation", id: .recommendations, rows: [
            
            ProductViewModel(id: "1", name: "Milk", price: 70, quantity: 5, carbonLevel: "6 kg CO^2", isDomestic: true, productIcon: "https://k-file-storage-qa.imgix.net/f/k-ruoka/product/0490000312492"),
            ProductViewModel(id: "1", name: "Coca-Cola", price: 15, quantity: 1, carbonLevel: "5 kg CO^2", isDomestic: false, productIcon: "https://k-file-storage-qa.imgix.net/f/k-ruoka/product/0490000312492"),
            ProductViewModel(id: "1", name: "Juice", price: 1, quantity: 1, carbonLevel: "11 kg CO^2", isDomestic: true, productIcon: "https://k-file-storage-qa.imgix.net/f/k-ruoka/product/0490000312492")
        ])
    ]
    
    var data: [[Product]] = [[], [.dummy, .dummy, .dummy], [.dummy, .dummy, .dummy]]
    var cellsData: [CreateShoppingListSectionModel] = []
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        cellsData = dummyData
        tableView.reloadData()
        title = "Create new list"
        
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
        buttonCreate.backgroundColor = Constants.Colors.theme
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
    
    // MARK: - Prepare data
    
    private func getViewModelsFromData() -> [CreateShoppingListSectionModel] {
        
        let sections = [
            CreateShoppingListSectionModel(header: "Shopping list name", id: .name, rows: [
                InputFieldViewModel(text: "")
            ]),
            CreateShoppingListSectionModel(header: "Added", id: .added, rows: [
                ]),
            CreateShoppingListSectionModel(header: "Recommendation", id: .recommendations, rows: [
            ])
        ]
        
        return sections
    }

    // MARK: - Actions
    
    @IBAction private func createButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
        }
        present(vc, animated: true, completion: nil)
    }
    
}

// MARK: - UITableViewDataSource

extension CreateShoppingListVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellsData.filter({ !$0.rows.isEmpty }).count
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
        let title = cellsData[section].header
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TitleHeaderTableViewHeaderFooterView.reuseIdentifier) as? TitleHeaderTableViewHeaderFooterView
        header?.configure(withTitle: title)
        return header
    }
    
}

// MARK: - UITableViewDelegate

extension CreateShoppingListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
}

// MARK: - InputFieldTableViewCellDelegate

extension CreateShoppingListVC: InputFieldTableViewCellDelegate {
    
    func inputFieldTableViewCellDidChangeText(_ cell: InputFieldTableViewCell, newText: String) {
        (cellsData[0].rows[0] as? InputFieldViewModel)?.text = newText
    }
    
}

// MARK: - ProductSelectionTableViewCellDelegate

extension CreateShoppingListVC: ProductSelectionTableViewCellDelegate {
    
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
            print("finished")
        }
        
        self.tableView.beginUpdates()
        
        if self.cellsData[2].rows.isEmpty {
            self.tableView.deleteSections(IndexSet(integer: 2), with: .automatic)
        } else {
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        self.tableView.insertRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
        
        self.tableView.endUpdates()
        CATransaction.commit()
    }
    
}
