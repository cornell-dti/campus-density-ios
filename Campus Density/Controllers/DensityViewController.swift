//
//  DensityViewController.swift
//  Campus Density
//
//  Created by Matthew Coufal on 11/9/18.
//  Copyright © 2018 Cornell DTI. All rights reserved.
//

import UIKit
import Presentr

class DensityViewController: UIViewController {

    // MARK: - Data vars
    var place: Place!
    var densityMap = [Int: Double]()
    var selectedHour: Int = 0
    var selectedWeekday: Int = 0
    var weekdays = [Int]()
    
    // MARK: - View vars
    var axis: UIView!
    var currentLabel: UILabel!
    var hoursLabel: UILabel!
    var closedLabel: UILabel!
    var bars = [UIView]()
    var densityDescriptionLabel: UILabel!
    var selectedView: UIView!
    var currentDensityView: CurrentDensityView!
    var hoursButton: UIButton!
    var arrowImageView: UIImageView!
    var headerLabel: UILabel!
    var formButton: UIButton!
    var weekdayButtons = [UIButton]()
    
    // MARK: - Constants
    let start: Int = 7
    let end: Int = 23
    let horizontalPadding: CGFloat = 15
    let numSpaces: CGFloat = 4
    let axisHeight: CGFloat = 2
    let hoursVerticalPadding: CGFloat = 15
    let barVerticalPadding: CGFloat = 150
    let descriptionLabelHorizontalPadding: CGFloat = 15
    let descriptionLabelHeight: CGFloat = 40
    let headerHeight: CGFloat = 40
    let formButtonHeight: CGFloat = 20
    let formButtonTopOffset: CGFloat = 5
    let weekdayButtonTopOffset: CGFloat = 5
    let closedLabelWidthInset: CGFloat = 75
    let closedLabelTopOffset: CGFloat = 15
    let hoursButtonHeight: CGFloat = 40
    let hoursButtonCornerRadius: CGFloat = 6
    let descriptionLabelCornerRadius: CGFloat = 6
    let selectedViewWidth: CGFloat = 1.5
    let maxBarHeight: CGFloat = 115
    let descriptionLabelVerticalPadding: CGFloat = 30
    let currentDensityViewHeight: CGFloat = 90
    let currentDensityViewVerticalPadding: CGFloat = 5
    let arrowImageViewLength: CGFloat = 20
    let weekdayLabelHeight: CGFloat = 35
    let weekdayLabelSpacing: CGFloat = 15
    let headerLabelText = "Popular Times"
    let arrowImageName = "downarrow"
    let formButtonText = "Is this accurate?"
    let feedbackForm = "https://docs.google.com/forms/d/e/1FAIpQLSeJZ7AyVRZ8tfw-XiJqREmKn9y0wPCyreEkkysJn0QHCLDmaA/viewform?vc=0&c=0&w=1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setWeekdays()
        selectedWeekday = getWeekday()
        selectedHour = getCurrentHour()
        getDensityMap()

