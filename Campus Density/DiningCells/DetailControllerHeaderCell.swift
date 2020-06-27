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

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstrains()
    }

    func setupViews() {
        timeString = NSMutableAttributedString(string: "Open until 8 pm")
        timeString.addAttribute(.foregroundColor, value: UIColor.lightTeal, range: NSRange(location: 0, length: timeString.mutableString.length))

        timeLabel = UILabel()
        timeLabel.attributedText = timeString
        addSubview(timeLabel)

        displayLabel = UILabel()
        displayLabel.text = place.displayName
        displayLabel.textColor = .grayishBrown
        displayLabel.textAlignment = .center
        displayLabel.font = .thirtyBold
        addSubview(displayLabel)
    }

    func setupConstrains() {

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with place: Place) {
        self.place = place
    }
}
