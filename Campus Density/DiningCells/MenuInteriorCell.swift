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
            make.top.equalToSuperview().offset(Constants.smallPadding)
            make.bottom.equalToSuperview().offset(-Constants.smallPadding)
            make.left.equalToSuperview().offset(Constants.smallPadding)
            make.right.equalToSuperview().offset(-Constants.smallPadding)
        }
        wrapperView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Constants.smallPadding)
            make.right.equalToSuperview().offset(-Constants.smallPadding)
        }
    }

    func setupViews() {
        menuLabel = UILabel()
        menuLabel.textAlignment = .left
        menuLabel.numberOfLines = 0
        menuLabel.isUserInteractionEnabled = true
        wrapperView.layer.borderColor = UIColor.whiteTwo.cgColor
        wrapperView.layer.borderWidth = 1
        wrapperView.layer.cornerRadius = 10
        wrapperView.addSubview(menuLabel)
        contentView.addSubview(wrapperView)
    }

    static func getMenuString(todaysMenu: DayMenus, selectedMeal: Meal) -> NSMutableAttributedString {
        let res = NSMutableAttributedString(string: "")
        let newLine = NSAttributedString(string: "\n", attributes: [NSAttributedString.Key.font: UIFont.fourteen])
        let empty = NSAttributedString(string: "")
        for meal in todaysMenu.menus {
            if (meal.description == selectedMeal.rawValue) {
                for station in meal.menu {
                    if (res != empty) {
                        res.append(newLine)
                        res.append(newLine)
                    }
                    let categoryString = NSMutableAttributedString(string: station.category)
                    categoryString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.grayishBrown, NSAttributedString.Key.font: UIFont.eighteenBold], range: NSRange(location: 0, length: categoryString.length))
                    res.append(categoryString)
                    let itemString = NSMutableAttributedString()
                    for item in station.items {
                        if (itemString != empty) {
                            itemString.append(newLine)
                        }
                        itemString.append(NSAttributedString(string: item))
                    }
                    itemString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.warmGray, NSAttributedString.Key.font: UIFont.sixteen], range: NSRange(location: 0, length: itemString.length))
                    if (itemString != empty) {
                        res.append(newLine)
                        res.append(itemString)
                    }
                }
            }
        }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        res.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: res.length))
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
