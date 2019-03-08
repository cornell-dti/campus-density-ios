//
//  ViewController.swift
//  Campus Density
//
//  Created by Matthew Coufal on 10/14/18.
//  Copyright © 2018 Cornell DTI. All rights reserved.
//

import UIKit
import SnapKit
import Firebase

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
    let placeTableViewCellHeight: CGFloat = 105
    let filtersViewHeight: CGFloat = 65
    let loadingViewLength: CGFloat = 50
    let placeTableViewCellReuseIdentifier = "places"
    let logoText = "powered by DTI"
    let smallLoadingBarsLength: CGFloat = 33
    let largeLoadingBarsLength: CGFloat = 63
    let logoViewHeight: CGFloat = 65
    let dtiWebsite = "https://www.cornelldti.org/"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Auth.auth().addIDTokenDidChangeListener { (auth, user) in
            if let user = user {
                user.getIDToken { (token, error) in
                    if let _ = error {
                        System.token = nil
                        UserDefaults.standard.removeObject(forKey: "token")
                        UserDefaults.standard.synchronize()
                        self.alertError()
                    } else if let token = token {
                        System.token = token
                        UserDefaults.standard.set(token, forKey: "token")
                        UserDefaults.standard.synchronize()
                    } else {
                        System.token = nil
                        UserDefaults.standard.removeObject(forKey: "token")
                        UserDefaults.standard.synchronize()
                        self.alertError()
                    }
                }
            }
        }
        
        signIn()

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
    
    func signIn() {
        if let user = Auth.auth().currentUser {
            if let _ = System.token {
                getPlaces()
            } else {
                user.getIDToken { (token, error) in
                    if let _ = error {
                        System.token = nil
                        UserDefaults.standard.removeObject(forKey: "token")
                        UserDefaults.standard.synchronize()
                        self.alertError()
                    } else {
                        if let token = token {
                            System.token = token
                            UserDefaults.standard.set(token, forKey: "token")
                            UserDefaults.standard.synchronize()
                            self.getPlaces()
                        } else {
                            System.token = nil
                            UserDefaults.standard.removeObject(forKey: "token")
                            UserDefaults.standard.synchronize()
                            self.alertError()
                        }
                    }
                }
            }
        } else {
            Auth.auth().signInAnonymously { (result, error) in
                if let _ = error {
                    System.token = nil
                    UserDefaults.standard.removeObject(forKey: "token")
                    UserDefaults.standard.synchronize()
                    self.alertError()
                } else {
                    if let result = result {
                        let user = result.user
                        user.getIDToken { (token, error) in
                            if let _ = error {
                                System.token = nil
                                UserDefaults.standard.removeObject(forKey: "token")
                                UserDefaults.standard.synchronize()
                                self.alertError()
                            } else {
                                if let token = token {
                                    System.token = token
                                    UserDefaults.standard.set(token, forKey: "token")
                                    UserDefaults.standard.synchronize()
                                    self.getPlaces()
                                } else {
                                    System.token = nil
                                    UserDefaults.standard.removeObject(forKey: "token")
                                    UserDefaults.standard.synchronize()
                                    UserDefaults.standard.removeObject(forKey: "token")
                                    UserDefaults.standard.synchronize()
                                    self.alertError()
                                }
                            }
                        }
                    } else {
                        System.token = nil
                        UserDefaults.standard.removeObject(forKey: "token")
                        UserDefaults.standard.synchronize()
                        self.alertError()
                    }
                }
            }
        }
    }
    
    func alertError() {
        let alertController = UIAlertController(title: "Error", message: "Failed to load data. Check your network connection.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Try Again", style: .default, handler: { action in
            self.signIn()
            alertController.dismiss(animated: true, completion: nil)
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    func getHistory() {
        API.history { gotHistory in
            if gotHistory {
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
    
    func updatePlaces() {
        if !System.places.isEmpty {
            setupRefreshControl()
            API.densities { gotDensities in
                if gotDensities {
                    API.status { gotStatus in
                        if gotStatus {
                            self.filter(by: self.selectedFilter)
                            self.placesTableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    
    @objc func didBecomeActive() {
        updatePlaces()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updatePlaces()
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
            filteredPlaces.append(contentsOf: System.places)
            break
        case .north:
            filteredPlaces = System.places.filter({ place -> Bool in
                return place.region == Region.north
            })
            break
        case .west:
            filteredPlaces = System.places.filter({ place -> Bool in
                return place.region == Region.west
            })
            break
        case .central:
            filteredPlaces = System.places.filter({ place -> Bool in
                return place.region == Region.central
            })
        }
        filteredPlaces.sort { placeOne, placeTwo -> Bool in
            if placeOne.isClosed && placeTwo.isClosed {
                return placeOne.displayName < placeTwo.displayName
            }
            if placeOne.isClosed {
                return false
            }
            if placeTwo.isClosed {
                return true
            }
            if placeOne.density.rawValue == placeTwo.density.rawValue {
                return placeOne.displayName < placeTwo.displayName
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
        let logoView = LogoView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: logoViewHeight))
        logoView.configure(with: self)
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

