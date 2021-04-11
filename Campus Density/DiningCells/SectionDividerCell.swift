//
//  SectionDividerCell.swift
//  Campus Density
//
//  Created by Mihikaa Goenka on 28/03/21.
//  Copyright © 2021 Cornell DTI. All rights reserved.
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
