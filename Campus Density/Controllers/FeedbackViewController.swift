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

    var parentHide: (() -> Void)?
    var questionIndex: Int = 0
    var questionView: UIView!
    var questions: [UIView]!
    var nextButton: UIButton!
    var prevButton: UIButton!

    override func viewDidLoad() {
        setupControlsAndBackground()
        setupQuestions()
    }

    func setupControlsAndBackground() {
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

        nextButton = UIButton()
        nextButton.addTarget(self, action: #selector(nextQuestion), for: .touchUpInside)
        nextButton.backgroundColor = .green
        nextButton.setTitle("Next", for: .normal)
        view.addSubview(nextButton)
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
        view.addSubview(prevButton)
        prevButton.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalTo(80)
            make.bottom.left.equalToSuperview().inset(20)
        }
    }

    func setupQuestions() {
        // Dummy questions
        let isAccurateView = UIView()
        isAccurateView.backgroundColor = .green
        let observedView = UIView()
        observedView.backgroundColor = .yellow
        questions = [isAccurateView, observedView]

        for question in questions {
            view.addSubview(question)
            question.snp.makeConstraints { make in
                make.top.left.right.equalToSuperview().inset(20)
                make.bottom.equalTo(nextButton.snp_topMargin)
            }
            question.isHidden = true
        }
    }

    func prepareWith(location: String, predictedDensity: Int) {
        feedback = Feedback(isAccurate: false, predicted: predictedDensity, observed: 0, waitTime: 0, dineIn: false, startDine: 0, endDine: 0, campuslocation: location, comments: "")
        questionIndex = 0
        questionView = questions[questionIndex]
        questionView.isHidden = false
        // Possibly want to reset the question views too
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
        }
        prevButton.isHidden = false
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
        parentHide?()
        // Actually this may be a good place to reset everything
    }

    func submitFeedback() {
        print("Submit feedback")
    }

}
