//
//  MealFilterCell.swift
//  Campus Density
//
//  Created by Ansh Godha on 16/11/19.
//  Copyright © 2019 Cornell DTI. All rights reserved.
//

import UIKit

protocol MealFilterCellDelegate: class {
    func mealFilterCellDidSelectFilter(selectedMeal: Meal)
}

class MealFilterCell: UICollectionViewCell {

    // MARK: - Data vars
    var mealModel: MealFiltersModel!
    weak var delegate: MealFilterCellDelegate?

    // MARK: - View vars
    var filterButtons = [UIButton]()
    var lineView: UIView!

    // MARK: - Constants
    let labelHorizontalPadding: CGFloat = 10
    let buttonHeight: CGFloat = 35

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @objc func filterButtonPressed(sender: UIButton) {
        delegate?.mealFilterCellDidSelectFilter(selectedMeal: mealModel.meals[sender.tag])
    }

    override func prepareForReuse() {
        for subview in contentView.subviews {
            subview.removeFromSuperview()
        }
        filterButtons.removeAll()
    }

    func mealLabel(meal: Meal) -> String {
        return meal.rawValue
    }

    func setupConstraints() {
        var index: Int = 0
        var buttonLeftOffset: CGFloat = 0
        let numOfMeals: CGFloat = CGFloat(filterButtons.count)
        let buttonWidth = frame.width / numOfMeals
        let sliderHeight = buttonHeight
        for (meal, button) in zip(mealModel.meals, filterButtons) {
            button.snp.makeConstraints { make in
                make.width.equalTo(buttonWidth)
                make.height.equalTo(buttonHeight)
                make.left.equalToSuperview().offset(buttonLeftOffset)
            }
            if meal == mealModel.selectedMeal {
                lineView = UIView(frame: CGRect(x: CGFloat(index)*buttonWidth, y: sliderHeight, width: buttonWidth, height: 2))
                lineView.backgroundColor = .densityGreen
                lineView.layer.borderColor = UIColor.densityGreen.cgColor
                lineView.layer.borderWidth = 1
                contentView.addSubview(lineView)
            }
            index += 1
            buttonLeftOffset += buttonWidth
        }
    }

    func configure(mealModel: MealFiltersModel, delegate: MealFilterCellDelegate) {
        self.mealModel = mealModel
        self.delegate = delegate

        for subview in contentView.subviews {
            subview.removeFromSuperview()
        }
        filterButtons.removeAll()

        for (index, meal) in mealModel.meals.enumerated() {
            let button = UIButton()
            button.tag = index
            button.setTitle(mealLabel(meal: meal), for: .normal)
            button.titleLabel?.font = .eighteen
            button.setTitleColor(.warmGray, for: .normal)
            button.clipsToBounds = true
            if meal == mealModel.selectedMeal {
                button.setTitleColor(.densityGreen, for: .normal)
                button.titleLabel?.font = .eighteenBold
            }
            button.addTarget(self, action: #selector(filterButtonPressed), for: .primaryActionTriggered)
            contentView.addSubview(button)
            self.filterButtons.append(button)
        }

        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
