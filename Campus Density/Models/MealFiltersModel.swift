//
//  MealFiltersModel.swift
//  Campus Density
//
//  Created by Ansh Godha on 16/11/19.
//  Copyright © 2019 Cornell DTI. All rights reserved.
//

import UIKit
import IGListKit

class MealFiltersModel {

    var meals: [Meal]
    var selectedMeal: Meal
    let identifier = UUID().uuidString

    init(meals: [Meal], selectedMeal: Meal) {
        self.meals = meals
        self.selectedMeal = selectedMeal
    }

}

extension MealFiltersModel: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSString
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true }
        guard let object = object as? MealFiltersModel else { return false }
        return object.identifier == identifier
    }

}
