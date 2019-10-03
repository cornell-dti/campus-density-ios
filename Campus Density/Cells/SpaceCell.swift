//
//  SpaceCell.swift
//  Campus Density
//
//  Created by Matthew Coufal on 3/8/19.
//  Copyright © 2019 Cornell DTI. All rights reserved.
//

import UIKit

class SpaceCell: UICollectionViewCell {

    // MARK: - View vars
    var space: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)

        space = UIView()
        space.backgroundColor = .white
        addSubview(space)

        space.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
            make.center.equalToSuperview()
        }

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
