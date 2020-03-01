//
//  GymFiltersSectionController.swift
//  Campus Density
//
//  Created by Ansh Godha on 29/02/20.
//  Copyright © 2020 Cornell DTI. All rights reserved.
//

import Foundation
import IGListKit

protocol GymFiltersSectionControllerDelegate: class {
    func gymFilterViewDidSelectEquipment(selectedEquipmentType: EquipmentType)
}

class GymFilterSectionController: ListSectionController {
    var gymFilterModel: GymFiltersModel!
    weak var delegate: GymFiltersSectionControllerDelegate?
    
    let cellHeight: CGFloat = 50
    
    init(equipmentModel: GymFiltersModel, delegate: GymFiltersSectionControllerDelegate) {
        self.gymFilterModel = equipmentModel
        self.delegate = delegate
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(of: GymFilterCell.self, for: self, at: index) as! GymFilterCell
        cell.configure(gymFilterModel: gymFilterModel, delegate: self)
        return cell
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.containerSize else { return .zero }
        return CGSize(width: containerSize.width, height: cellHeight)
    }
    
    override func didUpdate(to object: Any) {
        print("updated")
        gymFilterModel = object as? GymFiltersModel
    }
}

extension GymFilterSectionController: GymFilterCellDelegate {
    func gymFilterCellDidSelectFilter(selectedEquipmentType: EquipmentType) {
        delegate?.gymFilterViewDidSelectEquipment(selectedEquipmentType: selectedEquipmentType)
    }
}
