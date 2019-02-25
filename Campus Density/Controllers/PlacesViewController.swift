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
}

class PlacesViewController: UIViewController {
    
    // MARK: - Data vars
    var filteredPlaces = [Place]()
    var filters: [Filter]!
    var selectedFilter: Filter = .all
    var gettingDensities = false
    
    // MARK: - View vars
    var placesTableView: UITableView!
    var filterView: FilterView!
    var loadingBarsView: LoadingBarsView!
    
    // MARK: - Constants
    let cellAnimationDuration: TimeInterval = 0.2
    let cellScale: CGFloat = 0.95
    let minimumInteritemSpacing: CGFloat = 15
    let placeTableViewCellHeight: CGFloat = 105
    let filtersViewHeight: CGFloat = 65
    let loadingViewLength: CGFloat = 50
    let placeTableViewCellReuseIdentifier = "places"
    let logoText = "powered by DTI"
    let smallLoadingBarsLength: CGFloat = 33
    let largeLoadingBarsLength: CGFloat = 63
    let logoImageHeight: CGFloat = 80

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getToken()

        view.backgroundColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.grayishBrown]
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)

        filters = [.all, .north, .west, .central]

        setupViews()
        setupConstraints()
        
    }
    
    func alertError() {
        let alertController = UIAlertController(title: "Error", message: "Failed to load data. Check your network connection.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Try Again", style: .default, handler: { action in
            self.getToken()
            alertController.dismiss(animated: true, completion: nil)
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    func getHistory() {
        API.history { gotHistory in
            if gotHistory {
                self.getHours()
            } else {
                self.alertError()
            }
        }
    }
    
    func getHours() {
        API.hours { gotHours in
            if gotHours {
                self.title = "Places"
                sortPlaces()
                self.filter(by: self.selectedFilter)
                self.loadingBarsView.stopAnimating()
                self.placesTableView.isHidden = false
                self.filterView.isHidden = false
                self.placesTableView.reloadData()
            } else {
                self.alertError()
            }
        }
    }
    
    func getDensities() {
        API.densities { gotDensities in
            if gotDensities {
                self.getStatus()
            } else {
                self.alertError()
            }
        }
    }
    
    func getStatus() {
        API.status { gotStatus in
            if gotStatus {
                self.getHistory()
            } else {
                self.alertError()
            }
        }
    }
    
    func getPlaces() {
        API.places { gotPlaces in
            if gotPlaces {
                self.getDensities()
            } else {
                self.alertError()
            }
        }
    }
    
    func getToken() {
        API.token { gotToken in
            if gotToken {
                self.getPlaces()
            } else {
                self.alertError()
            }
        }
    }
    
    func updateDensities() {
        if !System.places.isEmpty {
            API.densities { gotDensities in
                if gotDensities {
                    sortPlaces()
                    self.filter(by: self.selectedFilter)
                    self.placesTableView.reloadData()
                }
            }
        }
    }
    
    @objc func didBecomeActive() {
        updateDensities()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateDensities()
        if !System.places.isEmpty {
            setupRefreshControl()
        }
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
    
    func getRegion(place: Place) -> String {
        switch place.displayName {
        case "Rose Dining Hall":
            return "West"
        case "Risley":
            return "North"
        case "RPCC Dining Hall":
            return "North"
        case "Olin Libe Cafe":
            return "Central"
        case "Okenshields":
            return "Central"
        case "North Star at Appel":
            return "North"
        case "104West!":
            return "West"
        case "Keeton House":
            return "West"
        case "Jansen's at Bethe House":
            return "West"
        case "Carl Becker House":
            return "West"
        case "Cafe Jennie":
            return "Central"
        case "Alice Cook House":
            return "West"
        default:
            return ""
        }
    }
    
    func filter(by selectedFilter: Filter) {
        switch selectedFilter {
        case .all:
            filteredPlaces = []
            filteredPlaces.append(contentsOf: System.places)
            break
        case .north:
            filteredPlaces = System.places.filter({ place -> Bool in
                return getRegion(place: place) == "North"
            })
            break
        case .west:
            filteredPlaces = System.places.filter({ place -> Bool in
                return getRegion(place: place) == "West"
            })
            break
        case .central:
            filteredPlaces = System.places.filter({ place -> Bool in
                return getRegion(place: place) == "Central"
            })
        }
        filteredPlaces.sort { placeOne, placeTwo -> Bool in
            if placeOne.isClosed && placeTwo.isClosed {
                return true
            }
            if placeOne.isClosed {
                return false
            }
            if placeTwo.isClosed {
                return true
            }
            return placeOne.density.rawValue < placeTwo.density.rawValue
        }
    }
    
    func setupRefreshControl() {
        if #available(iOS 10.0, *) {
            placesTableView.refreshControl?.removeFromSuperview()
            let refreshControl = UIRefreshControl()
            refreshControl.tintColor = .white
            refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
            let barsView = LoadingBarsView()
            barsView.configure(with: .small)
            barsView.startAnimating()
            refreshControl.addSubview(barsView)
            barsView.snp.makeConstraints { make in
                make.width.height.equalTo(smallLoadingBarsLength)
                make.center.equalToSuperview()
            }
            placesTableView.refreshControl = refreshControl
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
        placesTableView.register(PlaceTableViewCell.self, forCellReuseIdentifier: placeTableViewCellReuseIdentifier)
        filterView = FilterView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: filtersViewHeight))
        filterView.isHidden = true
        filterView.setNeedsUpdateConstraints()
        filterView.configure(with: filters, selectedFilter: selectedFilter, delegate: self, width: view.frame.width)
        placesTableView.tableHeaderView = filterView
        let logoView = LogoView()
        let logoViewHeight = logoImageHeight + logoText.height(withConstrainedWidth: view.frame.width, font: .sixteen)
        logoView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: logoViewHeight)
        placesTableView.tableFooterView = logoView
        placesTableView.isHidden = true
        view.addSubview(placesTableView)
        
        setupRefreshControl()
        
        loadingBarsView = LoadingBarsView()
        loadingBarsView.configure(with: .large)
        loadingBarsView.startAnimating()
        view.addSubview(loadingBarsView)
        
    }
    
    @objc func didPullToRefresh(sender: UIRefreshControl) {
        guard let refreshControl = placesTableView.refreshControl else { return }
        API.densities { gotDensities in
            if gotDensities {
                sortPlaces()
                self.filter(by: self.selectedFilter)
            }
            refreshControl.endRefreshing()
        }
    }
    
    func setupConstraints() {
        
        placesTableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        loadingBarsView.snp.makeConstraints { make in
            make.width.height.equalTo(largeLoadingBarsLength)
            make.center.equalToSuperview()
        }
        
    }


}

