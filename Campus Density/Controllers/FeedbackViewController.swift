//
//  FeedbackViewController.swift
//  Campus Density
//
//  Created by Changyuan Lin on 12/1/20.
//  Copyright © 2020 Cornell DTI. All rights reserved.
//

import UIKit

class FeedbackViewController: UIViewController {

    override func viewDidLoad() {
        let background = UIView()
        background.backgroundColor = .blue
        view.addSubview(background)
        background.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}
