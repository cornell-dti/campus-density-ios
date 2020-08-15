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
        let padding: CGFloat = Constants.smallPadding
        var index: Int = 0
        var buttonLeftOffset: CGFloat = padding
        filterButtons.forEach { button in
            let buttonWidth = mealLabel(meal: mealModel.meals[index]).widthWithConstrainedHeight(frame.height, font: .sixteen) + labelHorizontalPadding * 2
            button.snp.makeConstraints({ make in
                make.width.equalTo(buttonWidth)
                make.height.equalTo(buttonHeight)
                make.left.equalToSuperview().offset(buttonLeftOffset)
            })
            index += 1
            buttonLeftOffset += buttonWidth + padding
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
            button.titleLabel?.font = .sixteen
            button.setTitleColor(.warmGray, for: .normal)
            button.clipsToBounds = true
            if (meal == mealModel.selectedMeal) {
                button.setTitleColor(.grayishBrown, for: .normal)
                button.layer.borderColor = UIColor.warmGray.cgColor
                button.layer.borderWidth = 1
            }
            button.layer.cornerRadius = 10
            button.addTarget(self, action: #selector(filterButtonPressed), for: .touchUpInside)
            contentView.addSubview(button)
            self.filterButtons.append(button)
        }

        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
