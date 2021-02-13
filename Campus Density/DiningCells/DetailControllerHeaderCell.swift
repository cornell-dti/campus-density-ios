//
//  DetailControllerHeaderCell.swift
//  Campus Density
//
//  Created by Ansh Godha on 26/06/20.
//  Copyright © 2020 Cornell DTI. All rights reserved.
//

import UIKit

class DetailControllerHeaderCell: UICollectionViewCell {

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

        timeLabel = UILabel()
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

    func configure(displayName: String, hours: [DailyInfo]) {
        displayLabel.text = displayName
        if displayName.count >= 23 {
            displayLabel.font = .twentyEightBold
        }

        let timeText = getNextClosingText(hours: hours)
        let attributes = [NSAttributedString.Key.foregroundColor: (timeText == "Closed" ? UIColor.orangeyRed : UIColor.lightTeal)]
        timeLabel.attributedText = NSMutableAttributedString(string: timeText, attributes: attributes)
    }

    /**
     Returns a user-facing string representing the next closing time for this place.
    */
    func getNextClosingText(hours: [DailyInfo]) -> String {

        // TODO: consider moving to util or someplace since ithacaTime/ithacaCalendar are used multiple places
        let ithacaTime = TimeZone(identifier: "America/New_York")!
        var ithacaCalendar = Calendar.current
        ithacaCalendar.timeZone = ithacaTime

        let currTime = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.timeZone = ithacaTime

        for mealPeriod in hours {
            let startTime = Date(timeIntervalSince1970: mealPeriod.dailyHours.startTimestamp)
            let endTime = Date(timeIntervalSince1970: mealPeriod.dailyHours.endTimestamp)
            if currTime > startTime && currTime < endTime {
                return "Open until \(dateFormatter.string(from: endTime))"
            }
        }

        return "Closed"
    }

}
