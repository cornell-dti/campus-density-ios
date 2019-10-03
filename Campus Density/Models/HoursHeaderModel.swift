//
//  HoursHeaderModel.swift
//  Campus Density
//
//  Created by Matthew Coufal on 3/8/19.
//  Copyright © 2019 Cornell DTI. All rights reserved.
//

import Foundation
import IGListKit

class HoursHeaderModel {

    var weekday: String
    var date: String
    let identifier = UUID().uuidString

    init(weekday: String, date: String) {
        self.weekday = weekday
        self.date = date
    }

}

extension HoursHeaderModel: ListDiffable {

    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSString
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true }
        guard let object = object as? HoursHeaderModel else { return false }
        return object.identifier == identifier
    }

}
