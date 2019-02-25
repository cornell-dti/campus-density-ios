//
//  LogoView.swift
//  Campus Density
//
//  Created by Matthew Coufal on 11/29/18.
//  Copyright © 2018 Cornell DTI. All rights reserved.
//

import UIKit

class LogoView: UIView {
    
    // MARK: - Views
    var dti: UIImageView!
    var label: UILabel!
    var space: UIView!
    
    // MARK: - Constants
    let dtiLength: CGFloat = 50
    let dtiImageName = "dtilogo"
    let padding: CGFloat = 15
    let labelText = "powered by DTI"

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        dti = UIImageView()
        dti.image = UIImage(named: dtiImageName)
        addSubview(dti)
        
        label = UILabel()
        label.font = .sixteen
        label.textColor = .grayishBrown
        label.textAlignment = .center
        label.text = labelText
        addSubview(label)
        
        space = UIView()
        space.backgroundColor = .white
        addSubview(space)
        
        dti.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.height.equalTo(dtiLength)
        }
        
        label.snp.makeConstraints { make in
            make.top.equalTo(dti.snp.bottom).offset(padding)
            make.centerX.equalToSuperview()
        }
        
        space.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(padding)
            make.centerX.equalToSuperview()
            make.top.equalTo(label.snp.bottom)
        }
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
