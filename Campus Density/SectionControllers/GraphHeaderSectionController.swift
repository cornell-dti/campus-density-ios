//
//  GraphHeaderSectionController.swift
//  Campus Density
//
//  Created by Matthew Coufal on 3/8/19.
//  Copyright © 2019 Cornell DTI. All rights reserved.
//

import Foundation
import IGListKit

protocol GraphHeaderSectionControllerDelegate: class {
    
    func graphHeaderSectionControllerDidSelectWeekday(selectedWeekday: Int)
    
}

class GraphHeaderSectionController: ListSectionController {
    
    // MARK: - Data vars
    var graphHeaderModel: GraphHeaderModel!
    weak var delegate: GraphHeaderSectionControllerDelegate?
    
    // MARK: - Constants
    let headerText = "Popular Times"
    
    init(graphHeaderModel: GraphHeaderModel, delegate: GraphHeaderSectionControllerDelegate) {
        self.graphHeaderModel = graphHeaderModel
        self.delegate = delegate
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.containerSize else { return .zero }
        let buttonHeight = (containerSize.width - CGFloat(graphHeaderModel.weekdays.count + 1) * Constants.smallPadding) / CGFloat(graphHeaderModel.weekdays.count)
        let textHeight = headerText.height(withConstrainedWidth: containerSize.width - Constants.smallPadding * 2, font: .thirtyBold)
        return CGSize(width: containerSize.width, height: buttonHeight + textHeight + Constants.smallPadding)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(of: GraphHeaderCell.self, for: self, at: index) as! GraphHeaderCell
        cell.configure(weekdays: graphHeaderModel.weekdays, selectedWeekday: graphHeaderModel.selectedWeekday, delegate: self)
        return cell
    }
    
    override func didUpdate(to object: Any) {
        graphHeaderModel = object as? GraphHeaderModel
    }
    
}

extension GraphHeaderSectionController: GraphHeaderCellDelegate {
    
    func graphHeaderCellDidSelectWeekday(selectedWeekday: Int) {
        delegate?.graphHeaderSectionControllerDidSelectWeekday(selectedWeekday: selectedWeekday)
    }
    
}
