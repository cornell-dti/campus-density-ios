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
        print("New search model with text: \(searchText)")
        self.searchText = searchText
    }

}

extension SearchBarModel: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        print("Asking for identifier \(searchText)")
        return searchText as NSString
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        print("Trying to find if this is equal")
        if self === object { return true }
        guard let object = object as? SearchBarModel else { return false }
        let isSame = object.searchText == searchText
        print("Is this the same search model? \(isSame)")
        return isSame
    }

}
