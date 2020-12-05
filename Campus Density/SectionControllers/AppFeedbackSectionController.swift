//
//  AppFeedbackSectionController.swift
//  Campus Density
//
//  Created by Mihikaa Goenka on 05/12/20.
//  Copyright © 2020 Cornell DTI. All rights reserved.
//

import Foundation
import IGListKit

protocol AppFeedbackSectionControllerDelegate: class {

    func appFeedbackSectionControllerDidTapLink()

}

class AppFeedbackSectionController: ListSectionController {

    // MARK: - 'Data' vars
    var appFeedbackModel: AppFeedbackModel!
    weak var delegate: AppFeedbackSectionControllerDelegate?

    // MARK: - Constants
    let cellHeight: CGFloat = 20

    init(appFeedbackModel: AppFeedbackModel, delegate: AppFeedbackSectionControllerDelegate) {
        self.appFeedbackModel = appFeedbackModel
        self.delegate = delegate
    }

    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.containerSize else { return .zero }
        return CGSize(width: containerSize.width, height: cellHeight)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(of: AppFeedbackCell.self, for: self, at: index) as! AppFeedbackCell
        cell.configure(delegate: self)
        return cell
    }

    override func didUpdate(to object: Any) {
        appFeedbackModel = object as? AppFeedbackModel
    }

}

extension AppFeedbackSectionController: AppFeedbackCellDelegate {

    func appFeedbackCellDidTapLink() {
        delegate?.appFeedbackSectionControllerDidTapLink()
    }

}
