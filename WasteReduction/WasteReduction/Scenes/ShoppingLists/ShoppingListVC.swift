// Created for WasteReduction in 2019
// Using Swift 5.0
// Running on macOS 10.15

import UIKit

class ShoppingListVC: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var buttonShadowingView: ShadowingView!
    @IBOutlet private weak var buttonCreate: UIButton!
    
    // MARK: - Mock data
    
    var shoppingLists = ["Home" , "Work", "Kebab", "Mamba", "Vertungun", "Wroteben", "Arbaite", "Shnelia", "Schwine", "Long", "Data", "To", "Test", "Insets", "Of", "TableView"].map({ ShoppingList(id: UUID().uuidString, name: $0, products: []) })
    var cellsData: [ShoppingListModel] = []
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateViewModels()
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
        tableView.registerCells(with: [ShoppingListTableViewCell.cellIdentifier])
        tableView.rowHeight = UITableView.automaticDimension
    }

    // MARK: - Actions
    
    @IBAction private func createButtonAction(_ sender: UIButton) {
        let vc = CreateShoppingListVC.instantiate()
        
        vc.didCreate = { [weak self] shoppingList in
            guard let self = self else { return }
            self.shoppingLists.insert(shoppingList, at: 0)
            self.updateViewModels()
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            self.tableView.endUpdates()
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Private
    
    func updateViewModels() {
        cellsData = shoppingLists.map({ ShoppingListModel(id: UUID().uuidString, name: $0.name) })
    }
    
}

// MARK: - UITableViewDataSource

extension ShoppingListVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ShoppingListTableViewCell.dequeueFromTableView(tableView, indexPath: indexPath)
        cell.configure(withName: cellsData[indexPath.row].name)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ShoppingListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ConcreteShoppingListVC.instantiate()
        vc.shoppingList = shoppingLists[indexPath.row]
        vc.didUpdated = { [weak self] shoppingList in
            guard let self = self else { return }
            if let index = self.shoppingLists.firstIndex(where: { $0.id == shoppingList.id }) {
                self.shoppingLists[index] = shoppingList
                self.updateViewModels()
                self.tableView.beginUpdates()
                self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
                self.tableView.endUpdates()
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if cellsData[indexPath.row].shouldBeAnimated {
            cellsData[indexPath.row].shouldBeAnimated = false
            cell.alpha = 0
            UIView.animate(withDuration: 0.3, delay: 0.1 * Double(indexPath.row), options: .curveEaseInOut, animations: {
                cell.alpha = 1
            }, completion: nil)
        }
    }
}
