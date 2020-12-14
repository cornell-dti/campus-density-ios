//
//  HomeFeedbackViewController.swift
//  Campus Density
//
//  Created by Mihikaa Goenka on 05/12/20.
//  Copyright © 2020 Cornell DTI. All rights reserved.
//

import UIKit

class HomeFeedbackViewController: UIViewController {

    //recommendation question variables
    var recLabel: UILabel!
    let recLabelText = "1. How willing are you to recommend Flux to your friends? (1-10)"
    var recButtons: [UIButton] = []
    var recButtonsStackView: UIStackView!
    let radioButtonTitles = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    let radioButtonColors: [UIColor] = [.densityRed, .densityRed, .densityRed, .peach, .peach, .wheat, .wheat, .wheat, .densityGreen, .densityGreen]

    //feature question variables
    var featureLabel: UILabel!
    let featureLabelText = "2. Which feature(s) do you find useful?"
    var featureLabels: [UILabel] = []
    let featureLabelTitles = ["Popular Times", "Availability Breakdown", "Dining Areas", "Menu"]
    var featureButtons: [UIButton] = []
    var featureButtonsStackView: UIStackView!

    //overall review question variables
    var reviewLabel: UILabel!
    let reviewLabelText = "3. How do you like Flux overall?"
    let pillColors: [UIColor] = [.densityRed, .orangeyRed, .wheat, .densityGreen]
    let notLikeLabel = UILabel()
    let likeLabel = UILabel()
    var pillsStackView: UIStackView!
    var pills: [UIButton] = []
    var radioButtons: [UIButton] = []

    //suggestion question variables
    var suggestionLabel: UILabel!
    let suggestionLabelText = "4. Do you have any other suggestions?"
    var suggestionBox: UITextView!
    let suggestionPlaceholderText = "Please enter here. \nWe really appreciate your feedback."

    var proceedButton: UIButton!

    //Constants
    let padding: CGFloat = 15
    let interBarSpacing: CGFloat = 5
    let densityBarHeight: CGFloat = 25

    override func viewDidLoad() {
        view.backgroundColor = .white
        title = "Feedback"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = .warmGray
        setupViews()
        setupConstraints()
    }

    func setupViews() {
        setUpQuestionOne()
        setUpQuestionTwo()
        setUpQuestionThree()
        setUpQuestionFour()

        proceedButton = UIButton()
        proceedButton.translatesAutoresizingMaskIntoConstraints = false
        proceedButton.setTitle("Proceed", for: .normal)
        proceedButton.backgroundColor = .densityGreen
        proceedButton.setTitleColor(UIColor.white, for: .normal)
        proceedButton.titleLabel?.font =  UIFont(name: "Avenir-Heavy", size: 24)
        proceedButton.layer.cornerRadius = 7
        proceedButton.addTarget(self, action: #selector(proceedButtonPressed), for: .touchUpInside)
        view.addSubview(proceedButton)
    }

    func setUpLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .grayishBrown
        label.font = .sixteenBold
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }

