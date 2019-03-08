//
//  SpaceSectionController.swift
//  Campus Density
//
//  Created by Matthew Coufal on 3/8/19.
//  Copyright © 2019 Cornell DTI. All rights reserved.
//

import Foundation
import IGListKit

class SpaceSectionController: ListSectionController {
    
    // MARK: - Data vars
    var spaceModel: SpaceModel!
    
    init(spaceModel: SpaceModel) {
        self.spaceModel = spaceModel
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.containerSize else { return .zero }
        return CGSize(width: containerSize.width, height: spaceModel.space)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        return collectionContext?.dequeueReusableCell(of: SpaceCell.self, for: self, at: index) as! SpaceCell
    }
    
    override func didUpdate(to object: Any) {
        spaceModel = object as? SpaceModel
    }
    
}
