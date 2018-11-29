//
//  EateriesViewController+Extension.swift
//  Campus Density
//
//  Created by Matthew Coufal on 10/14/18.
//  Copyright © 2018 Cornell DTI. All rights reserved.
//

import UIKit

extension Filter: Equatable {
    public static func ==(lhs: Filter, rhs: Filter) -> Bool {
        switch lhs {
        case .all:
            switch rhs {
            case .all:
                return true
            case .central:
                return false
            case .north:
                return false
            case .west:
                return false
            }
        case .central:
            switch rhs {
            case .all:
                return false
            case .central:
                return true
            case .north:
                return false
            case .west:
                return false
            }
        case .north:
            switch rhs {
            case .all:
                return false
            case .central:
                return false
            case .north:
            return true
            case .west:
                return false
            }
        case .west:
            switch rhs {
            case .all:
                return false
            case .central:
                return false
            case .north:
                return false
            case .west:
                return true
            }
        }
    }
}

extension PlacesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: placeTableViewCellReuseIdentifier, for: indexPath) as? PlaceTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.configure(with: filteredPlaces[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return placeTableViewCellHeight
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? PlaceTableViewCell else { return }
        UIView.animate(withDuration: cellAnimationDuration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            cell.transform = CGAffineTransform(scaleX: self.cellScale, y: self.cellScale)
        }, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? PlaceTableViewCell else { return }
        UIView.animate(withDuration: cellAnimationDuration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            cell.transform = .identity
        }, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let place = filteredPlaces[indexPath.row]
        let densityViewController = DensityViewController()
        densityViewController.place = place
        navigationController?.pushViewController(densityViewController, animated: true)
    }
    
}

extension String {
    
    func widthWithConstrainedHeight(_ height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
        
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
}

extension PlacesViewController: FilterViewDelegate {
    
    func filterViewDidSelectFilter(selectedFilter: Filter) {
        self.selectedFilter = selectedFilter
        filter(by: selectedFilter)
        placesTableView.reloadData()
    }
    
}

extension PlacesViewController: APIDelegate {
    
    func didGetPlaces(updatedPlaces: [Place]?) {
        if let updatedPlaces = updatedPlaces {
            self.places = updatedPlaces
            api.getDensities(updatedPlaces: updatedPlaces)
        } else {
            let alertController = UIAlertController(title: "Error", message: "Failed to load data. Check your network connection.", preferredStyle: .actionSheet)
            alertController.addAction(UIAlertAction(title: "Try Again", style: .default, handler: { action in
                self.api.getPlaces()
                alertController.dismiss(animated: true, completion: nil)
            }))
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func didGetDensities(updatedPlaces: [Place]?) {
        if let updatedPlaces = updatedPlaces {
            self.places = updatedPlaces
            selectedFilter = .all
            filter(by: selectedFilter)
            loadingView.stopAnimating()
            placesTableView.isHidden = false
            filterView.isHidden = false
            placesTableView.reloadData()
        } else {
            let alertController = UIAlertController(title: "Error", message: "Failed to load data. Check your network connection.", preferredStyle: .actionSheet)
            alertController.addAction(UIAlertAction(title: "Try Again", style: .default, handler: { action in
                self.api.getDensities(updatedPlaces: self.places)
                alertController.dismiss(animated: true, completion: nil)
            }))
            present(alertController, animated: true, completion: nil)
        }
    }
    
}
