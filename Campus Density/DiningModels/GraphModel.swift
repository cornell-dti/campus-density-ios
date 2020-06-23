//
//  GraphModel.swift
//  Campus Density
//
//  Created by Matthew Coufal on 3/8/19.
//  Copyright © 2019 Cornell DTI. All rights reserved.
//

import Foundation
import IGListKit

class GraphModel {

    var densityMap: [Int: Double]
    var selectedHour: Int
    let identifier = UUID().uuidString

    init(densityMap: [Int: Double], selectedHour: Int) {
        self.densityMap = densityMap
        self.selectedHour = selectedHour
    }

}

extension GraphModel: ListDiffable {

    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSString
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true }
        guard let object = object as? GraphModel else { return false }
        return object.identifier == identifier
    }

}
