//
//  MenuFilterView.swift
//  Campus Density
//
//  Created by Ansh Godha on 16/11/19.
//  Copyright © 2019 Cornell DTI. All rights reserved.
//

import UIKit

protocol MenuFilterViewDelegate {
    func menuFilterViewDidSelectFilter(selectedMeal: Meal)
}

class MenuFilterView: UIView {
    
    var filters = [Meal]()
    var delegate: MenuFilterViewDelegate!
    var width: CGFloat = 0
    var selectedMeal: Meal!
    
    var mealFilterButtons = [UIButton]()
    
    // MARK: - Constants
    let labelHorizontalPadding: CGFloat = 10
    let verticalPadding: CGFloat = 15
    let buttonHeight: CGFloat = 35
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func mealLabel(meal: Meal) -> String {
        switch meal {
        case .breakfast:
            return "Breakfast"
        case .brunch:
            return "Brunch"
        case .lunch:
            return "Lunch"
        case .dinner:
            return "Dinner"
        }
    }
    
    @objc func mealFilterButtonPressed(sender: UIButton) {
        let index = filters.firstIndex { meal -> Bool in
            return meal == self.selectedMeal
        }
        
        guard let selectedIndex = index else { return }
        mealFilterButtons[selectedIndex].backgroundColor = .white
        mealFilterButtons[selectedIndex].setTitleColor(.densityDarkGray, for: .normal)
        mealFilterButtons[sender.tag].backgroundColor = .whiteTwo
        mealFilterButtons[sender.tag].setTitleColor(.grayishBrown, for: .normal)
        self.selectedMeal = filters[sender.tag]
        delegate.menuFilterViewDidSelectFilter(selectedMeal: filters[sender.tag])
    }
    
    override func updateConstraints() {
        var padding: CGFloat = width - labelHorizontalPadding * 2 * CGFloat(mealFilterButtons.count)
        filters.forEach { filter in
            let width = self.mealLabel(meal: filter).widthWithConstrainedHeight(buttonHeight, font: .sixteen)
            padding -= width
        }
        padding = padding / CGFloat(mealFilterButtons.count + 1)
        var index: Int = 0
        var buttonLeftOffset: CGFloat = padding
        mealFilterButtons.forEach { button in
            let buttonWidth = self.mealLabel(meal: self.filters[index]).widthWithConstrainedHeight(frame.height, font: .sixteen) + self.labelHorizontalPadding * 2
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
    
    func configure(with filters: [Meal], selectedMeal: Meal, delegate: MenuFilterViewDelegate, width: CGFloat) {
        self.filters = filters
        self.delegate = delegate
        self.width = width
        self.selectedMeal = selectedMeal
        
        var index: Int = 0
        
        filters.forEach { filter in
            let button = UIButton()
            button.tag = index
            button.backgroundColor = filter == selectedMeal ? .whiteTwo : .white
            button.setTitle(mealLabel(meal: filter), for: .normal)
            button.titleLabel?.font = .sixteen
            button.setTitleColor(filter == selectedMeal ? .grayishBrown : .densityDarkGray, for: .normal)
            button.clipsToBounds = true
            button.layer.cornerRadius = self.buttonHeight / 2
            button.addTarget(self, action: #selector(mealFilterButtonPressed), for: .touchUpInside)
            addSubview(button)
            self.mealFilterButtons.append(button)
            index += 1
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
