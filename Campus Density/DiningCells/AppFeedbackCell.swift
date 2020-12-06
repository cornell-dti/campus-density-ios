//
//  AppFeedbackCellCollectionViewCell.swift
//  Campus Density
//
//  Created by Mihikaa Goenka on 05/12/20.
//  Copyright © 2020 Cornell DTI. All rights reserved.
//

import UIKit

protocol AppFeedbackCellDelegate: class {

    func appFeedbackCellDidTapLink()

}

class AppFeedbackCell: UICollectionViewCell {

    // MARK: - Data vars
    var appFeedbackModel: AppFeedbackModel!
    weak var delegate: AppFeedbackCellDelegate?

    // MARK: - Views
    var linkButton: UIButton!
    var cellbground: UIView!
    var feedbackLabel: UILabel!

    // MARK: - Constants
    let surveyButtonText =  "Have feedback? We'd love to hear from you!"

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
    }

    func setupViews() {
        // Enable shadows with rounded border
        cellbground = UIView()
        cellbground.backgroundColor = .white
        cellbground.clipsToBounds = false
        cellbground.layer.masksToBounds = false
        cellbground.layer.cornerRadius = 10
        cellbground.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        cellbground.layer.shadowOpacity = 0.1
        cellbground.layer.borderColor = UIColor.whiteTwo.cgColor
        cellbground.layer.borderWidth = 0.5
        cellbground.layer.shadowRadius = 5
        cellbground.layer.shadowOffset = CGSize(width: 0, height: 3)
        addSubview(cellbground)

        feedbackLabel = UILabel()
        feedbackLabel.text = surveyButtonText
        feedbackLabel.textAlignment = .left
        feedbackLabel.numberOfLines = 0
        feedbackLabel.textColor = .grayishBrown
        feedbackLabel.font = .sixteenBold
        addSubview(feedbackLabel)

        linkButton = UIButton()
        linkButton.setTitle("", for: .normal)
        let linkButtonText = NSAttributedString(string: "Leave Feedback", attributes: [.foregroundColor: UIColor.white, .font: UIFont.fourteen])
        linkButton.setAttributedTitle(linkButtonText, for: .normal)
        linkButton.backgroundColor = UIColor(red: 0.29, green: 0.56, blue: 0.89, alpha: 1)
        linkButton.setTitleColor(.white, for: .normal)
        linkButton.layer.cornerRadius = 6
        linkButton.titleLabel?.textAlignment = .center
        linkButton.addTarget(self, action: #selector(linkButtonPressed), for: .touchUpInside)
        addSubview(linkButton)

        setupConstraints()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func linkButtonPressed() {
        delegate?.appFeedbackCellDidTapLink()
    }

    func setupConstraints() {
        cellbground.snp.makeConstraints { snp in
            snp.edges.equalToSuperview()
        }

        feedbackLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(30)
            make.height.equalTo(130)
            make.width.equalToSuperview().multipliedBy(0.4)
        }

        linkButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(30)
            make.width.equalToSuperview().multipliedBy(0.4)
        }

    }

    func configure(delegate: AppFeedbackCellDelegate) {
        self.delegate = delegate
        setupConstraints()
    }

}
