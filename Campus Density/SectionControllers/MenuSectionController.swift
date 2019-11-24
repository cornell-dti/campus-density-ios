//
//  MenuSectionController.swift
//  Campus Density
//
//  Created by Matthew Coufal on 11/10/19.
//  Copyright © 2019 Cornell DTI. All rights reserved.
//

import Foundation
import IGListKit

class MenuSectionController: ListSectionController {

    // MARK: - Data vars
    var menuModel: MenuModel!

    init(menuModel: MenuModel) {
        self.menuModel = menuModel
    }

    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.containerSize else { return .zero }
        let menuHeight = MenuCell().getMenuString(todaysMenu: menuModel.menu, selectedMeal: menuModel.selectedMeal).string.height(withConstrainedWidth: containerSize.width, font: .eighteenBold)
        return CGSize(width: containerSize.width, height: menuHeight)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(of: MenuCell.self, for: self, at: index) as! MenuCell
        cell.configure(with: menuModel!.menu, selectedMeal: menuModel!.selectedMeal)
        return cell
    }

    override func didUpdate(to object: Any) {
        menuModel = object as? MenuModel
    }

}
