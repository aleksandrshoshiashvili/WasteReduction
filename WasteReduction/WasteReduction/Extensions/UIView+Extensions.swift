//
//  ConsumptionsStatsTableViewCell.swift
//  WasteReduction
//
//  Created by Dmytro Antonchenko on 16.11.2019.
//  Copyright © 2019 Junction. All rights reserved.
//

import UIKit

protocol ViewInitializing {}

extension UIView: ViewInitializing {}

extension ViewInitializing where Self: UIView {
    static func instantiateView() -> Self {
        let nibName = "\(self)".split{$0 == "."}.map(String.init).last!
        let loadedElements = Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)!
        let loadedView = loadedElements.filter({$0 is Self}).first
        assert(loadedView != nil, "wrong nib name for view: \(nibName)")
        return loadedView as! Self
    }
}

extension UIColor {
    convenience init(R: Int, G: Int, B: Int, A: CGFloat = 1) {
        self.init(red: CGFloat(R)/255, green: CGFloat(G)/255, blue: CGFloat(B)/255, alpha: A)
    }
}

extension UIView {
        
    public func bindToSuperView(with insets: UIEdgeInsets = .zero) {
      guard let superView = self.superview else { return }
      self.translatesAutoresizingMaskIntoConstraints = false
      
      NSLayoutConstraint.activate([
        self.topAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.topAnchor, constant: insets.top),
        self.bottomAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.bottomAnchor, constant: -insets.bottom),
        self.trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: insets.right),
        self.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: insets.left)
        ])
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            if let borderColor = self.layer.borderColor {
                return UIColor(cgColor: borderColor)
            } else {
                return nil
            }
        }
        set {
            self.layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var masksToBounds: Bool {
        get {
            return self.layer.masksToBounds
        }
        set {
            self.layer.masksToBounds = newValue
        }
    }
    
    @IBInspectable var isApplyShadow: Bool {
        get {
            return self.layer.shadowColor != nil
        }
        set {
            self.applyShadow()
        }
    }
    
    func round(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func constraintToSuperViewEdges() {
        guard let superView = superview else {return}
        translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: 0).isActive = true
        trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: 0).isActive = true
        topAnchor.constraint(equalTo: superView.topAnchor, constant: 0).isActive = true
        bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: 0).isActive = true
    }
    
    func constraintsToViewEdges(view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    
    func constraintToSuperViewEdges(leading: CGFloat, trailing: CGFloat, top: CGFloat, bottom: CGFloat) {
        guard let superView = superview else {return}
        translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: leading).isActive = true
        trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: trailing).isActive = true
        topAnchor.constraint(equalTo: superView.topAnchor, constant: top).isActive = true
        bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: bottom).isActive = true
    }
    
    func equealWidthAndHeight(view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }

    func applyShadow() {
        layer.shadowColor = UIColor(R: 81, G: 81, B: 81, A: 0.3).cgColor
        layer.shadowRadius = 4.0
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 1.0
        clipsToBounds = false
    }

    func applyRounding() {
        cornerRadius = 8.0
    }

    func applyCircleShadow() {
        layer.shadowColor = UIColor(R: 246, G: 103, B: 103, A: 1).cgColor
        layer.shadowRadius = 16.0
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowOpacity = 1.0
        clipsToBounds = false
    }
}

