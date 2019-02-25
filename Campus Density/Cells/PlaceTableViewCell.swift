//
//  FacilityTableViewCell.swift
//  Campus Density
//
//  Created by Matthew Coufal on 10/14/18.
//  Copyright © 2018 Cornell DTI. All rights reserved.
//

import UIKit

public enum Density: Int, Codable {
    case veryBusy = 3
    case prettyBusy = 2
    case somewhatBusy = 1
    case notBusy = 0
}

class PlaceTableViewCell: UITableViewCell {
    
    // MARK: - Data vars
    var place: Place!
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
    
    // MARK: - Constants
    let backgroundCornerRadius: CGFloat = 10
    let densityBarCornerRadius: CGFloat = 5
    let padding: CGFloat = 15
    let interBarSpacing: CGFloat = 5
    let innerPadding: CGFloat = 50
    let labelHeight: CGFloat = 20
    let densityBarHeight: CGFloat = 25
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
        background.layer.borderColor = UIColor.whiteTwo.cgColor
        background.layer.borderWidth = 1
        addSubview(background)
        
        nameLabel = UILabel()
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.textColor = .grayishBrown
        nameLabel.textAlignment = .left
        nameLabel.numberOfLines = 0
        nameLabel.font = .sixteenBold
        addSubview(nameLabel)
        
        densityLabel = UILabel()
        densityLabel.adjustsFontSizeToFitWidth = true
        densityLabel.textAlignment = .right
        densityLabel.font = .fourteen
        addSubview(densityLabel)
        
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
    
    func setupConstraints() {
        
        let totalBarWidth: CGFloat = frame.width - padding * 4 - interBarSpacing * 3
        
        let barWidth: CGFloat = totalBarWidth / 4.0
        
        background.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(padding)
            make.width.equalToSuperview().inset(padding)
            make.height.equalToSuperview().offset(-padding)
        }
        
        barOne.snp.makeConstraints { make in
            make.left.equalTo(background).offset(padding)
            make.width.equalTo(barWidth)
            make.bottom.equalTo(background).inset(padding)
            make.height.equalTo(densityBarHeight)
        }
        
        barTwo.snp.makeConstraints { make in
            make.left.equalTo(barOne.snp.right).offset(interBarSpacing)
            make.width.equalTo(barWidth)
            make.bottom.equalTo(barOne)
            make.height.equalTo(barOne)
        }
        
        barThree.snp.makeConstraints { make in
            make.left.equalTo(barTwo.snp.right).offset(interBarSpacing)
            make.width.equalTo(barWidth)
            make.bottom.equalTo(barOne)
            make.height.equalTo(barOne)
        }
        
        barFour.snp.makeConstraints { make in
            make.left.equalTo(barThree.snp.right).offset(interBarSpacing)
            make.width.equalTo(barWidth)
            make.bottom.equalTo(barOne)
            make.height.equalTo(barOne)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(barOne)
            make.bottom.equalTo(barOne.snp.top).offset(-padding)
            make.width.equalTo(background).inset(padding).multipliedBy(0.6)
            make.height.equalTo(labelHeight)
        }
        
        densityLabel.snp.makeConstraints { make in
            make.width.equalTo(background).inset(padding).multipliedBy(0.4)
            make.height.equalTo(nameLabel)
            make.right.equalTo(background).inset(padding)
            make.centerY.equalTo(nameLabel)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func interpretDensity() -> String {
        switch place.density {
        case .veryBusy:
            return "Very busy"
        case .prettyBusy:
            return "Pretty busy"
        case .notBusy:
            return "Not busy"
        case .somewhatBusy:
            return "Somewhat busy"
        }
    }
    
    func colorBars() {
        if place.isClosed {
            barOne.backgroundColor = .whiteTwo
            barTwo.backgroundColor = barOne.backgroundColor
            barThree.backgroundColor = barOne.backgroundColor
            barFour.backgroundColor = barOne.backgroundColor
            return
        }
        switch place.density {
        case .veryBusy:
            barOne.backgroundColor = .orangeyRed
            barTwo.backgroundColor = barOne.backgroundColor
            barThree.backgroundColor = barTwo.backgroundColor
            barFour.backgroundColor = barThree.backgroundColor
            break
        case .prettyBusy:
            barOne.backgroundColor = .peach
            barTwo.backgroundColor = barOne.backgroundColor
            barThree.backgroundColor = barTwo.backgroundColor
            barFour.backgroundColor = .whiteTwo
            break
        case .notBusy:
            barOne.backgroundColor = .lightTeal
            barTwo.backgroundColor = .whiteTwo
            barThree.backgroundColor = barTwo.backgroundColor
            barFour.backgroundColor = barThree.backgroundColor
            break
        case .somewhatBusy:
            barOne.backgroundColor = .wheat
            barTwo.backgroundColor = barOne.backgroundColor
            barThree.backgroundColor = .whiteTwo
            barFour.backgroundColor = barThree.backgroundColor
            break
        }
    }
    
    func configure(with place: Place) {
        self.place = place
        nameLabel.text = place.displayName
        densityLabel.text = place.isClosed ? "Closed" : interpretDensity()
        densityLabel.textColor = place.isClosed ? .orangeyRed : .densityDarkGray
        setupConstraints()
        colorBars()
    }

}
