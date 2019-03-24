//
//  FiltersModel.swift
//  Campus Density
//
//  Created by Matthew Coufal on 3/24/19.
//  Copyright © 2019 Cornell DTI. All rights reserved.
//

import Foundation
import IGListKit

class FiltersModel {
    
    var filters: [Filter]
    var selectedFilter: Filter
    let identifier = UUID().uuidString
    
    init(filters: [Filter], selectedFilter: Filter) {
        self.filters = filters
        self.selectedFilter = selectedFilter
    }
    
}

extension FiltersModel: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSString
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true }
        guard let filtersModel = object as? FiltersModel else { return false }
        return filtersModel.identifier == identifier
    }
    
}
