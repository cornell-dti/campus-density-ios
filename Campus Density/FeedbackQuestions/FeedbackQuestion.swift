//
//  FeedbackQuestion.swift
//  Campus Density
//
//  Created by Changyuan Lin on 12/5/20.
//  Copyright © 2020 Cornell DTI. All rights reserved.
//

import UIKit

/// A blank feedback question
class FeedbackQuestion: UIView {
    var title = UILabel()
    var subtitle = UILabel()

    /// Initialize a blank feedback question, optionally with custom title/subtitle
    /// - Parameters:
    ///   - title: Question title, default "Accuracy Feedback"
    ///   - subtitle: Question subtitle, default empty
    init(title: String = "Accuracy Feedback", subtitle: String = "") {
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
