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
    var barGraphView: BarGraphView!
    var contentView: UIView!
    var scrollView: UIScrollView!
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
    var graphHeaderLabel: UILabel!
    var hoursHeaderLabel: UILabel!
    var selectedDateLabel: UILabel!
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
    let weekdayButtonTopOffset: CGFloat = 15
    let closedLabelWidthInset: CGFloat = 75
    let closedLabelTopOffset: CGFloat = 15
    let hoursButtonHeight: CGFloat = 40
    let hoursButtonCornerRadius: CGFloat = 6
    let descriptionLabelCornerRadius: CGFloat = 6
    let selectedViewWidth: CGFloat = 1.5
    let maxBarHeight: CGFloat = 150
    let descriptionLabelVerticalPadding: CGFloat = 30
    let currentDensityViewHeight: CGFloat = 90
    let currentDensityViewVerticalPadding: CGFloat = 5
    let arrowImageViewLength: CGFloat = 20
    let weekdayLabelHeight: CGFloat = 35
    let weekdayLabelSpacing: CGFloat = 15
    let barGraphViewHeight: CGFloat = 277
    let barGraphViewVerticalPadding: CGFloat = 50
    let totalSpacing: CGFloat = 220
    let graphHeaderLabelText = "Popular Times"
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
            hoursHeaderLabel.text = getWeekday() == selectedWeekday ? "Today" : selectedWeekdayText()
            selectedDateLabel.text = selectedDateLabelText()
            var hours = "No hours available"
            if let selectedWeekdayHours = place.hours[selectedWeekday] {
                hours = selectedWeekdayHours
            }
            hoursLabel.text = hours
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
            
            if !densityMap.isEmpty {
                var description = "\(getHourLabel()) - Closed"
                if let _ = densityMap[selectedHour] {
                    description = "\(getHourLabel()) - \(getCurrentDensity())"
                }
                barGraphView.updateDensityMap(densityMap: densityMap, description: description)
            } else {
                barGraphView.updateDensityMap(densityMap: nil, description: "Closed")
            }
            
            let hoursLabelTextHeight = hours.height(withConstrainedWidth: view.frame.width, font: hoursLabel.font)
            hoursLabel.snp.updateConstraints { update in
                update.height.equalTo(hoursLabelTextHeight)
            }
            
            contentView.snp.updateConstraints { update in
                update.height.equalTo(contentSizeHeight())
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
        
        scrollView = UIScrollView()
        scrollView.bounces = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isScrollEnabled = true
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
        view.addSubview(scrollView)
        
        contentView = UIView()
        scrollView.addSubview(contentView)
        
        currentDensityView = CurrentDensityView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: currentDensityViewHeight))
        currentDensityView.configure(with: place)
        contentView.addSubview(currentDensityView)
        
        graphHeaderLabel = UILabel()
        graphHeaderLabel.text = graphHeaderLabelText
        graphHeaderLabel.textColor = .grayishBrown
        graphHeaderLabel.textAlignment = .left
        graphHeaderLabel.font = .thirtyBold
        contentView.addSubview(graphHeaderLabel)
        
        formButton = UIButton()
        formButton.addTarget(self, action: #selector(formButtonPressed), for: .touchUpInside)
        formButton.setTitle(formButtonText, for: .normal)
        formButton.setTitleColor(.brightBlue, for: .normal)
        formButton.titleLabel?.font = .fourteen
        formButton.titleLabel?.textAlignment = .right
        contentView.addSubview(formButton)
        
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
            contentView.addSubview(weekdayButton)
            index += 1
        }
        
        barGraphView = BarGraphView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: barGraphViewHeight))
        if !densityMap.isEmpty {
            barGraphView.configure(description: "\(getHourLabel()) - \(getCurrentDensity())", densityMap: densityMap, selectedHour: selectedHour, delegate: self)
        } else {
            barGraphView.configure(description: "Closed", densityMap: nil, selectedHour: selectedHour, delegate: self)
        }
        contentView.addSubview(barGraphView)
        
        hoursHeaderLabel = UILabel()
        hoursHeaderLabel.text = getWeekday() == selectedWeekday ? "Today" : selectedWeekdayText()
        hoursHeaderLabel.textColor = .grayishBrown
        hoursHeaderLabel.textAlignment = .center
        hoursHeaderLabel.font = .twentyBold
        contentView.addSubview(hoursHeaderLabel)
        
        selectedDateLabel = UILabel()
        selectedDateLabel.text = selectedDateLabelText()
        selectedDateLabel.textColor = .densityDarkGray
        selectedDateLabel.textAlignment = .center
        selectedDateLabel.font = .sixteenBold
        contentView.addSubview(selectedDateLabel)
        
        hoursLabel = UILabel()
        hoursLabel.textColor = .warmGray
        var hours = "No hours available"
        if let selectedWeekdayHours = place.hours[selectedWeekday] {
            hours = selectedWeekdayHours
        }
        hoursLabel.text = hours
        hoursLabel.textAlignment = .center
        hoursLabel.numberOfLines = 0
        hoursLabel.font = .eighteenBold
        contentView.addSubview(hoursLabel)
    }
    
    func selectedDateLabelText() -> String {
        let today = Date()
        guard let weekdayIndex = weekdays.firstIndex(of: selectedWeekday) else { return "" }
        guard let selectedDate = Calendar.current.date(byAdding: Calendar.Component.day, value: weekdayIndex, to: today) else { return "" }
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .long
        let dateString = formatter.string(from: selectedDate)
        let dateStringComponents = dateString.components(separatedBy: ",")
        return dateStringComponents[0]
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
    
    func contentSizeHeight() -> CGFloat {
        guard let hoursLabelText = hoursLabel.text else { return 0 }
        let hoursLabelTextHeight = hoursLabelText.height(withConstrainedWidth: view.frame.width, font: hoursLabel.font)
        guard let hoursHeaderLabelText = hoursHeaderLabel.text else { return 0 }
        let hoursHeaderLabelTextHeight = hoursHeaderLabelText.height(withConstrainedWidth: view.frame.width, font: hoursLabel.font)
        guard let selectedDateLabelText = selectedDateLabel.text else { return 0 }
        let selectedDateLabelTextHeight = selectedDateLabelText.height(withConstrainedWidth: view.frame.width, font: selectedDateLabel.font)
        let weekdayButtonLength = (view.frame.width - CGFloat(weekdays.count + 1) * horizontalPadding) / CGFloat(weekdays.count)
        guard let graphHeaderLabelText = graphHeaderLabel.text else { return 0 }
        let graphHeaderLabelTextHeight = graphHeaderLabelText.height(withConstrainedWidth: view.frame.width, font: graphHeaderLabel.font)
        return hoursLabelTextHeight + hoursHeaderLabelTextHeight + selectedDateLabelTextHeight + weekdayButtonLength + graphHeaderLabelTextHeight + currentDensityViewHeight + barGraphViewHeight + formButtonHeight + totalSpacing
    }
    
    func setupConstraints() {
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
            make.height.equalTo(contentSizeHeight())
        }
        
        currentDensityView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(currentDensityViewHeight)
            make.top.equalToSuperview().offset(currentDensityViewVerticalPadding + 10)
        }
        
        formButton.snp.makeConstraints { make in
            make.height.equalTo(formButtonHeight)
            make.top.equalTo(currentDensityView.snp.bottom).offset(formButtonTopOffset)
            make.right.equalToSuperview().inset(horizontalPadding)
        }
        
        guard let graphHeaderLabelText = graphHeaderLabel.text else { return }
        let graphHeaderLabelHeight = graphHeaderLabelText.height(withConstrainedWidth: view.frame.width - horizontalPadding * 2, font: graphHeaderLabel.font)
        
        graphHeaderLabel.snp.makeConstraints { make in
            make.height.equalTo(graphHeaderLabelHeight)
            make.left.equalToSuperview().offset(horizontalPadding)
            make.top.equalTo(formButton.snp.bottom).offset(15)
        }
        
        let weekdayButtonLength = (view.frame.width - CGFloat(weekdays.count + 1) * horizontalPadding) / CGFloat(weekdays.count)
        var left: CGFloat = horizontalPadding
        
        for button in weekdayButtons {
            button.snp.makeConstraints { make in
                make.width.height.equalTo(weekdayButtonLength)
                make.top.equalTo(graphHeaderLabel.snp.bottom).offset(weekdayButtonTopOffset)
                make.left.equalTo(left)
            }
            left += weekdayButtonLength + horizontalPadding
        }
        
        barGraphView.snp.makeConstraints { make in
            make.top.equalTo(weekdayButtons[0].snp.bottom).offset(barGraphViewVerticalPadding)
            make.width.equalToSuperview()
            make.height.equalTo(barGraphViewHeight)
        }
        
        guard let hoursHeaderLabelText = hoursHeaderLabel.text else { return }
        let hoursHeaderLabelHeight = hoursHeaderLabelText.height(withConstrainedWidth: view.frame.width - horizontalPadding * 2, font: hoursHeaderLabel.font)
        
        hoursHeaderLabel.snp.makeConstraints { make in
            make.height.equalTo(hoursHeaderLabelHeight)
            make.centerX.equalToSuperview()
            make.top.equalTo(barGraphView.snp.bottom).offset(50)
        }
        
        guard let selectedDateLabelText = selectedDateLabel.text else { return }
        let selectedDateLabelTextHeight = selectedDateLabelText.height(withConstrainedWidth: view.frame.width, font: selectedDateLabel.font)
        
        selectedDateLabel.snp.makeConstraints { make in
            make.top.equalTo(hoursHeaderLabel.snp.bottom)
            make.height.equalTo(selectedDateLabelTextHeight)
            make.centerX.equalToSuperview()
        }
        
        guard let hoursLabelText = hoursLabel.text else { return }
        let hoursLabelTextHeight = hoursLabelText.height(withConstrainedWidth: view.frame.width, font: hoursLabel.font)
        
        hoursLabel.snp.makeConstraints { make in
            make.top.equalTo(selectedDateLabel.snp.bottom).offset(25)
            make.height.equalTo(hoursLabelTextHeight)
            make.centerX.equalToSuperview()
        }
        
    }

}

extension DensityViewController: BarGraphViewDelegate {
    
    func barGraphViewDidSelectHour(selectedHour: Int) {
        self.selectedHour = selectedHour
        let description = "\(getHourLabel()) - \(getCurrentDensity())"
        barGraphView.updateSelectedHour(selectedHour: selectedHour, description: description)
    }
    
}

extension DensityViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
}
