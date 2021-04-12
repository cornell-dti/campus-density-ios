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
    let unavailableText = "No menus available"

    init(menuModel: MenuModel, delegate: MenuSectionControllerDelegate) {
        super.init()
        self.menuModel = menuModel
        self.delegate = delegate
        tallestMenu = findLongestMenu(menuModel: menuModel)
    }

    func findLongestMenu(menuModel: MenuModel) -> CGFloat {
        var maxHeight: CGFloat = 0
        switch menuModel.facilityType {
        case .diningHall:
            for menu in menuModel.diningHallMenu.menus {
                let menuHeight = heightForDiningHallMenu(menuData: menu)
                maxHeight = CGFloat.maximum(maxHeight, menuHeight)
            }
        case .cafe:
            maxHeight = 100 // TODO find cafe menu height
        }
        return maxHeight
    }

    /// The height of the menu cell for a specific `Meal`
    func heightForDiningHallMenu(menuData: MenuData) -> CGFloat {
        guard let containerSize = collectionContext?.containerSize else { return .zero }
        let width = containerSize.width - 2 * Constants.smallPadding
        let menuHeight = ceil(DiningHallMenuInteriorCell.getMenuString(menuData: menuData).boundingRect(with: CGSize.init(width: width, height: 0), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).size.height)
        return menuHeight
    }

    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.containerSize else { return .zero }
        switch menuModel.facilityType {
        case .diningHall:
            let meal = menuModel.selectedMeal
            if meal == .none {
                return CGSize(width: containerSize.width, height: unavailableText.height(withConstrainedWidth: containerSize.width, font: .eighteenBold))
            } else {
                return CGSize(width: containerSize.width, height: tallestMenu + (DiningHallMenuInteriorCell.hoursLabelHeight + Constants.smallPadding)) // use heightForMenu() to change size every time
            }
        case .cafe:
            return CGSize(width: containerSize.width, height: tallestMenu + Constants.smallPadding)
        }
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(of: DiningHallMenuCell.self, for: self, at: index) as! DiningHallMenuCell
        if let index = menuModel.mealNames.index(of: menuModel.selectedMeal) {
            cell.configure(dataSource: self, selected: index, delegate: self)
        } else {
            cell.configureAsNoMenus()
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiningHallMenuInteriorCell.identifier, for: indexPath) as! DiningHallMenuInteriorCell
        let mealName = menuModel.mealNames[indexPath.item]
        let specificMenu = menuModel.diningHallMenu.menus.first(where: { $0.description == mealName.rawValue })!
        cell.configure(menuData: specificMenu)
        return cell
    }
}

extension MenuSectionController: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index: Int = Int(scrollView.contentOffset.x / scrollView.frame.width)
        let selectedMeal = self.menuModel.mealNames[index]
        print("Swiped to \(selectedMeal)")
        delegate?.menuSectionControllerDidChangeSelectedMeal(meal: selectedMeal)
    }
}
