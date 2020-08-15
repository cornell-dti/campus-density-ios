//
//  SearchBarModel.swift
//  Campus Density
//
//  Created by Ansh Godha on 15/08/20.
//  Copyright © 2020 Cornell DTI. All rights reserved.
//

import UIKit
import IGListKit

class SearchBarModel {

    var searchText: String
    let identifier = UUID().uuidString

    init(searchText: String) {
        self.searchText = searchText
    }

}

extension SearchBarModel: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSString
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true }
        guard let object = object as? SearchBarModel else { return false }
        return object.identifier == identifier
    }

}
