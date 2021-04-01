//
//  PlaceModel.swift
//  Campus Density
//
//  Created by Changyuan Lin on 3/20/21.
//  Copyright © 2021 Cornell DTI. All rights reserved.
//

import IGListKit

class PlaceModel {

    let id: String
    let displayName: String
    let density: Density
    let waitTime: Double?
    let isClosed: Bool

    init(place: Place) {
        self.id = place.id
        self.displayName = place.displayName
        self.density = place.density
        self.waitTime = place.waitTime
        self.isClosed = place.isClosed
    }

}

extension PlaceModel: ListDiffable {

    func diffIdentifier() -> NSObjectProtocol {
        return id as NSString
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? PlaceModel else { return false }
        return object.id == id
            && object.displayName == displayName
            && object.density == density
            && object.waitTime == waitTime
            && object.isClosed == isClosed
    }

}
