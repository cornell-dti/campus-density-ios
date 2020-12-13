//
//  WaitTimeQuestion.swift
//  Campus Density
//
//  Created by Changyuan Lin on 12/12/20.
//  Copyright © 2020 Cornell DTI. All rights reserved.
//

import UIKit

protocol WaitTimeQuestionDelegate: class {
    func waitTimeWasChanged(waitTime: Int)
}

class WaitTimeQuestion: FeedbackQuestion, UIPickerViewDataSource, UIPickerViewDelegate {
    weak var delegate: WaitTimeQuestionDelegate?
    let options = ["0-2", "2-4", "4-6", "6-8", "8-10", "10-12", "12-14", "14-16", "16-18", "18-20", "20+"]
    let picker = UIPickerView()

    init() {
        super.init(subtitle: "How many minutes did you wait in line?")
        backgroundColor = .white
        picker.dataSource = self
        picker.delegate = self
        addSubview(picker)
        picker.snp.makeConstraints { make in
            make.height.equalTo(120)
            make.bottom.left.right.equalToSuperview()
        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let timeBucketLowerBound = row * 2 // Buckets are two minutes each
        delegate?.waitTimeWasChanged(waitTime: timeBucketLowerBound)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
