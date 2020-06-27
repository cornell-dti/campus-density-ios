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

    // MARK: - 'Data' vars
    var lastUpdatedTextModel: LastUpdatedTextModel!

    init(lastUpdatedTextModel: LastUpdatedTextModel) {
        self.lastUpdatedTextModel = lastUpdatedTextModel
    }

    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.containerSize else { return .zero }
//        let textHeight = headerText.height(withConstrainedWidth: containerSize.width - Constants.smallPadding * 2, font: .thirtyBold)
        let textHeight = Constants.mediumPadding
        return CGSize(width: containerSize.width, height: textHeight)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(of: GraphHeaderCell.self, for: self, at: index) as! GraphHeaderCell
        // cell configure
        return cell
    }

    override func didUpdate(to object: Any) {
        lastUpdatedTextModel = object as? LastUpdatedTextModel
    }

}
