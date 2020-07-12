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

    func configure(with place: Place) {
        self.place = place
        displayLabel.text = place.displayName
        if place.displayName.count >= 23 {
            displayLabel.font = .twentyEightBold
        }

        if place.isClosed {
            timeString = NSMutableAttributedString(string: "Closed")
            timeString.addAttribute(.foregroundColor, value: UIColor.orangeyRed, range: NSRange(location: 0, length: timeString.mutableString.length))
        } else {
            let closingString = getNextClosingText()
            timeString = NSMutableAttributedString(string: "Open until `\(closingString)")
            timeString.addAttribute(.foregroundColor, value: UIColor.lightTeal, range: NSRange(location: 0, length: timeString.mutableString.length))
        }

        timeLabel.attributedText = timeString
    }

    /**
     Returns a string representing the next closing time for this place, with the hh:mm aa format.
    */
    func getNextClosingText() -> String {

        let ithacaTime = TimeZone(identifier: "America/New_York")!
        var ithacaCalendar = Calendar.current

        ithacaCalendar.timeZone = ithacaTime

        let currTime = Date()
        let day = ithacaCalendar.component(.weekday, from: currTime)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm aa"
        dateFormatter.timeZone = ithacaTime
        guard let placeHoursStringified = place.hours[day - 1] else { return "Operating hours could not be found" }
        let placeHours = placeHoursStringified.split(separator: "\n")
        for s in placeHours {
            let rangeSplit = String(s).split(separator: "-")
            let endTime = String(rangeSplit[1]).trimmingCharacters(in: .whitespacesAndNewlines)
            print("Endtime: " + endTime)

            var currTimeRef = Date(timeIntervalSinceReferenceDate: 0) // Initiates date at 2001-01-01 00:00:00 +0000
            var endTimeRef = Date(timeIntervalSinceReferenceDate: 0)

            let currDateComponents = ithacaCalendar.dateComponents([.hour, .minute], from: currTime)
            let endTimeComponents = ithacaCalendar.dateComponents([.hour, .minute], from: dateFormatter.date(from: endTime)!)

            currTimeRef = ithacaCalendar.date(byAdding: currDateComponents, to: currTimeRef)!
            endTimeRef = ithacaCalendar.date(byAdding: endTimeComponents, to: endTimeRef)!

            if currTimeRef < endTimeRef {
                return endTime
            }
        }

        return "Closed"
    }

}
