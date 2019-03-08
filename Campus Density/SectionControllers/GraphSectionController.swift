//
//  GraphSectionController.swift
//  Campus Density
//
//  Created by Matthew Coufal on 3/8/19.
//  Copyright © 2019 Cornell DTI. All rights reserved.
//

import Foundation
import IGListKit

protocol GraphSectionControllerDelegate: class {
    
    func graphSectionControllerDidSelectHour(selectedHour: Int)
    
}

class GraphSectionController: ListSectionController {
    
    // MARK: - Data vars
    var graphModel: GraphModel!
    weak var delegate: GraphSectionControllerDelegate?
    
    // MARK: - Constants
    let cellHeight: CGFloat = 277
    
    init(graphModel: GraphModel, delegate: GraphSectionControllerDelegate) {
        self.graphModel = graphModel
        self.delegate = delegate
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.containerSize else { return .zero }
        return CGSize(width: containerSize.width, height: cellHeight)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(of: GraphCell.self, for: self, at: index) as! GraphCell
        cell.configure(description: graphModel.description, densityMap: graphModel.densityMap, selectedHour: graphModel.selectedHour, delegate: self)
        return cell
    }
    
    override func didUpdate(to object: Any) {
        graphModel = object as? GraphModel
    }
    
}

extension GraphSectionController: GraphCellDelegate {
    
    func graphCellDidSelectHour(selectedHour: Int) {
        delegate?.graphSectionControllerDidSelectHour(selectedHour: selectedHour)
    }
    
}
