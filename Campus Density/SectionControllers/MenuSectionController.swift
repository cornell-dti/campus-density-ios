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
    func menuSectionControllerDidSwipeRightOnMenuLabel()
    func menuSectionControllerDidSwipeLeftOnMenuLabel()
}

class MenuSectionController: ListSectionController {

    // MARK: - Data vars
    var menuModel: MenuModel!
    weak var delegate: MenuSectionControllerDelegate?

    init(menuModel: MenuModel, delegate: MenuSectionControllerDelegate) {
        self.menuModel = menuModel
        self.delegate = delegate
    }

    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.containerSize else { return .zero }
        let menuHeight = MenuCell().getMenuString(todaysMenu: menuModel.menu, selectedMeal: menuModel.selectedMeal).string.height(withConstrainedWidth: containerSize.width, font: .eighteenBold)
        return CGSize(width: containerSize.width, height: menuHeight)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(of: MenuCell.self, for: self, at: index) as! MenuCell
        cell.configure(with: self, delegate: self)
//        cell.configure(with: menuModel!.menu, selectedMeal: menuModel!.selectedMeal, delegate: self)
        // do something here with selected meal
        return cell
    }

    override func didUpdate(to object: Any) {
        menuModel = object as? MenuModel
    }

}

extension MenuSectionController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuModel.mealNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuInteriorCell.identifier, for: indexPath) as! MenuInteriorCell
        let mealName = menuModel.mealNames[indexPath.item]
        print("MEAL NAME: \(mealName)")
        cell.configure(with: menuModel!.menu, forMeal: mealName)
        return cell
    }
}

extension MenuSectionController: MenuCellDelegate {
    func menucelldidSwipeRightOnMenus() {
        delegate?.menuSectionControllerDidSwipeRightOnMenuLabel()
    }

    func menucelldidSwipeLeftOnMenus() {
        delegate?.menuSectionControllerDidSwipeLeftOnMenuLabel()
    }
}
