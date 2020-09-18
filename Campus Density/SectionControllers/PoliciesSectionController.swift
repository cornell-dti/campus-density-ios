//
//  PoliciesSectionController.swift
//  Campus Density
//
//  Created by Ansh Godha on 18/09/20.
//  Copyright © 2020 Cornell DTI. All rights reserved.
//

import Foundation
import IGListKit

class PolicySectionController: ListSectionController {

    var policiesModel: PoliciesModel!

    let cellHeight: CGFloat = 150

    init(policiesModel: PoliciesModel) {
        self.policiesModel = policiesModel
    }

    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.containerSize else { return .zero }
        return CGSize(width: containerSize.width - 2 * Constants.smallPadding, height: cellHeight)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(of: PoliciesCell.self, for: self, at: index) as! PoliciesCell
        return cell
    }

    override func didUpdate(to object: Any) {
        policiesModel = object as? PoliciesModel
    }

}
