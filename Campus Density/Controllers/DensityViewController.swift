//
//  DensityViewController.swift
//  Campus Density
//
//  Created by Matthew Coufal on 11/9/18.
//  Copyright © 2018 Cornell DTI. All rights reserved.
//

import UIKit

class DensityViewController: UIViewController {

    // MARK: - Data vars
    var place: Place!
    var densityMap: [Int : Double?]?
    var selectedHour: Int = 10
    
    // MARK: - View vars
    var axis: UIView!
    var currentLabel: UILabel!
    var hoursLabel: UILabel!
    var bars = [UIButton]()
    var densityDescriptionLabel: UILabel!
    var selectedView: UIView!
    
    // MARK: - Constants
    let start: Int = 7
    let end: Int = 22
    let axisHeight: CGFloat = 2
    let axisHorizontalPadding: CGFloat = 10
    let hoursVerticalPadding: CGFloat = 15
    let barVerticalPadding: CGFloat = 85
    let descriptionLabelHorizontalPadding: CGFloat = 15
    let descriptionLabelHeight: CGFloat = 40
    let descriptionLabelCornerRadius: CGFloat = 6
    let selectedViewWidth: CGFloat = 1.5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        densityMap = getDensityMap()
        selectedHour = getCurrentHour()

        view.backgroundColor = .white
        title = place.displayName
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = .warmGray
        
