//
//  HoursSectionController.swift
//  Campus Density
//
//  Created by Matthew Coufal on 3/8/19.
//  Copyright © 2019 Cornell DTI. All rights reserved.
//

import Foundation
import IGListKit

class HoursSectionController: ListSectionController {
    
    // MARK: - Data vars
    var hoursModel: HoursModel!
    
    init(hoursModel: HoursModel) {
        self.hoursModel = hoursModel
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.containerSize else { return .zero }
        let hoursHeight = hoursModel.hours.height(withConstrainedWidth: containerSize.width, font: .eighteenBold)
        return CGSize(width: containerSize.width, height: hoursHeight)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(of: HoursCell.self, for: self, at: index) as! HoursCell
        cell.configure(with: hoursModel.hours)
        return cell
    }
    
    override func didUpdate(to object: Any) {
        hoursModel = object as? HoursModel
    }
    
}
