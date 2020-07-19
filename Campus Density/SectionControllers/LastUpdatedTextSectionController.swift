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

    // MARK: - Constants
    let cellHeight: CGFloat = 20

    init(lastUpdatedTextModel: LastUpdatedTextModel) {
        self.lastUpdatedTextModel = lastUpdatedTextModel
    }

    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.containerSize else { return .zero }
        return CGSize(width: containerSize.width, height: cellHeight)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(of: LastUpdatedTextCell.self, for: self, at: index) as! LastUpdatedTextCell
        cell.configure(lastUpdatedDate: lastUpdatedTextModel.lastUpdated)
        return cell
    }

    override func didUpdate(to object: Any) {
        lastUpdatedTextModel = object as? LastUpdatedTextModel
    }

}
