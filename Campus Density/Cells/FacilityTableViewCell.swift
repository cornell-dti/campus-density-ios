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
    var densityLabel: UILabel!
    var capacityLabel: UILabel!
    var totalDensityBar: UIView!
    var currentDensityBar: UIView!
    var heartButton: UIButton!
    
    // MARK: - Constants
    let backgroundCornerRadius: CGFloat = 10
    let densityBarCornerRadius: CGFloat = 5
    let padding: CGFloat = 50.0 / 3.0
    let labelHeight: CGFloat = 20
    let densityBarHeight: CGFloat = 30
    let heartButtonLength: CGFloat = 25
    let capacityLabelWidth: CGFloat = 92.5

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        setupViews()
        
    }
    
    func setupViews() {
        background = UIView()
        background.backgroundColor = .white
        background.clipsToBounds = true
        background.layer.cornerRadius = backgroundCornerRadius
        background.layer.masksToBounds = false
        background.layer.shadowColor = UIColor.densityDarkGray.cgColor
        background.layer.shadowRadius = 2.5
        background.layer.shadowOffset = CGSize(width: 0, height: 1)
        background.layer.shadowOpacity = 1.0
        addSubview(background)
        
        nameLabel = UILabel()
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.textColor = .darkGray
        nameLabel.textAlignment = .left
        nameLabel.numberOfLines = 0
        nameLabel.font = .eighteenBold
        addSubview(nameLabel)
        
        densityLabel = UILabel()
        densityLabel.adjustsFontSizeToFitWidth = true
        densityLabel.textColor = .densityDarkGray
        densityLabel.textAlignment = .right
        densityLabel.font = .fourteen
        addSubview(densityLabel)
        
        heartButton = UIButton()
        heartButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        heartButton.imageView?.tintColor = .densityDarkGray
        heartButton.contentMode = .scaleToFill
        addSubview(heartButton)
        
        totalDensityBar = UIView()
        totalDensityBar.backgroundColor = .white
        totalDensityBar.clipsToBounds = true
        totalDensityBar.layer.cornerRadius = densityBarHeight / 2.0
        totalDensityBar.layer.masksToBounds = false
        totalDensityBar.layer.shadowColor = UIColor.lightGray.cgColor
        totalDensityBar.layer.shadowRadius = 1.5
        totalDensityBar.layer.shadowOffset = CGSize(width: 0, height: 1)
        totalDensityBar.layer.shadowOpacity = 1.0
        addSubview(totalDensityBar)
        
        currentDensityBar = UIView()
        currentDensityBar.backgroundColor = .densityRed
        currentDensityBar.clipsToBounds = true
        currentDensityBar.layer.cornerRadius = totalDensityBar.layer.cornerRadius
        addSubview(currentDensityBar)
    }
    
    @objc func toggleFavorite() {
        print("toggle favorite")
    }
    
    func setupConstraints() {
        background.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(padding)
            make.width.equalToSuperview().offset(-padding * 2)
            make.height.equalToSuperview().offset(-padding)
        }
        
        totalDensityBar.snp.makeConstraints { make in
            make.left.equalTo(background).offset(padding)
            make.width.equalTo(background).offset(-padding * 2)
            make.bottom.equalTo(background).offset(-padding)
            make.height.equalTo(densityBarHeight)
        }
        
        currentDensityBar.snp.makeConstraints { make in
            make.left.equalTo(totalDensityBar)
            make.height.equalTo(totalDensityBar)
            make.width.equalTo(totalDensityBar).multipliedBy(percentage)
            make.centerY.equalTo(totalDensityBar)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(totalDensityBar)
            make.bottom.equalTo(totalDensityBar.snp.top).offset(-padding)
            make.width.equalTo(totalDensityBar).offset(-padding).multipliedBy(0.55)
            make.height.equalTo(labelHeight)
        }
        
        densityLabel.snp.makeConstraints { make in
            make.width.equalTo(totalDensityBar).offset(-padding).multipliedBy(0.45)
            make.height.equalTo(nameLabel)
            make.right.equalTo(background).offset(-padding)
            make.centerY.equalTo(nameLabel)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func interpretDensity() -> String {
        if percentage > 0.75 {
            return "As crowded as it gets"
        } else if percentage > 0.25 {
            return "Pretty crowded"
        }
        return "Not crowded"
    }
    
    func configure(with facility: Facility) {
        self.facility = facility
        nameLabel.text = facility.name
        percentage = facility.currentCapacity / facility.totalCapacity
        densityLabel.text = interpretDensity()
        setupConstraints()
        if facility.isFavorite {
            heartButton.setImage(UIImage(named: "favorite")?.withRenderingMode(.alwaysTemplate), for: .normal)
            heartButton.imageView?.tintColor = .densityBlue
        } else {
            heartButton.setImage(UIImage(named: "favoriteunfilled")?.withRenderingMode(.alwaysTemplate), for: .normal)
            heartButton.imageView?.tintColor = .densityDarkGray
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
