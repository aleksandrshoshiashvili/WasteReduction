// Created for WasteReduction in 2019
// Using Swift 5.0
// Running on macOS 10.15

import UIKit

class SearchVC: UIViewController, UISearchBarDelegate, UISearchResultsUpdating {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var nothingFoundView: UIView!
    
    // MARK: - Private
    
    private var searchController: UISearchController!
    private var willShowKeyboardToken: Token?
    private var willHideKeyboardToken: Token?
    
    // MARK: - Mock DAta
    
    let dummyNames = ["Home" , "Work", "Kebab", "Mamba", "Vertungun", "Wroteben", "Arbaite", "Shnelia", "Schwine", "Long", "Data", "To", "Test", "Insets", "Of", "TableView"]
    var notFiltered: [Product] = []
    
    var cellsData: [Product] = [] {
        didSet {
            tableView.reloadSections([0], with: .automatic)
            if cellsData != oldValue, cellsData.isEmpty {
                setNoResultsView(isHidden: false)
            } else {
                setNoResultsView(isHidden: true)
            }
        }
    }
    
    // MARK: - Completion
    
    var didSelectProduct: ((_ product: Product) -> Void )?
    
    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        notFiltered = dummyNames.map {Product(id: UUID().uuidString, name: $0, price: 75, quantity: 1)}
    }
    
    // MARK: - Private func
    
    private func setupUI() {
        setupTableView()
        setupSearchBar()
        addListeners()
        setNoResultsView(isHidden: false)
    }
    
    private func setNoResultsView(isHidden: Bool) {
        
        UIView.animate(withDuration: 0.3) {
            self.nothingFoundView.alpha = isHidden ? 0 : 1
        }
    }

    private func setupTableView() {
        tableView.registerCells(with: [SearchProductCell.cellIdentifier])
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
    }
    
    private func setupSearchBar() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
        searchBar.delegate = self
    }
    
    //MARK: - Subscribe to notifications
    private func addListeners() {
        
        let keyboardWillShowDescriptor = NotificationDescriptor<KeyBoardNotification>(name: UIResponder.keyboardWillShowNotification, convert: KeyBoardNotification.init)
        willShowKeyboardToken = NotificationCenter.default.addObserver(descriptor: keyboardWillShowDescriptor, using: { [weak self](keyBoardNotification) in
            guard let self = self else {return}
            
            let newBottomInset = self.view.safeAreaInsets.bottom + keyBoardNotification.frame.height
            let newInset = UIEdgeInsets(top: self.view.safeAreaInsets.top, left: 0, bottom: newBottomInset, right: 0)
            self.tableView.contentInset = newInset
            self.tableView.scrollIndicatorInsets = newInset
        })
        let keyboardWillHideDescriptor = NotificationDescriptor<KeyBoardNotification>(name: UIResponder.keyboardWillHideNotification, convert: KeyBoardNotification.init)
        willHideKeyboardToken = NotificationCenter.default.addObserver(descriptor: keyboardWillHideDescriptor, using: { [weak self](keyBoardNotification) in
            guard let self = self else {return}
            let newInset = UIEdgeInsets(top: self.view.safeAreaInsets.top, left: 0, bottom: self.view.safeAreaInsets.bottom, right: 0)
            self.tableView.contentInset = newInset
            self.tableView.scrollIndicatorInsets = newInset
        })
    }
    
    //MARK: - UISearchBarDelegate, UISearchResultsUpdating
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        cellsData = notFiltered.filter({$0.name.contains(searchText)})
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        print(searchController)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource

extension SearchVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SearchProductCell.dequeueFromTableView(tableView, indexPath: indexPath)
        cell.configure(withProduct: cellsData[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate

extension SearchVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let dismissCompletion: () -> Void = { [weak self] in
            guard let self = self else {return}
            self.didSelectProduct?(self.cellsData[indexPath.row])
        }
        dismiss(animated: true, completion: dismissCompletion)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
