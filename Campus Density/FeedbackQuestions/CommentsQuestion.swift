//
//  CommentsQuestion.swift
//  Campus Density
//
//  Created by Changyuan Lin on 12/13/20.
//  Copyright © 2020 Cornell DTI. All rights reserved.
//

import UIKit

protocol CommentsQuestionDelegate: class {
    func commentsWasChanged(comments: String)
    func commentsDidBeginEditing()
    func commentsDidEndEditing()
}

class CommentsQuestion: FeedbackQuestion, UITextViewDelegate {
    weak var delegate: CommentsQuestionDelegate?
    let textView = UITextView()

    init() {
        super.init(subtitle: "Is there anything else you would like to share?")
        textView.layer.cornerRadius = 5
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.whiteTwo.cgColor
        textView.delegate = self
        addSubview(textView)
        textView.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.bottom.left.right.equalToSuperview()
        }
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        delegate?.commentsDidBeginEditing()
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.commentsDidEndEditing()
    }

    func textViewDidChange(_ textView: UITextView) {
        delegate?.commentsWasChanged(comments: textView.text)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
