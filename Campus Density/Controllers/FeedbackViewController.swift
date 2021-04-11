//
//  FeedbackViewController.swift
//  Campus Density
//
//  Created by Changyuan Lin on 12/1/20.
//  Copyright © 2020 Cornell DTI. All rights reserved.
//

import UIKit

struct Feedback: Codable {
    var eatery: String
    var predictedDensity: Int  // Not on backend yet
    var observedDensity: Int  // Not on backend yet
    var predictedWait: Int  // Unknown, but required
    var observedWait: Int
    var comment: String
    var isAccurate: Bool  // Only used internally at the moment
}

class FeedbackViewController: UIViewController {

    var feedback: Feedback?

    // These are kept in ready-to-go first question state when the FeedbackViewController is not active.
    // Invariant: questionView = questions[questionIndex] is shown, with all other questions hidden.
    var questionIndex: Int = 0
    var questionView: FeedbackQuestion!
    var questions: [FeedbackQuestion] = []
    var thanksView: ThanksQuestion!
    var thanksTimer: Timer?
    var background: UIView!
    var nextButton: UIButton!
    var prevButton: UIButton!
    var isMovedUp: Bool = false

    override func viewDidLoad() {
        setupControlsBackgroundThanks()
        resetForm() // Also sets up questions
        setupGestureRecognizers()
    }

    func setupControlsBackgroundThanks() {
        let backdrop = UIButton()
        backdrop.addTarget(self, action: #selector(hide), for: .touchUpInside)
        backdrop.backgroundColor = UIColor(white: 0, alpha: 0.2)
        view.addSubview(backdrop)
        backdrop.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        background = UIView()
        background.backgroundColor = .white
        background.layer.cornerRadius = 8
        view.addSubview(background)
        background.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(300)
        }

        let hideButton = UIButton()
        hideButton.addTarget(self, action: #selector(hide), for: .touchUpInside)
        hideButton.setImage(UIImage(named: "close"), for: .normal)
        background.addSubview(hideButton)
        hideButton.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(10)
            make.height.width.equalTo(15)
        }

        nextButton = UIButton()
        nextButton.addTarget(self, action: #selector(nextQuestion), for: .touchUpInside)
        nextButton.backgroundColor = .densityGreen
        nextButton.layer.cornerRadius = 3
        nextButton.setTitle("Next", for: .normal)
        nextButton.titleLabel?.font = .fourteen
        background.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalTo(80)
            make.bottom.right.equalToSuperview().inset(30)
        }

        prevButton = UIButton()
        prevButton.addTarget(self, action: #selector(prevQuestion), for: .touchUpInside)
        prevButton.layer.cornerRadius = 3
        prevButton.layer.borderWidth = 1
        prevButton.layer.borderColor = UIColor.densityGreen.cgColor
        prevButton.setTitleColor(.densityGreen, for: .normal)
        prevButton.setTitle("Previous", for: .normal)
        prevButton.titleLabel?.font = .fourteen
        prevButton.isHidden = true
        background.addSubview(prevButton)
        prevButton.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalTo(80)
            make.bottom.left.equalToSuperview().inset(30)
        }

        thanksView = ThanksQuestion()
        thanksView.isHidden = true
        background.addSubview(thanksView)
        thanksView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(30)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalTo(nextButton.snp.top).offset(-20)
        }
    }

    func setupQuestions() {
        for question in questions {
            question.removeFromSuperview()
        }

        let accuracyQuestion = AccuracyQuestion()
        accuracyQuestion.delegate = self

        let observedDensityQuestion = ObservedDensityQuestion()
        observedDensityQuestion.delegate = self

        let waitTimeQuestion = WaitTimeQuestion()
        waitTimeQuestion.delegate = self

        let commentQuestion = CommentQuestion()
        commentQuestion.delegate = self

        questions = [accuracyQuestion, observedDensityQuestion, waitTimeQuestion, commentQuestion]
        for question in questions {
            background.addSubview(question)
            question.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(30)
                make.left.right.equalToSuperview().inset(30)
                make.bottom.equalTo(nextButton.snp.top).offset(-30)
            }
            question.isHidden = true
        }
    }

    func setupGestureRecognizers() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)
    }

    func showWith(location: String, predictedDensity: Int) {
        view.isHidden = false
        navigationController?.navigationBar.barTintColor = UIColor(white: 0.77, alpha: 0) // Surprisingly, this gets 80% white
        feedback = Feedback(eatery: location, predictedDensity: predictedDensity, observedDensity: -1, predictedWait: -1, observedWait: -1, comment: "", isAccurate: false)
    }

    @objc func nextQuestion() {
        questionView.isHidden = true
        questionIndex += (questionIndex == 0 && self.feedback!.isAccurate) ? 2 : 1
        if questionIndex == questions.count { // If out of questions, it's time to submit
            submitFeedback()
            showThanksAndHide()
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
        questionIndex -= (questionIndex == 2 && self.feedback!.isAccurate) ? 2 : 1
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
        navigationController?.navigationBar.barTintColor = UIColor(white: 1, alpha: 0)
        resetForm()
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func submitFeedback() {
        API.addFeedback(feedback: feedback!) { success in
            print("addFeedback was \(success)")
        }
    }

    func showThanksAndHide() {
        questionView.isHidden = true
        prevButton.isHidden = true
        nextButton.isHidden = true
        thanksView.isHidden = false
        thanksTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { _ in
            self.hide()
        }
    }

    func resetForm() {
        feedback = nil
        setupQuestions()
        questionIndex = 0
        questionView = questions[questionIndex]
        questionView.isHidden = false
        prevButton.isHidden = true
        nextButton.isHidden = false
        nextButton.setTitle(questions.count == 1 ? "Submit" : "Next", for: .normal)
        thanksView.isHidden = true
        thanksTimer?.invalidate()
        thanksTimer = nil
    }

    func moveUp() {
        if !isMovedUp {
            isMovedUp = true
            UIView.animate(withDuration: 0.2, animations: { self.view.frame.origin.y = -100 })
        }
    }

    func moveDown() {
        if isMovedUp {
            isMovedUp = false
            UIView.animate(withDuration: 0.2, animations: { self.view.frame.origin.y = 0 })
        }
    }
}

extension FeedbackViewController: AccuracyQuestionDelegate {
    func accuracyWasChanged(isAccurate: Bool) {
        self.feedback?.isAccurate = isAccurate
    }
}

extension FeedbackViewController: ObservedDensityQuestionDelegate {
    func observedDensityWasChanged(observed: Int) {
        self.feedback?.observedDensity = observed
    }
}

extension FeedbackViewController: WaitTimeQuestionDelegate {
    func waitTimeWasChanged(waitTime: Int) {
        self.feedback?.observedWait = waitTime
    }
}

extension FeedbackViewController: CommentQuestionDelegate {
    func commentWasChanged(comment: String) {
        self.feedback?.comment = comment
    }

    func commentDidBeginEditing() {
        moveUp()
    }

    func commentDidEndEditing() {
        moveDown()
    }
}
