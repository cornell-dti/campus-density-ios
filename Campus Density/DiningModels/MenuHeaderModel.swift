//
//  MenuHeaderModel.swift
//  Campus Density
//
//  Created by Changyuan Lin on 8/15/20.
//  Copyright © 2020 Cornell DTI. All rights reserved.
//

import Foundation
import IGListKit

class MenuHeaderModel {
    let identifier = UUID().uuidString
}

extension MenuHeaderModel: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSString
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true }
        guard let object = object as? MenuHeaderModel else { return false }
        return self.identifier == object.identifier
    }

}
