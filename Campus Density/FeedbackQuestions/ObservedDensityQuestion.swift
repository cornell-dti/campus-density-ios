//
//  ObservedDensityQuestion.swift
//  Campus Density
//
//  Created by Changyuan Lin on 12/12/20.
//  Copyright © 2020 Cornell DTI. All rights reserved.
//

import UIKit

protocol ObservedDensityQuestionDelegate: class {
}

class ObservedDensityQuestion: FeedbackQuestion {
    weak var delegate: ObservedDensityQuestionDelegate?

    init() {
        super.init(subtitle: "How crowded do you think the dining hall is right now?")
        backgroundColor = .yellow
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
