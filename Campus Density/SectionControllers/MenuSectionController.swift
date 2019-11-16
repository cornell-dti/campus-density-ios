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

    static func getMenuString(menudata: [String: [String: [String]]]) -> NSMutableAttributedString {
        let res = NSMutableAttributedString(string: "")
        let newLine = NSAttributedString(string: "\n")
        for (meal, categories) in menudata {
            let mealString = NSMutableAttributedString(string: meal)
            mealString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.grayishBrown, range: mealString.mutableString.range(of: meal))
            res.append(mealString)
            res.append(newLine)
            for (category, items) in categories {
                let categoryString = NSMutableAttributedString(string: category)
                categoryString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.densityBlue, range: mealString.mutableString.range(of: category))
                res.append(categoryString)
                res.append(newLine)
                let itemString = NSMutableAttributedString()
                for item in items {
                    itemString.append(NSAttributedString(string: item))
                    itemString.append(newLine)
                }
                res.append(itemString)
                res.append(newLine)
            }
        }
        return res
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.containerSize else { return .zero }
        let menuHeight = MenuSectionController.getMenuString(menudata: menuModel.menu).string.height(withConstrainedWidth: containerSize.width, font: .eighteenBold)
        return CGSize(width: containerSize.width, height: menuHeight)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(of: MenuCell.self, for: self, at: index) as! MenuCell
        cell.configure(with: menuModel!.menu)
        return cell
    }

    override func didUpdate(to object: Any) {
        menuModel = object as? MenuModel
    }

}
