//
//  GymFilterCell.swift
//  Campus Density
//
//  Created by Ansh Godha on 29/02/20.
//  Copyright © 2020 Cornell DTI. All rights reserved.
//

import UIKit

protocol GymFilterCellDelegate: class {
    func gymFilterCellDidSelectFilter(selectedEquipmentType: EquipmentType)
}

class GymFilterCell: UICollectionViewCell {
    
    var gymFilterModel: GymFiltersModel!
    weak var delegate: GymFilterCellDelegate?
    
    var filterButtons = [UIButton]()
    let buttonHeight: CGFloat = 35
    let labelHorizontalPadding: CGFloat = 10
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @objc func filterButtonPressed(sender: UIButton) {
        delegate?.gymFilterCellDidSelectFilter(selectedEquipmentType: gymFilterModel.equipmentTypes[sender.tag])
    }
    
    override func prepareForReuse() {
        for subview in contentView.subviews {
            subview.removeFromSuperview()
        }
        filterButtons.removeAll()
    }
    
    func typeLabel(equipmentType: EquipmentType) -> String {
        return equipmentType.rawValue
    }
    
    func setupConstraints() {
        let padding = Constants.smallPadding
        var index = 0
        var totalWidth: CGFloat = 0
        filterButtons.forEach { button in
            totalWidth += typeLabel(equipmentType: gymFilterModel.equipmentTypes[index]).widthWithConstrainedHeight(frame.height, font: .fourteen) + labelHorizontalPadding * 2
        }
        totalWidth += padding * CGFloat((filterButtons.count - 1))
        
        var buttonLeftOffset: CGFloat = (contentView.superview!.frame.width - totalWidth)/2
        filterButtons.forEach { button in
            let buttonWidth = typeLabel(equipmentType: gymFilterModel.equipmentTypes[index]).widthWithConstrainedHeight(frame.height, font: .fourteen) + labelHorizontalPadding * 2
            button.snp.makeConstraints({ make in
                make.width.equalTo(buttonWidth)
                make.height.equalTo(buttonHeight)
                make.left.equalToSuperview().offset(buttonLeftOffset)
                make.bottom.equalToSuperview()
            })
            buttonLeftOffset += buttonWidth + labelHorizontalPadding*2
            index += 1
        }
    }
    
    func configure(gymFilterModel: GymFiltersModel, delegate: GymFilterCellDelegate) {
        self.gymFilterModel = gymFilterModel
        self.delegate = delegate
        
        var index: Int = 0
        
        for subview in contentView.subviews {
            subview.removeFromSuperview()
        }
        filterButtons.removeAll()
        
        gymFilterModel.equipmentTypes.forEach { type in
            let button = UIButton()
            button.tag = index
            button.backgroundColor = type == gymFilterModel.selectedEquipmentType ? .whiteTwo : .white
            button.setTitle(typeLabel(equipmentType: type), for: .normal)
            button.titleLabel?.font = .fourteen
            button.setTitleColor(type == gymFilterModel.selectedEquipmentType ? .grayishBrown : .densityDarkGray, for: .normal)
            button.clipsToBounds = true
            button.layer.cornerRadius = self.buttonHeight/2
            button.addTarget(self, action: #selector(filterButtonPressed), for: .touchUpInside)
            contentView.addSubview(button)
            self.filterButtons.append(button)
            index += 1
        }
        
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
