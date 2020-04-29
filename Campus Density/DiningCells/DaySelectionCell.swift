//
//  DaySelectionCell.swift
//  Campus Density
//
//  Created by Matthew Coufal on 3/8/19.
//  Copyright © 2019 Cornell DTI. All rights reserved.
//

import UIKit

protocol DaySelectionCellDelegate: class {

    func daySelectionCellDidSelectWeekday(selectedWeekday: Int)

}

class DaySelectionCell: UICollectionViewCell {

    // MARK: - Data vars
    var weekdays: [(Int, Int)]!
    var selectedWeekday: Int!
    weak var delegate: DaySelectionCellDelegate?

    // MARK: - View vars
    var buttons = [UIButton]()

    // MARK: - Constants

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    func setupConstraints() {

        for button in buttons {
            button.removeFromSuperview()
        }
        buttons = []

        let buttonLength = (frame.width - CGFloat(weekdays.count + 1) * Constants.smallPadding) / CGFloat(weekdays.count)
        var buttonLeft: CGFloat = Constants.smallPadding

        for weekday in weekdays {
            let button = UIButton()
            button.tag = weekday.0
            button.addTarget(self, action: #selector(weekdayButtonPressed), for: .touchUpInside)
            button.clipsToBounds = true
            button.layer.cornerRadius = buttonLength / 2
            button.titleLabel?.font = .sixteen
            button.setTitle(weekdayAbbreviation(weekday: button.tag), for: .normal)
            if button.tag == selectedWeekday {
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
                make.width.height.equalTo(buttonLength)
            }

            buttonLeft += Constants.smallPadding + buttonLength
        }

    }

    @objc func weekdayButtonPressed(sender: UIButton) {
        delegate?.daySelectionCellDidSelectWeekday(selectedWeekday: sender.tag)
    }

    func configure(weekdays: [(Int, Int)], selectedWeekday: Int, delegate: DaySelectionCellDelegate) {
        self.weekdays = weekdays
        self.selectedWeekday = selectedWeekday
        self.delegate = delegate
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
