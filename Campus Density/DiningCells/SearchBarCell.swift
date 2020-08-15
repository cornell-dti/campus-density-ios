//
//  SearchBarCell.swift
//  Campus Density
//
//  Created by Ansh Godha on 15/08/20.
//  Copyright © 2020 Cornell DTI. All rights reserved.
//

import UIKit

protocol SearchBarCellDelegate: class {
    func didUpdateSearchText(searchText: String)
}

class SearchBarCell: UICollectionViewCell {
    var searchBarModel: SearchBarModel!
    weak var delegate: SearchBarCellDelegate?

    var searchBar = UITextField()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    func setupViews() {
        addSubview(searchBar)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
