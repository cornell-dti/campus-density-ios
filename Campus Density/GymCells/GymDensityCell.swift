//
//  GymDensityCell.swift
//  Campus Density
//
//  Created by Ansh Godha on 12/02/20.
//  Copyright © 2020 Cornell DTI. All rights reserved.
//

import UIKit

class GymDensityCell: UICollectionViewCell {

    var cardioView: UIView!
    var weightView: UIView!
    var cardioLabel: UILabel!
    var weightLabel: UILabel!
    var boxDimensions: CGFloat!
    let padding: CGFloat = 20

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        setUpConstraints()
    }

    func setUpViews() {
        cardioView = UIView()
        cardioView.clipsToBounds = true
        cardioView.layer.borderWidth = 1.0
        cardioView.layer.cornerRadius = 20
        cardioView.layer.borderColor = UIColor.densityDarkGray.cgColor
        addSubview(cardioView)

        weightView = UIView()
        weightView.clipsToBounds = true
        weightView.layer.borderWidth = 1.0
        weightView.layer.cornerRadius = 20
        weightView.layer.borderColor = UIColor.densityDarkGray.cgColor
        addSubview(weightView)

        cardioLabel = makeLabel(withText: "Cardio")
        cardioView.addSubview(cardioLabel)

        weightLabel = makeLabel(withText: "Weights")
        weightView.addSubview(weightLabel)
    }

    func makeLabel(withText text: String) -> UILabel {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .grayishBrown
        label.textAlignment = .center
        label.font = .sixteenBold
        label.text = text
        return label
    }

    func setUpConstraints() {

        self.boxDimensions = (frame.width - 3 * padding)/2

        cardioView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(padding)
            //TODO: Change constraints
            make.height.equalTo(boxDimensions)
            make.width.equalTo(boxDimensions)
            make.left.equalToSuperview().offset(padding)
        }

        weightView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(padding)
            make.height.equalTo(boxDimensions)
            make.width.equalTo(boxDimensions)
            make.right.equalToSuperview().inset(padding)
        }

        cardioLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().inset(10)
        }

        weightLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().inset(10)
        }
    }

    func configure() {
        setUpConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
