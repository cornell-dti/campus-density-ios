//
//  ReviewQuestion.swift
//  Campus Density
//
//  Created by Mihikaa Goenka on 07/03/21.
//  Copyright © 2021 Cornell DTI. All rights reserved.
//

import UIKit

protocol ReviewQuestionDelegate: class {
    func reviewWasChanged(review: Int)
}

class ReviewQuestion: HomeFeedbackQuestion {
    weak var delegate: ReviewQuestionDelegate?
    let colors: [UIColor] = [.orangeyRed, .wheat, .peach, .lightTeal] // From CurrentDensityCell
    let noLikeLabel = UILabel()
    let likeLabel = UILabel()
    var colorPills: [UIButton] = []
    var radioButtons: [UIButton] = []

    init() {
        super.init(subtitle: "3. How do you like Flux overall?")
        for review in 0...3 {
            let colorPill = UIButton()
            let radioButton = UIButton()
            colorPill.backgroundColor = .whiteTwo
            colorPill.tag = review
            colorPill.layer.cornerRadius = 5
            radioButton.layer.cornerRadius = 5
            radioButton.layer.borderWidth = 1
            radioButton.tag = review
            radioButton.layer.borderColor = UIColor.warmGray.cgColor
            colorPill.addTarget(self, action: #selector(pillButtonPressed), for: .touchUpInside)
            radioButton.addTarget(self, action: #selector(pillButtonPressed), for: .touchUpInside)
            colorPills.append(colorPill)
            radioButtons.append(radioButton)
        }

        let colorPillsStackView = UIStackView(arrangedSubviews: colorPills)
        colorPillsStackView.distribution = .fillEqually
        colorPillsStackView.spacing = 5
        addSubview(colorPillsStackView)
        colorPillsStackView.snp.makeConstraints { make in
            make.height.equalTo(15)
            make.bottom.equalToSuperview().inset(40)
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

        noLikeLabel.text = "I don't like it"
        likeLabel.text = "Very much"
        noLikeLabel.font = .fourteen
        likeLabel.font = .fourteen
        noLikeLabel.textColor = .darkGray
        likeLabel.textColor = .darkGray
        addSubview(noLikeLabel)
        addSubview(likeLabel)
        noLikeLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.bottom.equalTo(colorPillsStackView.snp.top).offset(-5)
        }
        likeLabel.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.bottom.equalTo(colorPillsStackView.snp.top).offset(-5)
        }
    }

    @objc func pillButtonPressed(sender: UIButton) {
        let review = sender.tag
        let reviewColor = colors[review]
        for i in 0...3 {
            colorPills[i].backgroundColor = i <= review ? reviewColor : .whiteTwo
            radioButtons[i].backgroundColor = i == review ? .black : .clear
        }
        delegate?.reviewWasChanged(review: review)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
