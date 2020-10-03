//
//  SectionDividerModel.swift
//  Campus Density
//
//  Created by Mihikaa Goenka on 9/29/20.
//  Copyright © 2020 Cornell DTI. All rights reserved.
//

import Foundation
import IGListKit

class SectionDividerModel {
    
    var lineWidth: CGFloat
    let identifier = UUID().uuidString
    
    init(lineWidth: CGFloat) {
        self.lineWidth = lineWidth
    }
    
}

extension SectionDividerModel: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSString
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true }
        guard let object = object as? SectionDividerModel else { return false }
        return object.identifier == identifier
    }
    
}
