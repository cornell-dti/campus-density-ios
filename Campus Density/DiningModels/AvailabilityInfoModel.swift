//
//  AvailabilityInfoModel.swift
//  Campus Density
//
//  Created by Ansh Godha on 14/06/20.
//  Copyright © 2020 Cornell DTI. All rights reserved.
//

import Foundation
import IGListKit

class AvailabilityInfoModel {

    var place: Place
    var identifier = UUID().uuidString

    init(place: Place) {
        self.place = place
    }
}

extension AvailabilityInfoModel: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSString
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true }
        guard let object = object as? AvailabilityInfoModel else { return false }
        return identifier == object.identifier
    }
}
