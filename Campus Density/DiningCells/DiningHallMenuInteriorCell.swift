//
//  DiningHallMenuInteriorCell.swift
//  Campus Density
//
//  Created by Changyuan Lin on 2/29/20.
//  Copyright © 2020 Cornell DTI. All rights reserved.
//

import UIKit

class DiningHallMenuInteriorCell: UICollectionViewCell {

    static let identifier: String = "DiningHallMenuInteriorCell"

    // MARK: - View vars
    var clockImageView: UIImageView!
    var hoursLabel: UILabel!
    var menuLabel: UILabel!

    // MARK: - Constants
    static let hoursLabelHeight: CGFloat = 22
    static let clockHoursGap: CGFloat = 8

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupConstraints() {
        clockImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(Constants.smallPadding)
            make.height.width.equalTo(DiningHallMenuInteriorCell.hoursLabelHeight)
        }
        hoursLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(DiningHallMenuInteriorCell.hoursLabelHeight)
            make.left.equalTo(clockImageView.snp.right).offset(DiningHallMenuInteriorCell.clockHoursGap)
        }
        menuLabel.snp.makeConstraints { make in
            make.top.equalTo(hoursLabel.snp.bottom).offset(Constants.smallPadding)
            make.left.equalToSuperview().offset(Constants.smallPadding)
            make.right.equalToSuperview().offset(-Constants.smallPadding)
        }
    }

    func setupViews() {
        clockImageView = UIImageView()
        clockImageView.image = UIImage(named: "clock")
        contentView.addSubview(clockImageView)
        hoursLabel = UILabel()
        hoursLabel.font = .sixteenBold
        hoursLabel.textColor = .black
        contentView.addSubview(hoursLabel)
        menuLabel = UILabel()
        menuLabel.textAlignment = .left
        menuLabel.numberOfLines = 0
        menuLabel.isUserInteractionEnabled = true
        contentView.addSubview(menuLabel)
    }

    static func getMenuString(menuData: MenuData) -> NSMutableAttributedString {
        let res = NSMutableAttributedString(string: "")
        let newLine = NSAttributedString(string: "\n", attributes: [NSAttributedString.Key.font: UIFont.fourteen])
        let empty = NSAttributedString(string: "")
        let stations = organizeCategories(menu: menuData.menu)
        for station in stations {
            if res != empty {
                res.append(newLine)
                res.append(newLine)
            }
            let categoryString = NSMutableAttributedString(string: station.category)
            categoryString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.grayishBrown, NSAttributedString.Key.font: UIFont.sixteenBold], range: NSRange(location: 0, length: categoryString.length))
            res.append(categoryString)
            let itemString = NSMutableAttributedString()
            for item in station.items {
                if itemString != empty {
                    itemString.append(newLine) // the styling is actually overridden here b/c it's part of itemString
                }
                itemString.append(NSAttributedString(string: item))
            }
            itemString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.warmGray, NSAttributedString.Key.font: UIFont.sixteen], range: NSRange(location: 0, length: itemString.length))
            if itemString != empty {
                res.append(newLine)
                res.append(itemString)
            }
        }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        res.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: res.length))
        return res
    }

    /**
     Organize the menu items, currently moves "Additional Items" to the last position if present
     - Parameter menu: a list of stations/menuitems
     - Returns: custom sorted list of stations
     */
    static func organizeCategories(menu: [MenuItem]) -> [MenuItem] {
        var organized = menu
        if let additionalItemsIndex = organized.firstIndex(where: {station in station.category == "Additional Items"}) {
            let additionalItemsStation = organized.remove(at: additionalItemsIndex)
            organized.append(additionalItemsStation)
        }
        return organized
    }

    func configure(menuData: MenuData) {
        hoursLabel.text = getHoursString(startTime: menuData.startTime, endTime: menuData.endTime)
        menuLabel.attributedText = DiningHallMenuInteriorCell.getMenuString(menuData: menuData)
        setupConstraints()
    }

}
