//
//  HoursModel.swift
//  Campus Density
//
//  Created by Matthew Coufal on 3/8/19.
//  Copyright © 2019 Cornell DTI. All rights reserved.
//

import Foundation
import IGListKit

class HoursModel {
    
    var hours: String
    let identifier = UUID().uuidString
    
    init(hours: String) {
        self.hours = hours
    }
    
}

extension HoursModel: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSString
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true }
        guard let object = object as? HoursModel else { return false }
        return object.identifier == identifier
    }
    
}
