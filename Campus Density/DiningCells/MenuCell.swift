//
//  MenuCell.swift
//  Campus Density
//
//  Created by Ashneel Das on 11/10/19.
//  Copyright © 2019 Cornell DTI. All rights reserved.
//

import UIKit

protocol MenuCellDelegate: class {
    func menucelldidSwipeRightOnMenus()
    func menucelldidSwipeLeftOnMenus()
}

class MenuCell: UICollectionViewCell {

    // MARK: - View vars
    var menuLabel: UILabel!
    weak var delegate: MenuCellDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    func setupConstraints() {
        menuLabel.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.left.equalToSuperview().offset(Constants.smallPadding)

        }
    }

    func setupViews() {
        menuLabel = UILabel()
        menuLabel.textColor = .warmGray
        menuLabel.textAlignment = .left
        menuLabel.numberOfLines = 0
        menuLabel.font = .eighteenBold
        menuLabel.isUserInteractionEnabled = true

        let swipeRecognizerRight = UISwipeGestureRecognizer(target: self, action: #selector(self.swipedRightOnMenus(sender:)))
        swipeRecognizerRight.direction = .right
        menuLabel.addGestureRecognizer(swipeRecognizerRight)

        let swipeRecognizerLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.swipedLeftOnMenus(sender:)))
        swipeRecognizerRight.direction = .left
        menuLabel.addGestureRecognizer(swipeRecognizerLeft)

        addSubview(menuLabel)
    }

    func getMenuString(todaysMenu: DayMenus, selectedMeal: Meal) -> NSMutableAttributedString {
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

    @objc func swipedRightOnMenus(sender: UISwipeGestureRecognizer) {
        delegate?.menucelldidSwipeRightOnMenus()
    }

    @objc func swipedLeftOnMenus(sender: UISwipeGestureRecognizer) {
        delegate?.menucelldidSwipeLeftOnMenus()
    }

    func configure(with menu: DayMenus, selectedMeal: Meal, delegate: MenuCellDelegate) {
        menuLabel.attributedText = getMenuString(todaysMenu: menu, selectedMeal: selectedMeal)
        if (menuLabel.text == "No menus available") {
            menuLabel.font = .eighteenBold
        }
        self.delegate = delegate
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
