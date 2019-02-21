//
//  WeekdayCollectionViewCell.swift
//  Campus Density
//
//  Created by Matthew Coufal on 2/9/19.
//  Copyright © 2019 Cornell DTI. All rights reserved.
//

import UIKit

class WeekdayCollectionViewCell: UICollectionViewCell {
    
    // MARK: - View vars
    var weekdayLabel: UILabel!
    
    // MARK: - Data vars
    var isSelectedWeekday: Bool!
    var weekday: String!
    var height: CGFloat!
    
    // MARK: - Constants
    let padding: CGFloat = 15
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        setupViews()
        
    }
    
    func setupViews() {
        weekdayLabel = UILabel()
        weekdayLabel.textAlignment = .center
        weekdayLabel.textColor = .grayishBrown
        weekdayLabel.font = .eighteenBold
        weekdayLabel.clipsToBounds = true
        addSubview(weekdayLabel)
    }
    
    func setupConstraints() {
        weekdayLabel.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(height)
            make.center.equalToSuperview()
        }
    }
    
    func configure(weekday: String, isSelectedWeekday: Bool, height: CGFloat) {
        self.weekday = weekday
        self.isSelectedWeekday = isSelectedWeekday
        self.height = height
        weekdayLabel.text = weekday
        if isSelectedWeekday {
            weekdayLabel.backgroundColor = .whiteTwo
        } else {
            weekdayLabel.backgroundColor = .white
            weekdayLabel.layer.borderWidth = 1
            weekdayLabel.layer.borderColor = UIColor.whiteTwo.cgColor
        }
        weekdayLabel.layer.cornerRadius = height / 2
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
