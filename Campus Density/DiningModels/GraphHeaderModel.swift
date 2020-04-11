//
//  GraphHeaderModel.swift
//  Campus Density
//
//  Created by Changyuan Lin on 4/11/20.
//  Copyright © 2020 Cornell DTI. All rights reserved.
//

import Foundation
import IGListKit

class GraphHeaderModel {

    let identifier = UUID().uuidString

}

extension GraphHeaderModel: ListDiffable {

    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSString
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true }
        guard let object = object as? GraphHeaderModel else { return false }
        return object.identifier == identifier
    }

}
