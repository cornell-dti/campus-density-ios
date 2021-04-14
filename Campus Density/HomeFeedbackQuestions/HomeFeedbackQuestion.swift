//
//  HomeFeedbackQuestion.swift
//  Campus Density
//
//  Created by Mihikaa Goenka on 14/04/21.
//  Copyright © 2021 Cornell DTI. All rights reserved.
//

import UIKit

class HomeFeedbackQuestion: UIView {
    var title = UILabel()
    var subtitle = UILabel()

    init(title: String = "Flux Feedback", subtitle: String = "") {
        super.init(frame: .zero)
        self.title.text = title
        self.title.textAlignment = .center
        self.title.font = .eighteenBold
        self.subtitle.text = subtitle
        self.subtitle.textAlignment = .center
        self.subtitle.font = .fourteen
        self.subtitle.textColor = .warmGray
        self.subtitle.numberOfLines = 0
        addSubview(self.title)
        addSubview(self.subtitle)
        self.title.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        self.subtitle.snp.makeConstraints { make in
            make.top.equalTo(self.title.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
