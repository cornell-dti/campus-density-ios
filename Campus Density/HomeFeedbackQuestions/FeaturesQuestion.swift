//
//  FeaturesQuestion.swift
//  Campus Density
//
//  Created by Mihikaa Goenka on 07/03/21.
//  Copyright © 2021 Cornell DTI. All rights reserved.
//

import UIKit

protocol FeaturesQuestionDelegate: class {
    func featuresWasChanged(features: [Int])
}

class FeaturesQuestion: HomeFeedbackQuestion {
    weak var delegate: FeaturesQuestionDelegate!
    var featureLabels: [UILabel] = []
    let featureLabelTitles = ["Popular Times", "Availability Breakdown", "Dining Areas", "Menu"]
    var featureButtons: [UIButton] = []
    var featureButtonsStackView: UIStackView!
    var chosenFeatures: [Int] = [0, 0, 0, 0]

    init() {
        super.init(subtitle: "2. Which feature(s) do you find useful?")
        for number in 0...3 {
            let label = UILabel()
            label.tag = number
            label.text = featureLabelTitles[number]
            label.textColor = .grayishBrown
            label.font = UIFont(name: "Avenir", size: 16.0)
            featureLabels.append(label)
            let button = UIButton()
            button.tag = number
            button.setImage(UIImage(named: "unchecked-box"), for: .normal)
            button.addTarget(self, action: #selector(checkboxButtonPressed), for: .touchUpInside)
            button.snp.makeConstraints { make in
                make.width.height.equalTo(30)
            }
            featureButtons.append(button)
        }

        let upper: UIView = subtitle
        var padding = 10
        for (checkbox, label) in zip(featureButtons, featureLabels) {
            let checkStackView = UIStackView(arrangedSubviews: [checkbox, label])
            addSubview(checkStackView)
            checkStackView.alignment = .center
            checkStackView.spacing = 10
            checkStackView.snp.makeConstraints { make in
                make.top.equalTo(upper.snp.bottom).offset(padding)
            }
            padding += 25
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func checkboxButtonPressed(sender: UIButton) {
        if sender.image(for: .normal) == UIImage(named: "checked-box") {
            sender.setImage(UIImage(named: "unchecked-box"), for: .normal)
            chosenFeatures[sender.tag] = 0
        } else {
            sender.setImage(UIImage(named: "checked-box"), for: .normal)
            chosenFeatures[sender.tag] = 1
        }
        var features: [Int] = []
        for i in 0...3 {
            if chosenFeatures[i] == 1 && !(features.contains(i)) {
                features.append(i)
            } else if chosenFeatures[i] == 0 && (features.contains(i)) {
                features.remove(at: i)
            }
        }
        delegate?.featuresWasChanged(features: features)
    }
}
