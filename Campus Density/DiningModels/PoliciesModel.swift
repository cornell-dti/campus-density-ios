//
//  PoliciesModel.swift
//  Campus Density
//
//  Created by Ansh Godha on 15/09/20.
//  Copyright © 2020 Cornell DTI. All rights reserved.
//

import Foundation

import IGListKit

class PoliciesModel {
    let identifier = UUID().uuidString
}

extension PoliciesModel: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSString
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true }
        guard let object = object as? PoliciesModel else { return false }
        return self.identifier == object.identifier
    }

}
