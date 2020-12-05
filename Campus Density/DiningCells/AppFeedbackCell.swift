//
//  AppFeedbackCellCollectionViewCell.swift
//  Campus Density
//
//  Created by Mihikaa Goenka on 05/12/20.
//  Copyright © 2020 Cornell DTI. All rights reserved.
//

import UIKit

protocol AppFeedbackCellDelegate: class {

    func appFeedbackCellDidTapLink()

}

class AppFeedbackCell: UICollectionViewCell {

    // MARK: - Data vars
    var appFeedbackModel: AppFeedbackModel!
    weak var delegate: AppFeedbackCellDelegate?

    // MARK: - Views
    var linkButton: UIButton!

    // MARK: - Constants
    let surveyButtonText =  "Like Flux? Give us feedback."

    override init(frame: CGRect) {
        super.init(frame: frame)

        linkButton = UIButton()
        linkButton.addTarget(self, action: #selector(linkButtonPressed), for: .touchUpInside)
        linkButton.setTitle(surveyButtonText, for: .normal)
        linkButton.setTitleColor(.black, for: .normal)
        linkButton.titleLabel?.textAlignment = .center
        linkButton.setAttributedTitle(self.attributedString(), for: .normal)
        addSubview(linkButton)

        setupConstraints()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func attributedString() -> NSAttributedString? {
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0),
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        let attributedString = NSAttributedString(string: self.surveyButtonText, attributes: attributes)
        return attributedString
    }

    @objc func linkButtonPressed() {
        delegate?.appFeedbackCellDidTapLink()
    }

    func setupConstraints() {
        linkButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }

    }

    func configure(delegate: AppFeedbackCellDelegate) {
        self.delegate = delegate
        setupConstraints()
    }

}

extension UILabel {
    func underlineMyText(range1: String, range2: String) {
        if let textString = self.text {

            let str = NSString(string: textString)
            let firstRange = str.range(of: range1)
            let secRange = str.range(of: range2)
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: firstRange)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: secRange)
            attributedText = attributedString
        }
    }
}
