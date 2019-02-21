//
//  WeekdaySelectorView.swift
//  Campus Density
//
//  Created by Matthew Coufal on 2/17/19.
//  Copyright © 2019 Cornell DTI. All rights reserved.
//

import UIKit

protocol WeekdayButtonViewDelegate {
    
    func weekdayButtonViewDidSelectWeekday(weekday: String)
    
}

class WeekdayButtonView: UIView {
    
    // MARK: - View vars
    var selectButton: UIButton!
    var dot: UIView!
    var weekdayLabel: UILabel!
    
    // MARK: - Data vars
    var weekday: String!
    var delegate: WeekdayButtonViewDelegate?
    
    // MARK: - Constants
    let height: CGFloat = 35
    let spacing: CGFloat = 15
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        selectButton = UIButton()
        selectButton.addTarget(self, action: #selector(selectButtonPressed), for: .touchUpInside)
        addSubview(selectButton)
        
        dot = UIView()
        dot.clipsToBounds = true
        dot.layer.cornerRadius = height / 4
        addSubview(dot)
        
        weekdayLabel = UILabel()
        weekdayLabel.font = .eighteen
        weekdayLabel.textColor = .grayishBrown
        addSubview(weekdayLabel)
        
    }
    
    func setupConstraints() {
        let weekdayLabelWidth = weekday.widthWithConstrainedHeight(height, font: .eighteen)
        let horizontalPadding = (frame.width - height - spacing - weekdayLabelWidth) / 2
        
        selectButton.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(height)
            make.center.equalToSuperview()
        }
        
        dot.snp.makeConstraints { make in
            make.width.height.equalTo(height / 2)
            make.left.equalToSuperview().offset(horizontalPadding)
            make.centerY.equalToSuperview()
        }
        
        weekdayLabel.snp.makeConstraints { make in
            make.width.equalTo(weekdayLabelWidth)
            make.height.equalTo(height)
            make.left.equalTo(dot.snp.right).offset(spacing)
            make.centerY.equalToSuperview()
        }
        
    }
    
    @objc func selectButtonPressed() {
        delegate?.weekdayButtonViewDidSelectWeekday(weekday: weekday)
    }
    
    func configure(weekday: String, isSelectedWeekday: Bool, delegate: WeekdayButtonViewDelegate) {
        self.weekday = weekday
        self.delegate = delegate
        weekdayLabel.text = weekday
        if isSelectedWeekday {
            dot.backgroundColor = .warmGray
            dot.layer.borderWidth = 0
        } else {
            dot.backgroundColor = .white
            dot.layer.borderWidth = 3
            dot.layer.borderColor = UIColor.warmGray.cgColor
        }
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
