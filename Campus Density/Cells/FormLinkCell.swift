//
//  FormLinkCell.swift
//  Campus Density
//
//  Created by Matthew Coufal on 3/8/19.
//  Copyright © 2019 Cornell DTI. All rights reserved.
//

import UIKit

protocol FormLinkCellDelegate: class {
    
    func formLinkCellDidPressLinkButton(link: String)
    
}

class FormLinkCell: UICollectionViewCell {
    
    // MARK: - Data vars
    var link: String!
    weak var delegate: FormLinkCellDelegate?
    
    // MARK: - View vars
    var linkButton: UIButton!
    
    // MARK: - Constants
    let linkButtonText = "Is this accurate?"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        linkButton = UIButton()
        linkButton.addTarget(self, action: #selector(linkButtonPressed), for: .touchUpInside)
        linkButton.setTitle(linkButtonText, for: .normal)
        linkButton.setTitleColor(.brightBlue, for: .normal)
        linkButton.titleLabel?.font = .fourteen
        linkButton.titleLabel?.textAlignment = .right
        addSubview(linkButton)
        
    }
    
    func setupConstraints() {
        linkButton.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.right.equalToSuperview().inset(Constants.smallPadding)
        }
    }
    
    func configure(delegate: FormLinkCellDelegate, link: String) {
        self.delegate = delegate
        self.link = link
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func linkButtonPressed() {
        delegate?.formLinkCellDidPressLinkButton(link: link)
    }
    
    
}
