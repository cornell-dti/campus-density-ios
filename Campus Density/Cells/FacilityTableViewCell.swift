//
//  FacilityTableViewCell.swift
//  Campus Density
//
//  Created by Matthew Coufal on 10/14/18.
//  Copyright © 2018 Cornell DTI. All rights reserved.
//

import UIKit

public enum Density {
    case noSpots
    case fewSpots
    case someSpots
    case manySpots
}

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
    var barOne: UIView!
    var barTwo: UIView!
    var barThree: UIView!
    var barFour: UIView!
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
        background.layer.shadowColor = UIColor.whiteTwo.cgColor
        background.layer.shadowRadius = 5.0
        background.layer.shadowOffset = CGSize(width: 0, height: 2)
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
        
        barOne = setupBar()
        addSubview(barOne)
        
        barTwo = setupBar()
        addSubview(barTwo)
        
        barThree = setupBar()
        addSubview(barThree)
        
        barFour = setupBar()
        addSubview(barFour)
    }
    
    func setupBar() -> UIView {
        let view = UIView()
        view.backgroundColor = .densityRed
        view.clipsToBounds = true
        view.layer.cornerRadius = densityBarHeight / 2.0
        return view
    }
    
    @objc func toggleFavorite() {
        print("toggle favorite")
    }
    
    func setupConstraints() {
        
        let totalBarWidth: CGFloat = frame.width - padding * 2 - 45
        
        let barWidth: CGFloat = totalBarWidth / 4.0
        
        background.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(padding)
            make.width.equalToSuperview().offset(-padding * 2)
            make.height.equalToSuperview().offset(-padding)
        }
        
        barOne.snp.makeConstraints { make in
            make.left.equalTo(background).offset(padding)
            make.width.equalTo(barWidth)
            make.bottom.equalTo(background).offset(-padding)
            make.height.equalTo(densityBarHeight)
        }
        
        barTwo.snp.makeConstraints { make in
            make.left.equalTo(barOne.snp.right).offset(5)
            make.width.equalTo(barWidth)
            make.bottom.equalTo(barOne)
            make.height.equalTo(barOne)
        }
        
        barThree.snp.makeConstraints { make in
            make.left.equalTo(barTwo.snp.right).offset(5)
            make.width.equalTo(barWidth)
            make.bottom.equalTo(barOne)
            make.height.equalTo(barOne)
        }
        
        barFour.snp.makeConstraints { make in
            make.left.equalTo(barThree.snp.right).offset(5)
            make.width.equalTo(barWidth)
            make.bottom.equalTo(barOne)
            make.height.equalTo(barOne)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(barOne)
            make.bottom.equalTo(barOne.snp.top).offset(-padding)
            make.width.equalTo(background).offset(-padding * 2).multipliedBy(0.55)
            make.height.equalTo(labelHeight)
        }
        
        densityLabel.snp.makeConstraints { make in
            make.width.equalTo(background).offset(-padding * 2).multipliedBy(0.45)
            make.height.equalTo(nameLabel)
            make.right.equalTo(background).offset(-padding)
            make.centerY.equalTo(nameLabel)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func interpretDensity() -> String {
        switch facility.density {
        case .noSpots:
            return "No spots"
        case .fewSpots:
            return "Few spots"
        case .manySpots:
            return "Many spots"
        case .someSpots:
            return "Some spots"
        }
    }
    
    func colorBars() {
        switch facility.density {
        case .noSpots:
            barOne.backgroundColor = .orangeyRed
            barTwo.backgroundColor = barOne.backgroundColor
            barThree.backgroundColor = barTwo.backgroundColor
            barFour.backgroundColor = barThree.backgroundColor
            break
        case .fewSpots:
            barOne.backgroundColor = .peach
            barTwo.backgroundColor = barOne.backgroundColor
            barThree.backgroundColor = barTwo.backgroundColor
            barFour.backgroundColor = .whiteTwo
            break
        case .manySpots:
            barOne.backgroundColor = .lightTeal
            barTwo.backgroundColor = .whiteTwo
            barThree.backgroundColor = barTwo.backgroundColor
            barFour.backgroundColor = barThree.backgroundColor
            break
        case .someSpots:
            barOne.backgroundColor = .wheat
            barTwo.backgroundColor = barOne.backgroundColor
            barThree.backgroundColor = .whiteTwo
            barFour.backgroundColor = barThree.backgroundColor
            break
        }
    }
    
    func configure(with facility: Facility) {
        self.facility = facility
        nameLabel.text = facility.name
        densityLabel.text = interpretDensity()
        setupConstraints()
        colorBars()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
