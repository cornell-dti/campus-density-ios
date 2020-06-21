//
//  AvailabilityInfoSectionController.swift
//  Campus Density
//
//  Created by Ansh Godha on 14/06/20.
//  Copyright © 2020 Cornell DTI. All rights reserved.
//

import Foundation
import IGListKit

class AvailabilityInfoSectionController: ListSectionController {

    var availabilityModel: AvailabilityInfoModel!
    let cellHeight: CGFloat = 100

    init(availabilityModel: AvailabilityInfoModel) {
        self.availabilityModel = availabilityModel
    }

    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.containerSize else { return .zero }
        return CGSize(width: containerSize.width, height: cellHeight)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(of: AvailabilityInfoCell.self, for: self, at: index) as! AvailabilityInfoCell
        cell.configure(with: availabilityModel.place)
        return cell
    }

    override func didUpdate(to object: Any) {
        availabilityModel = object as? AvailabilityInfoModel
    }

}
