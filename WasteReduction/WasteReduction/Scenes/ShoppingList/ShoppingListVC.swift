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
    
    let cellsData: [String] = ["Home" , "Work", "Kebab", "Mamba", "Vertungun", "Wroteben", "Arbaite", "Shnelia", "Schwine", "Long", "Data", "To", "Test", "Insets", "Of", "TableView"]
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        setupTableView()
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
        tableView.registerCells(with: [ShoppingListTableViewCell.cellIdentifier])
        tableView.rowHeight = UITableView.automaticDimension
    }

    // MARK: - Actions
    @IBAction private func createButtonAction(_ sender: UIButton) {
        //debug
        self.navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - UITableViewDataSource

extension ShoppingListVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ShoppingListTableViewCell.dequeueFromTableView(tableView, indexPath: indexPath)
        cell.configure(withName: cellsData[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ShoppingListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(cellsData[indexPath.row])
    }
    
}
