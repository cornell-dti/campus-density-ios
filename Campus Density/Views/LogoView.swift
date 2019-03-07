//
//  LogoView.swift
//  Campus Density
//
//  Created by Matthew Coufal on 11/29/18.
//  Copyright © 2018 Cornell DTI. All rights reserved.
//

import UIKit

protocol LogoViewDelegate: class {
    
    func logoViewDidPressLinkButton()
    
}

class LogoView: UIView {
    
    // MARK: - Data vars
    weak var delegate: LogoViewDelegate?
    
    // MARK: - Views
    var linkButton: UIButton!
    var dti: UIImageView!
    var label: UILabel!
    var space: UIView!
    
    // MARK: - Constants
    let dtiLength: CGFloat = 50
    let dtiImageName = "dtilogo"
    let padding: CGFloat = 15

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        linkButton = UIButton()
        linkButton.addTarget(self, action: #selector(linkButtonPressed), for: .touchUpInside)
        addSubview(linkButton)
        
        dti = UIImageView()
        dti.image = UIImage(named: dtiImageName)
        addSubview(dti)
        
        space = UIView()
        space.backgroundColor = .white
        addSubview(space)
        
        linkButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.height.equalTo(dtiLength)
        }
        
        dti.snp.makeConstraints { make in
            make.width.height.equalTo(linkButton)
            make.center.equalTo(linkButton)
        }
        
        space.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(padding)
            make.centerX.equalToSuperview()
            make.top.equalTo(linkButton.snp.bottom)
        }
        
    }
    
    func configure(with delegate: LogoViewDelegate) {
        self.delegate = delegate
    }
    
    @objc func linkButtonPressed() {
        delegate?.logoViewDidPressLinkButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
