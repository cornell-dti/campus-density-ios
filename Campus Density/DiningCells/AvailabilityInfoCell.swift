//
//  AvailabilityInfoCell.swift
//  
//
//  Created by Ansh Godha on 13/06/20.
//

import UIKit

class AvailabilityInfoCell: UICollectionViewCell {

    var place: Place!

    // Mark :- Constants
    let padding: CGFloat = 10
    let rangeStringFontSize: CGFloat = 40
    let containerCornerRadius: CGFloat = 8
    let imageWidth: CGFloat = 40

    // MARK: - UI component declarations
    var container: UIView!
    var numberAndImageContainer: UIView!
    var rangeLabel: UILabel!
    var rangeString: NSMutableAttributedString!
    var maxLimitString: NSMutableAttributedString!
    var maxLimitLabel: UILabel!
    var personIcon: UIImageView = UIImageView(image: UIImage(named: "accessibility"))
    var maxCapacityString: NSMutableAttributedString!

    // TEMP
    let maxLimit: CGFloat = 100

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        container = UIView()
        container.backgroundColor = .whiteTwo
        container.clipsToBounds = true
        container.layer.cornerRadius = containerCornerRadius
        addSubview(container)

        numberAndImageContainer = UIView()
        container.addSubview(numberAndImageContainer)

        rangeLabel = UILabel()
        rangeLabel.textAlignment = .center
        numberAndImageContainer.addSubview(personIcon)
        numberAndImageContainer.addSubview(rangeLabel)

        maxLimitLabel = UILabel()
        container.addSubview(maxLimitLabel)

        setupContraints()
    }

    func setupContraints() {
        container.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(padding * 2.5)
            make.width.equalToSuperview().offset(-padding * 5)
            make.height.equalToSuperview()
        }

        numberAndImageContainer.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.40)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(15)
            make.width.equalTo(rangeLabel.snp.width).offset(5 + imageWidth)
        }

        rangeLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.height.equalToSuperview()
            make.top.equalToSuperview()
        }

        personIcon.snp.makeConstraints { make in
            make.left.equalTo(rangeLabel.snp.right).offset(5)
            make.top.equalTo(rangeLabel.snp.top)
            make.height.equalTo(rangeLabel.snp.height)
            make.width.equalTo(imageWidth)
        }

        maxLimitLabel.snp.makeConstraints { make in
            make.top.equalTo(numberAndImageContainer.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
    }

    func setupConsts() {

        place.isClosed = false
        place.density = .notBusy

        if place.isClosed {
            rangeString = NSMutableAttributedString(string: "Closed")
            container.backgroundColor = .densityDarkGray
        } else {
            switch place.density {
                case .veryBusy:
                    rangeString = NSMutableAttributedString(string: "> \(Int(0.85 * maxLimit))")
                    container.backgroundColor = .orangeyRed
                case .prettyBusy:
                    rangeString = NSMutableAttributedString(string: "\(Int(0.50 * maxLimit))-\(Int(0.85 * maxLimit))")
                    container.backgroundColor = .peach
                case .somewhatBusy:
                    rangeString = NSMutableAttributedString(string: "\(Int(0.26 * maxLimit))-\(Int(0.50 * maxLimit))")
                    container.backgroundColor = .wheat
                case .notBusy:
                    rangeString = NSMutableAttributedString(string: "< \(Int(0.26 * maxLimit))")
                    container.backgroundColor = .densityGreen
            }
        }

        // Replace with the place's max limit.
        maxLimitString = NSMutableAttributedString(string: "Max Limit: \(Int(maxLimit))")
        maxLimitString.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: maxLimitString.mutableString.length))
        maxLimitString.addAttribute(.font, value: UIFont.sixteen, range: NSRange(location: 0, length: maxLimitString.mutableString.length))
        maxLimitLabel.attributedText = maxLimitString

        rangeString.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: rangeString.mutableString.length))
        rangeString.addAttribute(.font, value: UIFont.thirtySixBold, range: NSRange(location: 0, length: rangeString.mutableString.length))
        rangeLabel.attributedText = rangeString
    }

    func configure(with place: Place) {
        self.place = place
        setupConsts()
    }
}
