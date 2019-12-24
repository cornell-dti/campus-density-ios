//
//  PlaceCell.swift
//  Campus Density
//
//  Created by Matthew Coufal on 3/24/19.
//  Copyright © 2019 Cornell DTI. All rights reserved.
//

import UIKit

enum Density: Int, Codable {
    case veryBusy = 3
    case prettyBusy = 2
    case somewhatBusy = 1
    case notBusy = 0
}

class PlaceCell: UICollectionViewCell {

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

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .clear
        setupViews()

    }

    func setupViews() {
        background = UIView()
        background.backgroundColor = .white
        background.clipsToBounds = false
        background.layer.masksToBounds = false
        background.layer.cornerRadius = backgroundCornerRadius
        background.layer.shadowColor = UIColor(red: 0, green:0, blue: 0, alpha: 0.25).cgColor
        background.layer.shadowOpacity = 0.3
        background.layer.borderColor = UIColor.whiteTwo.cgColor
        background.layer.borderWidth = 0.5
        background.layer.shadowRadius = 2
        background.layer.shadowOffset = CGSize(width: 3, height: 3)
        contentView.addSubview(background)

        nameLabel = UILabel()
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.textColor = .grayishBrown
        nameLabel.textAlignment = .left
        nameLabel.numberOfLines = 0
        nameLabel.font = .sixteenBold
        contentView.addSubview(nameLabel)

        densityLabel = UILabel()
        densityLabel.adjustsFontSizeToFitWidth = true
        densityLabel.textAlignment = .right
        densityLabel.font = .fourteen
        contentView.addSubview(densityLabel)

        barOne = setupBar()
        contentView.addSubview(barOne)

        barTwo = setupBar()
        contentView.addSubview(barTwo)

        barThree = setupBar()
        contentView.addSubview(barThree)

        barFour = setupBar()
        contentView.addSubview(barFour)
    }

    override func prepareForReuse() {
        for subview in contentView.subviews {
            subview.snp.removeConstraints()
        }
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

        guard let densityLabelText = densityLabel.text else { return }
        let densityLabelWidth = densityLabelText.widthWithConstrainedHeight(labelHeight, font: densityLabel.font)

        background.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(padding)
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

        densityLabel.snp.makeConstraints { make in
            make.width.equalTo(densityLabelWidth)
            make.right.equalTo(background).inset(padding)
            make.top.equalTo(background)
            make.bottom.equalTo(barOne.snp.top)
        }

        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(barOne)
            make.bottom.equalTo(barOne.snp.top)
            make.right.equalTo(densityLabel.snp.left).offset(-5)
            make.top.equalTo(background)
        }
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
            case .prettyBusy:
                barOne.backgroundColor = .peach
                barTwo.backgroundColor = barOne.backgroundColor
                barThree.backgroundColor = barTwo.backgroundColor
                barFour.backgroundColor = .whiteTwo
            case .notBusy:
                barOne.backgroundColor = .lightTeal
                barTwo.backgroundColor = .whiteTwo
                barThree.backgroundColor = barTwo.backgroundColor
                barFour.backgroundColor = barThree.backgroundColor
            case .somewhatBusy:
                barOne.backgroundColor = .wheat
                barTwo.backgroundColor = barOne.backgroundColor
                barThree.backgroundColor = .whiteTwo
                barFour.backgroundColor = barThree.backgroundColor
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with place: Place) {
        self.place = place
        nameLabel.text = place.displayName
        densityLabel.text = place.isClosed ? "Closed" : interpretDensity()
        densityLabel.textColor = place.isClosed ? .orangeyRed : .densityDarkGray
        colorBars()
        setupConstraints()
    }

}

extension UILabel {
    func calculateMaxLines() -> Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }
}
