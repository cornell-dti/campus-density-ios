//
//  HoursCell.swift
//  Campus Density
//
//  Created by Matthew Coufal on 3/8/19.
//  Copyright © 2019 Cornell DTI. All rights reserved.
//

import UIKit

class HoursCell: UICollectionViewCell {
    
    // MARK: - View vars
    var hoursLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        hoursLabel = UILabel()
        hoursLabel.textColor = .warmGray
        hoursLabel.textAlignment = .center
        hoursLabel.numberOfLines = 0
        hoursLabel.font = .eighteenBold
        addSubview(hoursLabel)
        
    }
    
    func setupConstraints() {
        
        hoursLabel.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalToSuperview()
        }
    }
    
    func configure(with hours: String) {
        hoursLabel.text = hours
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
