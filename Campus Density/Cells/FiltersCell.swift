//
//  FiltersCell.swift
//  Campus Density
//
//  Created by Matthew Coufal on 3/24/19.
//  Copyright © 2019 Cornell DTI. All rights reserved.
//

import UIKit

protocol FiltersCellDelegate: class {
    
    func filtersCellDidSelectFilter(selectedFilter: Filter)
    
}

class FiltersCell: UICollectionViewCell {
    
    // MARK: - Data vars
    var filtersModel: FiltersModel!
    weak var delegate: FiltersCellDelegate?
    
    // MARK: - View vars
    var filterButtons = [UIButton]()
    
    // MARK: - Constants
    let labelHorizontalPadding: CGFloat = 10
    let buttonHeight: CGFloat = 35
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func filterLabel(filter: Filter) -> String {
        switch filter {
        case .all:
            return "All"
        case .central:
            return "Central"
        case .north:
            return "North"
        case .west:
            return "West"
        }
    }
    
    @objc func filterButtonPressed(sender: UIButton) {
        delegate?.filtersCellDidSelectFilter(selectedFilter: filtersModel.filters[sender.tag])
    }
    
    override func prepareForReuse() {
        for subview in contentView.subviews {
            subview.removeFromSuperview()
        }
        filterButtons.removeAll()
    }
    
    func setupConstraints() {
        var padding: CGFloat = frame.width - labelHorizontalPadding * 2 * CGFloat(filterButtons.count)
        filtersModel.filters.forEach { filter in
            let width = self.filterLabel(filter: filter).widthWithConstrainedHeight(buttonHeight, font: .sixteen)
            padding -= width
        }
        padding = padding / CGFloat(filterButtons.count + 1)
        var index: Int = 0
        var buttonLeftOffset: CGFloat = padding
        filterButtons.forEach { button in
            let buttonWidth = filterLabel(filter: filtersModel.filters[index]).widthWithConstrainedHeight(frame.height, font: .sixteen) + labelHorizontalPadding * 2
            button.snp.makeConstraints({ make in
                make.width.equalTo(buttonWidth)
                make.height.equalTo(buttonHeight)
                make.left.equalToSuperview().offset(buttonLeftOffset)
                make.bottom.equalToSuperview()
            })
            index += 1
            buttonLeftOffset += buttonWidth + padding
        }
    }
    
    func configure(filtersModel: FiltersModel, delegate: FiltersCellDelegate) {
        self.filtersModel = filtersModel
        self.delegate = delegate
        
        var index: Int = 0
        
        for subview in contentView.subviews {
            subview.removeFromSuperview()
        }
        filterButtons.removeAll()
        
        filtersModel.filters.forEach { filter in
            let button = UIButton()
            button.tag = index
            button.backgroundColor = filter == filtersModel.selectedFilter ? .whiteTwo : .white
            button.setTitle(filterLabel(filter: filter), for: .normal)
            button.titleLabel?.font = .sixteen
            button.setTitleColor(filter == filtersModel.selectedFilter ? .grayishBrown : .densityDarkGray, for: .normal)
            button.clipsToBounds = true
            button.layer.cornerRadius = self.buttonHeight / 2
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
