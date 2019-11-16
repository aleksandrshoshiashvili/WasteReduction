//
//  UIImageView+Extensions.swift
//  WasteReduction
//
//  Created by Alexander Shoshiashvili on 16.11.2019.
//  Copyright © 2019 Junction. All rights reserved.
//

import UIKit
import AlamofireImage

extension UIImageView {
  
  private var defaultImageTransition: ImageTransition {
    return .crossDissolve(0.3)
  }
  
  // MARK: URL
  
  func setImage(url: URL, placeholder: UIImage? = nil) {
    setImage(url: url, placeholder: placeholder, filter: nil)
  }
  
  func setRoundedImage(url: URL, placeholder: UIImage? = nil, radius: CGFloat) {
    let filter = RoundedCornersFilter(radius: radius)
    setImage(url: url, placeholder: placeholder, filter: filter)
  }
  
  func setCircularImage(url: URL, placeholder: UIImage? = nil) {
    setRoundedImage(url: url, placeholder: placeholder, radius: bounds.height / 2.0)
  }
  
  // MARK: UrlString
  
  func setImage(urlString: String, placeholder: UIImage? = nil) {
    guard let url = URL(string: urlString) else {
        return
    }
    setImage(url: url, placeholder: placeholder, filter: nil)
  }
  
  func setRoundedImage(urlString: String, placeholder: UIImage? = nil, radius: CGFloat) {
    guard let url = URL(string: urlString) else {
        return
    }
    let filter = RoundedCornersFilter(radius: radius)
    setImage(url: url, placeholder: placeholder, filter: filter)
  }
  
  func setCircularImage(urlString: String, placeholder: UIImage? = nil) {
    guard let url = URL(string: urlString) else {
        return
    }
    let filter = CircleFilter()
    setImage(url: url, placeholder: placeholder, filter: filter)
  }
  
  // MARK: Cancel
  
  func cancelImageLoad() {
    af_cancelImageRequest()
  }
  
  // MARK: - Helper
  
  private func setImage(url: URL, placeholder: UIImage?, filter: ImageFilter?) {
    af_setImage(withURL: url,
                placeholderImage: placeholder,
                filter: filter,
                imageTransition: defaultImageTransition,
                runImageTransitionIfCached: false)
  }
  
}
