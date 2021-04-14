//
//  AppFeedbackModel.swift
//  Campus Density
//
//  Created by Mihikaa Goenka on 05/12/20.
//  Copyright © 2020 Cornell DTI. All rights reserved.
//

import Foundation
import IGListKit

class AppFeedbackModel {

    let identifier = UUID().uuidString

}

extension AppFeedbackModel: ListDiffable {

    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSString
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true }
        guard let object = object as? AppFeedbackModel else { return false }
        return object.identifier == identifier
    }

}