        view.backgroundColor = .white
        title = place.displayName
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = .warmGray
        
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        setupViews()
        setupConstraints()
        
    }
    
    func setWeekdays() {
        let today = getWeekday()
        let last = 6
        weekdays = [today]
        var weekday = today + 1 > last ? 0 : today + 1
        while weekday != today {
            weekdays.append(weekday)
            weekday += 1
            if weekday > last {
                weekday = 0
            }
        }
    }
    
    @objc func didBecomeActive() {
        if let nav = navigationController, let _ = nav.topViewController as? DensityViewController {
            API.densities { gotDensities in
                if gotDensities {
                    API.status { gotStatus in
                        if gotStatus {
                            let index = System.places.firstIndex(where: { place -> Bool in
                                return place.id == self.place.id
                            })
                            guard let placeIndex = index else { return }
                            self.place = System.places[placeIndex]
                            self.currentDensityView.configure(with: self.place)
                        }
                    }
                }
            }
        }
    }
    
    func selectedWeekdayText() -> String {
        switch selectedWeekday {
        case 0:
            return "Sunday"
        case 1:
            return "Monday"
        case 2:
            return "Tuesday"
        case 3:
            return "Wednesday"
        case 4:
            return "Thursday"
        case 5:
            return "Friday"
        case 6:
            return "Saturday"
        default:
            return "Sunday"
        }
    }
    
    func getWeekday() -> Int {
        let today = Date()
        let calendar = Calendar.current
        return calendar.component(.weekday, from: today) - 1
    }
    
    func getCurrentHour() -> Int {
        let today = Date()
        let calendar = Calendar.current
        return calendar.component(.hour, from: today)
    }
    
    func historyKey(weekday: Int) -> String {
        switch weekday {
        case 0:
            return "SUN"
        case 1:
            return "MON"
        case 2:
            return "TUE"
        case 3:
            return "WED"
        case 4:
            return "THU"
        case 5:
            return "FRI"
        case 6:
            return "SAT"
        default:
            return "SUN"
        }
    }
    
    func weekdayNumber(weekday: String) -> Int {
        switch weekday {
        case "Sunday":
            return 0
        case "Monday":
            return 1
        case "Tuesday":
            return 2
        case "Wednesday":
            return 3
        case "Thursday":
            return 4
        case "Friday":
            return 5
        case "Saturday":
            return 6
        default:
            return 0
        }
    }
    
    func getDensityMap() {
        let weekdayKey = historyKey(weekday: selectedWeekday)
        guard let history = place.history[weekdayKey] else { return }
        let sortedKeys = history.keys.sorted { (one, two) in
            guard let one = Int(one), let two = Int(two) else { return true }
            return one < two
        }
        guard let first = sortedKeys.first, var start = Int(first) else { return }
        guard let last = sortedKeys.last, let end = Int(last) else { return }
        var closed: Int = 0
        while start <= end {
            if let density = history["\(start)"] {
                if density == -1.0 {
                    densityMap[start] = nil
                    closed += 1
                } else {
                    densityMap[start] = density
                }
            } else {
                densityMap[start] = nil
            }
            start += 1
        }
        if closed == sortedKeys.count {
            densityMap = [:]
        }
    }
    
    @objc func weekdayButtonPressed(sender: UIButton) {
        if selectedWeekday != sender.tag {
            selectedWeekday = sender.tag
            let currentLabelText = getWeekday() == selectedWeekday ? "Today" : selectedWeekdayText()
            currentLabel.text = currentLabelText
            getDensityMap()
            for button in weekdayButtons {
                if button.tag == selectedWeekday {
                    button.backgroundColor = .grayishBrown
                    button.setTitleColor(.white, for: .normal)
                    button.layer.borderWidth = 0
                } else {
                    button.backgroundColor = .white
                    button.layer.borderColor = UIColor.warmGray.cgColor
                    button.layer.borderWidth = 1
                    button.setTitleColor(.grayishBrown, for: .normal)
                }
            }
            for bar in bars {
                bar.removeFromSuperview()
            }
            bars = []
            if !densityMap.isEmpty {
                closedLabel.isHidden = true
                axis.isHidden = false
                selectedView.isHidden = false
                hoursLabel.isHidden = false
                currentLabel.isHidden = false
                var hours = "No hours available"
                if let selectedWeekdayHours = place.hours[selectedWeekday] {
                    hours = selectedWeekdayHours
                }
                hoursLabel.text = hours
                layoutBars()
                let verticalSpacing = spacing()
                axis.snp.remakeConstraints { make in
                    make.width.equalToSuperview().inset(horizontalPadding)
                    make.height.equalTo(axisHeight)
                    make.top.equalTo(densityDescriptionLabel.snp.bottom).offset(verticalSpacing + maxBarHeight)
                    make.centerX.equalToSuperview()
                }
                if let index = bars.firstIndex(where: { bar in
                    return bar.tag == selectedHour
                }), let _ = densityMap[selectedHour] {
                    let bar = bars[index]
                    didTapBar(bar: bar)
                } else {
                    densityDescriptionLabel.text = "\(getHourLabel()) - Closed"
                    let verticalSpacing = spacing()
                    
                    guard let description = densityDescriptionLabel.text else { return }
                    let descriptionWidth = description.widthWithConstrainedHeight(descriptionLabelHeight, font: .eighteen)
                    
                    densityDescriptionLabel.snp.remakeConstraints { remake in
                        remake.width.equalTo(descriptionWidth + descriptionLabelHorizontalPadding * 2)
                        remake.height.equalTo(descriptionLabelHeight)
                        remake.centerX.equalToSuperview()
                        remake.right.lessThanOrEqualToSuperview().offset(-horizontalPadding).priority(.required)
                        remake.left.greaterThanOrEqualToSuperview().offset(horizontalPadding).priority(.required)
                        remake.top.equalTo(weekdayButtons[0].snp.bottom).offset(verticalSpacing)
                    }
                }
            } else {
                densityDescriptionLabel.text = "Closed"
                hoursLabel.text = "No hours available"
                closedLabel.isHidden = false
                axis.isHidden = true
                selectedView.isHidden = true
                hoursLabel.isHidden = true
                currentLabel.isHidden = true
                let verticalSpacing = spacing()
                guard let descriptionText = densityDescriptionLabel.text else { return }
                let descriptionWidth = descriptionText.widthWithConstrainedHeight(descriptionLabelHeight, font: .eighteen)
                densityDescriptionLabel.snp.remakeConstraints { remake in
                    remake.width.equalTo(descriptionWidth + descriptionLabelHorizontalPadding * 2)
                    remake.top.equalTo(weekdayButtons[0].snp.bottom).offset(verticalSpacing)
                    remake.height.equalTo(descriptionLabelHeight)
                    remake.centerX.equalToSuperview()
                }
            }
        }
    }
    
    func weekdayAbbreviation(weekday: Int) -> String {
        switch weekday {
        case 0:
            return "Su"
        case 1:
            return "M"
        case 2:
            return "T"
        case 3:
            return "W"
        case 4:
            return "Th"
        case 5:
            return "F"
        case 6:
            return "S"
        default:
            return "M"
        }
    }
    
    @objc func formButtonPressed() {
        guard let url = URL(string: feedbackForm) else { return }
        UIApplication.shared.open(url)
    }
    
    func setupViews() {
        
        currentDensityView = CurrentDensityView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: currentDensityViewHeight))
        currentDensityView.configure(with: place)
        view.addSubview(currentDensityView)
        
        headerLabel = UILabel()
        headerLabel.text = headerLabelText
        headerLabel.textColor = .grayishBrown
        headerLabel.textAlignment = .left
        headerLabel.font = .eighteenBold
        view.addSubview(headerLabel)
        
        formButton = UIButton()
        formButton.addTarget(self, action: #selector(formButtonPressed), for: .touchUpInside)
        formButton.setTitle(formButtonText, for: .normal)
        formButton.setTitleColor(.brightBlue, for: .normal)
        formButton.titleLabel?.font = .fourteen
        formButton.titleLabel?.textAlignment = .right
        view.addSubview(formButton)
        
        let weekdayButtonLength = (view.frame.width - CGFloat(weekdays.count + 1) * 15) / CGFloat(weekdays.count)
        
        var index = 0
        while index < weekdays.count {
            let weekday = weekdays[index]
            let weekdayButton = UIButton()
            weekdayButton.tag = weekday
            weekdayButton.addTarget(self, action: #selector(weekdayButtonPressed), for: .touchUpInside)
            weekdayButton.clipsToBounds = true
            weekdayButton.layer.cornerRadius = weekdayButtonLength / 2
            weekdayButton.titleLabel?.font = .sixteen
            weekdayButton.setTitle(weekdayAbbreviation(weekday: weekday), for: .normal)
            if weekday == selectedWeekday {
                weekdayButton.backgroundColor = .grayishBrown
                weekdayButton.setTitleColor(.white, for: .normal)
            } else {
                weekdayButton.layer.borderColor = UIColor.warmGray.cgColor
                weekdayButton.layer.borderWidth = 1
                weekdayButton.backgroundColor = .white
                weekdayButton.setTitleColor(.grayishBrown, for: .normal)
            }
            weekdayButtons.append(weekdayButton)
            view.addSubview(weekdayButton)
            index += 1
        }
        
        axis = UIView()
        axis.backgroundColor = .whiteTwo
        axis.clipsToBounds = true
        axis.layer.cornerRadius = axisHeight / 2
        axis.isHidden = false
        view.addSubview(axis)
        
        currentLabel = UILabel()
        currentLabel.textColor = .warmGray
        let currentLabelText = getWeekday() == selectedWeekday ? "Today" : selectedWeekdayText()
        currentLabel.text = currentLabelText
        currentLabel.textAlignment = .center
        currentLabel.font = .eighteenBold
        currentLabel.isHidden = false
        view.addSubview(currentLabel)
        
        hoursLabel = UILabel()
        hoursLabel.textColor = .grayishBrown
        var hours = "No hours available"
        if let selectedWeekdayHours = place.hours[selectedWeekday] {
            hours = selectedWeekdayHours
        }
        hoursLabel.text = hours
        hoursLabel.textAlignment = .center
        hoursLabel.numberOfLines = 0
        hoursLabel.font = .eighteen
        hoursLabel.isHidden = false
        view.addSubview(hoursLabel)
        
        densityDescriptionLabel = UILabel()
        densityDescriptionLabel.textColor = .grayishBrown
        densityDescriptionLabel.clipsToBounds = true
        densityDescriptionLabel.backgroundColor = .white
        densityDescriptionLabel.layer.borderColor = UIColor.warmGray.cgColor
        densityDescriptionLabel.layer.borderWidth = 1
        densityDescriptionLabel.font = .eighteen
        densityDescriptionLabel.numberOfLines = 0
        densityDescriptionLabel.textAlignment = .center
        densityDescriptionLabel.text = "\(getHourLabel()) - \(getCurrentDensity())"
        densityDescriptionLabel.layer.cornerRadius = descriptionLabelCornerRadius
        view.addSubview(densityDescriptionLabel)
        
        closedLabel = UILabel()
        if getWeekday() == selectedWeekday {
            closedLabel.text = "This place is not open today. Select a different day of the week!"
        } else {
            closedLabel.text = "This place is not open on \(selectedWeekdayText())s. Select a different day of the week!"
        }
        closedLabel.textColor = .grayishBrown
        closedLabel.font = .eighteen
        closedLabel.numberOfLines = 0
        closedLabel.textAlignment = .center
        closedLabel.isHidden = true
        view.addSubview(closedLabel)
        
        selectedView = UIView()
        selectedView.backgroundColor = .warmGray
        selectedView.isHidden = false
        view.addSubview(selectedView)
        
        if densityMap.isEmpty {
            densityDescriptionLabel.text = "Closed"
            hoursLabel.text = "No hours available"
            closedLabel.isHidden = false
            axis.isHidden = true
            selectedView.isHidden = true
            hoursLabel.isHidden = true
            currentLabel.isHidden = true
        }
        
    }
    
    func getHourLabel() -> String {
        var hour = ""
        if selectedHour < 12 {
            hour = selectedHour == 0 ? "12" : "\(selectedHour)"
        } else {
            hour = selectedHour == 12 ? "\(selectedHour)" : "\(selectedHour - 12)"
        }
        return "\(hour) \(selectedHour < 12 ? "AM" : "PM")"
    }
    
    func getCurrentDensity() -> String {
        if densityMap.isEmpty {
            return "Closed"
        }
        guard let historicalAverage = densityMap[selectedHour] else { return "Closed" }
        if historicalAverage < 0.25 {
            return "Usually not busy"
        } else if historicalAverage < 0.5 {
            return "Usually somewhat busy"
        } else if historicalAverage < 0.75 {
            return "Usually pretty busy"
        } else {
            return "Usually very busy"
        }
    }
    
    func spacing() -> CGFloat {
        let weekdayButtonLength = (view.frame.width - CGFloat(weekdays.count + 1) * horizontalPadding) / CGFloat(weekdays.count)
        var total = currentDensityViewHeight + currentDensityViewVerticalPadding * 2 + formButtonHeight + formButtonTopOffset + headerHeight + weekdayButtonTopOffset + weekdayButtonLength + descriptionLabelHeight + maxBarHeight + axisHeight
        guard let currentLabelText = currentLabel.text else { return total }
        guard let hoursLabelText = hoursLabel.text else { return total }
        let currentHeight = currentLabelText.height(withConstrainedWidth: view.frame.width, font: .eighteenBold)
        let hoursHeight = hoursLabelText.height(withConstrainedWidth: view.frame.width, font: .eighteen)
        var difference = UIScreen.main.bounds.height - total - currentHeight - hoursHeight - navigationController!.navigationBar.frame.height - UIApplication.shared.statusBarFrame.height
        if densityMap.isEmpty {
            total = currentDensityViewHeight + currentDensityViewVerticalPadding * 2 + formButtonHeight + formButtonTopOffset + headerHeight + weekdayButtonTopOffset + weekdayButtonLength + descriptionLabelHeight
            guard let closedLabelText = closedLabel.text else { return total }
            let closedLabelHeight = closedLabelText.height(withConstrainedWidth: view.frame.width - closedLabelWidthInset * 2, font: .eighteen)
            difference = UIScreen.main.bounds.height - total - closedLabelHeight - closedLabelTopOffset - navigationController!.navigationBar.frame.height - UIApplication.shared.statusBarFrame.height
            return difference / 2
        }
        return difference / numSpaces
    }
    
    func setupConstraints() {
        let navOffset: CGFloat = UIApplication.shared.statusBarFrame.height + navigationController!.navigationBar.frame.height
        let verticalSpacing = spacing()
        
        guard let description = densityDescriptionLabel.text else { return }
        guard let closedLabelText = closedLabel.text else { return }
        let descriptionWidth = description.widthWithConstrainedHeight(descriptionLabelHeight, font: .eighteen)
        let closedLabelHeight = closedLabelText.height(withConstrainedWidth: view.frame.width - closedLabelWidthInset * 2, font: .eighteen)
        
        currentDensityView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(currentDensityViewHeight)
            make.top.equalToSuperview().offset(navOffset + currentDensityViewVerticalPadding)
        }
        
        formButton.snp.makeConstraints { make in
            make.height.equalTo(formButtonHeight)
            make.top.equalTo(currentDensityView.snp.bottom).offset(formButtonTopOffset)
            make.right.equalToSuperview().inset(horizontalPadding)
        }
        
        headerLabel.snp.makeConstraints { make in
            make.height.equalTo(headerHeight)
            make.left.equalToSuperview().offset(horizontalPadding)
            make.top.equalTo(formButton.snp.bottom)
        }
        
        let weekdayButtonLength = (view.frame.width - CGFloat(weekdays.count + 1) * horizontalPadding) / CGFloat(weekdays.count)
        var left: CGFloat = horizontalPadding
        
        for button in weekdayButtons {
            button.snp.makeConstraints { make in
                make.width.height.equalTo(weekdayButtonLength)
                make.top.equalTo(headerLabel.snp.bottom).offset(weekdayButtonTopOffset)
                make.left.equalTo(left)
            }
            left += weekdayButtonLength + horizontalPadding
        }
        
        if !densityMap.isEmpty {
            
            layoutBars()
            let index = bars.firstIndex(where: { bar -> Bool in
                return bar.tag == selectedHour
            })
        
            if let barIndex = index, let _ = densityMap[selectedHour] {
                densityDescriptionLabel.snp.makeConstraints { make in
                    make.width.equalTo(descriptionWidth + descriptionLabelHorizontalPadding * 2)
                    make.top.equalTo(weekdayButtons[0].snp.bottom).offset(verticalSpacing)
                    make.height.equalTo(descriptionLabelHeight)
                    make.centerX.equalTo(bars[barIndex]).priority(.high)
                    make.right.lessThanOrEqualToSuperview().offset(-horizontalPadding).priority(.required)
                    make.left.greaterThanOrEqualToSuperview().offset(horizontalPadding).priority(.required)
                }
                
                selectedView.snp.makeConstraints { make in
                    make.width.equalTo(selectedViewWidth)
                    make.top.equalTo(densityDescriptionLabel.snp.bottom)
                    make.bottom.equalTo(bars[barIndex].snp.top)
                    make.centerX.equalTo(bars[barIndex])
                }
            } else {
                densityDescriptionLabel.snp.makeConstraints { make in
                    make.width.equalTo(descriptionWidth + descriptionLabelHorizontalPadding * 2)
                    make.top.equalTo(weekdayButtons[0].snp.bottom).offset(verticalSpacing)
                    make.height.equalTo(descriptionLabelHeight)
                    make.centerX.equalToSuperview()
                }
            }
        } else {
            densityDescriptionLabel.snp.makeConstraints { make in
                make.width.equalTo(descriptionWidth + descriptionLabelHorizontalPadding * 2)
                make.top.equalTo(weekdayButtons[0].snp.bottom).offset(verticalSpacing)
                make.height.equalTo(descriptionLabelHeight)
                make.centerX.equalToSuperview()
            }
            
        }
        
        closedLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(closedLabelWidthInset)
            make.height.equalTo(closedLabelHeight)
            make.top.equalTo(densityDescriptionLabel.snp.bottom).offset(closedLabelTopOffset)
            make.centerX.equalToSuperview()
        }
        
        axis.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(horizontalPadding)
            make.height.equalTo(axisHeight)
            make.top.equalTo(densityDescriptionLabel.snp.bottom).offset(verticalSpacing + maxBarHeight)
            make.centerX.equalToSuperview()
        }
        
        currentLabel.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalTo(densityMap.isEmpty ? closedLabel.snp.bottom : axis.snp.bottom).offset(verticalSpacing)
            make.centerX.equalToSuperview()
        }
        
        hoursLabel.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalTo(currentLabel.snp.bottom).offset(hoursVerticalPadding)
            make.centerX.equalToSuperview()
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let location = touches.first?.location(in: view) {
            let index = bars.firstIndex { bar -> Bool in
                return bar.frame.contains(location)
            }
            guard let barIndex = index else { return }
            didTapBar(bar: bars[barIndex])
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let location = touches.first?.location(in: view) {
            let index = bars.firstIndex { bar -> Bool in
                return bar.frame.contains(location)
            }
            guard let barIndex = index else { return }
            didTapBar(bar: bars[barIndex])
        }
    }
    
    func didTapBar(bar: UIView) {
        selectedHour = bar.tag
        densityDescriptionLabel.text = "\(getHourLabel()) - \(getCurrentDensity())"
        let verticalSpacing = spacing()
        
        guard let description = densityDescriptionLabel.text else { return }
        let descriptionWidth = description.widthWithConstrainedHeight(descriptionLabelHeight, font: .eighteen)
        
        densityDescriptionLabel.snp.remakeConstraints { remake in
            remake.width.equalTo(descriptionWidth + descriptionLabelHorizontalPadding * 2)
            remake.height.equalTo(descriptionLabelHeight)
            remake.centerX.equalTo(bar).priority(.high)
            remake.right.lessThanOrEqualToSuperview().offset(-horizontalPadding).priority(.required)
            remake.left.greaterThanOrEqualToSuperview().offset(horizontalPadding).priority(.required)
            remake.top.equalTo(weekdayButtons[0].snp.bottom).offset(verticalSpacing)
        }
        
        selectedView.snp.remakeConstraints { remake in
            remake.width.equalTo(selectedViewWidth)
            remake.top.equalTo(densityDescriptionLabel.snp.bottom)
            remake.bottom.equalTo(bar.snp.top)
            remake.centerX.equalTo(bar)
        }
    }
    
    func layoutBars() {
        var startHour: Int = start
        let endHour: Int = end
        var barLeftOffset: CGFloat = 0
        let barWidth: CGFloat = (view.frame.width - horizontalPadding * 4) / CGFloat(endHour - startHour + 1)
        while startHour <= endHour {
            let bar = UIView()
            bar.tag = startHour
            var barHeight: CGFloat = 1
            if let historicalAverage = densityMap[startHour] {
                if historicalAverage < 0.25 {
                    bar.backgroundColor = .lightTeal
                } else if historicalAverage < 0.5 {
                    bar.backgroundColor = .wheat
                } else if historicalAverage < 0.75 {
                    bar.backgroundColor = .peach
                } else {
                    bar.backgroundColor = .orangeyRed
                }
                barHeight = maxBarHeight * CGFloat(historicalAverage < 0.075 ? 0.075 : historicalAverage)
            } else {
                bar.isHidden = true
            }
            bar.clipsToBounds = true
            bar.layer.cornerRadius = 5
            bar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            bar.layer.borderColor = UIColor.white.cgColor
            bar.layer.borderWidth = 0.5
            self.view.addSubview(bar)
            
            bar.snp.makeConstraints({ make in
                make.width.equalTo(barWidth)
                make.height.equalTo(barHeight)
                make.left.equalTo(axis).offset(barLeftOffset)
                make.bottom.equalTo(self.axis.snp.top)
            })
            self.bars.append(bar)
            barLeftOffset += barWidth
            startHour += 1
        }
    }

}
