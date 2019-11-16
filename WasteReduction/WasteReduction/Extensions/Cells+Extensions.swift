//
//  ConsumptionsStatsTableViewCell.swift
//  WasteReduction
//
//  Created by Dmytro Antonchenko on 16.11.2019.
//  Copyright © 2019 Junction. All rights reserved.
//

import UIKit

//MARK: - Cell Init protocol
protocol CellInitializing {}

//MARK: - UITableViewCell extensions
extension UITableViewCell: CellInitializing {}

extension UITableViewCell {
    static var cellIdentifier: String {
        return String(describing: self)
    }
}

extension CellInitializing where Self: UITableViewCell {
    /// UI can be not properly autolayouted
    static func dequeueFromTableView(_ tableView: UITableView) -> Self {
        let identifier = cellIdentifier
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! Self
        return cell
    }
    /// UI should be properly autolayouted
    static func dequeueFromTableView(_ tableView: UITableView, indexPath: IndexPath) -> Self {
        let identifier = cellIdentifier
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! Self
        return cell
    }
}

//MARK: - UICollectionViewCell extensions
extension UICollectionViewCell: CellInitializing {}

extension UICollectionViewCell {
    static var cellIdentifier: String {
        return String(describing: self)
    }
}

extension CellInitializing where Self: UICollectionViewCell {
    static func dequeueFromCollectionView(_ collectionView: UICollectionView, indexPath: IndexPath) -> Self {
        let identifier = cellIdentifier
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! Self
        return cell
    }
}

//MARK: - UITableView extensions
extension UITableView {
    func registerCells(with identifiers: [String]) {
        identifiers.forEach { (identifer) in
            self.register(UINib(nibName: identifer, bundle: nil), forCellReuseIdentifier: identifer)
        }
    }
    
    func registerReuseFootHeaderViews(with identifiers: [String]) {
        identifiers.forEach { (identifer) in
            self.register(UINib(nibName: identifer, bundle: nil), forHeaderFooterViewReuseIdentifier: identifer)
        }
    }
}

//MARK: - UICollectionView extension
extension UICollectionView {
    func registerCells(with identifiers: [String]) {
        identifiers.forEach { (identifer) in
            self.register(UINib(nibName: identifer, bundle: nil), forCellWithReuseIdentifier: identifer)
        }
    }
    
    func registerView(with identifiers: [String], for kind: String) {
        identifiers.forEach { (identifer) in
            self.register(UINib(nibName: identifer, bundle: nil), forSupplementaryViewOfKind: kind, withReuseIdentifier: identifer)
        }
    }
}
