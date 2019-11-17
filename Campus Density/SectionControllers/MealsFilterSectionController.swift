//
//  MealsFilterSectionController.swift
//  Campus Density
//
//  Created by Ashneel  Das on 11/16/19.
//  Copyright © 2019 Cornell DTI. All rights reserved.
//

import Foundation
import IGListKit

protocol MealsFilterSectionControllerDelegate : class {
    func menuFilterViewDidSelectFilter(selectedMeal: Meal)
}

class MealsFilterSectionController: ListSectionController {

    // MARK: - Data vars
    var mealModel: MealFiltersModel!
    weak var delegate: MealsFilterSectionControllerDelegate?

    // MARK: - Constants
    let cellHeight: CGFloat = 50

    init(mealModel: MealFiltersModel, delegate: MealsFilterSectionControllerDelegate) {
        self.mealModel = mealModel
        self.delegate = delegate
    }

    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.containerSize else { return .zero }
        return CGSize(width: containerSize.width, height: cellHeight)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(of: MealFilterCell.self, for: self, at: index) as! MealFilterCell
        cell.configure(mealModel: mealModel, delegate: self)
        return cell
    }

    override func didUpdate(to object: Any) {
        mealModel = object as? MealFiltersModel
    }

}

extension MealsFilterSectionController: MealFilterCellDelegate {
    func mealFilterCellDidSelectFilter(selectedMeal: Meal) {
        
        delegate?.menuFilterViewDidSelectFilter(selectedMeal: selectedMeal)
    }

}
