//
//  WeekdayToggleViewController.swift
//  Campus Density
//
//  Created by Matthew Coufal on 2/9/19.
//  Copyright © 2019 Cornell DTI. All rights reserved.
//

import UIKit

protocol WeekdayToggleViewControllerDelegate {
    
    func weekdayToggleViewControllerDidSelectWeekday(weekday: String)
    
}

class WeekdayToggleViewController: UIViewController, WeekdayButtonViewDelegate {
    
    // MARK: - View vars
    var closeButton: UIButton!
    var buttons = [WeekdayButtonView]()
    
    // MARK: - Data vars
    var delegate: WeekdayToggleViewControllerDelegate?
    var selectedWeekday: String!
    var weekdays: [String]!
    
    // MARK: - Constants
    let headerLabelHeight: CGFloat = 40
    let spacing: CGFloat = 12.5
    let weekdayCollectionViewCellHeight: CGFloat = 35
    let weekdayCollectionViewInteritemSpacing: CGFloat = 15
    let weekdayCollectionViewCellHorizontalPadding: CGFloat = 10
    let closeButtonLength: CGFloat = 40
    let closeButtonOffset: CGFloat = 10
    let weekdayButtonLength: CGFloat = 35
    let weekdaySpacing: CGFloat = 15
    let weekdayCellIdentifier = "weekdays"
    let headerLabelText = "Select a weekday"
    let closeButtonImageName = "close"

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        var sorted: [String] = [selectedWeekday]
        let index: Int! = weekdays.firstIndex(of: selectedWeekday)
        var weekdaysIndex = index + 1 == weekdays.count ? 0 : index + 1
        while weekdaysIndex < weekdays.count && weekdaysIndex != index {
            sorted.append(weekdays[weekdaysIndex])
            if weekdaysIndex + 1 == weekdays.count {
                weekdaysIndex = 0
            } else {
                weekdaysIndex += 1
            }
        }
        
        weekdays = sorted
        
        setupViews()
        setupConstraints()
        
    }
    
    @objc func closeButtonPressed() {
        delegate?.weekdayToggleViewControllerDidSelectWeekday(weekday: selectedWeekday)
        dismiss(animated: true, completion: nil)
    }
    
    func weekdayButtonViewDidSelectWeekday(weekday: String) {
        //
    }
    
    func setupViews() {
        
        closeButton = UIButton()
        closeButton.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
        closeButton.setImage(UIImage(named: closeButtonImageName)?.withRenderingMode(.alwaysTemplate), for: .normal)
        closeButton.imageView?.tintColor = .warmGray
        view.addSubview(closeButton)
        
        for weekday in weekdays {
            let button = WeekdayButtonView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: weekdayButtonLength))
            button.configure(weekday: weekday, isSelectedWeekday: weekday == selectedWeekday, delegate: self)
            buttons.append(button)
            view.addSubview(button)
        }
        
    }
    
    func setupConstraints() {
        
        closeButton.snp.makeConstraints { make in
            make.width.height.equalTo(closeButtonLength)
            make.top.equalToSuperview().offset(closeButtonOffset)
            make.left.equalToSuperview().offset(closeButtonOffset)
        }
        
        var top = closeButtonOffset + closeButtonLength + weekdaySpacing
        
        for button in buttons {
            button.snp.makeConstraints { make in
                make.top.equalTo(top)
            }
            top += weekdayButtonLength + weekdaySpacing
        }
    }

}