        setupViews()
        setupConstraints()
        
    }
    
    func getWeekday() -> Int {
        let today = Date()
        let calendar = Calendar.current
        return calendar.component(.weekday, from: today)
    }
    
    func getCurrentHour() -> Int {
        let today = Date()
        let calendar = Calendar.current
        return calendar.component(.hour, from: today)
    }
    
    func getDensityMap() -> [Int : Double?]? {
        switch place.displayName {
        case "Rose Dining Hall":
            switch getWeekday() {
            case 1:
                return nil
            case 2:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.977,
                    12: 0.832,
                    13: 0.219,
                    14: nil,
                    15: 0.386,
                    16: 0.518,
                    17: 0.921,
                    18: 0.227,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil
                ]
            case 3:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.977,
                    12: 0.832,
                    13: 0.219,
                    14: nil,
                    15: 0.386,
                    16: 0.518,
                    17: 0.921,
                    18: 0.227,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil
                ]
            case 4:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.977,
                    12: 0.832,
                    13: 0.219,
                    14: nil,
                    15: 0.386,
                    16: 0.518,
                    17: 0.921,
                    18: 0.227,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil
                ]
            case 5:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.977,
                    12: 0.832,
                    13: 0.219,
                    14: nil,
                    15: 0.386,
                    16: 0.518,
                    17: 0.921,
                    18: 0.227,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil
                ]
            case 6:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.977,
                    12: 0.832,
                    13: 0.219,
                    14: nil,
                    15: 0.386,
                    16: 0.518,
                    17: 0.921,
                    18: 0.227,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil
                ]
            case 7:
                return nil
            default:
                return nil
            }
        case "Risley":
            switch getWeekday() {
            case 1:
                return nil
            case 2:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.977,
                    12: 0.832,
                    13: 0.219,
                    14: nil,
                    15: 0.386,
                    16: 0.518,
                    17: 0.921,
                    18: 0.227,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil
                ]
            case 3:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.977,
                    12: 0.832,
                    13: 0.219,
                    14: nil,
                    15: 0.386,
                    16: 0.518,
                    17: 0.921,
                    18: 0.227,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil
                ]
            case 4:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.977,
                    12: 0.832,
                    13: 0.219,
                    14: nil,
                    15: 0.386,
                    16: 0.518,
                    17: 0.921,
                    18: 0.227,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil
                ]
            case 5:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.977,
                    12: 0.832,
                    13: 0.219,
                    14: nil,
                    15: 0.386,
                    16: 0.518,
                    17: 0.921,
                    18: 0.227,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil
                ]
            case 6:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.977,
                    12: 0.832,
                    13: 0.219,
                    14: nil,
                    15: 0.386,
                    16: 0.518,
                    17: 0.921,
                    18: 0.227,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil
                ]
            case 7:
                return nil
            default:
                return nil
            }
        case "RPCC Dining Hall":
            switch getWeekday() {
            case 1:
                return nil
            case 2:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.977,
                    12: 0.832,
                    13: 0.219,
                    14: nil,
                    15: 0.386,
                    16: 0.518,
                    17: 0.921,
                    18: 0.227,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil
                ]
            case 3:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.977,
                    12: 0.832,
                    13: 0.219,
                    14: nil,
                    15: 0.386,
                    16: 0.518,
                    17: 0.921,
                    18: 0.227,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil
                ]
            case 4:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.977,
                    12: 0.832,
                    13: 0.219,
                    14: nil,
                    15: 0.386,
                    16: 0.518,
                    17: 0.921,
                    18: 0.227,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil
                ]
            case 5:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.977,
                    12: 0.832,
                    13: 0.219,
                    14: nil,
                    15: 0.386,
                    16: 0.518,
                    17: 0.921,
                    18: 0.227,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil
                ]
            case 6:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.977,
                    12: 0.832,
                    13: 0.219,
                    14: nil,
                    15: 0.386,
                    16: 0.518,
                    17: 0.921,
                    18: 0.227,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil
                ]
            case 7:
                return nil
            default:
                return nil
            }
        case "Olin Libe Cafe":
            switch getWeekday() {
            case 1:
                return nil
            case 2:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.977,
                    12: 0.832,
                    13: 0.219,
                    14: nil,
                    15: 0.386,
                    16: 0.518,
                    17: 0.921,
                    18: 0.227,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil
                ]
            case 3:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.977,
                    12: 0.832,
                    13: 0.219,
                    14: nil,
                    15: 0.386,
                    16: 0.518,
                    17: 0.921,
                    18: 0.227,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil
                ]
            case 4:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.977,
                    12: 0.832,
                    13: 0.219,
                    14: nil,
                    15: 0.386,
                    16: 0.518,
                    17: 0.921,
                    18: 0.227,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil
                ]
            case 5:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.977,
                    12: 0.832,
                    13: 0.219,
                    14: nil,
                    15: 0.386,
                    16: 0.518,
                    17: 0.921,
                    18: 0.227,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil
                ]
            case 6:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.977,
                    12: 0.832,
                    13: 0.219,
                    14: nil,
                    15: 0.386,
                    16: 0.518,
                    17: 0.921,
                    18: 0.227,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil
                ]
            case 7:
                return nil
            default:
                return nil
            }
        case "Okenshields":
            switch getWeekday() {
            case 1:
                return nil
            case 2:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.977,
                    12: 0.832,
                    13: 0.219,
                    14: nil,
                    15: 0.386,
                    16: 0.518,
                    17: 0.921,
                    18: 0.227,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil
                ]
            case 3:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.977,
                    12: 0.832,
                    13: 0.219,
                    14: nil,
                    15: 0.386,
                    16: 0.518,
                    17: 0.921,
                    18: 0.227,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil
                ]
            case 4:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.977,
                    12: 0.832,
                    13: 0.219,
                    14: nil,
                    15: 0.386,
                    16: 0.518,
                    17: 0.921,
                    18: 0.227,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil
                ]
            case 5:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.977,
                    12: 0.832,
                    13: 0.219,
                    14: nil,
                    15: 0.386,
                    16: 0.518,
                    17: 0.921,
                    18: 0.227,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil
                ]
            case 6:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.977,
                    12: 0.832,
                    13: 0.219,
                    14: nil,
                    15: 0.386,
                    16: 0.518,
                    17: 0.921,
                    18: 0.227,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil
                ]
            case 7:
                return nil
            default:
                return nil
            }
        case "North Star at Appel":
            switch getWeekday() {
            case 1:
                return nil
            case 2:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.977,
                    12: 0.832,
                    13: 0.219,
                    14: nil,
                    15: 0.386,
                    16: 0.518,
                    17: 0.921,
                    18: 0.227,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil
                ]
            case 3:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.977,
                    12: 0.832,
                    13: 0.219,
                    14: nil,
                    15: 0.386,
                    16: 0.518,
                    17: 0.921,
                    18: 0.227,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil
                ]
            case 4:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.977,
                    12: 0.832,
                    13: 0.219,
                    14: nil,
                    15: 0.386,
                    16: 0.518,
                    17: 0.921,
                    18: 0.227,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil
                ]
            case 5:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.977,
                    12: 0.832,
                    13: 0.219,
                    14: nil,
                    15: 0.386,
                    16: 0.518,
                    17: 0.921,
                    18: 0.227,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil
                ]
            case 6:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.977,
                    12: 0.832,
                    13: 0.219,
                    14: nil,
                    15: 0.386,
                    16: 0.518,
                    17: 0.921,
                    18: 0.227,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil
                ]
            case 7:
                return nil
            default:
                return nil
            }
        case "104West!":
            switch getWeekday() {
            case 1:
                return nil
            case 2:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.977,
                    12: 0.832,
                    13: 0.219,
                    14: nil,
                    15: 0.386,
                    16: 0.518,
                    17: 0.921,
                    18: 0.227,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil
                ]
            case 3:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.977,
                    12: 0.832,
                    13: 0.219,
                    14: nil,
                    15: 0.386,
                    16: 0.518,
                    17: 0.921,
                    18: 0.227,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil
                ]
            case 4:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.977,
                    12: 0.832,
                    13: 0.219,
                    14: nil,
                    15: 0.386,
                    16: 0.518,
                    17: 0.921,
                    18: 0.227,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil
                ]
            case 5:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.977,
                    12: 0.832,
                    13: 0.219,
                    14: nil,
                    15: 0.386,
                    16: 0.518,
                    17: 0.921,
                    18: 0.227,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil
                ]
            case 6:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.977,
                    12: 0.832,
                    13: 0.219,
                    14: nil,
                    15: 0.386,
                    16: 0.518,
                    17: 0.921,
                    18: 0.227,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil
                ]
            case 7:
                return nil
            default:
                return nil
            }
        case "Keeton House":
            switch getWeekday() {
            case 1:
                return nil
            case 2:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.977,
                    12: 0.832,
                    13: 0.219,
                    14: nil,
                    15: 0.386,
                    16: 0.518,
                    17: 0.921,
                    18: 0.227,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil
                ]
            case 3:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.977,
                    12: 0.832,
                    13: 0.219,
                    14: nil,
                    15: 0.386,
                    16: 0.518,
                    17: 0.921,
                    18: 0.227,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil
                ]
            case 4:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.977,
                    12: 0.832,
                    13: 0.219,
                    14: nil,
                    15: 0.386,
                    16: 0.518,
                    17: 0.921,
                    18: 0.227,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil
                ]
            case 5:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.977,
                    12: 0.832,
                    13: 0.219,
                    14: nil,
                    15: 0.386,
                    16: 0.518,
                    17: 0.921,
                    18: 0.227,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil
                ]
            case 6:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.977,
                    12: 0.832,
                    13: 0.219,
                    14: nil,
                    15: 0.386,
                    16: 0.518,
                    17: 0.921,
                    18: 0.227,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil
                ]
            case 7:
                return nil
            default:
                return nil
            }
        case "Jansen's at Bethe House":
            switch getWeekday() {
            case 1:
                return nil
            case 2:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.977,
                    12: 0.832,
                    13: 0.219,
                    14: nil,
                    15: 0.386,
                    16: 0.518,
                    17: 0.921,
                    18: 0.227,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil
                ]
            case 3:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.977,
                    12: 0.832,
                    13: 0.219,
                    14: nil,
                    15: 0.386,
                    16: 0.518,
                    17: 0.921,
                    18: 0.227,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil
                ]
            case 4:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.977,
                    12: 0.832,
                    13: 0.219,
                    14: nil,
                    15: 0.386,
                    16: 0.518,
                    17: 0.921,
                    18: 0.227,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil
                ]
            case 5:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.977,
                    12: 0.832,
                    13: 0.219,
                    14: nil,
                    15: 0.386,
                    16: 0.518,
                    17: 0.921,
                    18: 0.227,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil
                ]
            case 6:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.977,
                    12: 0.832,
                    13: 0.219,
                    14: nil,
                    15: 0.386,
                    16: 0.518,
                    17: 0.921,
                    18: 0.227,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil
                ]
            case 7:
                return nil
            default:
                return nil
            }
        case "Carl Becker House":
            switch getWeekday() {
            case 1:
                return nil
            case 2:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.977,
                    12: 0.832,
                    13: 0.219,
                    14: nil,
                    15: 0.386,
                    16: 0.518,
                    17: 0.921,
                    18: 0.227,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil
                ]
            case 3:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.977,
                    12: 0.832,
                    13: 0.219,
                    14: nil,
                    15: 0.386,
                    16: 0.518,
                    17: 0.921,
                    18: 0.227,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil
                ]
            case 4:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.977,
                    12: 0.832,
                    13: 0.219,
                    14: nil,
                    15: 0.386,
                    16: 0.518,
                    17: 0.921,
                    18: 0.227,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil
                ]
            case 5:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.977,
                    12: 0.832,
                    13: 0.219,
                    14: nil,
                    15: 0.386,
                    16: 0.518,
                    17: 0.921,
                    18: 0.227,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil
                ]
            case 6:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.977,
                    12: 0.832,
                    13: 0.219,
                    14: nil,
                    15: 0.386,
                    16: 0.518,
                    17: 0.921,
                    18: 0.227,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil
                ]
            case 7:
                return nil
            default:
                return nil
            }
        case "Cafe Jennie":
            switch getWeekday() {
            case 1:
                return nil
            case 2:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.977,
                    12: 0.832,
                    13: 0.219,
                    14: nil,
                    15: 0.386,
                    16: 0.518,
                    17: 0.921,
                    18: 0.227,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil
                ]
            case 3:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.977,
                    12: 0.832,
                    13: 0.219,
                    14: nil,
                    15: 0.386,
                    16: 0.518,
                    17: 0.921,
                    18: 0.227,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil
                ]
            case 4:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.977,
                    12: 0.832,
                    13: 0.219,
                    14: nil,
                    15: 0.386,
                    16: 0.518,
                    17: 0.921,
                    18: 0.227,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil
                ]
            case 5:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.977,
                    12: 0.832,
                    13: 0.219,
                    14: nil,
                    15: 0.386,
                    16: 0.518,
                    17: 0.921,
                    18: 0.227,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil
                ]
            case 6:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.977,
                    12: 0.832,
                    13: 0.219,
                    14: nil,
                    15: 0.386,
                    16: 0.518,
                    17: 0.921,
                    18: 0.227,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil
                ]
            case 7:
                return nil
            default:
                return nil
            }
        case "Alice Cook House":
            switch getWeekday() {
            case 1:
                return nil
            case 2:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.977,
                    12: 0.832,
                    13: 0.219,
                    14: nil,
                    15: 0.386,
                    16: 0.518,
                    17: 0.921,
                    18: 0.227,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil
                ]
            case 3:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.977,
                    12: 0.832,
                    13: 0.219,
                    14: nil,
                    15: 0.386,
                    16: 0.518,
                    17: 0.921,
                    18: 0.227,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil
                ]
            case 4:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.977,
                    12: 0.832,
                    13: 0.219,
                    14: nil,
                    15: 0.386,
                    16: 0.518,
                    17: 0.921,
                    18: 0.227,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil
                ]
            case 5:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.977,
                    12: 0.832,
                    13: 0.219,
                    14: nil,
                    15: 0.386,
                    16: 0.518,
                    17: 0.921,
                    18: 0.227,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil
                ]
            case 6:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.977,
                    12: 0.832,
                    13: 0.219,
                    14: nil,
                    15: 0.386,
                    16: 0.518,
                    17: 0.921,
                    18: 0.227,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil
                ]
            case 7:
                return nil
            default:
                return nil
            }
        default:
            return [:]
        }
    }
    
    func setupViews() {
        axis = UIView()
        axis.backgroundColor = .whiteTwo
        axis.clipsToBounds = true
        axis.layer.cornerRadius = axisHeight / 2
        view.addSubview(axis)
        
        currentLabel = UILabel()
        currentLabel.textColor = .warmGray
        currentLabel.text = "Hours"
        currentLabel.textAlignment = .center
        currentLabel.font = .eighteenBold
        view.addSubview(currentLabel)
        
        hoursLabel = UILabel()
        hoursLabel.textColor = .grayishBrown
        hoursLabel.text = operatingHours()
        hoursLabel.textAlignment = .center
        hoursLabel.numberOfLines = 0
        hoursLabel.font = .eighteen
        view.addSubview(hoursLabel)
        
        densityDescriptionLabel = UILabel()
        densityDescriptionLabel.textColor = .grayishBrown
        densityDescriptionLabel.clipsToBounds = true
        densityDescriptionLabel.backgroundColor = .white
        densityDescriptionLabel.layer.borderColor = UIColor.warmGray.cgColor
        densityDescriptionLabel.layer.borderWidth = 1
        densityDescriptionLabel.font = .eighteen
        densityDescriptionLabel.numberOfLines = 0
        densityDescriptionLabel.textAlignment = .center
        densityDescriptionLabel.text = "\(getHourLabel()) - \(getCurrentDensity())"
        densityDescriptionLabel.layer.cornerRadius = descriptionLabelCornerRadius
        view.addSubview(densityDescriptionLabel)
        
        selectedView = UIView()
        selectedView.backgroundColor = .warmGray
        view.addSubview(selectedView)
        
    }
    
    func operatingHours() -> String {
        switch place.displayName {
        case "Rose Dining Hall":
            return ""
        case "Risley":
            return ""
        case "RPCC Dining Hall":
            return ""
        case "Olin Libe Cafe":
            return ""
        case "Okenshields":
            if getWeekday() == 6 {
                return "11:00 AM - 2:30 PM"
            } else if getWeekday() == 1 || getWeekday() == 7 {
                return "Closed"
            } else {
                return "11:00 AM - 2:30 PM\n4:30 PM - 7:30 PM"
            }
        case "North Star at Appel":
            return ""
        case "104West!":
            return ""
        case "Keeton House":
            return ""
        case "Jansen's at Bethe House":
            return ""
        case "Carl Becker House":
            return ""
        case "Cafe Jennie":
            return ""
        case "Alice Cook House":
            return ""
        default:
            return ""
        }
    }
    
    func getHourLabel() -> String {
        var hour = ""
        if selectedHour < 12 {
            hour = "\(selectedHour)"
        } else {
            hour = selectedHour == 12 ? "\(selectedHour)" : "\(selectedHour - 12)"
        }
        return "\(hour) \(selectedHour < 12 ? "AM" : "PM")"
    }
    
    func getCurrentDensity() -> String {
        guard let densityMap = densityMap else { return "Closed" }
        guard let historicalAverage = densityMap[selectedHour] else { return "Closed" }
        guard let avg = historicalAverage else { return "Closed" }
        if avg < 0.5 {
            return "Many spots"
        } else if avg < 0.75 {
            return "Few spots"
        } else {
            return "No spots"
        }
    }
    
    func isOpen() -> Bool {
        return true
    }
    
    func setupConstraints() {
        let navOffset: CGFloat = UIApplication.shared.statusBarFrame.height + navigationController!.navigationBar.frame.height
        let currentLabelBottomInset: CGFloat = (view.frame.height - (view.frame.height / 2)) / 2
        let maxBarHeight: CGFloat = view.frame.height / 2.0 - navOffset - barVerticalPadding
        let descriptionCenterY: CGFloat = navOffset + barVerticalPadding * 0.75
        
        axis.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(axisHorizontalPadding * 2)
            make.height.equalTo(axisHeight)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.snp.centerY).offset(navOffset)
        }
        
        currentLabel.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.bottom.equalToSuperview().inset(currentLabelBottomInset)
            make.centerX.equalToSuperview()
        }
        
        hoursLabel.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalTo(currentLabel.snp.bottom).offset(hoursVerticalPadding)
            make.centerX.equalToSuperview()
        }
        
        guard let description = densityDescriptionLabel.text else { return }
        let descriptionWidth = description.widthWithConstrainedHeight(descriptionLabelHeight, font: .eighteen)
        
        layoutBars(maxBarHeight: maxBarHeight, startHour: start, endHour: end)
        
        let index = bars.firstIndex(where: { bar -> Bool in
            return bar.tag == selectedHour
        })
        guard let barIndex = index else { return }
        
        densityDescriptionLabel.snp.makeConstraints { make in
            make.width.equalTo(descriptionWidth + descriptionLabelHorizontalPadding * 2)
            make.height.equalTo(40)
            make.centerX.equalTo(bars[barIndex]).priority(.high)
            make.right.lessThanOrEqualToSuperview().offset(-descriptionLabelHorizontalPadding).priority(.required)
            make.left.greaterThanOrEqualToSuperview().offset(descriptionLabelHorizontalPadding).priority(.required)
            make.centerY.equalTo(descriptionCenterY)
        }
        
        selectedView.snp.makeConstraints { make in
            make.width.equalTo(selectedViewWidth)
            make.top.equalTo(densityDescriptionLabel.snp.bottom)
            make.bottom.equalTo(bars[barIndex].snp.top)
            make.centerX.equalTo(bars[barIndex])
        }
        
    }
    
    @objc func didTapBar(sender: UIButton) {
        selectedHour = sender.tag
        densityDescriptionLabel.text = "\(getHourLabel()) - \(getCurrentDensity())"
        
        let navOffset: CGFloat = UIApplication.shared.statusBarFrame.height + navigationController!.navigationBar.frame.height
        let descriptionCenterY: CGFloat = navOffset + barVerticalPadding * 0.75
        
        guard let description = densityDescriptionLabel.text else { return }
        let descriptionWidth = description.widthWithConstrainedHeight(descriptionLabelHeight, font: .eighteen)
        
        densityDescriptionLabel.snp.remakeConstraints { remake in
            remake.width.equalTo(descriptionWidth + descriptionLabelHorizontalPadding * 2)
            remake.height.equalTo(40)
            remake.centerX.equalTo(sender).priority(.high)
            remake.right.lessThanOrEqualToSuperview().offset(-descriptionLabelHorizontalPadding).priority(.required)
            remake.left.greaterThanOrEqualToSuperview().offset(descriptionLabelHorizontalPadding).priority(.required)
            remake.centerY.equalTo(descriptionCenterY)
        }
        
        selectedView.snp.remakeConstraints { remake in
            remake.width.equalTo(selectedViewWidth)
            remake.top.equalTo(densityDescriptionLabel.snp.bottom)
            remake.bottom.equalTo(sender.snp.top)
            remake.centerX.equalTo(sender)
        }
    }
    
    func layoutBars(maxBarHeight: CGFloat, startHour: Int, endHour: Int) {
        guard let densityMap = densityMap else { return }
        var hour: Int = startHour
        var barLeftOffset: CGFloat = 0
        let barWidth: CGFloat = (view.frame.width - axisHorizontalPadding * 4) / CGFloat(densityMap.keys.count)
        while hour <= endHour {
            let bar = UIButton()
            bar.tag = hour
            bar.addTarget(self, action: #selector(didTapBar), for: .touchUpInside)
            var barHeight: CGFloat = 1
            if let historicalAverage = densityMap[hour], let avg = historicalAverage {
                if avg < 0.5 {
                    bar.backgroundColor = .lightTeal
                } else if avg < 0.75 {
                    bar.backgroundColor = .peach
                } else {
                    bar.backgroundColor = .orangeyRed
                }
                barHeight = maxBarHeight * CGFloat(avg)
            } else {
                bar.isHidden = true
                bar.isEnabled = false
            }
            bar.clipsToBounds = true
            bar.layer.cornerRadius = 5
            bar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            bar.layer.borderColor = UIColor.white.cgColor
            bar.layer.borderWidth = 0.5
            self.view.addSubview(bar)
            
            bar.snp.makeConstraints({ make in
                make.width.equalTo(barWidth)
                make.height.equalTo(barHeight)
                make.left.equalTo(axis).offset(barLeftOffset)
                make.bottom.equalTo(self.axis.snp.top)
            })
            self.bars.append(bar)
            barLeftOffset += barWidth
            hour += 1
        }
    }

}
