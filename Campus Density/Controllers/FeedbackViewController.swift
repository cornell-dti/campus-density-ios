//
//  FeedbackViewController.swift
//  Campus Density
//
//  Created by Changyuan Lin on 12/1/20.
//  Copyright © 2020 Cornell DTI. All rights reserved.
//

import UIKit

class FeedbackViewController: UIViewController {

    var parentHide: (() -> Void)?

    override func viewDidLoad() {
        let background = UIView()
        background.backgroundColor = .blue
        view.addSubview(background)
        background.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        let hideButton = UIButton()
        hideButton.addTarget(self, action: #selector(hide), for: .touchUpInside)
        hideButton.backgroundColor = .red
        view.addSubview(hideButton)
        hideButton.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(10)
            make.height.width.equalTo(15)
        }
    }

    @objc func hide() {
        view.isHidden = true
        parentHide?()
    }

}
