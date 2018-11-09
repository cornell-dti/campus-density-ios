//
//  ViewController.swift
//  Campus Density
//
//  Created by Matthew Coufal on 10/14/18.
//  Copyright © 2018 Cornell DTI. All rights reserved.
//

import UIKit
import SnapKit

public enum Filter {
    case all
    case north
    case west
    case central
    case density(type: Density)
}

class EateriesViewController: UIViewController {
    
    // MARK: - Data vars
    var facilities: [Facility]!
    var filteredFacilities = [Facility]()
    var filters: [Filter]!
    var selectedFilter: Filter = .all
    
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
        title = "Places"
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = .white
        
        filters = [.all, .north, .west, .central, .density(type: .manySpots), .density(type: .someSpots), .density(type: .fewSpots), .density(type: .noSpots)]
        
        facilities = [Facility(name: "Becker House", id: "beckerid", opensAt: "7:00 AM", closesAt: "8:00 PM", address: "address", density: .someSpots, region: "west"), Facility(name: "Rose House", id: "roseid", opensAt: "7:00 AM", closesAt: "8:00 PM", address: "address", density: .noSpots, region: "west"), Facility(name: "Okenshields", id: "okenshieldsid", opensAt: "11:30 AM", closesAt: "2:30 PM", address: "address", density: .manySpots, region: "central"), Facility(name: "Appel", id: "okenshieldsid", opensAt: "8:00 AM", closesAt: "2:30 PM", address: "address", density: .fewSpots, region: "north")]
        
        filter(by: selectedFilter)
        
        setupViews()
        setupConstraints()
        
    }
    
    func filterLabel(filter: Filter) -> String {
        switch filter {
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
    
    func filter(by selectedFilter: Filter) {
        switch selectedFilter {
        case .all:
            filteredFacilities = []
            filteredFacilities.append(contentsOf: facilities)
            break
        case .north:
            filteredFacilities = facilities.filter({ facility -> Bool in
                return facility.region == "north"
            })
            break
        case .west:
            filteredFacilities = facilities.filter({ facility -> Bool in
                return facility.region == "west"
            })
            break
        case .central:
            filteredFacilities = facilities.filter({ facility -> Bool in
                return facility.region == "central"
            })
            break
        case .density(let type):
            filteredFacilities = facilities.filter({ facility -> Bool in
                return facility.density == type
            })
        }
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

