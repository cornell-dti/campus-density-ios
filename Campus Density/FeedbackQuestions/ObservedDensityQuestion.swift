//
//  ObservedDensityQuestion.swift
//  Campus Density
//
//  Created by Changyuan Lin on 12/12/20.
//  Copyright © 2020 Cornell DTI. All rights reserved.
//

import UIKit

protocol ObservedDensityQuestionDelegate: class {
    func observedDensityWasChanged(observed: Int)
}

class ObservedDensityQuestion: FeedbackQuestion {
    weak var delegate: ObservedDensityQuestionDelegate?
    let colors: [UIColor] = [.lightTeal, .wheat, .peach, .orangeyRed] // From CurrentDensityCell
    let notBusyLabel = UILabel()
    let veryBusyLabel = UILabel()
    var colorPills: [UIButton] = []
    var radioButtons: [UIButton] = []

    init() {
        super.init(subtitle: "How crowded do you think the dining hall is right now?")
        for density in 0...3 {
            let colorPill = UIButton()
            let radioButton = UIButton()
            colorPill.backgroundColor = .whiteTwo
            colorPill.layer.cornerRadius = 5
            radioButton.layer.cornerRadius = 5
            radioButton.layer.borderWidth = 1
            radioButton.layer.borderColor = UIColor.warmGray.cgColor
            colorPill.addHandler(for: .primaryActionTriggered) {
                self.changeObservedDensity(density: density)
            }
            radioButton.addHandler(for: .primaryActionTriggered) {
                self.changeObservedDensity(density: density)
            }
            colorPills.append(colorPill)
            radioButtons.append(radioButton)
        }

        let colorPillsStackView = UIStackView(arrangedSubviews: colorPills)
        colorPillsStackView.distribution = .fillEqually
        colorPillsStackView.spacing = 5
        addSubview(colorPillsStackView)
        colorPillsStackView.snp.makeConstraints { make in
            make.height.equalTo(15)
            make.bottom.equalToSuperview().inset(30)
            make.left.right.equalToSuperview()
        }
        for i in 0...3 {  // Feel free to make this better with a stack view like above
            let radioButton = radioButtons[i]
            let colorPill = colorPills[i]
            addSubview(radioButton)
            radioButton.snp.makeConstraints { make in
                make.height.width.equalTo(10)
                make.top.equalTo(colorPill.snp.bottom).offset(10)
                make.centerX.equalTo(colorPill)
            }
        }

        notBusyLabel.text = "Not busy"
        veryBusyLabel.text = "Very busy"
        notBusyLabel.font = .fourteen
        veryBusyLabel.font = .fourteen
        notBusyLabel.textColor = .darkGray
        veryBusyLabel.textColor = .darkGray
        addSubview(notBusyLabel)
        addSubview(veryBusyLabel)
        notBusyLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.bottom.equalTo(colorPillsStackView.snp.top).offset(-5)
        }
        veryBusyLabel.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.bottom.equalTo(colorPillsStackView.snp.top).offset(-5)
        }
    }

    func changeObservedDensity(density: Int) {
        let densityColor = colors[density]
        for i in 0...3 {
            colorPills[i].backgroundColor = i <= density ? densityColor : .whiteTwo
            radioButtons[i].backgroundColor = i == density ? .black : .clear
        }
        delegate?.observedDensityWasChanged(observed: density)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
