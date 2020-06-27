//
//  DetailControllerHeaderSectionController.swift
//  Campus Density
//
//  Created by Ansh Godha on 27/06/20.
//  Copyright © 2020 Cornell DTI. All rights reserved.
//

import Foundation
import IGListKit

class DetailControllerHeaderSectionController: ListSectionController {

    var headerModel: DetailControllerHeaderModel!
    let cellHeight: CGFloat = 70

    init(detailControllerHeaderModel: DetailControllerHeaderModel) {
        headerModel = detailControllerHeaderModel
    }

    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.containerSize else { return .zero }
        return CGSize(width: containerSize.width, height: cellHeight)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(of: DetailControllerHeaderCell.self, for: self, at: index) as! DetailControllerHeaderCell
        cell.configure(with: headerModel.place)
        return cell
    }

    override func didUpdate(to object: Any) {
        headerModel = object as? DetailControllerHeaderModel
    }
}