    func setUpQuestionOne() {
        recLabel = setUpLabel()
        recLabel.text = recLabelText
        recLabel.numberOfLines = 2
        view.addSubview(recLabel)

        for rating in 0...9 {
            let button = UIButton()
            button.setTitle(radioButtonTitles[rating], for: .normal)
            button.backgroundColor = .white
            button.tag = rating
            button.layer.cornerRadius = 10
            button.layer.borderWidth = 2
            button.setTitleColor(.densityDarkGray, for: .normal)
            button.titleLabel?.font =  UIFont(name: "Avenir", size: 14)
            button.layer.borderColor = UIColor.densityDarkGray.cgColor
            button.addTarget(self, action: #selector(radioButtonPressed), for: .touchUpInside)
            button.snp.makeConstraints { make in
                make.height.width.equalTo(22)
            }
            recButtons.append(button)
        }

        recButtonsStackView = UIStackView(arrangedSubviews: recButtons)
        recButtonsStackView.alignment = .center
        recButtonsStackView.distribution = .fillEqually
        recButtonsStackView.spacing = 12
        view.addSubview(recButtonsStackView)
    }

    @objc func radioButtonPressed(sender: UIButton) {
        let rating = sender.tag
        let recColor = radioButtonColors[rating]
        for i in 0...9 {
            if i<=rating {
                recButtons[i].backgroundColor = recColor
                recButtons[i].setTitleColor(.white, for: .normal)
                recButtons[i].layer.borderColor = recColor.cgColor
            } else {
                recButtons[i].backgroundColor = .white
                recButtons[i].setTitleColor(.densityDarkGray, for: .normal)
                recButtons[i].layer.borderColor = UIColor.densityDarkGray.cgColor
            }
        }
    }

    func setUpQuestionTwo() {
        featureLabel = setUpLabel()
        featureLabel.text = featureLabelText
        view.addSubview(featureLabel)

        for number in 0...3 {
            let label = UILabel()
            label.tag = number
            label.text = featureLabelTitles[number]
            label.textColor = .grayishBrown
            label.font = UIFont(name: "Avenir", size: 16.0)
            featureLabels.append(label)
            let button = UIButton()
            button.tag = number
            button.setImage(UIImage(named: "unchecked-box"), for: .normal)
            button.addTarget(self, action: #selector(checkboxButtonPressed), for: .touchUpInside)
            button.snp.makeConstraints { make in
                make.width.height.equalTo(30)
            }
            featureButtons.append(button)
        }

        var padding = 10
        for (checkbox, label) in zip(featureButtons, featureLabels) {
            let checkStackView = UIStackView(arrangedSubviews: [checkbox, label])
            view.addSubview(checkStackView)
            checkStackView.alignment = .center
            checkStackView.spacing = 10
            checkStackView.snp.makeConstraints { make in
                make.left.equalTo(recLabel.snp.left)
                make.top.equalTo(featureLabel.snp.bottom).offset(padding)
            }
            padding = padding + 25
        }
    }

    @objc func checkboxButtonPressed(sender: UIButton) {
        if sender.image(for: .normal) == UIImage(named: "checked-box") {
            sender.setImage(UIImage(named: "unchecked-box"), for: .normal)
        } else {
            sender.setImage(UIImage(named: "checked-box"), for: .normal)
        }
    }

    func setUpQuestionThree() {
        reviewLabel = setUpLabel()
        reviewLabel.text = reviewLabelText
        view.addSubview(reviewLabel)

        notLikeLabel.text = "I don't like it."
        likeLabel.text = "Very much"
        for label in [notLikeLabel, likeLabel] {
            label.font = .fourteen
            label.textColor = .darkGray
            view.addSubview(label)
        }

        for pillRating in 0...3 {
            let pill = UIButton()
            let radioButton = UIButton()
            pill.backgroundColor = .whiteTwo
            pill.layer.cornerRadius = densityBarHeight / 2.0
            pill.tag = pillRating
            radioButton.layer.borderWidth = 1
            radioButton.layer.borderColor = UIColor.warmGray.cgColor
            radioButton.layer.cornerRadius = 5
            radioButton.tag = pillRating
            pill.addTarget(self, action: #selector(pillButtonPressed), for: .touchUpInside)
            radioButton.addTarget(self, action: #selector(pillButtonPressed), for: .touchUpInside)
            pills.append(pill)
            radioButtons.append(radioButton)
        }
        pillsStackView = UIStackView(arrangedSubviews: pills)
        pillsStackView.distribution = .fillEqually
        pillsStackView.spacing = 5
        view.addSubview(pillsStackView)

        for i in 0...3 {
            let radioButton = radioButtons[i]
            let pill = pills[i]
            view.addSubview(radioButton)
            radioButton.snp.makeConstraints { make in
            make.height.width.equalTo(10)
            make.top.equalTo(pill.snp.bottom).offset(10)
            make.centerX.equalTo(pill)
            }
        }
    }

    @objc func pillButtonPressed(sender: UIButton) {
        let pillRating = sender.tag
        let pillColor = pillColors[pillRating]
        for i in 0...3 {
            pills[i].backgroundColor = i<=pillRating ? pillColor : .whiteTwo
            radioButtons[i].backgroundColor = i == pillRating ? .black : .clear
        }
    }

    func setUpQuestionFour() {
        suggestionLabel = setUpLabel()
        suggestionLabel.text = suggestionLabelText
        view.addSubview(suggestionLabel)

        suggestionBox = UITextView()
        suggestionBox.translatesAutoresizingMaskIntoConstraints = false
        suggestionBox.text = suggestionPlaceholderText
        suggestionBox.textColor = .densityDarkGray
        suggestionBox.textAlignment = .left
        suggestionBox.layer.cornerRadius = 3
        suggestionBox.layer.borderWidth = 1
        suggestionBox.layer.borderColor = UIColor.grayishBrown.cgColor
        suggestionBox.allowsEditingTextAttributes = true
        view.addSubview(suggestionBox)
    }

    func setupConstraints() {
        let labelTextHeight = recLabelText.height(withConstrainedWidth: view.frame.width - Constants.smallPadding, font: recLabel.font)
        let totalBarWidth: CGFloat = view.frame.width - padding * 4 - interBarSpacing * 3
        let leftPadding: CGFloat = 20
        let suggestionBoxWidth: CGFloat = view.frame.width - 2 * leftPadding

        recLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(leftPadding)
            make.top.equalToSuperview().offset(100)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(labelTextHeight)
        }

        recButtonsStackView.snp.makeConstraints { make in
            make.top.equalTo(recLabel.snp.bottom).offset(10)
            make.left.equalTo(recLabel.snp.left)
        }

        featureLabel.snp.makeConstraints { make in
            make.left.equalTo(recLabel.snp.left)
            make.top.equalTo(recButtonsStackView.snp.bottom).offset(30)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(labelTextHeight)
        }

        reviewLabel.snp.makeConstraints { make in
            make.left.equalTo(recLabel.snp.left)
            make.top.equalTo(featureLabel.snp.bottom).offset(140) //calculated
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(labelTextHeight)
        }

        notLikeLabel.snp.makeConstraints { make in
            make.left.equalTo(recLabel.snp.left)
            make.top.equalTo(reviewLabel.snp.bottom).offset(10)
        }

        likeLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.top.equalTo(reviewLabel.snp.bottom).offset(10)
        }

        pillsStackView.snp.makeConstraints { make in
            make.height.equalTo(25)
            make.top.equalTo(likeLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.width.equalTo(totalBarWidth)
        }

        suggestionLabel.snp.makeConstraints { make in
            make.left.equalTo(recLabel.snp.left)
            make.top.equalTo(pillsStackView.snp.bottom).offset(55)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(labelTextHeight)
        }

        suggestionBox.snp.makeConstraints { make in
            make.left.equalTo(recLabel.snp.left)
            make.top.equalTo(suggestionLabel.snp.bottom).offset(10)
            make.width.equalTo(suggestionBoxWidth)
            make.height.equalTo(120)
        }

        proceedButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(suggestionBox.snp.bottom).offset(100)
            make.width.equalTo(150)
            make.height.equalTo(50)
        }
    }

    @objc func proceedButtonPressed() {
        let thankYouViewController = ThankYouViewController()
        navigationController?.pushViewController(thankYouViewController, animated: true)
    }
}
