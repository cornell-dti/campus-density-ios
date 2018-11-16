//
//  ViewController.swift
//  Campus Density
//
//  Created by Matthew Coufal on 10/14/18.
//  Copyright © 2018 Cornell DTI. All rights reserved.
//

import UIKit
import SnapKit
import NVActivityIndicatorView

public enum Filter {
    case all
    case north
    case west
    case central
}

class PlacesViewController: UIViewController {
    
    // MARK: - Data vars
    var places = [Place]()
    var filteredPlaces = [Place]()
    var filters: [Filter]!
    var selectedFilter: Filter = .all
    var api: API!
    
    // MARK: - View vars
    var placesTableView: UITableView!
    var filterView: FilterView!
    var loadingView: NVActivityIndicatorView!
    
    // MARK: - Constants
    let cellAnimationDuration: TimeInterval = 0.2
    let cellScale: CGFloat = 0.95
    let minimumInteritemSpacing: CGFloat = 15
    let placeTableViewCellHeight: CGFloat = 115
    let filtersCollectionViewHeight: CGFloat = 65
    let filterCollectionViewCellHorizontalPadding: CGFloat = 12.5
    let loadingViewLength: CGFloat = 50

    override func viewDidLoad() {
        super.viewDidLoad()
        
        api = API(delegate: self)
        api.getPlaces()
        
        view.backgroundColor = .white
        title = "Places"
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.largeTitleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.grayishBrown]
        
        filters = [.all, .north, .west, .central]
        
        setupViews()
        setupConstraints()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
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
        }
    }
    
    func filter(by selectedFilter: Filter) {
        switch selectedFilter {
        case .all:
            filteredPlaces = []
            filteredPlaces.append(contentsOf: places)
            break
        case .north:
            filteredPlaces = places.filter({ place -> Bool in
                return place.region == "north"
            })
            break
        case .west:
            filteredPlaces = places.filter({ place -> Bool in
                return place.region == "west"
            })
            break
        case .central:
            filteredPlaces = places.filter({ place -> Bool in
                return place.region == "central"
            })
        }
    }
    
    func setupViews() {
        
        placesTableView = UITableView()
        placesTableView.delegate = self
        placesTableView.dataSource = self
        placesTableView.separatorStyle = .none
        placesTableView.backgroundColor = .clear
        placesTableView.showsVerticalScrollIndicator = false
        placesTableView.showsHorizontalScrollIndicator = false
        placesTableView.register(PlaceTableViewCell.self, forCellReuseIdentifier: "eateries")
        filterView = FilterView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: filtersCollectionViewHeight))
        filterView.isHidden = true
        filterView.setNeedsUpdateConstraints()
        filterView.configure(with: filters, selectedFilter: selectedFilter, delegate: self, width: view.frame.width)
        placesTableView.tableHeaderView = filterView
        placesTableView.isHidden = true
        view.addSubview(placesTableView)
        
        loadingView = NVActivityIndicatorView(frame: .zero, type: NVActivityIndicatorType.ballClipRotate, color: .peach, padding: nil)
        loadingView.startAnimating()
        view.addSubview(loadingView)
        
    }
    
    func setupConstraints() {
        
        placesTableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        loadingView.snp.makeConstraints { make in
            make.width.height.equalTo(loadingViewLength)
            make.center.equalToSuperview()
        }
        
    }


}

