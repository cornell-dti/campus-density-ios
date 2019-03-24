//
//  FiltersSectionController.swift
//  Campus Density
//
//  Created by Matthew Coufal on 3/24/19.
//  Copyright © 2019 Cornell DTI. All rights reserved.
//

import Foundation
import IGListKit

protocol FiltersSectionControllerDelegate: class {
    
    func filtersSectionControllerDidSelectFilter(selectedFilter: Filter)
    
}

class FiltersSectionController: ListSectionController {
    
    // MARK: - Data vars
    var filtersModel: FiltersModel!
    weak var delegate: FiltersSectionControllerDelegate?
    
    // MARK: - Constants
    let cellHeight: CGFloat = 50
    
    init(filtersModel: FiltersModel, delegate: FiltersSectionControllerDelegate) {
        self.filtersModel = filtersModel
        self.delegate = delegate
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.containerSize else { return .zero }
        return CGSize(width: containerSize.width, height: cellHeight)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(of: FiltersCell.self, for: self, at: index) as! FiltersCell
        cell.configure(filtersModel: filtersModel, delegate: self)
        return cell
    }
    
    override func didUpdate(to object: Any) {
        filtersModel = object as? FiltersModel
    }
    
}

extension FiltersSectionController: FiltersCellDelegate {
    
    func filtersCellDidSelectFilter(selectedFilter: Filter) {
        delegate?.filtersSectionControllerDidSelectFilter(selectedFilter: selectedFilter)
    }
    
}
