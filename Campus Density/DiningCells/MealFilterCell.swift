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
    var headerLabel: UILabel!
    var filterButtons = [UIButton]()

    // MARK: - Constants
    let headerLabelText = "Menus"
    let labelHorizontalPadding: CGFloat = 10
    let buttonHeight: CGFloat = 35

    override init(frame: CGRect) {
        super.init(frame: frame)

        headerLabel = UILabel()
        headerLabel.text = headerLabelText
        headerLabel.textColor = .black
        headerLabel.textAlignment = .left
        headerLabel.font = .thirtyBold
        addSubview(headerLabel)

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

        let headerLabelTextHeight = headerLabelText.height(withConstrainedWidth: frame.width - Constants.smallPadding * 2, font: headerLabel.font)

        headerLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(Constants.smallPadding)
            make.left.equalToSuperview().offset(Constants.smallPadding)
            make.height.equalTo(headerLabelTextHeight)
        }

        let padding: CGFloat = Constants.smallPadding
        var index: Int = 0
        var buttonLeftOffset: CGFloat = padding
        filterButtons.forEach { button in
            let buttonWidth = mealLabel(meal: mealModel.meals[index]).widthWithConstrainedHeight(frame.height, font: .sixteen) + labelHorizontalPadding * 2
            button.snp.makeConstraints({ make in
                make.width.equalTo(buttonWidth)
                make.height.equalTo(buttonHeight)
                make.top.equalTo(headerLabel.snp.bottom).offset(Constants.smallPadding)
                make.left.equalToSuperview().offset(buttonLeftOffset)
                make.bottom.equalToSuperview()
            })
            index += 1
            buttonLeftOffset += buttonWidth + padding
        }
    }

    func configure(mealModel: MealFiltersModel, delegate: MealFilterCellDelegate) {
        self.mealModel = mealModel
        self.delegate = delegate

        var index: Int = 0

        for subview in contentView.subviews {
            subview.removeFromSuperview()
        }
        filterButtons.removeAll()

        mealModel.meals.forEach { meal in
            let button = UIButton()
            button.tag = index
            button.backgroundColor = meal == mealModel.selectedMeal ? .whiteTwo : .white
            button.setTitle(mealLabel(meal: meal), for: .normal)
            button.titleLabel?.font = .sixteen
            button.setTitleColor(meal == mealModel.selectedMeal ? .grayishBrown : .densityDarkGray, for: .normal)
            button.clipsToBounds = true
            button.layer.cornerRadius = self.buttonHeight / 2
            button.addTarget(self, action: #selector(filterButtonPressed), for: .touchUpInside)
            contentView.addSubview(button)
            self.filterButtons.append(button)
            index += 1
        }

        if filterButtons.isEmpty {
            headerLabel.isHidden = true
        } else {
            headerLabel.isHidden = false
        }

        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
