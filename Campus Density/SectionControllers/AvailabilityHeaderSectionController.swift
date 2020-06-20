//
//  AvailabilityHeaderSectionController.swift
//  Campus Density
//
//  Created by Ansh Godha on 20/06/20.
//  Copyright © 2020 Cornell DTI. All rights reserved.
//

import Foundation
import IGListKit

class AvailabilityHeaderSectionController: ListSectionController {

    var headerModel: AvailabilityHeaderModel!
    let headerText = "Availability"

    init(headerModel: AvailabilityHeaderModel) {
        self.headerModel = headerModel
    }

    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.containerSize else { return .zero }
        let textHeight = headerText.height(withConstrainedWidth: containerSize.width - Constants.smallPadding * 2, font: .thirtyBold)
        return CGSize(width: containerSize.width, height: textHeight)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(of: AvailabilityHeaderCell.self, for: self, at: index) as! AvailabilityHeaderCell
        return cell
    }

    override func didUpdate(to object: Any) {
        headerModel = object as? AvailabilityHeaderModel
    }
}
