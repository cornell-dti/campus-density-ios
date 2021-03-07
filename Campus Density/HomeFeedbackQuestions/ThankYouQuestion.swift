//
//  ThankYouQuestion.swift
//  Campus Density
//
//  Created by Mihikaa Goenka on 07/03/21.
//  Copyright © 2021 Cornell DTI. All rights reserved.
//

import UIKit

class ThankYouQuestion: HomeFeedbackQuestion {
    let thanksImageView = UIImageView(image: UIImage(named: "thanks"))
    let thanksLabel = UILabel()

    init() {
        super.init(title: "Thank You!")
        addSubview(thanksImageView)
        thanksImageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        thanksLabel.text = "This helps us fix any discrepancies and create a better experience for you."
        thanksLabel.numberOfLines = 0
        thanksLabel.font = .fourteen
        thanksLabel.textColor = .warmGray
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
