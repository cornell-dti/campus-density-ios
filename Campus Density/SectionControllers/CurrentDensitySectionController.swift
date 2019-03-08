//
//  CurrentDensitySectionController.swift
//  Campus Density
//
//  Created by Matthew Coufal on 3/8/19.
//  Copyright © 2019 Cornell DTI. All rights reserved.
//

import Foundation
import IGListKit

class CurrentDensitySectionController: ListSectionController {
    
    // MARK: - Data vars
    var currentDensityModel: CurrentDensityModel!
    
    // MARK: - Constants
    let cellHeight: CGFloat = 90
    
    init(currentDensityModel: CurrentDensityModel) {
        self.currentDensityModel = currentDensityModel
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.containerSize else { return .zero }
        return CGSize(width: containerSize.width, height: cellHeight)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(of: CurrentDensityCell.self, for: self, at: index) as! CurrentDensityCell
        cell.configure(with: currentDensityModel.place)
        return cell
    }
    
    override func didUpdate(to object: Any) {
        currentDensityModel = object as? CurrentDensityModel
    }
    
}
