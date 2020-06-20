//
//  AvailabilityHeaderModel.swift
//  Campus Density
//
//  Created by Ansh Godha on 20/06/20.
//  Copyright © 2020 Cornell DTI. All rights reserved.
//

import Foundation
import IGListKit

class AvailabilityHeaderModel {
    let identifier = UUID().uuidString
}

extension AvailabilityHeaderModel: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSString
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true }
        guard let object = object as? AvailabilityHeaderModel else { return false }
        return self.identifier == object.identifier
    }

}
