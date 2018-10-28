//
//  EateriesViewController+Extension.swift
//  Campus Density
//
//  Created by Matthew Coufal on 10/14/18.
//  Copyright © 2018 Cornell DTI. All rights reserved.
//

import UIKit

extension EateriesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return facilities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "eateries", for: indexPath) as? FacilityTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.configure(with: facilities[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return facilityTableViewCellHeight
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? FacilityTableViewCell else { return }
        UIView.animate(withDuration: cellAnimationDuration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            cell.transform = CGAffineTransform(scaleX: self.cellScale, y: self.cellScale)
        }, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? FacilityTableViewCell else { return }
        UIView.animate(withDuration: cellAnimationDuration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            cell.transform = .identity
        }, completion: nil)
    }
    
}

extension EateriesViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = filtersCollectionView.dequeueReusableCell(withReuseIdentifier: "filters", for: indexPath) as? FilterCollectionViewCell else { return UICollectionViewCell() }
        let filter = filters[indexPath.row]
        cell.configure(with: filter, isSelectedFilter: filter == selectedFilter)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let filter = filters[indexPath.row]
        let width = filter.widthWithConstrainedHeight(filtersCollectionViewHeight, font: .eighteen) + filterCollectionViewCellHorizontalPadding * 2
        return CGSize(width: width, height: filtersCollectionViewHeight)
    }
    
}

extension String {
    
    func widthWithConstrainedHeight(_ height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
        
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
}

extension EateriesViewController: FilterCollectionViewCellDelegate {
    
    func filterCollectionViewCellDidTapFilterButton(filter: String) {
        selectedFilter = filter
        filtersCollectionView.reloadData()
    }
    
}
