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
    var filters: [String]!
    var selectedFilter: String = "All"
    
    // MARK: - View vars
    var facilitiesTableView: UITableView!
    var filtersCollectionView: UICollectionView!
    
    // MARK: - Constants
    let cellAnimationDuration: TimeInterval = 0.2
    let cellScale: CGFloat = 0.95
    let minimumInteritemSpacing: CGFloat = 15
    let facilityTableViewCellHeight: CGFloat = 115
    let filtersCollectionViewHeight: CGFloat = 65
    let filterCollectionViewCellHorizontalPadding: CGFloat = 12.5

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Eateries"
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = .white
        
        facilities = [Facility(name: "Becker House", id: "beckerid", opensAt: "7:00 AM", closesAt: "8:00 PM", address: "address", currentCapacity: 52.0, totalCapacity: 100.0, isFavorite: false), Facility(name: "Flora Rose House", id: "roseid", opensAt: "7:00 AM", closesAt: "8:00 PM", address: "address", currentCapacity: 86.0, totalCapacity: 100.0, isFavorite: true), Facility(name: "Okenshields", id: "okenshieldsid", opensAt: "11:30 AM", closesAt: "2:30 PM", address: "address", currentCapacity: 24, totalCapacity: 100, isFavorite: true)]
        
        filters = ["All", "Favorites", "North", "West", "Central"]
        
        setupViews()
        setupConstraints()
        
    }
    
    func setupViews() {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = minimumInteritemSpacing
        layout.scrollDirection = .horizontal
        
        filtersCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: filtersCollectionViewHeight), collectionViewLayout: layout)
        filtersCollectionView.contentInset = UIEdgeInsets(top: 0, left: minimumInteritemSpacing, bottom: 0, right: minimumInteritemSpacing)
        filtersCollectionView.backgroundColor = .clear
        filtersCollectionView.delegate = self
        filtersCollectionView.dataSource = self
        filtersCollectionView.showsVerticalScrollIndicator = false
        filtersCollectionView.showsHorizontalScrollIndicator = false
        filtersCollectionView.bounces = true
        filtersCollectionView.register(FilterCollectionViewCell.self, forCellWithReuseIdentifier: "filters")
        view.addSubview(filtersCollectionView)
        
        facilitiesTableView = UITableView()
        facilitiesTableView.delegate = self
        facilitiesTableView.dataSource = self
        facilitiesTableView.separatorStyle = .none
        facilitiesTableView.backgroundColor = .clear
        facilitiesTableView.showsVerticalScrollIndicator = false
        facilitiesTableView.showsHorizontalScrollIndicator = false
        facilitiesTableView.register(FacilityTableViewCell.self, forCellReuseIdentifier: "eateries")
        facilitiesTableView.tableHeaderView = filtersCollectionView
        view.addSubview(facilitiesTableView)
        
    }
    
    func setupConstraints() {
        
        facilitiesTableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
        
    }


}

