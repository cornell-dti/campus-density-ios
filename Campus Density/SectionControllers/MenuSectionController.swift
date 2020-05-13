//
//  MenuSectionController.swift
//  Campus Density
//
//  Created by Matthew Coufal on 11/10/19.
//  Copyright © 2019 Cornell DTI. All rights reserved.
//

import Foundation
import IGListKit

protocol MenuSectionControllerDelegate: class {
    func menuSectionControllerDidChangeSelectedMeal(meal: Meal)
}

class MenuSectionController: ListSectionController {

    // MARK: - Data vars
    var menuModel: MenuModel!
    var tallestMenu: CGFloat = 0
    weak var delegate: MenuSectionControllerDelegate?

    init(menuModel: MenuModel, delegate: MenuSectionControllerDelegate) {
        super.init()
        self.menuModel = menuModel
        self.delegate = delegate
        tallestMenu = findLongestMenu(menuModel: menuModel)
    }

    func findLongestMenu(menuModel: MenuModel) -> CGFloat {
        guard let containerSize = collectionContext?.containerSize else { return .zero }
        var maxHeight: CGFloat = 0
        let width = containerSize.width - 4 * Constants.smallPadding // 2 each for the exterior cell and interior cell
        for meal in menuModel.mealNames {
            let menuHeight = ceil(MenuInteriorCell.getMenuString(todaysMenu: menuModel.menu, selectedMeal: meal).boundingRect(with: CGSize.init(width: width, height: 0), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).size.height) + 2 * Constants.smallPadding
            maxHeight = CGFloat.maximum(maxHeight, menuHeight)
        }
        return maxHeight
    }

    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.containerSize else { return .zero }
        return CGSize(width: containerSize.width, height: tallestMenu)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(of: MenuCell.self, for: self, at: index) as! MenuCell
        if let index = menuModel.mealNames.index(of: menuModel.selectedMeal) {
            cell.configure(dataSource: self, selected: index, delegate: self)
        }
        return cell
    }

    override func didUpdate(to object: Any) {
        menuModel = object as? MenuModel
        tallestMenu = findLongestMenu(menuModel: menuModel)
    }

}

// For the collection view inside the menu cell, returning interior cells
extension MenuSectionController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuModel.mealNames.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuInteriorCell.identifier, for: indexPath) as! MenuInteriorCell
        let mealName = menuModel.mealNames[indexPath.item]
        cell.configure(with: menuModel!.menu, forMeal: mealName)
        return cell
    }
}

extension MenuSectionController: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index: Int = Int(scrollView.contentOffset.x / scrollView.frame.width)
        menuModel.selectedMeal = self.menuModel.mealNames[index]
        print("Swiped to \(menuModel.selectedMeal)")
        delegate?.menuSectionControllerDidChangeSelectedMeal(meal: menuModel.selectedMeal)
    }
}
