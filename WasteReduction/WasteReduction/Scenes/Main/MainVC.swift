//
//  MainVC.swift
//  WasteReduction
//
//  Created by Alexander Shoshiashvili on 16.11.2019.
//  Copyright © 2019 Junction. All rights reserved.
//

import UIKit
import Parchment
import Hero

public class MainVC: UIViewController {
  
  var pagingViewController: PagingViewController<PagingIndexItem>?
  
  var isReloaded = false
  
  // MARK: - View lifecycle
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    
    let pagingViewController = PagingViewController<PagingIndexItem>()
    addChild(pagingViewController)
    view.addSubview(pagingViewController.view)
    pagingViewController.view.bindToSuperView()
    pagingViewController.didMove(toParent: self)
    pagingViewController.dataSource = self
    
    self.pagingViewController = pagingViewController
    self.pagingViewController?.view.clipsToBounds = false
    self.pagingViewController?.view.layer.masksToBounds = false
    self.pagingViewController?.pageViewController.view.clipsToBounds = false
    self.pagingViewController?.pageViewController.view.layer.masksToBounds = false
    setupOptions()
    
    navigationController?.isHeroEnabled = true
    navigationController?.heroNavigationAnimationType = .autoReverse(presenting: .zoom)
  }
  
  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: true)
  }
  
  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if !isReloaded {
      reload()
      isReloaded = true
    }
  }
  
  public override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
  }
  
  // MARK: - MovieListViewInput
  
  public func setupInitialState() {
  }
  
  // MARK: - Private
  
  private func reload() {
    pagingViewController?.reloadData()
  }
  
  private func setupOptions() {
    pagingViewController?.collectionView.backgroundColor = .white
    pagingViewController?.menuItemSize = .sizeToFit(minWidth: 60, height: 44.0)
    pagingViewController?.textColor = UIColor.black.withAlphaComponent(0.4)
    pagingViewController?.selectedTextColor = UIColor.black
    
    let indicatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    pagingViewController?.indicatorOptions = .visible(height: 6.0, zIndex: Int.max, spacing: .zero, insets: indicatorInset)
    pagingViewController?.indicatorColor = Constants.Colors.theme
    
    pagingViewController?.borderOptions = .hidden
    
    pagingViewController?.font = .systemFont(ofSize: 16, weight: .regular)
    pagingViewController?.selectedFont = .systemFont(ofSize: 16, weight: .bold)
    
    pagingViewController?.collectionView.isScrollEnabled = false
  }
    
    private func page(atIndex index: Int) -> UIViewController {
        switch index {
        case 0:
            return HistoryViewController.instantiate()
        case 1:
            return ShoppingListVC.instantiate()
        default:
            return UIViewController()
        }
    }
    
    private func titleForPage(atIndex index: Int) -> String {
        switch index {
        case 0:
            return "History"
        case 1:
            return "Shopping list"
        default:
            return ""
        }
    }
    
    private func numberOfPages() -> Int {
        return 2
    }
  
}

// MARK: - PagingViewControllerDataSource

extension MainVC: PagingViewControllerDataSource {
  
  public func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, viewControllerForIndex index: Int) -> UIViewController {
    let viewController = page(atIndex: index)
    viewController.view.backgroundColor = .white
    return viewController
  }
  
  public func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, pagingItemForIndex index: Int) -> T {
    let title = titleForPage(atIndex: index)
    guard let item = PagingIndexItem(index: index, title: title) as? T else {
      fatalError()
    }
    return item
  }
  
  public func numberOfViewControllers<T>(in pagingViewController: PagingViewController<T>) -> Int {
    return numberOfPages()
  }
  
}
