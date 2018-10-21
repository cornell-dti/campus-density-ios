//
//  FacilityTableViewCell.swift
//  Campus Density
//
//  Created by Matthew Coufal on 10/14/18.
//  Copyright © 2018 Cornell DTI. All rights reserved.
//

import UIKit

protocol FacilityTableViewCellDelegate {
    func facilityTableViewCellDidTapFavoritebackground(facility: Facility)
}

class FacilityTableViewCell: UITableViewCell {
    
    // MARK: - Data vars
    var facility: Facility!
    var percentage: Double!
    
    // MARK: - View vars
    var background: UIView!
    var nameLabel: UILabel!
    var timeLabel: UILabel!
    var capacityLabel: UILabel!
    var totalCapacityBar: UIView!
    var currentCapacityBar: UIView!
    
    // MARK: - Constants
    let backgroundCornerRadius: CGFloat = 10
    let capacityBarCornerRadius: CGFloat = 5
    let padding: CGFloat = 15
    let capacityBarHeight: CGFloat = 45
    let capacityLabelWidth: CGFloat = 92.5

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        setupViews()
        
    }
    
    func setupViews() {
        background = UIView()
        background.backgroundColor = .offWhite
        background.clipsToBounds = true
        background.layer.cornerRadius = backgroundCornerRadius
        background.layer.masksToBounds = false
        background.layer.shadowColor = UIColor.lightGray.cgColor
        background.layer.shadowRadius = 2.5
        background.layer.shadowOffset = CGSize(width: 0, height: 1)
        background.layer.shadowOpacity = 1.0
        addSubview(background)
        
        nameLabel = UILabel()
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.textColor = .darkGray
        nameLabel.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
        addSubview(nameLabel)
        
        timeLabel = UILabel()
        timeLabel.adjustsFontSizeToFitWidth = true
        timeLabel.textColor = .darkGray
        timeLabel.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        addSubview(timeLabel)
        
        capacityLabel = UILabel()
        capacityLabel.adjustsFontSizeToFitWidth = true
        capacityLabel.textAlignment = .right
        capacityLabel.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize * 2)
        addSubview(capacityLabel)
        
        totalCapacityBar = UIView()
        totalCapacityBar.backgroundColor = .white
        totalCapacityBar.clipsToBounds = true
        totalCapacityBar.layer.cornerRadius = capacityBarCornerRadius
        totalCapacityBar.layer.cornerRadius = backgroundCornerRadius
        totalCapacityBar.layer.masksToBounds = false
        totalCapacityBar.layer.shadowColor = UIColor.lightGray.cgColor
        totalCapacityBar.layer.shadowRadius = 1.5
        totalCapacityBar.layer.shadowOffset = CGSize(width: 0, height: 1)
        totalCapacityBar.layer.shadowOpacity = 1.0
        addSubview(totalCapacityBar)
        
        currentCapacityBar = UIView()
        currentCapacityBar.backgroundColor = .densityBlue
        currentCapacityBar.clipsToBounds = true
        currentCapacityBar.layer.cornerRadius = capacityBarCornerRadius
        addSubview(currentCapacityBar)
    }
    
    func setupConstraints() {
        background.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(padding)
            make.width.equalToSuperview().offset(-padding * 2)
            make.height.equalToSuperview().offset(-padding)
        }
        
        totalCapacityBar.snp.makeConstraints { make in
            make.left.equalTo(background).offset(padding)
            make.width.equalTo(background).offset(-padding * 2)
            make.bottom.equalTo(background).offset(-padding)
            make.height.equalTo(capacityBarHeight)
        }
        
        currentCapacityBar.snp.makeConstraints { make in
            make.left.equalTo(totalCapacityBar)
            make.height.equalTo(totalCapacityBar)
            make.width.equalTo(totalCapacityBar).multipliedBy(percentage)
            make.centerY.equalTo(totalCapacityBar)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.left.equalTo(totalCapacityBar)
            make.bottom.equalTo(totalCapacityBar.snp.top).offset(-padding)
            make.width.equalTo(totalCapacityBar).offset(-capacityLabelWidth - padding * 2)
            make.height.equalTo(capacityBarHeight / 2)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(timeLabel)
            make.bottom.equalTo(timeLabel.snp.top)
            make.width.equalTo(timeLabel)
            make.height.equalTo(timeLabel)
        }
        
        capacityLabel.snp.makeConstraints { make in
            make.width.equalTo(capacityLabelWidth)
            make.height.equalTo(capacityBarHeight)
            make.right.equalTo(background).offset(-padding)
            make.top.equalTo(nameLabel)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getCapacityColor() -> UIColor {
        if percentage > 0.75 {
            return UIColor.red
        } else if percentage > 0.25 {
            return UIColor.orange
        }
        return UIColor.green
    }
    
    func configure(with facility: Facility) {
        self.facility = facility
        nameLabel.text = facility.name
        timeLabel.text = "Open until \(facility.closesAt)"
        percentage = facility.currentCapacity / facility.totalCapacity
        capacityLabel.text = "\(Int(percentage * 100))% full"
        capacityLabel.textColor = getCapacityColor()
        setupConstraints()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
