//
//  WeekdayToggleView.swift
//  Campus Density
//
//  Created by Matthew Coufal on 2/9/19.
//  Copyright © 2019 Cornell DTI. All rights reserved.
//

import UIKit

protocol WeekdayToggleViewDelegate {
    
    func weekdayToggleViewDidTapToggleButton(selectedWeekday: String)
    
}

class WeekdayToggleView: UIView {
    
    // MARK: - View vars
    var toggleButton: UIButton!
    var weekdayLabel: UILabel!
    var arrowImageView: UIImageView!
    
    // MARK: - Data vars
    var weekday: String!
    var delegate: WeekdayToggleViewDelegate?
    var width: CGFloat!
    
    // MARK: - Constants
    let arrowImageViewLength: CGFloat = 20
    let toggleButtonCornerRadius: CGFloat = 10
    let height: CGFloat = 40
    let toggleButtonHorizontalPadding: CGFloat = 15
    let arrowImageViewHorizontalPadding: CGFloat = 5
    let arrowImageName = "downarrow"

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        
    }
    
    func setupViews() {
        toggleButton = UIButton()
        toggleButton.addTarget(self, action: #selector(toggleButtonPressed), for: .touchUpInside)
        toggleButton.clipsToBounds = true
        toggleButton.layer.cornerRadius = toggleButtonCornerRadius
        toggleButton.backgroundColor = .whiteTwo
        addSubview(toggleButton)
        
        weekdayLabel = UILabel()
        weekdayLabel.textColor = .grayishBrown
        weekdayLabel.font = .eighteenBold
        addSubview(weekdayLabel)
        
        arrowImageView = UIImageView()
        arrowImageView.image = UIImage(named: arrowImageName)?.withRenderingMode(.alwaysTemplate)
        arrowImageView.tintColor = .grayishBrown
        addSubview(arrowImageView)
    }
    
    @objc func toggleButtonPressed() {
        delegate?.weekdayToggleViewDidTapToggleButton(selectedWeekday: weekday)
    }
    
    func setupConstraints() {
        guard let weekdayText = weekdayLabel.text else { return }
        let weekdayWidth = weekdayText.widthWithConstrainedHeight(height, font: .eighteenBold)
        let toggleButtonWidth = weekdayWidth + toggleButtonHorizontalPadding + arrowImageViewLength + arrowImageViewHorizontalPadding * 2
        width = toggleButtonWidth
        
        toggleButton.snp.makeConstraints { make in
            make.width.equalTo(toggleButtonWidth)
            make.height.equalTo(height)
            make.centerX.equalToSuperview()
        }
        
        weekdayLabel.snp.makeConstraints { make in
            make.width.equalTo(weekdayWidth)
            make.centerY.equalTo(toggleButton)
            make.left.equalTo(toggleButton).offset(toggleButtonHorizontalPadding)
            make.height.equalTo(height)
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.width.height.equalTo(arrowImageViewLength)
            make.left.equalTo(weekdayLabel.snp.right)
            make.centerY.equalTo(toggleButton)
        }
        
    }
    
    func configure(weekday: String, delegate: WeekdayToggleViewDelegate?) {
        self.delegate = delegate
        self.weekday = weekday
        weekdayLabel.text = weekday
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
