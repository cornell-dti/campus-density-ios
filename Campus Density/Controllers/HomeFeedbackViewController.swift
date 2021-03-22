//
//  HomeFeedbackViewController.swift
//  Campus Density
//
//  Created by Mihikaa Goenka on 05/12/20.
//  Copyright © 2020 Cornell DTI. All rights reserved.
//

import UIKit

struct FluxFeedback: Codable {
    var likelytoRecommend: Int
    var usefulFeatures: [Int]
    // How do you like flux overall
    var likeFluxOverall: Int
    // other comments
    var comment: String
}

class HomeFeedbackViewController: UIViewController {

    var feedback: FluxFeedback?

    var questionIndex: Int = 0
    var questionView: HomeFeedbackQuestion!
    var questions: [HomeFeedbackQuestion] = []
    var thanksView: ThankYouQuestion!
    var thanksTimer: Timer?
    var background: UIView!
    var nextButton: UIButton!
    var prevButton: UIButton!
    var isMovedUp: Bool = false
    var notAnswered: UILabel!

    override func viewDidLoad() {
        setupControlsBackgroundThanks()
        resetForm() // Also sets up questions
        setupGestureRecognizers()
    }

    func setupControlsBackgroundThanks() { //From FeedbackViewController
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
            hideButton.setImage(UIImage(named: "quit"), for: .normal)
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

            thanksView = ThankYouQuestion()
            thanksView.isHidden = true
            background.addSubview(thanksView)
            thanksView.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(30)
                make.left.right.equalToSuperview().inset(20)
                make.bottom.equalTo(nextButton.snp.top).offset(-20)
            }

        notAnswered = UILabel()
        notAnswered.textColor = .black
        notAnswered.textAlignment = .center
        notAnswered.font = .ten
        notAnswered.text = "Please answer this question before proceeding"
        notAnswered.isHidden = true
        background.addSubview(notAnswered)
        notAnswered.snp.makeConstraints { make in
            make.bottom.equalTo(nextButton.snp.top).offset(-20)
            make.centerX.equalToSuperview()
        }

        }

    func setupQuestions() {
        for question in questions {
            question.removeFromSuperview()
        }

        let recQuestion = RecommendQuestion()
        recQuestion.delegate = self

        let featuresQuestion = FeaturesQuestion()
        featuresQuestion.delegate = self

        let reviewQuestion = ReviewQuestion()
        reviewQuestion.delegate = self

        let otherCommentsQuestion = OtherCommentsQuestion()
        otherCommentsQuestion.delegate = self

        questions = [recQuestion, featuresQuestion, reviewQuestion, otherCommentsQuestion]
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

    func showWith() {
        view.isHidden = false
        navigationController?.navigationBar.barTintColor = UIColor(white: 1, alpha: 0)
        feedback = FluxFeedback(likelytoRecommend: -1, usefulFeatures: [], likeFluxOverall: -1, comment: "")
        }

    @objc func nextQuestion() {
        if questionIndex == 0 && feedback?.likelytoRecommend == -1 {
            notAnswered.isHidden = false
        } else {
            notAnswered.isHidden = true
            questionView.isHidden = true
            questionIndex += 1
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
            navigationController?.navigationBar.barTintColor = UIColor(white: 1, alpha: 0)
            resetForm()
        }

        @objc func dismissKeyboard() {
            view.endEditing(true)
        }

        func submitFeedback() {
            API.addGeneralFeedback(feedback: feedback!) { success in
                print("addGeneralFeedback was maybe \(success) but it hasn't been tested")
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

extension HomeFeedbackViewController: RecommendationQuestionDelegate {
    func recValueWasChanged(rec: Int) {
        self.feedback?.likelytoRecommend = rec
    }
}

extension HomeFeedbackViewController: FeaturesQuestionDelegate {
    func featuresWasChanged(features: [Int]) {
        self.feedback?.usefulFeatures = features
    }
}

extension HomeFeedbackViewController: ReviewQuestionDelegate {
    func reviewWasChanged(review: Int) {
        self.feedback?.likeFluxOverall = review
        print(review)
    }
}

extension HomeFeedbackViewController: OtherCommentsQuestionDelegate {
    func commentDidBeginEditing() {
        moveUp()
    }

    func commentDidEndEditing() {
        moveDown()
    }

    func otherCommentsWasChanged(comment: String) {
        self.feedback?.comment = comment
    }
}
