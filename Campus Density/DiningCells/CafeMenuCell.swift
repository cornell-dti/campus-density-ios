//
//  CafeMenuCell.swift
//  Campus Density
//
//  Created by Changyuan Lin on 4/12/21.
//  Copyright © 2021 Cornell DTI. All rights reserved.
//

import UIKit

class CafeMenuCell: UICollectionViewCell {

    static let identifier: String = "CafeMenuCell"

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

    static func getMenuString(cafeMenu: [String]) -> NSMutableAttributedString {
        return NSMutableAttributedString(
            string: cafeMenu.joined(separator: "\n"),
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.warmGray,
                NSAttributedString.Key.font: UIFont.sixteen,
                NSAttributedString.Key.paragraphStyle: {
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.lineHeightMultiple = 1.15
                    return paragraphStyle
                }()
            ]
        )
    }

    func configure(cafeMenu: [String], startTime: Double, endTime: Double) {
        hoursLabel.text = getHoursString(startTime: startTime, endTime: endTime)
        menuLabel.attributedText = CafeMenuCell.getMenuString(cafeMenu: cafeMenu)
        setupConstraints()
    }

}
