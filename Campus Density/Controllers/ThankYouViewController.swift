//
//  ThankYouViewController.swift
//  Campus Density
//
//  Created by Mihikaa Goenka on 11/12/20.
//  Copyright © 2020 Cornell DTI. All rights reserved.
//

import UIKit

class ThankYouViewController: UIViewController, UIScrollViewDelegate {

    var thanksLabel: UILabel!
    var subtextLabel: UILabel!
    var backToHomeButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = ""
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = .warmGray

        thanksLabel = UILabel()
        thanksLabel.translatesAutoresizingMaskIntoConstraints = false
        thanksLabel.text = "Thank You!"
        thanksLabel.textAlignment = .center
        thanksLabel.textColor = .grayishBrown
        thanksLabel.font = UIFont(name: "Avenir-Heavy", size: 32)
        view.addSubview(thanksLabel)

        subtextLabel = UILabel()
        subtextLabel.translatesAutoresizingMaskIntoConstraints = false
        subtextLabel.text = "Your feedback would\nhelp us improve."
        subtextLabel.numberOfLines = 2
        subtextLabel.textAlignment = .center
        subtextLabel.textColor = .grayishBrown
        subtextLabel.font = UIFont(name: "Avenir-Medium", size: 14)
        view.addSubview(subtextLabel)

        backToHomeButton = UIButton()
        backToHomeButton.translatesAutoresizingMaskIntoConstraints = false
        backToHomeButton.setTitle("Back to Home", for: .normal)
        backToHomeButton.backgroundColor = .densityGreen
        backToHomeButton.setTitleColor(UIColor.white, for: .normal)
        backToHomeButton.titleLabel?.font =  UIFont(name: "Avenir-Heavy", size: 20)
        backToHomeButton.layer.cornerRadius = 7
        backToHomeButton.addTarget(self, action: #selector(backToHomeButtonPressed), for: .touchUpInside)
        view.addSubview(backToHomeButton)

        // Do any additional setup after loading the view.
        setupConstraints()
    }

    func setupConstraints() {
        subtextLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(100)
        }

        thanksLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(subtextLabel.snp.top).inset(20)
            make.height.equalTo(30)
        }

        backToHomeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(subtextLabel.snp.bottom).offset(30)
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
    }

    @objc func backToHomeButtonPressed() {
        let homeViewController = PlacesViewController()
        navigationController?.pushViewController(homeViewController, animated: true)
    }

}
