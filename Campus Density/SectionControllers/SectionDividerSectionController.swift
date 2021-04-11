//
//  SectionDividerSectionController.swift
//  Campus Density
//
//  Created by Mihikaa Goenka on 28/03/21.
//  Copyright © 2021 Cornell DTI. All rights reserved.
//

import Foundation
import IGListKit

class SectionDividerSectionController: ListSectionController {

    // MARK: - Data vars
    var sectionDividerModel: SectionDividerModel!

    init(sectionDividerModel: SectionDividerModel) {
        self.sectionDividerModel = sectionDividerModel
    }

    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.containerSize else { return .zero }
        return CGSize(width: containerSize.width, height: sectionDividerModel.lineWidth)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        return collectionContext?.dequeueReusableCell(of: SectionDividerCell.self, for: self, at: index) as! SectionDividerCell
    }

    override func didUpdate(to object: Any) {
        sectionDividerModel = object as? SectionDividerModel
    }

}
