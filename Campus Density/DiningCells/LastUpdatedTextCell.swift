//
//  LastUpdatedTextCell.swift
//  Campus Density
//
//  Created by Changyuan Lin on 7/2/20.
//  Copyright © 2020 Cornell DTI. All rights reserved.
//

import UIKit

class LastUpdatedTextCell: UICollectionViewCell {

    // MARK: - View vars
    var lastUpdatedLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)

        lastUpdatedLabel = UILabel()
        lastUpdatedLabel.textColor = .densityDarkGray
        contentView.addSubview(lastUpdatedLabel)

        setupConstraints()
    }

    func setupConstraints() {
        lastUpdatedLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(Constants.smallPadding)
            make.height.equalToSuperview()
        }
    }

    func configure(lastUpdatedDate: Date, style: LastUpdatedTextSectionController.Style) {
        let formatter = DateFormatter()

        switch style {
        case .main:
            formatter.dateStyle = .medium
            lastUpdatedLabel.textAlignment = .center
            lastUpdatedLabel.font = .sixteen
        case .detail:
            formatter.dateStyle = .none
            lastUpdatedLabel.textAlignment = .left
            lastUpdatedLabel.font = .fourteen
        }

        formatter.timeStyle = .short
        lastUpdatedLabel.text = "Last updated " + formatter.string(from: lastUpdatedDate)
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
