//
//  ConsumptionsStatsTableViewCell.swift
//  WasteReduction
//
//  Created by Dmytro Antonchenko on 16.11.2019.
//  Copyright © 2019 Junction. All rights reserved.
//

import UIKit
import DynamicButton

class ConsumptionsStatsTableViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var domesticButtonContainerView: UIView!
    private var domesticButton: DynamicButton!
    @IBOutlet weak var domesticLabel: UILabel!
    @IBOutlet weak var domesticDetailsLabel: UILabel!
    @IBOutlet weak var wasteButtonContainerView: UIView!
    private var wasteButton: DynamicButton!
    @IBOutlet weak var wasteLabel: UILabel!
    @IBOutlet weak var wasteDetailasLabel: UILabel!
    @IBOutlet weak var carbonButtonContainerView: UIView!
    private var carbonButton: DynamicButton!
    @IBOutlet weak var carbonLabel: UILabel!
    @IBOutlet weak var carbonDetailsLabel: UILabel!
    
    // MARK: - Object lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    // MARK: - Open
    
    func configure(withModel model: ConsumptionsStats) {
        
        domesticLabel.text = model.domestic.type.title
        domesticDetailsLabel.text = model.domestic.details
        wasteLabel.text = model.waste.type.title
        wasteDetailasLabel.text = model.waste.details
        carbonLabel.text = model.carbon.type.title
        carbonDetailsLabel.text = model.carbon.details
    }
    
    // MARK: - Animation
    
    func animate() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.domesticButton.setStyle(.caretUp, animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.wasteButton.setStyle(.caretDown, animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.carbonButton.setStyle(.caretDown, animated: true)
                }
            }
        }
    }
    
    func reset() {
        domesticButton.setStyle(.dot, animated: false)
        wasteButton.setStyle(.dot, animated: false)
        carbonButton.setStyle(.dot, animated: false)
    }
    
    // MARK: - Private
    
    private func setup() {
        
        configure(button: &domesticButton, container: domesticButtonContainerView, color: Constants.Colors.lightYellow)
        configure(button: &wasteButton, container: wasteButtonContainerView, color: Constants.Colors.darkBlue)
        configure(button: &carbonButton, container: carbonButtonContainerView, color: Constants.Colors.pinkRed)
        domesticDetailsLabel.textColor = Constants.Colors.lightYellow
        wasteDetailasLabel.textColor = Constants.Colors.darkBlue
        carbonDetailsLabel.textColor = Constants.Colors.pinkRed
    }
    
    private func configure(button: inout DynamicButton?, container: UIView, color: UIColor) {
        
        button = DynamicButton()
        button!.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(button!)
        button!.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button!.layer.cornerRadius = 22
        button!.layer.masksToBounds = true
        button!.backgroundColor = .darkGray
        button!.lineWidth = 4
        button!.strokeColor = color
        button!.constraintToSuperViewEdges()
        button!.setStyle(.dot, animated: false)
        button!.isUserInteractionEnabled = false
    }

}
