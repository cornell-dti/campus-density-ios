//
//  HoursHeaderCell.swift
//  Campus Density
//
//  Created by Matthew Coufal on 3/8/19.
//  Copyright © 2019 Cornell DTI. All rights reserved.
//

import UIKit

class HoursHeaderCell: UICollectionViewCell {

    // MARK: - View vars
    var weekdayLabel: UILabel!
    var dateLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)

        weekdayLabel = UILabel()
        weekdayLabel.textColor = .grayishBrown
        weekdayLabel.textAlignment = .center
        weekdayLabel.font = .twentyBold
        addSubview(weekdayLabel)

        dateLabel = UILabel()
        dateLabel.textColor = .densityDarkGray
        dateLabel.textAlignment = .center
        dateLabel.font = .sixteenBold
        addSubview(dateLabel)

    }

    func setupConstraints() {
        guard let weekdayLabelText = weekdayLabel.text,
            let dateLabelText = dateLabel.text else { return }
        let weekdayLabelTextHeight = weekdayLabelText.height(withConstrainedWidth: frame.width, font: weekdayLabel.font)
        let dateLabelTextHeight = dateLabelText.height(withConstrainedWidth: frame.width, font: dateLabel.font)

        weekdayLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(weekdayLabelTextHeight)
        }

        dateLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(weekdayLabel.snp.bottom)
            make.height.equalTo(dateLabelTextHeight)
        }

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(weekday: String, date: String) {
        weekdayLabel.text = weekday
        dateLabel.text = date
        setupConstraints()
    }

}
