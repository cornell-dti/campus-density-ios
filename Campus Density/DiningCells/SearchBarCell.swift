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

    var searchBar: UITextField!

    override init(frame: CGRect) {
        super.init(frame: frame)
        searchBar = UITextField()
        searchBar.borderStyle = .roundedRect
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor.whiteTwo.cgColor
        searchBar.layer.cornerRadius = 10
        searchBar.layer.masksToBounds = true
        searchBar.placeholder = "Search for Eateries..."
        searchBar.addTarget(self, action: #selector(searchBarTextChanged), for: .editingChanged)
        searchBar.delegate = self
        contentView.addSubview(searchBar)
        setupContraints()
    }

    @objc func searchBarTextChanged(textField: UITextField) {
        delegate?.searchBarCellDidUpdateSearchText(searchText: textField.text ?? "")
    }

    func setupContraints() {
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

extension SearchBarCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
