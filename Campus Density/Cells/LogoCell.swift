//
//  LogoCell.swift
//  Campus Density
//
//  Created by Matthew Coufal on 3/24/19.
//  Copyright © 2019 Cornell DTI. All rights reserved.
//

import UIKit

protocol LogoCellDelegate: class {
    
    func logoCellDidTapLink()
    
}

class LogoCell: UICollectionViewCell {
    
    // MARK: - Data vars
    var logoModel: LogoModel!
    weak var delegate: LogoCellDelegate?
    
    // MARK: - Views
    var linkButton: UIButton!
    var dti: UIImageView!
    
    // MARK: - Constants
    let dtiImageName = "dtilogo"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        
    }
    
    override func prepareForReuse() {
        linkButton.snp.removeConstraints()
        dti.snp.removeConstraints()
    }
    
    @objc func linkButtonPressed() {
        delegate?.logoCellDidTapLink()
    }
    
    func setupViews() {
        linkButton = UIButton()
        linkButton.addTarget(self, action: #selector(linkButtonPressed), for: .touchUpInside)
        contentView.addSubview(linkButton)
        
        dti = UIImageView()
        dti.image = UIImage(named: dtiImageName)
        contentView.addSubview(dti)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        linkButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.height.equalTo(logoModel.length)
        }
        
        dti.snp.makeConstraints { make in
            make.width.height.equalTo(linkButton)
            make.center.equalTo(linkButton)
        }
    }
    
    func configure(logoModel: LogoModel, delegate: LogoCellDelegate) {
        self.logoModel = logoModel
        self.delegate = delegate
        setupConstraints()
    }
    
}
