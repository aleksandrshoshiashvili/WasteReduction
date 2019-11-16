// Created for WasteReduction in 2019
// Using Swift 5.0
// Running on macOS 10.15

import UIKit

class ShadowingView: UIView {
    
    //set custom property for shadow
    var shadowColor: UIColor?
    var shadowOffset: CGSize?
    var shadowOpasity: Float?
    var shadowRadius: CGFloat?
    var shadowCornerRadius: CGFloat?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let myLayer = layer
        myLayer.backgroundColor = nil
        
        //default shadow of this view
        layer.shadowColor = shadowColor?.cgColor ?? UIColor.black.withAlphaComponent(0.2).cgColor
        layer.shadowOffset = shadowOffset ?? .zero
        layer.shadowOpacity = shadowOpasity ?? 1
        layer.masksToBounds = false
        layer.shadowRadius = shadowRadius ?? 4
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: shadowCornerRadius ?? 8).cgPath
    }
    
    override func action(for layer: CALayer, forKey event: String) -> CAAction? {
        if event != "shadowPath" {
            return super.action(for: layer, forKey: event)
        }
        let priorPath = layer.shadowPath
        if priorPath == nil {
            return super.action(for: layer, forKey: event)
        }
        
        let caAnim: CAAnimation? = layer.animation(forKey: "bounds.size")
        if !(caAnim is CABasicAnimation) {
            return super.action(for: layer, forKey: event)
        }
        
        
        let shadowAnimation: CABasicAnimation = caAnim!.copy() as! CABasicAnimation
        shadowAnimation.keyPath = "shadowPath"
        
        let act = ShadowingViewAction()
        act.priorPath = priorPath
        act.pendingAnimation = shadowAnimation
        return act
        
    }
}

class ShadowingViewAction: NSObject, CAAction {
    var pendingAnimation: CABasicAnimation?
    var priorPath: CGPath?
    func run(forKey event: String, object anObject: Any, arguments dict: [AnyHashable : Any]?) {
        if !(anObject is CALayer) || pendingAnimation == nil {
            return
        }
        let newLayer = anObject as! CALayer
        pendingAnimation?.fromValue = priorPath
        pendingAnimation?.toValue = newLayer.shadowPath
        newLayer.add(pendingAnimation!, forKey: "shadowPath")
    }
    
}



