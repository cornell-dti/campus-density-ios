//
//  FacilityTableViewCell.swift
//  Campus Density
//
//  Created by Matthew Coufal on 10/14/18.
//  Copyright © 2018 Cornell DTI. All rights reserved.
//

import UIKit

protocol FacilityTableViewCellDelegate {
    func facilityTableViewCellDidTapFavoriteButton(facility: Facility)
}

class FacilityTableViewCell: UITableViewCell {
    
    // MARK: - Data vars
    var facility: Facility!
    var percentage: Double!
    
    // MARK: - View vars
    var button: UIButton!
    var nameLabel: UILabel!
    var timeLabel: UILabel!
    var capacityLabel: UILabel!
    var totalCapacityBar: UIView!
    var currentCapacityBar: UIView!
    
    // MARK: - Constants
    let buttonCornerRadius: CGFloat = 10
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
        button = UIButton()
        button.backgroundColor = .offWhite
        button.clipsToBounds = true
        button.layer.cornerRadius = buttonCornerRadius
        button.layer.masksToBounds = false
        button.layer.shadowColor = UIColor.lightGray.cgColor
        button.layer.shadowRadius = 2.5
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowOpacity = 1.0
        addSubview(button)
        
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
        totalCapacityBar.layer.cornerRadius = buttonCornerRadius
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
    }
    
    override func updateConstraints() {
        button.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(padding)
            make.width.equalToSuperview().offset(-padding * 2)
            make.height.equalToSuperview().offset(-padding)
        }
        
        totalCapacityBar.snp.makeConstraints { make in
            make.left.equalTo(button).offset(padding)
            make.width.equalTo(button).offset(-padding * 2)
            make.bottom.equalTo(button).offset(-padding)
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
            make.right.equalTo(button).offset(-padding)
            make.top.equalTo(nameLabel)
        }
        
        super.updateConstraints()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
