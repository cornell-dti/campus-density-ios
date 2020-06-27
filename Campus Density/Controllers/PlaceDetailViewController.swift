//
//  PlaceDetailViewController.swift
//  Campus Density
//
//  Created by Matthew Coufal on 3/8/19.
//  Copyright © 2019 Cornell DTI. All rights reserved.
//

import UIKit
import IGListKit
import Firebase

enum Meal: String, CaseIterable {
    case none = "No"
    case breakfast = "Breakfast"
    case brunch = "Brunch"
    case lunch = "Lunch"
    case dinner = "Dinner"
}

class PlaceDetailViewController: UIViewController {

    // MARK: - Data vars
    var place: Place!
    var selectedWeekday: Int = 0
    var selectedHour: Int = 0
    var mealList = [Meal]()
    var selectedMeal: Meal = .none
    var weekdays = [(Int, Int)]() // (weekday, dayNum) as in (0, 5) for Sunday the 5th
    var densityMap = [Int: Double]()
    var adapter: ListAdapter!
    var loadingHours: Bool = true
    var loadingMenus: Bool = true

    // MARK: - View vars
    var collectionView: UICollectionView!
    var loadingBarsView: LoadingBarsView!

    // MARK: - Constants
    let largeLoadingBarsLength: CGFloat = 63
    let linkTopOffset: CGFloat = 5
    let feedbackForm = "https://docs.google.com/forms/d/e/1FAIpQLSeJZ7AyVRZ8tfw-XiJqREmKn9y0wPCyreEkkysJn0QHCLDmaA/viewform?vc=0&c=0&w=1"
    let ithacaTime = TimeZone(identifier: "America/New_York")!
    var ithacaCalendar = Calendar.current

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        //title = place.displayName
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = .warmGray
        tabBarController?.tabBar.isHidden = true

        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)

        loadingBarsView = LoadingBarsView()
        loadingBarsView.configure(with: .large)
        view.addSubview(loadingBarsView)

        loadingBarsView.snp.makeConstraints { make in
            make.width.height.equalTo(largeLoadingBarsLength)
            make.center.equalToSuperview()
        }

        ithacaCalendar.timeZone = ithacaTime

        if place.hours.isEmpty {
            loadingBarsView.isHidden = false
            loadingBarsView.startAnimating()
            getHours()
        } else {
            loadingBarsView.removeFromSuperview()
            loadingHours = false
            setup()
        }
        if ((place?.menus.weeksMenus)!.isEmpty) {
            getMenus()
        } else {
            loadingMenus = false
            setup()
        }

    }

    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }

    func getHours() {
        API.hours(place: place) { [weak self] gotHours in
            if gotHours {
                DispatchQueue.main.async {
                    self?.loadingBarsView.removeFromSuperview()
                    self?.loadingHours = false
                    self?.setup()
                }
            } else {
                self?.alertError(completion: { self?.getHours() })
            }
        }
    }

    func getMenus() {
        API.menus(place: place) { gotMenus in
            if gotMenus {
                DispatchQueue.main.async {
                    self.loadingMenus = false
                    self.setup()
                }
            } else {
                print("fail")
            }
        }
    }

    func signIn(completion: @escaping () -> Void) {
        if let user = Auth.auth().currentUser {
            if System.token != nil {
                completion()
            } else {
                user.getIDToken { (token, error) in
                    if error != nil {
                        forgetToken()
                        self.alertError(completion: completion)
                    } else {
                        if let token = token {
                            rememberToken(token: token)
                            completion()
                        } else {
                            forgetToken()
                            self.alertError(completion: completion)
                        }
                    }
                }
            }
        } else {
            Auth.auth().signInAnonymously { (result, error) in
                if error != nil {
                    forgetToken()
                    self.alertError(completion: completion)
                } else {
                    if let result = result {
                        let user = result.user
                        user.getIDToken { (token, error) in
                            if error != nil {
                                forgetToken()
                                self.alertError(completion: completion)
                            } else {
                                if let token = token {
                                    rememberToken(token: token)
                                    completion()
                                } else {
                                    forgetToken()
                                    self.alertError(completion: completion)
                                }
                            }
                        }
                    } else {
                        forgetToken()
                        self.alertError(completion: completion)
                    }
                }
            }
        }
    }

    func alertError(completion: @escaping () -> Void) {
        let alertController = UIAlertController(title: "Error", message: "Failed to load data. Check your network connection.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Try Again", style: .default, handler: { _ in
            self.signIn(completion: completion)
            alertController.dismiss(animated: true, completion: nil)
        }))
        present(alertController, animated: true, completion: nil)
    }

    func setup() {
        setWeekdays()
        selectedWeekday = getCurrentWeekday()
        selectedHour = getCurrentHour()
        getDensityMap()
        setupViews()
    }

    func setWeekdays() {
        let today = Date()
        weekdays = []
        for i in 0...6 {
            let future = ithacaCalendar.date(byAdding: .day, value: i, to: today)!
            let weekday = ithacaCalendar.component(.weekday, from: future) - 1
            let dayNum = ithacaCalendar.component(.day, from: future)
            weekdays.append((weekday, dayNum))
        }
    }

    func getCurrentHour() -> Int {
        let today = Date()
        return ithacaCalendar.component(.hour, from: today)
    }

    func update() {
        setWeekdays()
        API.densities { gotDensities in
            if gotDensities {
                API.status { gotStatus in
                    if gotStatus {
                        let index = System.places.firstIndex(where: { place -> Bool in
                            return place.id == self.place.id
                        })
                        guard let placeIndex = index else { return }
                        self.place = System.places[placeIndex]
                        DispatchQueue.main.async {
                            self.adapter.performUpdates(animated: false, completion: nil)
                        }
                    } else {
                        self.alertError(completion: { self.update() })
                    }
                }
            } else {
                self.alertError(completion: { self.update() })
            }
        }
    }

    @objc func didBecomeActive() {
        if let nav = navigationController, let _ = nav.topViewController as? PlaceDetailViewController {
            if !loadingHours || !loadingMenus {
                update()
            }

        }
    }

    func setupViews() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        view.addSubview(collectionView)

        let updater = ListAdapterUpdater()
        adapter = ListAdapter(updater: updater, viewController: nil)
        adapter.collectionView = collectionView
        adapter.dataSource = self

        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        adapter.performUpdates(animated: false, completion: nil)
    }

    func historyKey(weekday: Int) -> String {
        return ithacaCalendar.shortStandaloneWeekdaySymbols[weekday].uppercased()
    }

    func getDensityMap() {
        let weekdayKey = historyKey(weekday: selectedWeekday)
        guard let history = place.history[weekdayKey] else { return }
        let sortedKeys = history.keys.sorted { (one, two) in
            guard let one = Int(one), let two = Int(two) else { return true }
            return one < two
        }
        guard let first = sortedKeys.first, var start = Int(first) else { return }
        guard let last = sortedKeys.last, let end = Int(last) else { return }
        var closed: Int = 0
        while start <= end {
            if let density = history["\(start)"] {
                if density == -1.0 {
                    densityMap[start] = nil
                    closed += 1
                } else {
                    densityMap[start] = density
                }
            } else {
                densityMap[start] = nil
            }
            start += 1
        }
        if closed == sortedKeys.count {
            densityMap = [:]
        }
    }

    func getCurrentWeekday() -> Int {
        let today = Date()
        return ithacaCalendar.component(.weekday, from: today) - 1
    }

    func selectedWeekdayText() -> String {
        return ithacaCalendar.weekdaySymbols[selectedWeekday]
    }

    func selectedDateText() -> String {
        let today = Date()
        guard let weekdayIndex = weekdays.firstIndex(where: {$0.0 == selectedWeekday}) else { return "" }
        guard let selectedDate = ithacaCalendar.date(byAdding: Calendar.Component.day, value: weekdayIndex, to: today) else { return "" }
        let formatter = DateFormatter()
        formatter.timeZone = ithacaTime
        formatter.setLocalizedDateFormatFromTemplate("MMMM dd")
        let text = formatter.string(from: selectedDate)
          + ((TimeZone.current != ithacaTime) ? " (\(ithacaTime.abbreviation()!))" : "")
        return text
    }

}
