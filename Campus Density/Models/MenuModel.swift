//
//  MenuModel.swift
//  Campus Density
//
//  Created by Matthew Coufal on 11/10/19.
//  Copyright © 2019 Cornell DTI. All rights reserved.
//

import Foundation
import IGListKit

class MenuModel {

    var menu: [String: [String: [String]]]
    let identifier = UUID().uuidString

    init(menu: [String: [String: [String]]]) {
        self.menu = menu
    }

}

extension MenuModel: ListDiffable {

    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSString
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true }
        guard let object = object as? MenuModel else { return false }
        return object.identifier == identifier
    }

}
