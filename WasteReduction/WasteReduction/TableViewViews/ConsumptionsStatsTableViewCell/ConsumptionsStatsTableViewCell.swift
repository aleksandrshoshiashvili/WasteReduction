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
    
    @IBOutlet weak var containerView: UIView!
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
        domesticButton.setStyle(.dot, animated: true)
        wasteLabel.text = model.waste.type.title
        wasteDetailasLabel.text = model.waste.details
        wasteButton.setStyle(.dot, animated: true)
        carbonLabel.text = model.carbon.type.title
        carbonDetailsLabel.text = model.carbon.details
        carbonButton.setStyle(.dot, animated: true)
    }
    
    // MARK: - Animation
    
    func animate(withModel model: ConsumptionsStats) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.domesticButton.setStyle(model.domestic.direction.dynamicButtonStyle, animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.wasteButton.setStyle(model.waste.direction.dynamicButtonStyle, animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.carbonButton.setStyle(model.carbon.direction.dynamicButtonStyle, animated: true)
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
        
        containerView.applyShadow()
        
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
        button!.backgroundColor = .systemGray6
        button!.lineWidth = 4
        button!.strokeColor = color
        button!.constraintToSuperViewEdges()
        button!.setStyle(.dot, animated: false)
        button!.isUserInteractionEnabled = false
    }

}
