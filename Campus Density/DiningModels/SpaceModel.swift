//
//  SpaceModel.swift
//  Campus Density
//
//  Created by Matthew Coufal on 3/8/19.
//  Copyright © 2019 Cornell DTI. All rights reserved.
//

import Foundation
import IGListKit

class SpaceModel {

    var space: CGFloat
    let identifier = UUID().uuidString

    init(space: CGFloat) {
        self.space = space
    }

}

extension SpaceModel: ListDiffable {

    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSString
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true }
        guard let object = object as? SpaceModel else { return false }
        return object.identifier == identifier
    }

}
