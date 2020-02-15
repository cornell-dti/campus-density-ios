//
//  GymDensitySectionController.swift
//  Campus Density
//
//  Created by Ansh Godha on 15/02/20.
//  Copyright © 2020 Cornell DTI. All rights reserved.
//

import Foundation
import IGListKit

class GymDensitySectionController: ListSectionController {
    var densityModel: GymDensityModel!

    init(densityModel: GymDensityModel) {
        self.densityModel = densityModel
    }

    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.containerSize else { return .zero}
        //let boxHeight = GymDensityCell().boxDimensions!
        return CGSize(width: containerSize.width, height: 200)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(of: GymDensityCell.self, for: self, at: index) as! GymDensityCell
        //TODO: add configure method
        return cell
    }

    override func didUpdate(to object: Any) {
        densityModel = object as? GymDensityModel
    }
}
