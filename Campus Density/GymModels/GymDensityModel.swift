//
//  GymDensityModel.swift
//  Campus Density
//
//  Created by Ansh Godha on 12/02/20.
//  Copyright © 2020 Cornell DTI. All rights reserved.
//

import Foundation
import IGListKit

class GymDensityModel {
    var currentCardioCount: Int
    var maxCardioCount: Int
    var currentWeightCount: Int
    let identifier = UUID().uuidString

    init (currentCardioCount: Int, maxCardioCount: Int, currentWeightCount: Int) {
        self.currentCardioCount = currentCardioCount
        self.maxCardioCount = maxCardioCount
        self.currentWeightCount = currentWeightCount
    }
}

extension GymDensityModel: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSString
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if object === self {return true}
        guard let object = object as? GymDensityModel else {return false}
        return object.identifier == identifier
    }
}
