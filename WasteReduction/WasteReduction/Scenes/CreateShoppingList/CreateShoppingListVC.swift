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
    let rows: [ViewModel]
    
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
            ProductWithRecommendaitonViewModel(id: "1", name: "Milk", price: 7, quantity: 1, carbonLevel: "30 kg CO^2", isDomestic: true),
            ProductWithRecommendaitonViewModel(id: "1", name: "Milk", price: 1, quantity: 3, carbonLevel: "6 kg CO^2", isDomestic: false),
            ProductWithRecommendaitonViewModel(id: "1", name: "Milk", price: 70, quantity: 5, carbonLevel: "10 kg CO^2", isDomestic: true)
        ])
    ]
    
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
        let newInsets = UIEdgeInsets(top: view.safeAreaInsets.top, left: 0, bottom: view.safeAreaInsets.bottom + 8 + 60, right: 0)
        tableView.contentInset = newInsets
        tableView.scrollIndicatorInsets = newInsets
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerReuseFootHeaderViews(with: [TitleHeaderTableViewHeaderFooterView.reuseIdentifier])
        tableView.registerCells(with: [ProductWithRecommendaitonTableViewCell.cellIdentifier, ProductTableViewCell.cellIdentifier, InputFieldTableViewCell.cellIdentifier])
        tableView.rowHeight = UITableView.automaticDimension
    }

    // MARK: - Actions
    
    @IBAction private func createButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func handleSearchAction() {
        
    }
    
}

// MARK: - UITableViewDataSource

extension CreateShoppingListVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellsData.count
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
            guard let model = viewModel as? ProductWithRecommendaitonViewModel else {
                return .init()
            }
            let cell = ProductTableViewCell.dequeueFromTableView(tableView, indexPath: indexPath)
            cell.configure(withProduct: model)
            return cell
        case .recommendations:
            guard let model = viewModel as? ProductWithRecommendaitonViewModel else {
                return .init()
            }
            let cell = ProductWithRecommendaitonTableViewCell.dequeueFromTableView(tableView, indexPath: indexPath)
            cell.configure(withProduct: model)
            return cell
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
