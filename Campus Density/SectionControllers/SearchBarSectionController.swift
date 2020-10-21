//
//  SearchBarSectionController.swift
//  Campus Density
//
//  Created by Ansh Godha on 16/08/20.
//  Copyright © 2020 Cornell DTI. All rights reserved.
//

import Foundation
import IGListKit

protocol SearchBarSectionControllerDelegate: class {
    func searchBarDidUpdateSearchText(searchText: String)
}

class SearchBarSectionController: ListSectionController {

    var searchBarModel: SearchBarModel!
    weak var delegate: SearchBarSectionControllerDelegate?

    let cellHeight: CGFloat = 40

    init(searchBarModel: SearchBarModel, delegate: SearchBarSectionControllerDelegate) {
        self.searchBarModel = searchBarModel
        self.delegate = delegate
    }

    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.containerSize else { return .zero }
        return CGSize(width: containerSize.width, height: cellHeight)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(of: SearchBarCell.self, for: self, at: index) as! SearchBarCell
        cell.configure(delegate: self)
        return cell
    }

    override func didUpdate(to object: Any) {
        searchBarModel = object as? SearchBarModel
    }

}

extension SearchBarSectionController: SearchBarCellDelegate {
    func searchBarCellDidUpdateSearchText(searchText: String) {
        delegate?.searchBarDidUpdateSearchText(searchText: searchText)
    }
}
