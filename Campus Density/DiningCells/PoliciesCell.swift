//
//  PoliciesCell.swift
//  Campus Density
//
//  Created by Ansh Godha on 18/09/20.
//  Copyright © 2020 Cornell DTI. All rights reserved.
//

import UIKit

protocol PoliciesCellDelegate: class {
    func policiesCellDelegateDidPressPoliciesButton()
}

class PoliciesCell: UICollectionViewCell {

    // MARK: - Data vars
    weak var delegate: PoliciesCellDelegate?

    // MARK: - View vars
    var personWithMaskIV: UIImageView!
    var faceCoveringLabel: UILabel!
    var diningPolicyButton: UIButton!
    var closeButton: UIButton!
    var background: UIView!

    // MARK: - Constants
    var policyText: String = "Face coverings are required at all dining halls!"

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()

    }

    func setupViews() {

        // Enable shadows with rounded border
        background = UIView()
        background.backgroundColor = .white
        background.clipsToBounds = false
        background.layer.masksToBounds = false
        background.layer.cornerRadius = 10
        background.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        background.layer.shadowOpacity = 0.1
        background.layer.borderColor = UIColor.whiteTwo.cgColor
        background.layer.borderWidth = 0.5
        background.layer.shadowRadius = 5
        background.layer.shadowOffset = CGSize(width: 0, height: 3)
        addSubview(background)

        personWithMaskIV = UIImageView()
        personWithMaskIV.image = UIImage(named: "person_with_mask")
        personWithMaskIV.contentMode = .scaleAspectFit
        addSubview(personWithMaskIV)

        faceCoveringLabel = UILabel()
        faceCoveringLabel.text = policyText
        faceCoveringLabel.textAlignment = .left
        faceCoveringLabel.numberOfLines = 0
        faceCoveringLabel.textColor = .grayishBrown
        faceCoveringLabel.font = .sixteenBold
        addSubview(faceCoveringLabel)

        diningPolicyButton = UIButton()
        diningPolicyButton.setTitle("", for: .normal)
        let diningPolicyButtonText = NSAttributedString(string: "View dining hall policies", attributes: [.foregroundColor: UIColor.warmGray, .font: UIFont.fourteen])
        diningPolicyButton.setAttributedTitle(diningPolicyButtonText, for: .normal)
        diningPolicyButton.tintColor = .white
        diningPolicyButton.layer.borderColor = UIColor.warmGray.cgColor
        diningPolicyButton.layer.borderWidth = 1
        diningPolicyButton.layer.cornerRadius = 8
        diningPolicyButton.addTarget(self, action: #selector(policyButtonPressed), for: .touchUpInside)
        addSubview(diningPolicyButton)

        setupConstraints()

    }

    @objc func policyButtonPressed() {
        delegate?.policiesCellDelegateDidPressPoliciesButton()
    }

    func setupConstraints() {
        background.snp.makeConstraints { snp in
            snp.edges.equalToSuperview()
        }

        personWithMaskIV.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(30)
            make.height.equalTo(160)
            make.width.equalTo(130)
        }

        diningPolicyButton.snp.makeConstraints { make in
            make.bottom.equalTo(personWithMaskIV.snp.bottom).offset(-20)
            make.left.equalTo(personWithMaskIV.snp.right).offset(10)
            make.height.equalTo(30)
            make.width.equalToSuperview().multipliedBy(0.5)
        }

        faceCoveringLabel.snp.makeConstraints { make in
            make.bottom.equalTo(diningPolicyButton.snp.top).offset(-10)
            make.height.equalTo(70)
            make.width.equalTo(diningPolicyButton.snp.width)
            make.left.equalTo(diningPolicyButton.snp.left)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
