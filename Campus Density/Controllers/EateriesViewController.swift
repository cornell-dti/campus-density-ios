//
//  ViewController.swift
//  Campus Density
//
//  Created by Matthew Coufal on 10/14/18.
//  Copyright © 2018 Cornell DTI. All rights reserved.
//

import UIKit
import SnapKit

class EateriesViewController: UIViewController {
    
    // MARK: - Data vars
    var facilities: [Facility]!
    
    // MARK: - View vars
    var tableView: UITableView!
    
    // MARK: - Constants
    let buttonAnimationDuration: TimeInterval = 0.2
    let buttonScale: CGFloat = 0.95
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Eateries"
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = .white
        
        facilities = [Facility(name: "Becker House", id: "beckerid", opensAt: "7:00 AM", closesAt: "8:00 PM", address: "address", currentCapacity: 52.0, totalCapacity: 100.0), Facility(name: "Flora Rose House", id: "roseid", opensAt: "7:00 AM", closesAt: "8:00 PM", address: "address", currentCapacity: 86.0, totalCapacity: 100.0), Facility(name: "Okenshields", id: "okenshieldsid", opensAt: "11:30 AM", closesAt: "2:30 PM", address: "address", currentCapacity: 24, totalCapacity: 100)]
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        let box = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 15))
        box.backgroundColor = .clear
        tableView.tableHeaderView = box
        tableView.backgroundColor = .clear
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.register(FacilityTableViewCell.self, forCellReuseIdentifier: "eateries")
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
    }


}

