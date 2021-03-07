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
import IGListKit

enum Filter: String {
    case all = "All"
    case north = "North"
    case west = "West"
    case central = "Central"
}

class PlacesViewController: UIViewController, UIScrollViewDelegate {

    // MARK: - Data vars
    var filteredPlaces = [Place]()
    var filters: [Filter]!
    var selectedFilter: Filter = .all
    var searchText: String = ""
    var gettingDensities = false
    var adapter: ListAdapter!

    // MARK: - View vars
    var collectionView: UICollectionView!
    var loadingBarsView: LoadingBarsView!
    var refreshBarsView: LoadingBarsView!
    var feedbackHome: UIButton!
    var homeFeedbackViewController: HomeFeedbackViewController!

    // MARK: - Constants
    let refreshOffset: CGFloat = 146
    let cellAnimationDuration: TimeInterval = 0.2
    let cellScale: CGFloat = 0.95
    let placeTableViewCellHeight: CGFloat = 105
    let filtersViewHeight: CGFloat = 65
    let loadingViewLength: CGFloat = 50
    let placeTableViewCellReuseIdentifier = "places"
    let smallLoadingBarsLength: CGFloat = 33
    let largeLoadingBarsLength: CGFloat = 63
    let logoLength: CGFloat = 50
    let dtiWebsite = "https://www.cornelldti.org/"
    let diningPolicyURL = "https://scl.cornell.edu/news-events/news/guide-cornell-dining-fall-2020"

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Eateries"
        Auth.auth().addIDTokenDidChangeListener { (_, user) in
            if let user = user {
                user.getIDToken { (token, error) in
                    if error != nil {
                        forgetToken()
                        self.alertError()
                    } else if let token = token {
                        rememberToken(token: token)
                    } else {
                        forgetToken()
                        self.alertError()
                    }
                }
            } else {
                forgetToken()
                self.alertError()
            }
        }

        signIn()

