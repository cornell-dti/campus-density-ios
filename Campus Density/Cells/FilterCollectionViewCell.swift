//
//  FilterCollectionViewCell.swift
//  Campus Density
//
//  Created by Matthew Coufal on 10/25/18.
//  Copyright © 2018 Cornell DTI. All rights reserved.
//

import UIKit

protocol FilterCollectionViewCellDelegate {
    func filterCollectionViewCellDidTapFilterButton(selectedFilter: Filter)
}

class FilterCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Data vars
    var delegate: FilterCollectionViewCellDelegate!
    var filter: Filter!
    var isSelectedFilter: Bool!
    
    // MARK: - View vars
    var filterButton: UIButton!
    
    // MARK: - Constants
    let filterButtonHeight: CGFloat = 35
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        filterButton = UIButton()
        filterButton.addTarget(self, action: #selector(filterButtonPressed), for: .touchUpInside)
        filterButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        filterButton.clipsToBounds = true
        filterButton.layer.cornerRadius = filterButtonHeight / 2
        filterButton.titleLabel?.font = .eighteen
        addSubview(filterButton)
        
        filterButton.snp.makeConstraints { make in
            make.center.width.equalToSuperview()
            make.height.equalTo(filterButtonHeight)
        }
        
    }
    
    @objc func filterButtonPressed() {
        delegate.filterCollectionViewCellDidTapFilterButton(selectedFilter: filter)
    }
    
    func filterLabel() -> String {
        switch filter! {
        case .all:
            return "All"
        case .central:
            return "Central"
        case .north:
            return "North"
        case .west:
            return "West"
        case .density(let type):
            switch type {
            case .noSpots:
                return "No spots"
            case .fewSpots:
                return "Few spots"
            case .someSpots:
                return "Some spots"
            case .manySpots:
                return "Many spots"
            }
        }
    }
    
    func configure(with filter: Filter, isSelectedFilter: Bool) {
        self.filter = filter
        self.isSelectedFilter = isSelectedFilter
        filterButton.setTitle(filterLabel(), for: .normal)
        
        if isSelectedFilter {
            filterButton.backgroundColor = .densityBlue
            filterButton.setTitleColor(.white, for: .normal)
            filterButton.layer.borderColor = nil
            filterButton.layer.borderWidth = 0
        } else {
            filterButton.backgroundColor = .white
            filterButton.setTitleColor(.densityBlue, for: .normal)
            filterButton.layer.borderColor = UIColor.densityBlue.cgColor
            filterButton.layer.borderWidth = 1
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
