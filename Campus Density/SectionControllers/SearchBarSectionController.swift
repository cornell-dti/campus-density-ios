//
//  SearchBarSectionController.swift
//  Campus Density
//
//  Created by Ansh Godha on 16/08/20.
//  Copyright © 2020 Cornell DTI. All rights reserved.
//

import Foundation
import IGListKit

class SearchBarSectionController: ListSectionController {

    var searchBarModel: SearchBarModel!

    let cellHeight: CGFloat = 40

    init(searchBarModel: SearchBarModel) {
        self.searchBarModel = searchBarModel
    }

    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.containerSize else { return .zero }
        return CGSize(width: containerSize.width, height: cellHeight)
    }

//    override func cellForItem(at index: Int) -> UICollectionViewCell {
//        <#code#>
//    }
}
