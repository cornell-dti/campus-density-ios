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
        cell.configure(with: facilities[indexPath.row])
        cell.setNeedsUpdateConstraints()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "eateries", for: indexPath) as? FacilityTableViewCell else { return }
        UIView.animate(withDuration: buttonAnimationDuration) {
            cell.transform = CGAffineTransform(scaleX: self.buttonScale, y: self.buttonScale)
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "eateries", for: indexPath) as? FacilityTableViewCell else { return }
        UIView.animate(withDuration: buttonAnimationDuration) {
            cell.transform = .identity
        }
    }
    
}
