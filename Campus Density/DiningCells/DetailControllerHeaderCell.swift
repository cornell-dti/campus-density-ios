//
//  DetailControllerHeaderCell.swift
//  Campus Density
//
//  Created by Ansh Godha on 26/06/20.
//  Copyright © 2020 Cornell DTI. All rights reserved.
//

import UIKit

class DetailControllerHeaderCell: UICollectionViewCell {

    var place: Place!
    var displayLabel: UILabel!
    var timeString: NSMutableAttributedString!
    var timeLabel: UILabel!
    var bottomBorder: UIView!

    let spacing = 5

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
    }

    func setupViews() {
        timeString = NSMutableAttributedString(string: "Open until 8 pm")
        timeString.addAttribute(.foregroundColor, value: UIColor.lightTeal, range: NSRange(location: 0, length: timeString.mutableString.length))

        timeLabel = UILabel()
        timeLabel.attributedText = timeString
        addSubview(timeLabel)

        displayLabel = UILabel()
        displayLabel.textColor = .black
        displayLabel.textAlignment = .center
        displayLabel.font = .thirtyBold
        addSubview(displayLabel)

        bottomBorder = UIView()
        bottomBorder.backgroundColor = .densityDarkGray
        addSubview(bottomBorder)

        setupConstraints()
    }

    func setupConstraints() {
        displayLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-5)
            make.centerX.equalToSuperview()
        }

        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(displayLabel.snp.bottom).offset(spacing)
            make.centerX.equalToSuperview()
        }

        bottomBorder.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
            make.width.equalToSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with place: Place) {
        self.place = place
        displayLabel.text = place.displayName
    }
}
