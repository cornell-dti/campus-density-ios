//
//  MenuInteriorCell.swift
//  Campus Density
//
//  Created by Changyuan Lin on 2/29/20.
//  Copyright © 2020 Cornell DTI. All rights reserved.
//

import UIKit

class MenuInteriorCell: UICollectionViewCell {

    static let identifier: String = "MenuInteriorCell"

    // MARK: - View vars
    let wrapperView = UIView()
    var menuLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupConstraints() {
        menuLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Constants.smallPadding)
            make.right.equalToSuperview().offset(-Constants.smallPadding)
        }
        wrapperView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Constants.smallPadding)
            make.right.equalToSuperview().offset(-Constants.smallPadding)
            make.height.equalTo(menuLabel)
        }
    }

    func setupViews() {
        menuLabel = UILabel()
        menuLabel.textColor = .warmGray
        menuLabel.textAlignment = .left
        menuLabel.numberOfLines = 0
        menuLabel.font = .eighteenBold
        menuLabel.isUserInteractionEnabled = true
        wrapperView.layer.borderColor = UIColor.warmGray.cgColor
        wrapperView.layer.borderWidth = 1
        wrapperView.layer.cornerRadius = 10
        wrapperView.addSubview(menuLabel)
        contentView.addSubview(wrapperView)
    }

    static func getMenuString(todaysMenu: DayMenus, selectedMeal: Meal) -> NSMutableAttributedString {
        let res = NSMutableAttributedString(string: "")
        let newLine = NSAttributedString(string: "\n")
        for meal in todaysMenu.menus {
            if (meal.description == selectedMeal.rawValue) {
                if (meal.menu.count != 0) {
                    for station in meal.menu {
                        let categoryString = NSMutableAttributedString(string: station.category)
                        categoryString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.grayishBrown, range: categoryString.mutableString.range(of: station.category))
                        res.append(categoryString)
                        res.append(newLine)
                        let itemString = NSMutableAttributedString()
                        for item in station.items {
                            itemString.append(NSAttributedString(string: item))
                            itemString.append(newLine)
                        }
                        res.append(itemString)
                        res.append(newLine)
                    }
                }
            }
        }
        return res
    }

    func configure(with menu: DayMenus, forMeal meal: Meal) {
        menuLabel.attributedText = MenuInteriorCell.getMenuString(todaysMenu: menu, selectedMeal: meal)
        if (menuLabel.text == "No menus available") {
            menuLabel.font = .eighteenBold
        }
        setupConstraints()
    }

}
