//
//  ThankYouQuestion.swift
//  Campus Density
//
//  Created by Mihikaa Goenka on 07/03/21.
//  Copyright © 2021 Cornell DTI. All rights reserved.
//

import UIKit

class ThankYouQuestion: HomeFeedbackQuestion {
    let thankYouLabel = UILabel()
    let thanksLabel = UILabel()

    init() {
        super.init(title: "")
        thankYouLabel.text = "Thank You!"
        thankYouLabel.numberOfLines = 0
        thankYouLabel.font = .twentyBold
        thankYouLabel.textColor = .black
        thankYouLabel.textAlignment = .center
        addSubview(thankYouLabel)
        thankYouLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.centerY.equalToSuperview().offset(-20)
        }
        thanksLabel.text = "Your feedback would help us improve."
        thanksLabel.numberOfLines = 0
        thanksLabel.font = .fourteen
        thanksLabel.textColor = .warmGray
        thanksLabel.textAlignment = .center
        addSubview(thanksLabel)
        thanksLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(thankYouLabel.snp.bottom).offset(20)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
