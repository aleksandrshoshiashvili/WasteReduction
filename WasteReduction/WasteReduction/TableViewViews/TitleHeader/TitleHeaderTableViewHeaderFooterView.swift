//
//  TitleHeaderTableViewHeaderFooterView.swift
//  WasteReduction
//
//  Created by Alexander Shoshiashvili on 16.11.2019.
//  Copyright © 2019 Junction. All rights reserved.
//

import UIKit

class TitleHeaderTableViewHeaderFooterView: UITableViewHeaderFooterView {

    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    // MARK: - Outlets
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descrLabel: UILabel!
    
    // MARK: - Interace
    
    func configure(withTitle title: String, descr: String? = nil) {
        titleLabel.text = title
        descrLabel.text = descr
        
        descrLabel.isHidden = (descr ?? "").isEmpty
    }

}
