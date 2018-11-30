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
    var bars = [UIView]()
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
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: 0.646,
                    11: 0.873,
                    12: 0.642,
                    13: 0.792,
                    14: 0.024,
                    15: nil,
                    16: nil,
                    17: 1,
                    18: 0.92,
                    19: 0.528,
                    20: nil,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            case 2:
                return [
                    7: 0.279,
                    8: 0.325,
                    9: 0.396,
                    10: nil,
                    11: nil,
                    12: nil,
                    13: nil,
                    14: nil,
                    15: nil,
                    16: nil,
                    17: 0.87,
                    18: 0.909,
                    19: 0.877,
                    20: nil,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            case 3:
                return [
                    7: 0.558,
                    8: 0.629,
                    9: 0.179,
                    10: nil,
                    11: nil,
                    12: nil,
                    13: nil,
                    14: nil,
                    15: nil,
                    16: nil,
                    17: 0.979,
                    18: 1,
                    19: 0.538,
                    20: nil,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            case 4:
                return [
                    7: 0.636,
                    8: 0.393,
                    9: 0.011,
                    10: nil,
                    11: nil,
                    12: nil,
                    13: nil,
                    14: nil,
                    15: nil,
                    16: nil,
                    17: 0.768,
                    18: 1,
                    19: 0.599,
                    20: nil,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            case 5:
                return [
                    7: 0.433,
                    8: 0.502,
                    9: 0.16,
                    10: nil,
                    11: nil,
                    12: nil,
                    13: nil,
                    14: nil,
                    15: nil,
                    16: nil,
                    17: 1,
                    18: 0.825,
                    19: 0.886,
                    20: nil,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            case 6:
                return [
                    7: 0.162,
                    8: 0.554,
                    9: 0.378,
                    10: nil,
                    11: nil,
                    12: nil,
                    13: nil,
                    14: nil,
                    15: nil,
                    16: nil,
                    17: 0.459,
                    18: 1,
                    19: 0.532,
                    20: nil,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            case 7:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: 0.283,
                    11: 0.409,
                    12: 0.424,
                    13: 0.533,
                    14: 0.011,
                    15: nil,
                    16: nil,
                    17: 0.899,
                    18: 1,
                    19: 0.62,
                    20: nil,
                    21: nil,
                    22: nil,
                    23: nil
                ]
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
                    11: 0.77,
                    12: 0.745,
                    13: 0.506,
                    14: nil,
                    15: nil,
                    16: nil,
                    17: 0.749,
                    18: 1,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            case 3:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 1,
                    12: 0.563,
                    13: 0.508,
                    14: nil,
                    15: nil,
                    16: nil,
                    17: 0.809,
                    18: 0.915,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            case 4:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.711,
                    12: 0.803,
                    13: 0.491,
                    14: nil,
                    15: nil,
                    16: nil,
                    17: 0.784,
                    18: 1,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            case 5:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.969,
                    12: 0.591,
                    13: 0.508,
                    14: nil,
                    15: nil,
                    16: nil,
                    17: 1,
                    18: 0.601,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            case 6:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.691,
                    12: 1,
                    13: 0.461,
                    14: nil,
                    15: nil,
                    16: nil,
                    17: 0.669,
                    18: 0.994,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            case 7:
                return nil
            default:
                return nil
            }
        case "RPCC Dining Hall":
            switch getWeekday() {
            case 1:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: 0.933,
                    11: 1,
                    12: 0.69,
                    13: 0.595,
                    14: nil,
                    15: nil,
                    16: nil,
                    17: 0.517,
                    18: 0.793,
                    19: 0.579,
                    20: 0.233,
                    21: nil,
                    22: nil,
                    23: nil
                ]
                
            case 2:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: nil,
                    12: nil,
                    13: nil,
                    14: nil,
                    15: nil,
                    16: nil,
                    17: 0.504,
                    18: 1,
                    19: 0.743,
                    20: 0.429,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            case 3:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: nil,
                    12: nil,
                    13: nil,
                    14: nil,
                    15: nil,
                    16: nil,
                    17: 0.737,
                    18: 1,
                    19: 0.733,
                    20: 0.28,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            case 4:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: nil,
                    12: nil,
                    13: nil,
                    14: nil,
                    15: nil,
                    16: nil,
                    17: 0.459,
                    18: 1,
                    19: 0.602,
                    20: 0.285,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            case 5:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: nil,
                    12: nil,
                    13: nil,
                    14: nil,
                    15: nil,
                    16: nil,
                    17: 0.584,
                    18: 1,
                    19: 0.699,
                    20: 0.416,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            case 6:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: nil,
                    12: nil,
                    13: nil,
                    14: nil,
                    15: nil,
                    16: nil,
                    17: 0.339,
                    18: 1,
                    19: 0.602,
                    20: 0.328,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            case 7:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: nil,
                    12: nil,
                    13: nil,
                    14: nil,
                    15: nil,
                    16: nil,
                    17: 0.406,
                    18: 1,
                    19: 0.638,
                    20: 0.23,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            default:
                return nil
            }
        case "Olin Libe Cafe":
            switch getWeekday() {
            case 1:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.490,
                    12: 0.611,
                    13: 0.681,
                    14: 0.841,
                    15: 0.873,
                    16: 1.000,
                    17: 0.717,
                    18: 0.513,
                    19: 0.401,
                    20: 0.457,
                    21: 0.434,
                    22: 0.484,
                    23: 0.389
                ]
            case 2:
                return [
                    7: nil,
                    8: 0.443,
                    9: 0.621,
                    10: 0.709,
                    11: 0.876,
                    12: 0.727,
                    13: 0.826,
                    14: 1.000,
                    15: 0.950,
                    16: 0.936,
                    17: 0.543,
                    18: 0.624,
                    19: 0.663,
                    20: 0.642,
                    21: 0.858,
                    22: 0.589,
                    23: 0.535
                ]
            case 3:
                return [
                    7: nil,
                    8: 0.41,
                    9: 0.571,
                    10: 0.679,
                    11: 0.894,
                    12: 0.734,
                    13: 0.91,
                    14: 0.862,
                    15: 0.917,
                    16: 1,
                    17: 0.58,
                    18: 0.702,
                    19: 0.635,
                    20: 0.609,
                    21: 0.606,
                    22: 0.503,
                    23: 0.41
                ]
            case 4:
                return [
                    7: nil,
                    8: 0.516,
                    9: 0.422,
                    10: 0.892,
                    11: 0.655,
                    12: 0.92,
                    13: 0.885,
                    14: 1,
                    15: 0.861,
                    16: 0.948,
                    17: 0.61,
                    18: 0.571,
                    19: 0.509,
                    20: 0.554,
                    21: 0.669,
                    22: 0.537,
                    23: 0.383
                ]
            case 5:
                return [
                    7: nil,
                    8: 0.484,
                    9: 0.709,
                    10: 0.717,
                    11: 1.102,
                    12: 0.791,
                    13: 0.882,
                    14: 0.984,
                    15: 1,
                    16: 0.988,
                    17: 0.665,
                    18: 0.543,
                    19: 0.587,
                    20: 0.5,
                    21: 0.488,
                    22: 0.386,
                    23: 0.307
                ]
            case 6:
                return [
                    7: nil,
                    8: 0.365,
                    9: 0.578,
                    10: 0.877,
                    11: 0.749,
                    12: 0.972,
                    13: 0.791,
                    14: 1,
                    15: 0.739,
                    16: 0.81,
                    17: 0.445,
                    18: nil,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            case 7:
                return [
                7: nil,
                8: nil,
                9: nil,
                10: 0.571,
                11: 0.472,
                12: 0.714,
                13: 0.974,
                14: 0.892,
                15: 1,
                16: 0.81,
                17: 0.641,
                18: nil,
                19: nil,
                20: nil,
                21: nil,
                22: nil,
                23: nil
                ]
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
                    11: 1,
                    12: 0.977,
                    13: 0.832,
                    14: 0.219,
                    15: nil,
                    16: 0.386,
                    17: 0.518,
                    18: 0.921,
                    19: 0.227,
                    20: nil,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            case 3:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 1,
                    12: 0.63,
                    13: 0.63,
                    14: 0.101,
                    15: nil,
                    16: 0.304,
                    17: 0.518,
                    18: 0.757,
                    19: 0.164,
                    20: nil,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            case 4:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.823,
                    12: 1,
                    13: 0.659,
                    14: 0.166,
                    15: nil,
                    16: 0.346,
                    17: 0.645,
                    18: 0.88,
                    19: 0.192,
                    20: nil,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            case 5:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 1,
                    12: 0.573,
                    13: 0.69,
                    14: 0.15,
                    15: nil,
                    16: 0.407,
                    17: 0.81,
                    18: 0.872,
                    19: 0.239,
                    20: nil,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            case 6:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.828,
                    12: 1,
                    13: 0.689,
                    14: 0.306,
                    15: nil,
                    16: nil,
                    17: nil,
                    18: nil,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            case 7:
                return nil
            default:
                return nil
            }
        case "North Star at Appel":
            switch getWeekday() {
            case 1:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: 0.485,
                    11: 0.554,
                    12: 0.575,
                    13: 0.429,
                    14: 0.265,
                    15: 0.193,
                    16: nil,
                    17: 1,
                    18: 0.906,
                    19: 0.733,
                    20: nil,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            case 2:
                return [
                    7: 0.354,
                    8: 0.556,
                    9: 0.531,
                    10: 0.347,
                    11: 0.603,
                    12: 0.621,
                    13: 0.533,
                    14: 0.28,
                    15: 0.079,
                    16: nil,
                    17: 0.81,
                    18: 1,
                    19: 0.686,
                    20: nil,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            case 3:
                return [
                    7: 0.28,
                    8: 0.458,
                    9: 0.365,
                    10: 0.292,
                    11: 0.717,
                    12: 0.576,
                    13: 0.522,
                    14: 0.202,
                    15: 0.13,
                    16: nil,
                    17: 0.877,
                    18: 1,
                    19: 0.502,
                    20: nil,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            case 4:
                return [
                    7: 0.193,
                    8: 0.471,
                    9: 0.309,
                    10: 0.275,
                    11: 0.435,
                    12: 0.667,
                    13: 0.39,
                    14: 0.184,
                    15: 0.085,
                    16: nil,
                    17: 0.691,
                    18: 1,
                    19: 0.401,
                    20: nil,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            case 5:
                return [
                    7: 0.322,
                    8: 0.473,
                    9: 0.392,
                    10: 0.311,
                    11: 0.809,
                    12: 0.653,
                    13: 0.745,
                    14: 0.176,
                    15: 0.101,
                    16: nil,
                    17: 0.948,
                    18: 1,
                    19: 0.867,
                    20: nil,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            case 6:
                return [
                    7: 0.143,
                    8: 0.362,
                    9: 0.401,
                    10: 0.424,
                    11: 0.539,
                    12: 0.973,
                    13: 0.583,
                    14: 0.329,
                    15: 0.136,
                    16: 0.06,
                    17: 0.545,
                    18: 1,
                    19: 0.564,
                    20: nil,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            case 7:
                return [
                    7: 0.048,
                    8: 0.212,
                    9: 0.292,
                    10: 0.388,
                    11: 0.525,
                    12: 1,
                    13: 0.581,
                    14: 0.276,
                    15: 0.128,
                    16: 0.022,
                    17: 0.351,
                    18: 0.767,
                    19: 0.494,
                    20: nil,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            default:
                return nil
            }
        case "104West!":
            switch getWeekday() {
            case 1:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.873,
                    12: 0.642,
                    13: 0.792,
                    14: 0.024,
                    15: nil,
                    16: nil,
                    17: 1,
                    18: 0.92,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            case 2:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.734,
                    12: 1,
                    13: 0.909,
                    14: 0.13,
                    15: nil,
                    16: nil,
                    17: 0.87,
                    18: 0.909,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            case 3:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.8,
                    12: 0.558,
                    13: 0.629,
                    14: 0.179,
                    15: nil,
                    16: nil,
                    17: 0.979,
                    18: 1,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            case 4:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.397,
                    12: 0.636,
                    13: 0.393,
                    14: 0.011,
                    15: nil,
                    16: nil,
                    17: 0.768,
                    18: 1,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            case 5:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.631,
                    12: 0.433,
                    13: 0.502,
                    14: 0.16,
                    15: nil,
                    16: nil,
                    17: 1,
                    18: 0.825,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            case 6:
                return [
                    7: 0.162,
                    8: 0.554,
                    9: 0.378,
                    10: 0.378,
                    11: 0.518,
                    12: 0.716,
                    13: 0.604,
                    14: 0.176,
                    15: 0.10,
                    16: nil,
                    17:nil,
                    18: 1,
                    19: 0.9,
                    20: nil,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            case 7:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: 0.283,
                    11: 0.409,
                    12: 0.424,
                    13: 0.533,
                    14: 0.011,
                    15: nil,
                    16: nil,
                    17: 0.899,
                    18: 1,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            default:
                return nil
            }
        case "Keeton House":
            switch getWeekday() {
            case 1:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: 0.646,
                    11: 0.873,
                    12: 0.642,
                    13: 0.792,
                    14: 0.024,
                    15: nil,
                    16: nil,
                    17: 1,
                    18: 0.92,
                    19: 0.528,
                    20: nil,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            case 2:
                return [
                    7: nil,
                    8: 0.279,
                    9: 0.325,
                    10: 0.396,
                    11: 0.734,
                    12: 1,
                    13: 0.909,
                    14: 0.13,
                    15: nil,
                    16: nil,
                    17: 0.87,
                    18: 0.909,
                    19: 0.877,
                    20: nil,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            case 3:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.8,
                    12: 0.558,
                    13: 0.629,
                    14: 0.179,
                    15: nil,
                    16: nil,
                    17: 0.979,
                    18: 1,
                    19: 0.538,
                    20: nil,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            case 4:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.397,
                    12: 0.636,
                    13: 0.393,
                    14: 0.011,
                    15: nil,
                    16: nil,
                    17: 0.768,
                    18: 1,
                    19: 0.599,
                    20: nil,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            case 5:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.631,
                    12: 0.433,
                    13: 0.502,
                    14: 0.16,
                    15: nil,
                    16: nil,
                    17: 1,
                    18: 0.825,
                    19: 0.886,
                    20: nil,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            case 6:
                return [
                    7: 0.162,
                    8: 0.554,
                    9: 0.378,
                    10: 0.378,
                    11: 0.518,
                    12: 0.716,
                    13: 0.604,
                    14: 0.176,
                    15: nil,
                    16: nil,
                    17: 0.459,
                    18: 1,
                    19: 0.532,
                    20: nil,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            case 7:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: 0.283,
                    11: 0.409,
                    12: 0.424,
                    13: 0.533,
                    14: 0.011,
                    15: nil,
                    16: nil,
                    17: 0.899,
                    18: 1,
                    19: 0.62,
                    20: nil,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            default:
                return nil
            }
        case "Jansen's at Bethe House":
            switch getWeekday() {
            case 1:
                return [
                        7: 0.241,
                        8: 0.431,
                        9: 0.356,
                        10: 0.218,
                        11: 0.417,
                        12: 0.583,
                        13: 0.541,
                        14: 0.006,
                        15: nil,
                        16: 0.28,
                        17: 0.529,
                        18: 1,
                        19: 0.272,
                        20: nil,
                        21: nil,
                        22: nil,
                        23: nil
                ]
            case 2:
                return [
                    7: 0.275,
                    8: 0.472,
                    9: 0.431,
                    10: 0.209,
                    11: 0.5,
                    12: 0.556,
                    13: 0.534,
                    14: 0.016,
                    15: nil,
                    16: 0.25,
                    17: 0.609,
                    18: 1,
                    19: 0.278,
                    20: nil,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            case 3:
                return [
                    7: 0.373,
                    8: 0.703,
                    9: 0.656,
                    10: 0.383,
                    11: 0.981,
                    12: 0.679,
                    13: 0.689,
                    14: 0.01,
                    15: nil,
                    16: 0.321,
                    17: 0.732,
                    18: 1,
                    19: 0.278,
                    20: nil,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            case 4:
                return [
                    7: 0.217,
                    8: 0.502,
                    9: 0.375,
                    10: 0.304,
                    11: 0.511,
                    12: 0.816,
                    13: 0.615,
                    14: 0,
                    15: nil,
                    16: 0,
                    17: 0.155,
                    18: 1,
                    19: 0.256,
                    20: nil,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            case 5:
                return [
                    7: 0.251,
                    8: 0.547,
                    9: 0.494,
                    10: 0.358,
                    11: 0.844,
                    12: 0.543,
                    13: 0.634,
                    14: 0.004,
                    15: nil,
                    16: 0.337,
                    17: 0.802,
                    18: 1,
                    19: 0.453,
                    20: nil,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            case 6:
                return [
                    7: 0.141,
                    8: 0.452,
                    9: 0.444,
                    10: 0.267,
                    11: 0.6,
                    12: 1,
                    13: 0.778,
                    14: 0.015,
                    15: nil,
                    16: 0.226,
                    17: 0.504,
                    18: 0.981,
                    19: 0.348,
                    20: nil,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            case 7:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: 0.536,
                    11: 0.563,
                    12: 0.865,
                    13: 0.661,
                    14: 0.021,
                    15: nil,
                    16: 0.453,
                    17: 0.599,
                    18: 1,
                    19: 0.375,
                    20: nil,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            default:
                return nil
            }
        case "Carl Becker House":
            switch getWeekday() {
            case 1:
                return [
                        7: nil,
                        8: nil,
                        9: nil,
                        10: 0.646,
                        11: 0.873,
                        12: 0.642,
                        13: 0.792,
                        14: 0.024,
                        15: nil,
                        16: nil,
                        17: 1,
                        18: 0.92,
                        19: 0.528,
                        20: nil,
                        21: nil,
                        22: nil,
                        23: nil
                ]
            case 2:
                return [
                    7: nil,
                    8: 0.279,
                    9: 0.325,
                    10: 0.396,
                    11: 0.734,
                    12: 1,
                    13: 0.909,
                    14: 0.13,
                    15: nil,
                    16: nil,
                    17: 0.87,
                    18: 0.909,
                    19: 0.877,
                    20: nil,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            case 3:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.8,
                    12: 0.558,
                    13: 0.629,
                    14: 0.179,
                    15: nil,
                    16: nil,
                    17: 0.979,
                    18: 1,
                    19: 0.538,
                    20: nil,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            case 4:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.397,
                    12: 0.636,
                    13: 0.393,
                    14: 0.011,
                    15: nil,
                    16: nil,
                    17: 0.768,
                    18: 1,
                    19: 0.599,
                    20: nil,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            case 5:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.631,
                    12: 0.433,
                    13: 0.502,
                    14: 0.16,
                    15: nil,
                    16: nil,
                    17: 1,
                    18: 0.825,
                    19: 0.886,
                    20: nil,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            case 6:
                return [
                    7: 0.162,
                    8: 0.554,
                    9: 0.378,
                    10: 0.378,
                    11: 0.518,
                    12: 0.716,
                    13: 0.604,
                    14: 0.176,
                    15: nil,
                    16: nil,
                    17: 0.459,
                    18: 1,
                    19: 0.532,
                    20: nil,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            case 7:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: 0.283,
                    11: 0.409,
                    12: 0.424,
                    13: 0.533,
                    14: 0.011,
                    15: nil,
                    16: nil,
                    17: 0.899,
                    18: 1,
                    19: 0.62,
                    20: nil,
                    21: nil,
                    22: nil,
                    23: nil
                ]
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
                    8: 0.253,
                    9: 0.56,
                    10: 0.473,
                    11: 0.893,
                    12: 0.62,
                    13: 1,
                    14: 0.653,
                    15: 0.56,
                    16: 0.68,
                    17: 0.267,
                    18: nil,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            case 3:
                return [
                    7: nil,
                    8: 0.549,
                    9: 0.346,
                    10: 0.662,
                    11: 0.677,
                    12: 1,
                    13: 0.917,
                    14: 0.82,
                    15: 0.436,
                    16: 0.812,
                    17: 0.331,
                    18: nil,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            case 4:
                return [
                    7: nil,
                    8: 0.243,
                    9: 0.5,
                    10: 0.507,
                    11: 0.784,
                    12: 0.534,
                    13: 1,
                    14: 0.682,
                    15: 0.459,
                    16: 0.635,
                    17: 0.291,
                    18: nil,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            case 5:
                return [
                    7: nil,
                    8: 0.238,
                    9: 0.377,
                    10: 0.68,
                    11: 0.656,
                    12: 1,
                    13: 0.91,
                    14: 0.877,
                    15: 0.82,
                    16: 0.689,
                    17: 0.164,
                    18: nil,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            case 6:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: 0.552,
                    11: 0.552,
                    12: 1,
                    13: 0.952,
                    14: 0.781,
                    15: 0.895,
                    16: 0.638,
                    17: nil,
                    18: nil,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            case 7:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: 0.552,
                    11: 0.552,
                    12: 1,
                    13: 0.952,
                    14: 0.781,
                    15: 0.895,
                    16: 0.638,
                    17: nil,
                    18: nil,
                    19: nil,
                    20: nil,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            default:
                return nil
            }
        case "Alice Cook House":
            switch getWeekday() {
            case 1:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: 0.646,
                    11: 0.873,
                    12: 0.642,
                    13: 0.792,
                    14: 0.024,
                    15: nil,
                    16: nil,
                    17: 1,
                    18: 0.92,
                    19: 0.528,
                    20: nil,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            case 2:
                return [
                    7: nil,
                    8: 0.279,
                    9: 0.325,
                    10: 0.396,
                    11: 0.734,
                    12: 1,
                    13: 0.909,
                    14: 0.13,
                    15: nil,
                    16: nil,
                    17: 0.87,
                    18: 0.909,
                    19: 0.877,
                    20: nil,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            case 3:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.8,
                    12: 0.558,
                    13: 0.629,
                    14: 0.179,
                    15: nil,
                    16: nil,
                    17: 0.979,
                    18: 1,
                    19: 0.538,
                    20: nil,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            case 4:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.397,
                    12: 0.636,
                    13: 0.393,
                    14: 0.011,
                    15: nil,
                    16: nil,
                    17: 0.768,
                    18: 1,
                    19: 0.599,
                    20: nil,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            case 5:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: nil,
                    11: 0.631,
                    12: 0.433,
                    13: 0.502,
                    14: 0.16,
                    15: nil,
                    16: nil,
                    17: 1,
                    18: 0.825,
                    19: 0.886,
                    20: nil,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            case 6:
                return [
                    7: 0.162,
                    8: 0.554,
                    9: 0.378,
                    10: 0.378,
                    11: 0.518,
                    12: 0.716,
                    13: 0.604,
                    14: 0.176,
                    15: nil,
                    16: nil,
                    17: 0.459,
                    18: 1,
                    19: 0.532,
                    20: nil,
                    21: nil,
                    22: nil,
                    23: nil
                ]
            case 7:
                return [
                    7: nil,
                    8: nil,
                    9: nil,
                    10: 0.283,
                    11: 0.409,
                    12: 0.424,
                    13: 0.533,
                    14: 0.011,
                    15: nil,
                    16: nil,
                    17: 0.899,
                    18: 1,
                    19: 0.62,
                    20: nil,
                    21: nil,
                    22: nil,
                    23: nil
                ]
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
        currentLabel.text = "Today's Hours"
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
            switch getWeekday() {
            case 1:
                return "8:00 AM - 9:30 AM\n10:00 AM - 2:00 PM\n5:00 PM - 8:00 PM"
            case 2:
                return "7:30 AM - 10:00 AM\n5:00 PM - 8:00 PM"
            case 3:
                return "7:30 AM - 10:00 AM\n5:00 PM - 8:00 PM"
            case 4:
                return "7:30 AM - 10:00 AM\n6:00 PM - 8:00 PM"
            case 5:
                return "7:30 AM - 10:00 AM\n5:00 PM - 8:00 PM"
            case 6:
                return "7:30 AM - 10:00 AM\n5:00 PM - 8:00 PM"
            case 7:
                return "8:00 AM - 10:00 AM\n10:30 AM - 2:00 PM\n5:00 PM - 8:00 PM"
            default:
                return "Closed"
            }
        case "Risley":
            switch getWeekday() {
            case 1:
                return "Closed"
            case 2:
                return "11:00 AM - 2:00 PM\n5:00 PM - 7:00 PM"
            case 3:
                return "11:00 AM - 2:00 PM\n5:00 PM - 7:00 PM"
            case 4:
                return "11:00 AM - 2:00 PM\n5:00 PM - 7:00 PM"
            case 5:
                return "11:00 AM - 2:00 PM\n5:00 PM - 7:00 PM"
            case 6:
                return "11:00 AM - 2:00 PM\n5:00 PM - 7:00 PM"
            case 7:
                return "Closed"
            default:
                return "Closed"
            }
        case "RPCC Dining Hall":
            switch getWeekday() {
            case 1:
                return "10:00 AM - 2:00 PM\n5:30 PM - 8:30 PM"
            case 2:
                return "5:30 PM - 9:00 PM"
            case 3:
                return "5:30 PM - 9:00 PM"
            case 4:
                return "5:30 PM - 9:00 PM"
            case 5:
                return "5:30 PM - 9:00 PM"
            case 6:
                return "5:30 PM - 8:30 PM"
            case 7:
                return "5:30 PM - 8:30 PM"
            default:
                return "Closed"
            }
        case "Olin Libe Cafe":
            switch getWeekday() {
            case 1:
                return "10:00 AM - 12:00 AM"
            case 2:
                return "8:00 AM - 12:00 AM"
            case 3:
                return "8:00 AM - 12:00 AM"
            case 4:
                return "8:00 AM - 12:00 AM"
            case 5:
                return "8:00 AM - 12:00 AM"
            case 6:
                return "8:00 AM - 6:00 PM"
            case 7:
                return "10:00 AM - 8:00 PM"
            default:
                return "Closed"
            }
        case "Okenshields":
            if getWeekday() == 6 {
                return "11:00 AM - 2:30 PM"
            } else if getWeekday() == 1 || getWeekday() == 7 {
                return "Closed"
            } else {
                return "11:00 AM - 2:30 PM\n4:30 PM - 7:30 PM"
            }
        case "North Star at Appel":
            switch getWeekday() {
            case 1:
                return "10:00 AM - 2:00 PM\n2:00 PM - 4:00 PM\n5:00 PM - 8:00 PM"
            case 2:
                return "7:00 AM - 10:30 AM\n10:30 AM - 2:00 PM\n2:00 PM - 4:00 PM\n5:00 PM - 8:00 PM"
            case 3:
                return "7:00 AM - 10:30 AM\n10:30 AM - 2:00 PM\n2:00 PM - 4:00 PM\n5:00 PM - 8:00 PM"
            case 4:
                return "7:00 AM - 10:30 AM\n10:30 AM - 2:00 PM\n2:00 PM - 4:00 PM\n5:00 PM - 8:00 PM"
            case 5:
                return "7:00 AM - 10:30 AM\n10:30 AM - 2:00 PM\n2:00 PM - 4:00 PM\n5:00 PM - 8:00 PM"
            case 6:
                return "7:00 AM - 10:30 AM\n10:30 AM - 2:00 PM\n2:00 PM - 4:00 PM\n5:00 PM - 8:00 PM"
            case 7:
                return "8:00 AM - 10:30 AM\n10:30 AM - 2:00 PM\n2:00 PM - 4:00 PM\n5:00 PM - 8:00 PM"
            default:
                return "Closed"
            }
        case "104West!":
            switch getWeekday() {
            case 1:
                return "11:00 AM - 2:00 PM\n5:00 PM - 7:00 PM"
            case 2:
                return "11:00 AM - 2:00 PM\n5:00 PM - 7:00 PM"
            case 3:
                return "11:00 AM - 2:00 PM\n5:00 PM - 7:00 PM"
            case 4:
                return "11:00 AM - 2:00 PM\n5:00 PM - 7:00 PM"
            case 5:
                return "11:00 AM - 2:00 PM\n5:00 PM - 7:00 PM"
            case 6:
                return "11:00 AM - 3:00 PM\n6:00 PM - 8:00 PM"
            case 7:
                return "12:30 PM - 2:00 PM\n6:00 PM - 8:00 PM"
            default:
                return "Closed"
            }
        case "Keeton House":
            switch getWeekday() {
            case 1:
                return "10:00 AM - 2:00 PM\n5:00 PM - 8:00 PM"
            case 2:
                return "7:30 AM - 10:00 AM\n5:00 PM - 8:00 PM"
            case 3:
                return "11:00 AM - 2:00 PM\n5:00 PM - 8:00 PM"
            case 4:
                return "6:00 PM - 8:00 PM"
            case 5:
                return "7:30 AM - 10:00 AM\n5:00 PM - 8:00 PM"
            case 6:
                return "7:30 AM - 10:00 AM\n5:00 PM - 8:00 PM"
            case 7:
                return "10:30 AM - 2:00 PM\n5:00 PM - 8:00 PM"
            default:
                return "Closed"
            }
        case "Jansen's at Bethe House":
            switch getWeekday() {
            case 1:
                return "10:00 AM - 2:00 PM\n4:30 PM - 7:30 PM"
            case 2:
                return "7:00 AM - 10:30 AM\n10:30 AM - 2:00 PM\n4:30 PM - 7:30 PM"
            case 3:
                return "7:00 AM - 10:30 AM\n10:30 AM - 2:00 PM\n4:30 PM - 7:30 PM"
            case 4:
                return "7:00 AM - 10:30 AM\n10:30 AM - 2:00 PM\n6:00 PM - 7:30 PM"
            case 5:
                return "7:00 AM - 10:30 AM\n10:30 AM - 2:00 PM\n4:30 PM - 7:30 PM"
            case 6:
                return "7:00 AM - 10:30 AM\n10:30 AM - 2:00 PM\n4:30 PM - 7:30 PM"
            case 7:
                return "10:30 AM - 2:00 PM\n4:30 PM - 7:30 PM"
            default:
                return "Closed"
            }
        case "Carl Becker House":
            switch getWeekday() {
            case 1:
                return "10:00 AM - 2:00 PM\n5:00 PM - 8:00 PM"
            case 2:
                return "7:00 AM - 10:30 AM\n10:30 AM - 2:00 PM\n5:00 PM - 8:00 PM"
            case 3:
                return "7:00 AM - 10:30 AM\n10:30 AM - 2:00 PM\n5:00 PM - 8:00 PM"
            case 4:
                return "7:00 AM - 10:30 AM\n10:30 AM - 2:00 PM\n6:00 PM - 8:00 PM"
            case 5:
                return "7:00 AM - 10:30 AM\n10:30 AM - 3:30 PM\n5:00 PM - 8:00 PM"
            case 6:
                return "7:00 AM - 10:30 AM\n10:30 AM - 3:30 PM\n5:00 PM - 8:00 PM"
            case 7:
                return "10:30 AM - 2:00 PM\n5:00 PM - 8:00 PM"
            default:
                return "Closed"
            }
        case "Cafe Jennie":
            switch getWeekday() {
            case 1:
                return "Closed"
            case 2:
                return "8:00 AM - 6:00 PM"
            case 3:
                return "8:00 AM - 6:00 PM"
            case 4:
                return "8:00 AM - 6:00 PM"
            case 5:
                return "8:00 AM - 6:00 PM"
            case 6:
                return "8:00 AM - 6:00 PM"
            case 7:
                return "10:00 AM - 5:00 PM"
            default:
                return "Closed"
            }
        case "Alice Cook House":
            switch getWeekday() {
            case 1:
                return "10:00 AM - 2:00 PM\n5:00 PM - 9:00 PM"
            case 2:
                return "7:30 AM - 10:00 AM\n5:00 PM - 9:00 PM"
            case 3:
                return "7:30 AM - 10:00 AM\n5:00 PM - 9:00 PM"
            case 4:
                return "6:00 PM - 9:00 PM"
            case 5:
                return "7:30 AM - 10:00 AM\n5:00 PM - 9:00 PM"
            case 6:
                return "7:30 AM - 10:00 AM\n5:00 PM - 9:00 PM"
            case 7:
                return "10:30 AM - 2:00 PM\n5:00 PM - 9:00 PM"
            default:
                return "Closed"
            }
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
            return "Usually not busy"
        } else if avg < 0.75 {
            return "Usually pretty busy"
        } else {
            return "Usually very busy"
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
        
        if let barIndex = index {
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
        } else {
            densityDescriptionLabel.snp.makeConstraints { make in
                make.width.equalTo(descriptionWidth + descriptionLabelHorizontalPadding * 2)
                make.height.equalTo(40)
                make.centerX.equalToSuperview()
                make.centerY.equalTo(descriptionCenterY)
            }
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let location = touches.first?.location(in: view) {
            let index = bars.firstIndex { bar -> Bool in
                return bar.frame.contains(location)
            }
            guard let barIndex = index else { return }
            didTapBar(bar: bars[barIndex])
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let location = touches.first?.location(in: view) {
            let index = bars.firstIndex { bar -> Bool in
                return bar.frame.contains(location)
            }
            guard let barIndex = index else { return }
            didTapBar(bar: bars[barIndex])
        }
    }
    
    func didTapBar(bar: UIView) {
        selectedHour = bar.tag
        densityDescriptionLabel.text = "\(getHourLabel()) - \(getCurrentDensity())"
        
        let navOffset: CGFloat = UIApplication.shared.statusBarFrame.height + navigationController!.navigationBar.frame.height
        let descriptionCenterY: CGFloat = navOffset + barVerticalPadding * 0.75
        
        guard let description = densityDescriptionLabel.text else { return }
        let descriptionWidth = description.widthWithConstrainedHeight(descriptionLabelHeight, font: .eighteen)
        
        densityDescriptionLabel.snp.remakeConstraints { remake in
            remake.width.equalTo(descriptionWidth + descriptionLabelHorizontalPadding * 2)
            remake.height.equalTo(40)
            remake.centerX.equalTo(bar).priority(.high)
            remake.right.lessThanOrEqualToSuperview().offset(-descriptionLabelHorizontalPadding).priority(.required)
            remake.left.greaterThanOrEqualToSuperview().offset(descriptionLabelHorizontalPadding).priority(.required)
            remake.centerY.equalTo(descriptionCenterY)
        }
        
        selectedView.snp.remakeConstraints { remake in
            remake.width.equalTo(selectedViewWidth)
            remake.top.equalTo(densityDescriptionLabel.snp.bottom)
            remake.bottom.equalTo(bar.snp.top)
            remake.centerX.equalTo(bar)
        }
    }
    
    func layoutBars(maxBarHeight: CGFloat, startHour: Int, endHour: Int) {
        guard let densityMap = densityMap else { return }
        var hour: Int = startHour
        var barLeftOffset: CGFloat = 0
        let barWidth: CGFloat = (view.frame.width - axisHorizontalPadding * 4) / CGFloat(densityMap.keys.count)
        while hour <= endHour {
            let bar = UIView()
            bar.tag = hour
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
