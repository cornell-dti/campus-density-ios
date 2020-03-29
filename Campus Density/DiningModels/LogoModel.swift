//
//  LogoModel.swift
//  Campus Density
//
//  Created by Matthew Coufal on 3/24/19.
//  Copyright © 2019 Cornell DTI. All rights reserved.
//

import Foundation
import IGListKit

class LogoModel {

    var length: CGFloat
    var link: String
    let identifier = UUID().uuidString

    init(length: CGFloat, link: String) {
        self.length = length
        self.link = link
    }

}

extension LogoModel: ListDiffable {

    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSString
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true }
        guard let logoModel = object as? LogoModel else { return false }
        return logoModel.identifier == identifier
    }

}
