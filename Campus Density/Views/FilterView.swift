//
//  FilterView.swift
//  Campus Density
//
//  Created by Matthew Coufal on 11/11/18.
//  Copyright © 2018 Cornell DTI. All rights reserved.
//

import UIKit

protocol FilterViewDelegate {
    func filterViewDidSelectFilter(selectedFilter: Filter)
}

class FilterView: UIView {
    
    // MARK: - Data vars
    var filters = [Filter]()
    var delegate: FilterViewDelegate!
    var width: CGFloat = 0
    var selectedFilter: Filter!
    
    // MARK: - View vars
    var filterButtons = [UIButton]()
    
    // MARK: - Constants
    let labelHorizontalPadding: CGFloat = 10
    let verticalPadding: CGFloat = 15
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
        let index = filters.firstIndex { filter -> Bool in
            return filter == self.selectedFilter
        }
        guard let selectedIndex = index else { return }
        filterButtons[selectedIndex].backgroundColor = .white
        filterButtons[selectedIndex].setTitleColor(.densityDarkGray, for: .normal)
        filterButtons[sender.tag].backgroundColor = .whiteTwo
        filterButtons[sender.tag].setTitleColor(.grayishBrown, for: .normal)
        self.selectedFilter = filters[sender.tag]
        delegate.filterViewDidSelectFilter(selectedFilter: filters[sender.tag])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        var padding: CGFloat = width - labelHorizontalPadding * 2 * CGFloat(filterButtons.count)
        filters.forEach { filter in
            let width = self.filterLabel(filter: filter).widthWithConstrainedHeight(buttonHeight, font: .sixteen)
            padding -= width
        }
        padding = padding / CGFloat(filterButtons.count + 1)
        var index: Int = 0
        var buttonLeftOffset: CGFloat = padding
        filterButtons.forEach { button in
            let buttonWidth = self.filterLabel(filter: self.filters[index]).widthWithConstrainedHeight(frame.height, font: .sixteen) + self.labelHorizontalPadding * 2
            button.snp.makeConstraints({ make in
                make.width.equalTo(buttonWidth)
                make.height.equalTo(buttonHeight)
                make.left.equalToSuperview().offset(buttonLeftOffset)
                make.centerY.equalToSuperview()
            })
            index += 1
            buttonLeftOffset += buttonWidth + padding
        }
        
        super.updateConstraints()
    }
    
    func configure(with filters: [Filter], selectedFilter: Filter, delegate: FilterViewDelegate, width: CGFloat) {
        self.filters = filters
        self.delegate = delegate
        self.width = width
        self.selectedFilter = selectedFilter
        
        var index: Int = 0
        
        filters.forEach { filter in
            let button = UIButton()
            button.tag = index
            button.backgroundColor = filter == selectedFilter ? .whiteTwo : .white
            button.setTitle(filterLabel(filter: filter), for: .normal)
            button.titleLabel?.font = .sixteen
            button.setTitleColor(filter == selectedFilter ? .grayishBrown : .densityDarkGray, for: .normal)
            button.clipsToBounds = true
            button.layer.cornerRadius = self.buttonHeight / 2
            button.addTarget(self, action: #selector(filterButtonPressed), for: .touchUpInside)
            addSubview(button)
            self.filterButtons.append(button)
            index += 1
        }
    }
    
}
