//
//  ConsumptionsStatsTableViewCell.swift
//  WasteReduction
//
//  Created by Dmytro Antonchenko on 16.11.2019.
//  Copyright © 2019 Junction. All rights reserved.
//

import UIKit

//MARK: - Add all your storyboard here
enum StoryboardId: String {
    case Main = "Main"
    case Search = "Search"
}

//MARK: - Add all your controllers ids here
enum ControllersId: String {
    
    //MARK: - Main.storyboard
    case HistoryViewController = "HistoryViewController"
    case ShoppingListVC = "ShoppingListVC"
    case MainVC = "MainVC"
    case SearchVC = "SearchVC"
    case CreateShoppingListVC = "CreateShoppingListVC"
    case ConcreteShoppingListVC = "ConcreteShoppingListVC"
    
    //MARK: - Populate switch case statement
    var storyboardId: StoryboardId {
        switch self {
        case .HistoryViewController, .ShoppingListVC, .MainVC, .CreateShoppingListVC, .ConcreteShoppingListVC:
            return .Main
        case .SearchVC:
            return .Search
        }
    }
}

//MARK: - Initialization extensions
protocol StoryboardInitializing {}
extension UIViewController: StoryboardInitializing {}
private extension UIViewController {
    static var className: String {
        return String(describing: self)
    }
}

extension StoryboardInitializing where Self: UIViewController {
    
    /// Initialize controller from storyboard withIdentifier: className
    static func instantiate(with storyboardId: StoryboardId) -> Self {
        let vcIdentifier = className
        
        let storyboard = UIStoryboard(name: storyboardId.rawValue, bundle: nil) as UIStoryboard?
        assert(storyboard != nil, "Storyboard name is incorrect")
        
        let vc = storyboard?.instantiateViewController(withIdentifier: vcIdentifier)
        assert(vc != nil, "ViewController id name is incorrect")
        
        return vc as! Self
    }
    
    /// Initialize controller from storyboard with custom identifier
    static func instantiate(with storyboardId: StoryboardId, viewIdentifier: String) -> Self {
        
        let storyboard = UIStoryboard(name: storyboardId.rawValue, bundle: nil) as UIStoryboard?
        assert(storyboard != nil, "Storyboard name is incorrect")
        
        let vc = storyboard?.instantiateViewController(withIdentifier: viewIdentifier)
        assert(vc != nil, "ViewController id name is incorrect")
        
        return vc as! Self
    }
    
    /// Initialize controller automatically based on StoryboardId and ControllerId
    static func instantiate() -> Self {
        let storyboardID = ControllersId(rawValue: className)?.storyboardId
        assert(storyboardID != nil, "storyboard id is nil")
        return instantiate(with: storyboardID!)
    }
    
    /// Initialize initial controller from storyboard
    static func instantiateInitial(from storyboardId: StoryboardId) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardId.rawValue, bundle: nil) as UIStoryboard?
        assert(storyboard != nil, "Storyboard name is incorrect")
        let vc = storyboard?.instantiateInitialViewController()
        assert(vc != nil, "No initialViewcontroller in storyboard")
        return vc!
    }
    
}

