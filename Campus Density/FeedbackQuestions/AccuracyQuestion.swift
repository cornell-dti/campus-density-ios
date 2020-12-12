//
//  AccuracyQuestion.swift
//  Campus Density
//
//  Created by Changyuan Lin on 12/12/20.
//  Copyright © 2020 Cornell DTI. All rights reserved.
//

import UIKit

protocol AccuracyQuestionDelegate: class {
    func accuracyWasChanged(isAccurate: Bool)
}

class AccuracyQuestion: FeedbackQuestion {
    weak var delegate: AccuracyQuestionDelegate?
    let yesLabel = UILabel()
    let noLabel = UILabel()
    let yesButton = UIButton()
    let noButton = UIButton()

    init() {
        super.init(subtitle: "Is this information accurate?")
        backgroundColor = .green
        yesLabel.text = "Yes"
        noLabel.text = "No"
        yesButton.addHandler(for: .primaryActionTriggered, action: yesButtonPressed)
        noButton.addHandler(for: .primaryActionTriggered, action: noButtonPressed)
        for button in [yesButton, noButton] {
            button.layer.borderColor = UIColor.black.cgColor
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 5
            button.snp.makeConstraints { make in
                make.height.width.equalTo(10)
            }
        }
        var upper: UIView = subtitle
        for row in [UIStackView(arrangedSubviews: [yesButton, yesLabel]), UIStackView(arrangedSubviews: [noButton, noLabel])] {
            self.addSubview(row)
            row.alignment = .center
            row.spacing = 10
            row.snp.makeConstraints { make in
                make.left.right.equalToSuperview().inset(30)
                make.height.equalTo(20)
                make.top.equalTo(upper.snp_bottomMargin).offset(5)
            }
            upper = row
        }
    }

    func yesButtonPressed() {
        yesButton.backgroundColor = .black
        noButton.backgroundColor = .clear
        delegate?.accuracyWasChanged(isAccurate: true)
    }

    func noButtonPressed() {
        yesButton.backgroundColor = .clear
        noButton.backgroundColor = .black
        delegate?.accuracyWasChanged(isAccurate: false)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
