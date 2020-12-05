//
//  HomeFeedbackViewController.swift
//  Campus Density
//
//  Created by Mihikaa Goenka on 05/12/20.
//  Copyright © 2020 Cornell DTI. All rights reserved.
//

import UIKit

class HomeFeedbackViewController: UIViewController {

    var parentHide: (() -> Void)?
    var background: UIView!
    var hideButton: UIButton!

    override func viewDidLoad() {
        background = UIView()
        background.backgroundColor = .densityLightGray
        view.addSubview(background)

        hideButton = UIButton()
        hideButton.addTarget(self, action: #selector(hide), for: .touchUpInside)
        hideButton.backgroundColor = .densityDarkGray
        view.addSubview(hideButton)

        setupConstraints()
    }

    func setupConstraints() {
        background.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

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
