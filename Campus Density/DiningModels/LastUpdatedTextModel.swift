//
//  LastUpdatedTextModel.swift
//  Campus Density
//
//  Created by Changyuan Lin on 6/27/20.
//  Copyright © 2020 Cornell DTI. All rights reserved.
//

import Foundation
import IGListKit

class LastUpdatedTextModel {

    var lastUpdated: Date
    let identifier = UUID().uuidString

    init(lastUpdated: Date) {
        self.lastUpdated = lastUpdated
    }

}

extension LastUpdatedTextModel: ListDiffable {

    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSString
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true }
        guard let object = object as? LastUpdatedTextModel else { return false }
        return object.identifier == identifier
    }

}
