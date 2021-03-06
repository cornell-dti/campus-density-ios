//
//  OtherCommentsQuestion.swift
//  Campus Density
//
//  Created by Mihikaa Goenka on 14/04/21.
//  Copyright © 2021 Cornell DTI. All rights reserved.
//

import UIKit

protocol OtherCommentsQuestionDelegate: class {
    func otherCommentsWasChanged(comment: String)
    func commentDidBeginEditing()
    func commentDidEndEditing()
}

class OtherCommentsQuestion: HomeFeedbackQuestion, UITextViewDelegate {
    weak var delegate: OtherCommentsQuestionDelegate?
    let textView = UITextView()

    init() {
        super.init(subtitle: "4. Do you have any other suggestions?")
        textView.layer.cornerRadius = 5
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.whiteTwo.cgColor
        textView.delegate = self
        textView.text = "Please enter here! We really appreciate your feedback"
        textView.textColor = .densityDarkGray
        addSubview(textView)
        textView.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.bottom.left.right.equalToSuperview()
        }
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.densityDarkGray {
            textView.text = ""
            textView.textColor = .black
        }
        delegate?.commentDidBeginEditing()
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.commentDidEndEditing()
    }

    func textViewDidChange(_ textView: UITextView) {
        delegate?.otherCommentsWasChanged(comment: textView.text)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
