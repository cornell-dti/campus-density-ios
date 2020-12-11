//
//  HomeFeedbackViewController.swift
//  Campus Density
//
//  Created by Mihikaa Goenka on 05/12/20.
//  Copyright © 2020 Cornell DTI. All rights reserved.
//

import UIKit

class HomeFeedbackViewController: UIViewController {
    //var scrollView: UIScrollView!
    var recLabel: UILabel!
    let recLabelText = "1. How willing are you to recommend Flux to your friends? (1-10)"
    var button1: UIButton!
    var button2: UIButton!
    var button3: UIButton!
    var button4: UIButton!
    var button5: UIButton!
    var recButtons: [UIButton]!
    var featureLabel: UILabel!
    let featureLabelText = "2. Which feature do you find useful?"
    var checkbox1: UIButton!
    var checkbox1Label: UILabel!
    var checkbox2: UIButton!
    var checkbox2Label: UILabel!
    var checkbox3: UIButton!
    var checkbox3Label: UILabel!
    var checkbox4: UIButton!
    var checkbox4Label: UILabel!
    var allLabel: UILabel!
    let allLabelText = "3. How do you like Flux overall?"
    var barOne: UIView!
    var barTwo: UIView!
    var barThree: UIView!
    var barFour: UIView!
    var suggestionLabel: UILabel!
    let suggestionLabelText = "4. Do you have any other suggestions?"
    var suggestionBox: UITextView!
    let suggestionPlaceholderText = "Please enter here. \nWe really appreciate your feedback."
    var proceedButton: UIButton!

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

