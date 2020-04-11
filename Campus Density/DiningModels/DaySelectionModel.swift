//
//  DaySelectionModel.swift
//  Campus Density
//
//  Created by Matthew Coufal on 3/8/19.
//  Copyright © 2019 Cornell DTI. All rights reserved.
//

import Foundation
import IGListKit

class DaySelectionModel {

    var selectedWeekday: Int
    var weekdays: [Int]
    let identifier = UUID().uuidString

    init(selectedWeekday: Int, weekdays: [Int]) {
        self.selectedWeekday = selectedWeekday
        self.weekdays = weekdays
    }

}

extension DaySelectionModel: ListDiffable {

    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSString
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true }
        guard let object = object as? DaySelectionModel else { return false }
        return object.identifier == identifier
    }

}