        view.backgroundColor = .white
        navigationController?.navigationBar.topItem?.title = "Eateries"
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
        setupGestureRecognizers()
    }

    func signIn() {
        if let user = Auth.auth().currentUser {
            if System.token != nil {
                getPlaces()
            } else {
                user.getIDToken { (token, error) in
                    if error != nil {
                        forgetToken()
                        self.alertError()
                    } else {
                        if let token = token {
                            rememberToken(token: token)
                            self.getPlaces()
                        } else {
                            forgetToken()
                            self.alertError()
                        }
                    }
                }
            }
        } else {
            Auth.auth().signInAnonymously { (result, error) in
                if error != nil {
                    forgetToken()
                    self.alertError()
                } else {
                    if let result = result {
                        let user = result.user
                        user.getIDToken { (token, error) in
                            if error != nil {
                                forgetToken()
                                self.alertError()
                            } else {
                                if let token = token {
                                    rememberToken(token: token)
                                    self.getPlaces()
                                } else {
                                    forgetToken()
                                    self.alertError()
                                }
                            }
                        }
                    } else {
                        forgetToken()
                        self.alertError()
                    }
                }
            }
        }
    }

    func alertError() {
        let alertController = UIAlertController(title: "Error", message: "Failed to load data. Check your network connection.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Try Again", style: .default, handler: { _ in
            self.signIn()
            alertController.dismiss(animated: true, completion: nil)
        }))
        present(alertController, animated: true, completion: nil)
    }

    func getHistory() {
        API.history { gotHistory in
            if gotHistory {
                self.title = "Eateries"
                sortPlaces()
                self.updateFilteredPlaces()
                self.loadingBarsView.stopAnimating()
                self.collectionView.isHidden = false
                self.adapter.performUpdates(animated: false, completion: nil)
                self.setupRefreshControl()
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
                            sortPlaces() // Maybe fixes a bug related to opening the app after a long time and refreshed densities being out of order
                            self.updateFilteredPlaces()
                            self.adapter.performUpdates(animated: false, completion: nil)
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
        self.tabBarController?.tabBar.isHidden = false
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

    /// Update `filteredPlaces` by filtering through current location filter and then search filter
    func updateFilteredPlaces() {
        filteredPlaces = filter(places: filter(places: System.places, by: self.selectedFilter), by: self.searchText)
    }

    func filter(places: [Place], by selectedFilter: Filter) -> [Place] {
        var filteredPlaces: [Place] = []
        print("Filtering by \(selectedFilter)")
        switch selectedFilter {
        case .all:
            filteredPlaces.append(contentsOf: places)
        case .north:
            filteredPlaces = places.filter({ place -> Bool in
                return place.region == Region.north
            })
        case .west:
            filteredPlaces = places.filter({ place -> Bool in
                return place.region == Region.west
            })
        case .central:
            filteredPlaces = places.filter({ place -> Bool in
                return place.region == Region.central
            })
        }
        filteredPlaces = sortFilteredPlaces(places: filteredPlaces)
        return filteredPlaces
    }

    func filter(places: [Place], by text: String) -> [Place] {
        var filteredPlaces: [Place] = []
        print("Filtering by \(text)")
        if text == "" {
            filteredPlaces.append(contentsOf: places)
        } else {
            filteredPlaces = places.filter({ place -> Bool in
                return place.displayName.lowercased().contains(text.lowercased())
            })
        }
        filteredPlaces = sortFilteredPlaces(places: filteredPlaces)
        return filteredPlaces
    }

    func setupRefreshControl() {
        if refreshBarsView != nil {
            refreshBarsView.removeFromSuperview()
        }
        collectionView.refreshControl?.removeFromSuperview()
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white // Basically invisible
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        refreshBarsView = LoadingBarsView()
        refreshBarsView.configure(with: .small)
        refreshBarsView.setBarHeights(fraction: 0)
        refreshBarsView.alpha = 0.0
        refreshControl.addSubview(refreshBarsView)
        refreshBarsView.snp.makeConstraints { make in
            make.width.height.equalTo(smallLoadingBarsLength)
            make.center.equalToSuperview()
        }
        collectionView.refreshControl = refreshControl
    }

    func setupViews() {

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isHidden = true
        collectionView.alwaysBounceVertical = true
        collectionView.bounces = true
        view.addSubview(collectionView)

        let updater = ListAdapterUpdater()
        adapter = ListAdapter(updater: updater, viewController: nil, workingRangeSize: 1)
        adapter.collectionView = collectionView
        adapter.dataSource = self
        adapter.scrollViewDelegate = self

        setupRefreshControl()

        loadingBarsView = LoadingBarsView()
        loadingBarsView.configure(with: .large)
        loadingBarsView.startAnimating()
        view.addSubview(loadingBarsView)

        feedbackHome = UIButton()
        //feedbackHome.addTarget(self, action: #selector(homeFeedbackForm), for: .touchUpInside)
        feedbackHome.backgroundColor = UIColor(white: 0, alpha: 0.2)
        feedbackHome.isHidden = true
        view.addSubview(feedbackHome)

        feedbackHome.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        homeFeedbackViewController = HomeFeedbackViewController()
        addChild(homeFeedbackViewController)
        homeFeedbackViewController.view.isHidden = true
        view.addSubview(homeFeedbackViewController.view)

        homeFeedbackViewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        adapter.performUpdates(animated: false, completion: nil)
    }

    @objc func didPullToRefresh(sender: UIRefreshControl) {
        guard let refreshControl = collectionView.refreshControl else { return }
        API.densities { gotDensities in
            if gotDensities {
                sortPlaces()
                self.updateFilteredPlaces()
            }
            refreshControl.endRefreshing()
            self.adapter.performUpdates(animated: false, completion: nil) // After refreshing, reload with sorted places - otherwise may just have same order with updated density card on cell dequeue and configure (passing the place by reference and updating the places) ?
        }
    }

    func setupConstraints() {

        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        loadingBarsView.snp.makeConstraints { make in
            make.width.height.equalTo(largeLoadingBarsLength)
            make.center.equalToSuperview()
        }

    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let headerOffset = 116 // Found experimentally lol
        let offset = -(scrollView.contentOffset.y + CGFloat(headerOffset))
        let fraction = offset > 25 ? offset / refreshOffset : 0 // Minimum offset required
        let alpha = min(1, fraction)
        refreshBarsView.alpha = alpha
        if !refreshBarsView.animating && fraction >= 1 && collectionView.refreshControl?.isRefreshing ?? false {
            refreshBarsView.startAnimating()
        }
        if !refreshBarsView.animating && fraction >= 0 {
            refreshBarsView.setBarHeights(fraction: fraction)
        }
        if refreshBarsView.animating && offset <= 25 {
            refreshBarsView.stopAnimating()
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        refreshBarsView.alpha = 0
    }

    /// Setup a gesture recognizer to dismiss search bar keyboard on tap
    func setupGestureRecognizers() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

//    @objc func homeFeedbackForm() {
//    feedbackHome.isHidden = true
//    feedbackViewController.view.isHidden = true
//    }
}
