//
//  ConsumptionsStatsTableViewCell.swift
//  WasteReduction
//
//  Created by Dmytro Antonchenko on 16.11.2019.
//  Copyright © 2019 Junction. All rights reserved.
//

import UIKit

protocol ShareDialogProtocol {
    func showShareDialog(text: String, image: UIImage)
    func showShareDialog(text: String, image: UIImage, url: URL)
    func showShareDialog(data: Data)
    func showShareDialog(url: URL)
}

extension ShareDialogProtocol where Self: UIViewController {

    func showShareDialog(text: String, image: UIImage) {
        self.showShareDialog(text: text, image: image, url: nil, data: nil)
    }

    func showShareDialog(text: String, image: UIImage, url: URL) {
        self.showShareDialog(text: text, image: image, url: url, data: nil)
    }

    func showShareDialog(data: Data) {
        self.showShareDialog(text: nil, image: nil, url: nil, data: data)
    }

    func showShareDialog(url: URL) {
        self.showShareDialog(text: nil, image: nil, url: url, data: nil)
    }

    // MARK: - Private

    private func showShareDialog(text: String?, image: UIImage?, url: URL?, data: Data?) {

        var shareItems: [Any] = []

        if let text = text {
            shareItems.append(text)
        }

        if let image = image {
            shareItems.append(image)
        }

        if let url = url {
            shareItems.append(url)
        }

        if let data = data {
            shareItems.append(data)
        }

        let activityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }

}
