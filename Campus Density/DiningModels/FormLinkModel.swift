//
//  FormLinkModel.swift
//  Campus Density
//
//  Created by Matthew Coufal on 3/8/19.
//  Copyright © 2019 Cornell DTI. All rights reserved.
//

import Foundation
import IGListKit

class FormLinkModel {

    var feedbackForm: String
    let identifier = UUID().uuidString

    init(feedbackForm: String) {
        self.feedbackForm = feedbackForm
    }

}

extension FormLinkModel: ListDiffable {

    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSString
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true }
        guard let object = object as? FormLinkModel else { return false }
        return object.identifier == identifier
    }

}
