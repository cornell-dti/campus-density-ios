//
//  HomeFeedbackViewController.swift
//  Campus Density
//
//  Created by Mihikaa Goenka on 05/12/20.
//  Copyright © 2020 Cornell DTI. All rights reserved.
//

import UIKit

class HomeFeedbackViewController: UIViewController {

//    var parentHide: (() -> Void)?
//    var background: UIView!
//    var hideButton: UIButton!
    var recLabel: UILabel!
    let recLabelText = "1. How willing are you to recommend Flux to your friends? (1-10)"
    var button1: UIButton!
    var button2: UIButton!
    var button3: UIButton!
    var button4: UIButton!
    var button5: UIButton!
    var recButtons: [UIButton]!
    var featureLabel: UILabel!
    var featureLabelText = "3. How do you like Flux overall?"
    var barOne: UIView!
    var barTwo: UIView!
    var barThree: UIView!
    var barFour: UIView!

    //Constants
    let padding: CGFloat = 15
    let interBarSpacing: CGFloat = 5
    let innerPadding: CGFloat = 50
    let labelHeight: CGFloat = 20
    let densityBarHeight: CGFloat = 25

    override func viewDidLoad() {
        view.backgroundColor = .white
        title = "Feedback"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = .warmGray

        recLabel = UILabel()
        recLabel.text = recLabelText
        recLabel.textColor = .grayishBrown
        recLabel.font = .sixteenBold
        recLabel.numberOfLines = 2
        recLabel.translatesAutoresizingMaskIntoConstraints = false
        recLabel.textAlignment = .left
        view.addSubview(recLabel)

        addButtons()

        featureLabel = UILabel()
        featureLabel.text = featureLabelText
        featureLabel.textColor = .grayishBrown
        featureLabel.font = .sixteenBold
        featureLabel.numberOfLines = 1
        featureLabel.translatesAutoresizingMaskIntoConstraints = false
        featureLabel.textAlignment = .left
        view.addSubview(featureLabel)

        barOne = setupBar()
        view.addSubview(barOne)

        barTwo = setupBar()
        view.addSubview(barTwo)

        barThree = setupBar()
        view.addSubview(barThree)

        barFour = setupBar()
        view.addSubview(barFour)

        setupConstraints()
    }

    func addButtons() {
        button1 = UIButton()
        button1.translatesAutoresizingMaskIntoConstraints = false
        button1.backgroundColor = .white
        button1.layer.cornerRadius = 10
        button1.layer.borderWidth = 2
        button1.setTitle("1", for: .normal)
        button1.setTitleColor(.densityDarkGray, for: .normal)
        button1.titleLabel?.font =  UIFont(name: "Avenir", size: 14)
        button1.layer.borderColor = UIColor.densityDarkGray.cgColor
        button1.addTarget(self, action: #selector(radioButtonPressed), for: .touchUpInside)
        view.addSubview(button1)
    }

    func setupBar() -> UIView {
        let view = UIView()
        view.backgroundColor = .densityRed
        view.clipsToBounds = true
        view.layer.cornerRadius = densityBarHeight / 2.0
        return view
    }

    func setupConstraints() {
        let labelTextHeight = recLabelText.height(withConstrainedWidth: view.frame.width - Constants.smallPadding, font: recLabel.font)
        let totalBarWidth: CGFloat = view.frame.width - padding * 4 - interBarSpacing * 3
        let barWidth: CGFloat = totalBarWidth / 4.0

        recLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(100)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(labelTextHeight)
        }

        button1.snp.makeConstraints { make in
            make.left.equalTo(recLabel.snp.left)
            make.top.equalTo(recLabel.snp.bottom).offset(10)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }

        featureLabel.snp.makeConstraints { make in
            make.left.equalTo(recLabel.snp.left)
            make.top.equalTo(button1.snp.bottom).offset(30)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(labelTextHeight)
        }

        barOne.snp.makeConstraints { make in
            make.left.equalTo(recLabel.snp.left)
            make.width.equalTo(barWidth)
            make.top.equalTo(featureLabel.snp.bottom).offset(10)
            make.height.equalTo(densityBarHeight)
        }

        barTwo.snp.makeConstraints { make in
            make.left.equalTo(barOne.snp.right).offset(interBarSpacing)
            make.width.equalTo(barWidth)
            make.bottom.equalTo(barOne)
            make.height.equalTo(barOne)
        }

        barThree.snp.makeConstraints { make in
            make.left.equalTo(barTwo.snp.right).offset(interBarSpacing)
            make.width.equalTo(barWidth)
            make.bottom.equalTo(barOne)
            make.height.equalTo(barOne)
        }

        barFour.snp.makeConstraints { make in
            make.left.equalTo(barThree.snp.right).offset(interBarSpacing)
            make.width.equalTo(barWidth)
            make.bottom.equalTo(barOne)
            make.height.equalTo(barOne)
        }
    }

    @objc func radioButtonPressed() {
        if button1.titleColor(for: .normal) == .white {
            button1.backgroundColor = .white
            button1.layer.borderColor = UIColor.densityDarkGray.cgColor
            button1.setTitleColor(.densityDarkGray, for: .normal)
        } else {
            button1.backgroundColor = .densityGreen
            button1.layer.borderColor = UIColor.densityGreen.cgColor
            button1.setTitleColor(.white, for: .normal)
        }
    }
}
