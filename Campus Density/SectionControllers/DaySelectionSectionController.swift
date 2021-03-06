//
//  DaySelectionSectionController.swift
//  Campus Density
//
//  Created by Matthew Coufal on 3/8/19.
//  Copyright © 2019 Cornell DTI. All rights reserved.
//

import Foundation
import IGListKit

protocol DaySelectionSectionControllerDelegate: class {

    func daySelectionSectionControllerDidSelectWeekday(selectedWeekday: Int)

}

class DaySelectionSectionController: ListSectionController {

    // MARK: - Data vars
    var daySelectionModel: DaySelectionModel!
    weak var delegate: DaySelectionSectionControllerDelegate?

    init(daySelectionModel: DaySelectionModel, delegate: DaySelectionSectionControllerDelegate) {
        self.daySelectionModel = daySelectionModel
        self.delegate = delegate
    }

    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.containerSize else { return .zero }
        let buttonHeight = (containerSize.width - Constants.smallPadding - CGFloat(daySelectionModel.weekdays.count + 1) * Constants.smallPadding / 2) / CGFloat(daySelectionModel.weekdays.count) * 1.5
        return CGSize(width: containerSize.width, height: buttonHeight)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(of: DaySelectionCell.self, for: self, at: index) as! DaySelectionCell
        cell.configure(weekdays: daySelectionModel.weekdays, selectedWeekday: daySelectionModel.selectedWeekday, delegate: self)
        return cell
    }

    override func didUpdate(to object: Any) {
        daySelectionModel = object as? DaySelectionModel
    }

}

extension DaySelectionSectionController: DaySelectionCellDelegate {

    func daySelectionCellDidSelectWeekday(selectedWeekday: Int) {
        delegate?.daySelectionSectionControllerDidSelectWeekday(selectedWeekday: selectedWeekday)
    }

}
