//
//  FeedbackViewController.swift
//  Campus Density
//
//  Created by Changyuan Lin on 12/1/20.
//  Copyright © 2020 Cornell DTI. All rights reserved.
//

import UIKit

struct Feedback: Codable {
    var isAccurate: Bool
    var predicted: Int
    var observed: Int
    var waitTime: Int
    var dineIn: Bool
    var startDine: Int
    var endDine: Int
    var campuslocation: String
    var comments: String
}

class FeedbackViewController: UIViewController {

    var feedback: Feedback?

    // These are kept in ready-to-go first question state when the FeedbackViewController is not active.
    // Invariant: questionView = questions[questionIndex] is shown, with all other questions hidden.
    var questionIndex: Int = 0
    var questionView: FeedbackQuestion!
    var questions: [FeedbackQuestion]!
    var background: UIView!
    var nextButton: UIButton!
    var prevButton: UIButton!

    override func viewDidLoad() {
        setupControlsAndBackground()
        setupQuestions()
        resetForm()
    }

    func setupControlsAndBackground() {
        let backdrop = UIButton()
        backdrop.addTarget(self, action: #selector(hide), for: .touchUpInside)
        backdrop.backgroundColor = UIColor(white: 0, alpha: 0.2)
        view.addSubview(backdrop)
        backdrop.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        background = UIView()
        background.backgroundColor = .blue
        view.addSubview(background)
        background.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(300)
        }

        let hideButton = UIButton()
        hideButton.addTarget(self, action: #selector(hide), for: .touchUpInside)
        hideButton.backgroundColor = .red
        background.addSubview(hideButton)
        hideButton.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(10)
            make.height.width.equalTo(15)
        }

        nextButton = UIButton()
        nextButton.addTarget(self, action: #selector(nextQuestion), for: .touchUpInside)
        nextButton.backgroundColor = .green
        nextButton.setTitle("Next", for: .normal)
        background.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalTo(80)
            make.bottom.right.equalToSuperview().inset(20)
        }

        prevButton = UIButton()
        prevButton.addTarget(self, action: #selector(prevQuestion), for: .touchUpInside)
        prevButton.backgroundColor = .orange
        prevButton.setTitle("Previous", for: .normal)
        prevButton.isHidden = true
        background.addSubview(prevButton)
        prevButton.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalTo(80)
            make.bottom.left.equalToSuperview().inset(20)
        }
    }

    func setupQuestions() {
        // Dummy questions
        let isAccurateView: FeedbackQuestion = {
            let view = FeedbackQuestion(subtitle: "Is this information accurate?")
            view.backgroundColor = .green
            let yesLabel = UILabel()
            let noLabel = UILabel()
            let yesButton = UIButton()
            let noButton = UIButton()
            yesLabel.text = "Yes"
            noLabel.text = "No"
            for button in [yesButton, noButton] {
                button.layer.borderColor = UIColor.black.cgColor
                button.layer.borderWidth = 1
                button.layer.cornerRadius = 5
                button.snp.makeConstraints { make in
                    make.height.width.equalTo(10)
                }
            }
            yesButton.addHandler(for: .touchUpInside) {
                yesButton.backgroundColor = .black
                noButton.backgroundColor = .clear
                self.feedback?.isAccurate = true
            }
            noButton.addHandler(for: .touchUpInside) {
                yesButton.backgroundColor = .clear
                noButton.backgroundColor = .black
                self.feedback?.isAccurate = false
            }
            var upper: UIView = view.subtitle
            for row in [UIStackView(arrangedSubviews: [yesButton, yesLabel]), UIStackView(arrangedSubviews: [noButton, noLabel])] {
                view.addSubview(row)
                row.alignment = .center
                row.spacing = 10
                row.snp.makeConstraints { make in
                    make.left.right.equalToSuperview().inset(30)
                    make.height.equalTo(20)
                    make.top.equalTo(upper.snp_bottomMargin).offset(5)
                }
                upper = row
            }
            return view
        }()

        let observedView: FeedbackQuestion = {
            let view = FeedbackQuestion(subtitle: "How crowded do you think the dining hall is right now?")
            view.backgroundColor = .yellow
            return view
        }()

        questions = [isAccurateView, observedView]
        for question in questions {
            background.addSubview(question)
            question.snp.makeConstraints { make in
                make.top.left.right.equalToSuperview().inset(20)
                make.bottom.equalTo(nextButton.snp_topMargin)
            }
            question.isHidden = true
        }
    }

    func showWith(location: String, predictedDensity: Int) {
        view.isHidden = false
        feedback = Feedback(isAccurate: false, predicted: predictedDensity, observed: 0, waitTime: 0, dineIn: false, startDine: 0, endDine: 0, campuslocation: location, comments: "")
    }

    @objc func nextQuestion() {
        questionView.isHidden = true
        questionIndex += 1
        if questionIndex == questions.count { // If out of questions, it's time to submit
            submitFeedback()
            hide()
        } else {
            if questionIndex == questions.count - 1 {
                nextButton.setTitle("Submit", for: .normal)
            }
            questionView = questions[questionIndex]
            questionView.isHidden = false
            prevButton.isHidden = false
        }
    }

    @objc func prevQuestion() {
        questionView.isHidden = true
        questionIndex -= 1
        if questionIndex <= 0 {
            prevButton.isHidden = true
            questionIndex = 0
        }
        questionView = questions[questionIndex]
        questionView.isHidden = false
        if nextButton.currentTitle != "Next" {
            nextButton.setTitle("Next", for: .normal)
        }
    }

    @objc func hide() {
        view.isHidden = true
        resetForm()
    }

    func submitFeedback() {
        print("Submit feedback")
    }

    func resetForm() {
        feedback = nil
        questionView?.isHidden = true
        questionIndex = 0
        questionView = questions[questionIndex]
        questionView.isHidden = false
        nextButton.setTitle(questions.count == 1 ? "Submit" : "Next", for: .normal)
        prevButton.isHidden = true
    }

}
