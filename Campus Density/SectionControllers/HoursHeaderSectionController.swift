//
//  HoursHeaderSectionController.swift
//  Campus Density
//
//  Created by Matthew Coufal on 3/8/19.
//  Copyright © 2019 Cornell DTI. All rights reserved.
//

import Foundation
import IGListKit

class HoursHeaderSectionController: ListSectionController {

    // MARK: - Data vars
    var hoursHeaderModel: HoursHeaderModel!

    init(hoursHeaderModel: HoursHeaderModel) {
        self.hoursHeaderModel = hoursHeaderModel
    }

    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.containerSize else { return .zero }
        let weekdayHeight = hoursHeaderModel.weekday.height(withConstrainedWidth: containerSize.width, font: .twentyBold)
        let dateHeight = hoursHeaderModel.date.height(withConstrainedWidth: containerSize.width, font: .sixteenBold)
        return CGSize(width: containerSize.width, height: weekdayHeight + dateHeight)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(of: HoursHeaderCell.self, for: self, at: index) as! HoursHeaderCell
        cell.configure(weekday: hoursHeaderModel.weekday, date: hoursHeaderModel.date)
        return cell
    }

    override func didUpdate(to object: Any) {
        hoursHeaderModel = object as? HoursHeaderModel
    }

}
