//
//  RecommendQuestion.swift
//  Campus Density
//
//  Created by Mihikaa Goenka on 07/03/21.
//  Copyright © 2021 Cornell DTI. All rights reserved.
//

import UIKit

protocol RecommendationQuestionDelegate: class {
    func recValueWasChanged(rec: Int)
}

class RecommendQuestion: HomeFeedbackQuestion {
    weak var delegate: RecommendationQuestionDelegate?
    var recButtons: [UIButton] = []
    var recButtonsStackView: UIStackView!
    let radioButtonTitles = ["1", "2", "3", "4", "5"]
    let radioButtonColors: [UIColor] = [.densityRed, .densityRed, .wheat, .peach, .densityGreen]

    init() {
        super.init(subtitle: "1. How willing are you to recommend Flux to your friends? (1-5)")

        for rating in 0...4 {
            let button = UIButton()
            button.setTitle(radioButtonTitles[rating], for: .normal)
            button.backgroundColor = .white
            button.tag = rating
            button.layer.cornerRadius = 10
            button.layer.borderWidth = 2
            button.setTitleColor(.densityDarkGray, for: .normal)
            button.titleLabel?.font =  UIFont(name: "Avenir", size: 14)
            button.layer.borderColor = UIColor.densityDarkGray.cgColor
            button.addTarget(self, action: #selector(radioButtonPressed), for: .touchUpInside)
            button.snp.makeConstraints { make in
                make.height.width.equalTo(20)
            }
            recButtons.append(button)
        }
        let upper: UIView = subtitle
        recButtonsStackView = UIStackView(arrangedSubviews: recButtons)
        recButtonsStackView.alignment = .center
        recButtonsStackView.distribution = .fillEqually
        recButtonsStackView.spacing = 12
        addSubview(recButtonsStackView)
        recButtonsStackView.snp.makeConstraints { make in
            make.top.equalTo(upper.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func radioButtonPressed(sender: UIButton) {
        let rating = sender.tag
        let recColor = radioButtonColors[rating]
        for i in 0...4 {
            if i <= rating {
                recButtons[i].backgroundColor = recColor
                recButtons[i].setTitleColor(.white, for: .normal)
                recButtons[i].layer.borderColor = recColor.cgColor
            } else {
                recButtons[i].backgroundColor = .white
                recButtons[i].setTitleColor(.densityDarkGray, for: .normal)
                recButtons[i].layer.borderColor = UIColor.densityDarkGray.cgColor
            }
        }
        delegate?.recValueWasChanged(rec: rating)
    }
}
