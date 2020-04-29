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

        let cornerRadius: CGFloat = 10
        let buttonLength = (frame.width - Constants.smallPadding - CGFloat(weekdays.count + 1) * Constants.smallPadding / 2) / CGFloat(weekdays.count)
        var buttonLeft: CGFloat = Constants.smallPadding

        for weekday in weekdays {
            let button = UIButton()
            button.tag = weekday.0
            button.addTarget(self, action: #selector(weekdayButtonPressed), for: .touchUpInside)
            button.clipsToBounds = true
            button.layer.cornerRadius = cornerRadius
            button.titleLabel?.lineBreakMode = .byWordWrapping
            button.titleLabel?.textAlignment = .center
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 5
            paragraphStyle.alignment = .center
            let title = NSMutableAttributedString(string: weekdayAbbreviation(weekday: button.tag), attributes: [.foregroundColor: UIColor.warmGray, .font: UIFont.sixteen, .paragraphStyle: paragraphStyle])
            title.append(NSAttributedString(string: "\n\(weekday.1)", attributes: [.foregroundColor: UIColor.grayishBrown, .font: UIFont.sixteenBold]))
            button.setAttributedTitle(title, for: .normal)
            if button.tag == selectedWeekday {
                button.layer.borderColor = UIColor.warmGray.cgColor
                button.layer.borderWidth = 1
            }

            buttons.append(button)
            addSubview(button)

            button.snp.makeConstraints { make in
                make.left.equalTo(buttonLeft)
                make.width.equalTo(buttonLength)
                make.height.equalTo(buttonLength * 1.5)
            }

            buttonLeft += Constants.smallPadding / 2 + buttonLength
        }

        let line = UIView()
        line.backgroundColor = .warmGray
        addSubview(line)
        line.snp.makeConstraints { make in
            make.left.equalTo(Constants.smallPadding + cornerRadius)
            make.width.equalTo(frame.width - Constants.smallPadding * 2 - cornerRadius * 2)
            make.height.equalTo(1)
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
