//
//  SearchBarCell.swift
//  Campus Density
//
//  Created by Ansh Godha on 15/08/20.
//  Copyright © 2020 Cornell DTI. All rights reserved.
//

import UIKit

protocol SearchBarCellDelegate: class {
    func searchBarCellDidUpdateSearchText(searchText: String)
}

class SearchBarCell: UICollectionViewCell {
    var searchBarModel: SearchBarModel!
    weak var delegate: SearchBarCellDelegate?

    var searchBar: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.warmGray.cgColor
        tf.layer.cornerRadius = 5
        tf.layer.masksToBounds = true
        tf.placeholder = "Search for Eateries..."
        return tf
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        searchBar.addTarget(self, action: #selector(searchBarTextChanged), for: .editingChanged)
        contentView.addSubview(searchBar)
        setupContraints()
    }

    @objc func searchBarTextChanged(textField: UITextField) {
        delegate?.searchBarCellDidUpdateSearchText(searchText: textField.text ?? "")
    }

    func setupContraints() {
        //searchBar.backgroundColor = .red
        searchBar.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Constants.smallPadding)
            make.top.equalToSuperview()
            make.right.equalToSuperview().offset(-Constants.smallPadding)
            make.bottom.equalToSuperview()
        }
    }

    func configure(delegate: SearchBarCellDelegate) {
        self.delegate = delegate
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
