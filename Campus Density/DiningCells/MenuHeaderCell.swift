//
//  MenuHeaderCell.swift
//  Campus Density
//
//  Created by Changyuan Lin on 8/15/20.
//  Copyright © 2020 Cornell DTI. All rights reserved.
//

import UIKit

class MenuHeaderCell: UICollectionViewCell {

    // MARK: - View vars
    var headerLabel: UILabel!
    var detailsLabel: UILabel!

    // MARK: - Constants
    let headerLabelText = "Menus & Hours"
    let detailsLabelText = "Show Details For:"
    let spacing = 5

    override init(frame: CGRect) {
        super.init(frame: frame)

        headerLabel = UILabel()
        headerLabel.text = headerLabelText
        headerLabel.textColor = .black
        headerLabel.textAlignment = .left
        headerLabel.font = .twentyFiveBold
        addSubview(headerLabel)

        detailsLabel = UILabel()
        detailsLabel.text = detailsLabelText
        detailsLabel.textColor = .warmGray
        detailsLabel.textAlignment = .left
        detailsLabel.font = .sixteen
        addSubview(detailsLabel)

        setupConstraints()
    }

    func setupConstraints() {
        let headerLabelTextHeight = headerLabelText.height(withConstrainedWidth: frame.width - Constants.smallPadding * 2, font: headerLabel.font)

        let detailsLabelTextHeight = detailsLabelText.height(withConstrainedWidth: frame.width - Constants.smallPadding * 2, font: detailsLabel.font)

        headerLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(Constants.smallPadding)
            make.left.equalToSuperview().offset(Constants.smallPadding)
            make.height.equalTo(headerLabelTextHeight)
        }

        detailsLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(Constants.smallPadding)
            make.left.equalToSuperview().offset(Constants.smallPadding)
            make.height.equalTo(detailsLabelTextHeight)
            make.top.equalTo(headerLabel.snp_bottom).offset(spacing)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
