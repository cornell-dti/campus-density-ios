//
//  CommentQuestion.swift
//  Campus Density
//
//  Created by Changyuan Lin on 12/13/20.
//  Copyright © 2020 Cornell DTI. All rights reserved.
//

import UIKit

protocol CommentQuestionDelegate: class {
    func commentWasChanged(comment: String)
    func commentDidBeginEditing()
    func commentDidEndEditing()
}

class CommentQuestion: FeedbackQuestion, UITextViewDelegate {
    weak var delegate: CommentQuestionDelegate?
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
        delegate?.commentDidBeginEditing()
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.commentDidEndEditing()
    }

    func textViewDidChange(_ textView: UITextView) {
        delegate?.commentWasChanged(comment: textView.text)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
