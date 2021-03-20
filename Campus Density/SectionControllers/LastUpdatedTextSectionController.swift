//
//  LastUpdatedTextSectionController.swift
//  Campus Density
//
//  Created by Changyuan Lin on 6/27/20.
//  Copyright © 2020 Cornell DTI. All rights reserved.
//

import Foundation
import IGListKit

class LastUpdatedTextSectionController: ListSectionController {

    enum Style {
        case main
        case detail
    }

    // MARK: - 'Data' vars
    var lastUpdatedTextModel: LastUpdatedTextModel!
    var style: Style

    // MARK: - Constants
    let cellHeight: CGFloat = 20

    init(lastUpdatedTextModel: LastUpdatedTextModel, style: Style) {
        self.lastUpdatedTextModel = lastUpdatedTextModel
        self.style = style
    }

    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.containerSize else { return .zero }
        return CGSize(width: containerSize.width, height: cellHeight)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(of: LastUpdatedTextCell.self, for: self, at: index) as! LastUpdatedTextCell
        cell.configure(lastUpdatedDate: lastUpdatedTextModel.lastUpdated, style: style)
        return cell
    }

    override func didUpdate(to object: Any) {
        lastUpdatedTextModel = object as? LastUpdatedTextModel
    }

}
