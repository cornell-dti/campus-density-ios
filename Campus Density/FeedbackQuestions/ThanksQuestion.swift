//
//  ThanksQuestion.swift
//  Campus Density
//
//  Created by Changyuan Lin on 12/13/20.
//  Copyright © 2020 Cornell DTI. All rights reserved.
//

import UIKit

class ThanksQuestion: FeedbackQuestion {
    let thanksImageView = UIImageView(image: UIImage(named: "thanks"))
    let thanksLabel = UILabel()

    init() {
        super.init(title: "Thank You!")
        backgroundColor = .white
        addSubview(thanksImageView)
        thanksImageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        thanksLabel.text = "This helps us fix any discrepancies and create a better experience for you."
        thanksLabel.numberOfLines = 0
        thanksLabel.textAlignment = .center
        addSubview(thanksLabel)
        thanksLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(thanksImageView.snp.bottom).offset(20)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
