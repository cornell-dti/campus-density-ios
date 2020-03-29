//
//  GymFiltersModel.swift
//  Campus Density
//
//  Created by Ansh Godha on 29/02/20.
//  Copyright © 2020 Cornell DTI. All rights reserved.
//

import IGListKit
import UIKit

class GymFiltersModel {
    var equipmentTypes: [EquipmentType]
    var selectedEquipmentType: EquipmentType
    let identifier = UUID().uuidString

    init(equipmentTypes: [EquipmentType], selectedEquipmentType: EquipmentType) {
        self.equipmentTypes = equipmentTypes
        self.selectedEquipmentType = selectedEquipmentType
    }
}

extension GymFiltersModel: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSString
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true }
        guard let object = object as? GymFiltersModel else { return false }
        return object.identifier == identifier
    }

}