        setupViews()
        setupConstraints()
    }

    func setupViews() {

//        scrollView = UIScrollView()
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        scrollView.backgroundColor = .white
//        scrollView.delegate = self
//        scrollView.isScrollEnabled = true
//        scrollView.alwaysBounceVertical = false
//        scrollView.contentSize = CGSize(width: 0, height: self.scrollView.contentSize.height)
//        view.addSubview(scrollView)
//        scrollView.snp.makeConstraints { make in
//                make.edges.equalToSuperview()
//            }

        recLabel = setUpLabel()
        recLabel.text = recLabelText
        recLabel.numberOfLines = 2
        view.addSubview(recLabel)

        addChoiceButtons()

        featureLabel = setUpLabel()
        featureLabel.text = featureLabelText
        view.addSubview(featureLabel)

        checkbox1Label = setUpCheckboxLabel()
        checkbox1Label.text = "Popular Times"
        view.addSubview(checkbox1Label)

        checkbox2Label = setUpCheckboxLabel()
        checkbox2Label.text = "Availability Breakdown"
        view.addSubview(checkbox2Label)

        checkbox3Label = setUpCheckboxLabel()
        checkbox3Label.text = "Dining Areas"
        view.addSubview(checkbox3Label)

        checkbox4Label = setUpCheckboxLabel()
        checkbox4Label.text = "Menu"
        view.addSubview(checkbox4Label)

        allLabel = setUpLabel()
        allLabel.text = allLabelText
        view.addSubview(allLabel)

        barOne = setupBar()
        view.addSubview(barOne)

        barTwo = setupBar()
        view.addSubview(barTwo)

        barThree = setupBar()
        view.addSubview(barThree)

        barFour = setupBar()
        view.addSubview(barFour)

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

    func setUpCheckboxLabel() -> UILabel {
        let checkboxLabel = UILabel()
        checkboxLabel.textColor = .densityDarkGray
        checkboxLabel.font = .fourteen
        checkboxLabel.translatesAutoresizingMaskIntoConstraints = false
        checkboxLabel.textAlignment = .left
        return checkboxLabel
    }

    func addChoiceButtons() {
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

        checkbox1 = UIButton()
        checkbox1.translatesAutoresizingMaskIntoConstraints = false
        checkbox1.setImage(UIImage(named: "unchecked-box"), for: .normal)
        checkbox1.addTarget(self, action: #selector(checkboxPressed), for: .touchUpInside)
        view.addSubview(checkbox1)

        checkbox2 = UIButton()
        checkbox2.translatesAutoresizingMaskIntoConstraints = false
        checkbox2.setImage(UIImage(named: "unchecked-box"), for: .normal)
        checkbox1.addTarget(self, action: #selector(checkboxPressed), for: .touchUpInside)
        view.addSubview(checkbox2)

        checkbox3 = UIButton()
        checkbox3.translatesAutoresizingMaskIntoConstraints = false
        checkbox3.setImage(UIImage(named: "unchecked-box"), for: .normal)
        checkbox1.addTarget(self, action: #selector(checkboxPressed), for: .touchUpInside)
        view.addSubview(checkbox3)

        checkbox4 = UIButton()
        checkbox4.translatesAutoresizingMaskIntoConstraints = false
        checkbox4.setImage(UIImage(named: "unchecked-box"), for: .normal)
        checkbox1.addTarget(self, action: #selector(checkboxPressed), for: .touchUpInside)
        view.addSubview(checkbox4)

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
        let leftPadding: CGFloat = 20
        let suggestionBoxWidth: CGFloat = view.frame.width - 2 * leftPadding

        recLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(leftPadding)
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

        checkbox1.snp.makeConstraints { make in
            make.left.equalTo(recLabel.snp.left)
            make.top.equalTo(featureLabel.snp.bottom).offset(10)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }

        checkbox1Label.snp.makeConstraints { make in
            make.left.equalTo(checkbox1.snp.right).offset(5)
            make.top.equalTo(featureLabel.snp.bottom).offset(10)
            make.height.equalTo(checkbox1.snp.height)
        }

        checkbox2.snp.makeConstraints { make in
            make.left.equalTo(recLabel.snp.left)
            make.top.equalTo(checkbox1.snp.bottom).offset(3)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }

        checkbox2Label.snp.makeConstraints { make in
            make.left.equalTo(checkbox2.snp.right).offset(5)
            make.top.equalTo(checkbox1.snp.bottom).offset(3)
            make.height.equalTo(checkbox1.snp.height)
        }

        checkbox3.snp.makeConstraints { make in
            make.left.equalTo(recLabel.snp.left)
            make.top.equalTo(checkbox2.snp.bottom).offset(3)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }

        checkbox3Label.snp.makeConstraints { make in
            make.left.equalTo(checkbox3.snp.right).offset(5)
            make.top.equalTo(checkbox2.snp.bottom).offset(3)
            make.height.equalTo(checkbox1.snp.height)
        }

        checkbox4.snp.makeConstraints { make in
            make.left.equalTo(recLabel.snp.left)
            make.top.equalTo(checkbox3.snp.bottom).offset(3)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }

        checkbox4Label.snp.makeConstraints { make in
            make.left.equalTo(checkbox4.snp.right).offset(5)
            make.top.equalTo(checkbox3.snp.bottom).offset(3)
            make.height.equalTo(checkbox1.snp.height)
        }

        allLabel.snp.makeConstraints { make in
            make.left.equalTo(recLabel.snp.left)
            make.top.equalTo(checkbox4.snp.bottom).offset(30)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(labelTextHeight)
        }

        barOne.snp.makeConstraints { make in
            make.left.equalTo(recLabel.snp.left)
            make.width.equalTo(barWidth)
            make.top.equalTo(allLabel.snp.bottom).offset(10)
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

        suggestionLabel.snp.makeConstraints { make in
            make.left.equalTo(recLabel.snp.left)
            make.top.equalTo(barOne.snp.bottom).offset(30)
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

    @objc func checkboxPressed() {
        if checkbox1.image(for: .normal) == UIImage(named: "checked-box") {
            checkbox1.setImage(UIImage(named: "unchecked-box"), for: .normal)
        } else {
            checkbox1.setImage(UIImage(named: "checked-box"), for: .normal)
        }
    }

    @objc func proceedButtonPressed() {
        let thankYouViewController = ThankYouViewController()
        navigationController?.pushViewController(thankYouViewController, animated: true)
    }

}
