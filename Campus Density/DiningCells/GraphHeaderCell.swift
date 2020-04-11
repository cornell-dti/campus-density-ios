//
//  GraphHeaderCell.swift
//  Campus Density
//
//  Created by Changyuan Lin on 4/11/20.
//  Copyright © 2020 Cornell DTI. All rights reserved.
//

import UIKit

class GraphHeaderCell: UICollectionViewCell {

    // MARK: - View vars
    var headerLabel: UILabel!

    // MARK: - Constants
    let headerLabelText = "Popular Times"

    override init(frame: CGRect) {
        super.init(frame: frame)

        headerLabel = UILabel()
        headerLabel.text = headerLabelText
        headerLabel.textColor = .grayishBrown
        headerLabel.textAlignment = .left
        headerLabel.font = .thirtyBold
        addSubview(headerLabel)

        setupConstraints()
    }

    func setupConstraints() {
        let headerLabelTextHeight = headerLabelText.height(withConstrainedWidth: frame.width - Constants.smallPadding * 2, font: headerLabel.font)

        headerLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(Constants.smallPadding)
            make.left.equalToSuperview().offset(Constants.smallPadding)
            make.height.equalTo(headerLabelTextHeight)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
