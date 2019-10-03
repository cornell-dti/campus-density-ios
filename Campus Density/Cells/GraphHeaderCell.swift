//
//  GraphHeaderCell.swift
//  Campus Density
//
//  Created by Matthew Coufal on 3/8/19.
//  Copyright © 2019 Cornell DTI. All rights reserved.
//

import UIKit

protocol GraphHeaderCellDelegate: class {

    func graphHeaderCellDidSelectWeekday(selectedWeekday: Int)

}

class GraphHeaderCell: UICollectionViewCell {

    // MARK: - Data vars
    var weekdays: [Int]!
    var selectedWeekday: Int!
    weak var delegate: GraphHeaderCellDelegate?

    // MARK: - View vars
    var headerLabel: UILabel!
    var buttons = [UIButton]()

    // MARK: - Constants
    let headerLabelText = "Popular Times"

    override init(frame: CGRect) {
        super.init(frame: frame)

        headerLabel = UILabel()
        headerLabel.text = headerLabelText
        headerLabel.textColor = .grayishBrown
        headerLabel.textAlignment = .left
        headerLabel.font = .thirtyBold
        addSubview(headerLabel)

    }

    func setupConstraints() {

        let headerLabelTextHeight = headerLabelText.height(withConstrainedWidth: frame.width - Constants.smallPadding * 2, font: headerLabel.font)

        headerLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(Constants.smallPadding)
            make.left.equalToSuperview().offset(Constants.smallPadding)
            make.height.equalTo(headerLabelTextHeight)
        }

        for button in buttons {
            button.removeFromSuperview()
        }
        buttons = []

        let buttonLength = (frame.width - CGFloat(weekdays.count + 1) * Constants.smallPadding) / CGFloat(weekdays.count)
        var buttonLeft: CGFloat = Constants.smallPadding
        var index = 0

        while index < weekdays.count {
            let weekday = weekdays[index]
            let button = UIButton()
            button.tag = weekday
            button.addTarget(self, action: #selector(weekdayButtonPressed), for: .touchUpInside)
            button.clipsToBounds = true
            button.layer.cornerRadius = buttonLength / 2
            button.titleLabel?.font = .sixteen
            button.setTitle(weekdayAbbreviation(weekday: weekday), for: .normal)
            if weekday == selectedWeekday {
                button.backgroundColor = .grayishBrown
                button.setTitleColor(.white, for: .normal)
            } else {
                button.layer.borderColor = UIColor.warmGray.cgColor
                button.layer.borderWidth = 1
                button.backgroundColor = .white
                button.setTitleColor(.grayishBrown, for: .normal)
            }

            buttons.append(button)
            addSubview(button)

            button.snp.makeConstraints { make in
                make.left.equalTo(buttonLeft)
                make.top.equalTo(headerLabel.snp.bottom).offset(Constants.smallPadding)
                make.width.height.equalTo(buttonLength)
            }

            buttonLeft += Constants.smallPadding + buttonLength
            index += 1
        }

    }

    @objc func weekdayButtonPressed(sender: UIButton) {
        delegate?.graphHeaderCellDidSelectWeekday(selectedWeekday: sender.tag)
    }

    func configure(weekdays: [Int], selectedWeekday: Int, delegate: GraphHeaderCellDelegate) {
        self.weekdays = weekdays
        self.selectedWeekday = selectedWeekday
        self.delegate = delegate
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
