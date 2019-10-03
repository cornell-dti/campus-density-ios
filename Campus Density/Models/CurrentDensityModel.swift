//
//  CurrentDensityModel.swift
//  Campus Density
//
//  Created by Matthew Coufal on 3/8/19.
//  Copyright © 2019 Cornell DTI. All rights reserved.
//

import Foundation
import IGListKit

class CurrentDensityModel {

    var place: Place
    let identifier = UUID().uuidString

    init(place: Place) {
        self.place = place
    }

}

extension CurrentDensityModel: ListDiffable {

    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSString
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true }
        guard let object = object as? CurrentDensityModel else { return false }
        return object.identifier == identifier
    }

}
