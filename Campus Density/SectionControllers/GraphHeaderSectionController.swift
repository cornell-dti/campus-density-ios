//
//  GraphHeaderSectionController.swift
//  Campus Density
//
//  Created by Changyuan Lin on 4/11/20.
//  Copyright © 2020 Cornell DTI. All rights reserved.
//

import Foundation
import IGListKit

class GraphHeaderSectionController: ListSectionController {

    // MARK: - 'Data' vars
    var graphHeaderModel: GraphHeaderModel!

    // MARK: - Constants
    let headerText = "Popular Times"

    init(graphHeaderModel: GraphHeaderModel) {
        self.graphHeaderModel = graphHeaderModel
    }

    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.containerSize else { return .zero }
        let textHeight = headerText.height(withConstrainedWidth: containerSize.width - Constants.smallPadding * 2, font: .thirtyBold)
        return CGSize(width: containerSize.width, height: textHeight)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(of: GraphHeaderCell.self, for: self, at: index) as! GraphHeaderCell
        return cell
    }

    override func didUpdate(to object: Any) {
        graphHeaderModel = object as? GraphHeaderModel
    }

}
