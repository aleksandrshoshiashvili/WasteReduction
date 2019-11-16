//
//  InputFieldTableViewCell.swift
//  WasteReduction
//
//  Created by Alexander Shoshiashvili on 16.11.2019.
//  Copyright © 2019 Junction. All rights reserved.
//

import UIKit

class InputFieldViewModel: ViewModel {
    var text: String
    
    init(text: String) {
        self.text = text
    }
}

protocol InputFieldTableViewCellDelegate: class {
    func inputFieldTableViewCellDidChangeText(_ cell: InputFieldTableViewCell, newText: String)
}

class InputFieldTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var underlineView: UIView!
    @IBOutlet private weak var textField: UITextField!
    
    // MARK: - Delegate
    
    weak var delegate: InputFieldTableViewCellDelegate?
    
    // MARK: - Reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Object Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        underlineView.backgroundColor = Constants.Colors.theme.withAlphaComponent(0.4)
        textField.delegate = self
        textField.tintColor = Constants.Colors.theme
        selectionStyle = .none
    }

    // MARK: - Interface
    
    func configure(with viewModel: InputFieldViewModel) {
        textField.text = viewModel.text
    }
    
    // MARK: - Actions
    
    @objc func textFieldDidChange(textField: UITextField) {
        delegate?.inputFieldTableViewCellDidChangeText(self, newText: textField.text ?? "")
    }
}

extension InputFieldTableViewCell: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        underlineView.backgroundColor = Constants.Colors.theme
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        underlineView.backgroundColor = Constants.Colors.theme.withAlphaComponent(0.4)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
