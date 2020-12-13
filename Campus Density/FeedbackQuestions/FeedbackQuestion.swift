//
//  FeedbackQuestion.swift
//  Campus Density
//
//  Created by Changyuan Lin on 12/5/20.
//  Copyright © 2020 Cornell DTI. All rights reserved.
//

import UIKit

class FeedbackQuestion: UIView {
    var title = UILabel()
    var subtitle = UILabel()

    init(title: String = "Accuracy Feedback", subtitle: String = "") {
        super.init(frame: .zero)
        // TODO this will be styled eventually
        self.title.text = title
        self.title.textAlignment = .center
        self.subtitle.text = subtitle
        self.subtitle.textAlignment = .center
        self.subtitle.numberOfLines = 0
        addSubview(self.title)
        addSubview(self.subtitle)
        self.title.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        self.subtitle.snp.makeConstraints { make in
            make.top.equalTo(self.title.snp_bottomMargin).offset(5)
            make.left.right.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
