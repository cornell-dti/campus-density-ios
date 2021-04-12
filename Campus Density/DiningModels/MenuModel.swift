//
//  MenuModel.swift
//  Campus Density
//
//  Created by Matthew Coufal on 11/10/19.
//  Copyright © 2019 Cornell DTI. All rights reserved.
//

import Foundation
import IGListKit

class MenuModel {

    let facilityType: FacilityType
    let diningHallMenu: DayMenus! // nil if facilityType == .cafe
    let mealNames: [Meal]! // nil if facilityType == .cafe
    let selectedMeal: Meal
    let cafeMenu: [String]! // nil if facilityType == .diningHall
    let identifier = UUID().uuidString

    init(diningHallMenu: DayMenus, mealNames: [Meal], selectedMeal: Meal) {
        self.facilityType = .diningHall
        self.diningHallMenu = diningHallMenu
        self.mealNames = mealNames
        self.selectedMeal = selectedMeal
        self.cafeMenu = nil
    }

    init(cafeMenu: [String]) {
        self.facilityType = .cafe
        self.diningHallMenu = nil
        self.mealNames = nil
        self.selectedMeal = .none
        self.cafeMenu = cafeMenu
    }

}

extension MenuModel: ListDiffable {

    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSString
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true }
        guard let object = object as? MenuModel else { return false }
        return object.identifier == identifier
    }

}
