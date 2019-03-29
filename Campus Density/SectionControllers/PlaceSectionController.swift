//
//  PlaceSectionController.swift
//  Campus Density
//
//  Created by Matthew Coufal on 3/24/19.
//  Copyright © 2019 Cornell DTI. All rights reserved.
//

import Foundation
import IGListKit

protocol PlaceSectionControllerDelegate: class {
    
    func placeSectionControllerDidSelectPlace(place: Place)
    
}

class PlaceSectionController: ListSectionController {
    
    // MARK: - Data vars
    var place: Place!
    weak var delegate: PlaceSectionControllerDelegate?
    
    // MARK: - Constants
    let labelHeight: CGFloat = 20
    let cellHeight: CGFloat = 105
    let cellAnimationDuration: TimeInterval = 0.2
    let cellScale: CGFloat = 0.95
    
    init(place: Place, delegate: PlaceSectionControllerDelegate) {
        self.place = place
        self.delegate = delegate
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.containerSize else { return .zero }
        let densityWidth = interpretDensity(place: place).widthWithConstrainedHeight(labelHeight, font: .fourteen)
        let nameWidth = containerSize.width - Constants.smallPadding * 4 - densityWidth - 5
        let nameHeight = place.displayName.height(withConstrainedWidth: nameWidth, font: .sixteenBold)
        return CGSize(width: containerSize.width, height: Constants.smallPadding * 4 + Constants.mediumPadding + nameHeight)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(of: PlaceCell.self, for: self, at: index) as! PlaceCell
        cell.configure(with: place)
        return cell
    }
    
    override func didSelectItem(at index: Int) {
        delegate?.placeSectionControllerDidSelectPlace(place: place)
    }
    
    override func didHighlightItem(at index: Int) {
        let cell = collectionContext?.cellForItem(at: index, sectionController: self) as! PlaceCell
        UIView.animate(withDuration: cellAnimationDuration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            cell.transform = CGAffineTransform(scaleX: self.cellScale, y: self.cellScale)
        }, completion: nil)
    }
    
    override func didUnhighlightItem(at index: Int) {
        let cell = collectionContext?.cellForItem(at: index, sectionController: self) as! PlaceCell
        UIView.animate(withDuration: cellAnimationDuration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            cell.transform = .identity
        }, completion: nil)
    }
    
    override func didUpdate(to object: Any) {
        place = object as? Place
    }
    
}
