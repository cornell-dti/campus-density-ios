//
//  SectionDividerCell.swift
//  Campus Density
//
//  Created by Mihikaa Goenka on 9/29/20.
//  Copyright © 2020 Cornell DTI. All rights reserved.
//

import UIKit

class SectionDividerCell: UICollectionViewCell {

    // MARK: - View vars
    var line: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)

        line = UIView()
        line.backgroundColor = .densityLightGray
        addSubview(line)

        line.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
            make.center.equalToSuperview()
        }

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
