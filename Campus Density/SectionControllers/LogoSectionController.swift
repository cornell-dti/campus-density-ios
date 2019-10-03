//
//  LogoSectionController.swift
//  Campus Density
//
//  Created by Matthew Coufal on 3/24/19.
//  Copyright © 2019 Cornell DTI. All rights reserved.
//

import Foundation
import IGListKit

protocol LogoSectionControllerDelegate: class {

    func logoSectionControllerDidTapLink(logoModel: LogoModel)

}

class LogoSectionController: ListSectionController {

    // MARK: - Data vars
    var logoModel: LogoModel!
    weak var delegate: LogoSectionControllerDelegate?

    init(logoModel: LogoModel, delegate: LogoSectionControllerDelegate?) {
        self.logoModel = logoModel
        self.delegate = delegate
    }

    override func sizeForItem(at index: Int) -> CGSize {
        guard let containerSize = collectionContext?.containerSize else { return .zero }
        return CGSize(width: containerSize.width, height: logoModel.length)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(of: LogoCell.self, for: self, at: index) as! LogoCell
        cell.configure(logoModel: logoModel, delegate: self)
        return cell
    }

}

extension LogoSectionController: LogoCellDelegate {

    func logoCellDidTapLink() {
        delegate?.logoSectionControllerDidTapLink(logoModel: logoModel)
    }

}
