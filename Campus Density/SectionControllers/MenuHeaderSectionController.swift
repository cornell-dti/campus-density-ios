//
//  MenuHeaderSectionController.swift
//  Campus Density
//
//  Created by Changyuan Lin on 8/15/20.
//  Copyright © 2020 Cornell DTI. All rights reserved.
//

import Foundation
import IGListKit

class MenuHeaderSectionController: ListSectionController {

    // MARK: - 'Data' vars
    var menuHeaderModel: MenuHeaderModel!

    // MARK: - Constants
    let headerLabelText = "Menus & Hours"
    let detailsLabelText = "Show Details For:"
    let spacing: CGFloat = 5

    init(menuHeaderModel: MenuHeaderModel) {
        self.menuHeaderModel = menuHeaderModel
    }

    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.containerSize else { return .zero }
        var textHeight = headerLabelText.height(withConstrainedWidth: containerSize.width - Constants.smallPadding * 2, font: .twentyFiveBold)
        if menuHeaderModel.showDetails {
            textHeight += detailsLabelText.height(withConstrainedWidth: containerSize.width - Constants.smallPadding * 2, font: .sixteen) + spacing
        }
        return CGSize(width: containerSize.width, height: textHeight)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(of: MenuHeaderCell.self, for: self, at: index) as! MenuHeaderCell
        cell.configure(showDetails: menuHeaderModel.showDetails)
        return cell
    }

    override func didUpdate(to object: Any) {
        menuHeaderModel = object as? MenuHeaderModel
    }

}
