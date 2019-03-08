//
//  Utils.swift
//  Campus Density
//
//  Created by Matthew Coufal on 2/24/19.
//  Copyright © 2019 Cornell DTI. All rights reserved.
//

import UIKit

struct Constants {
    static let smallPadding: CGFloat = 15
    static let mediumPadding: CGFloat = 25
    static let largePadding: CGFloat = 50
}

func getHourLabel(selectedHour: Int) -> String {
    var hour = ""
    if selectedHour < 12 {
        hour = selectedHour == 0 ? "12" : "\(selectedHour)"
    } else {
        hour = selectedHour == 12 ? "\(selectedHour)" : "\(selectedHour - 12)"
    }
    return "\(hour) \(selectedHour < 12 ? "AM" : "PM")"
}

func getCurrentDensity(densityMap: [Int: Double], selectedHour: Int) -> String {
    if densityMap.isEmpty {
        return "Closed"
    }
    guard let historicalAverage = densityMap[selectedHour] else { return "Closed" }
    if historicalAverage < 0.25 {
        return "Usually not busy"
    } else if historicalAverage < 0.5 {
        return "Usually somewhat busy"
    } else if historicalAverage < 0.75 {
        return "Usually pretty busy"
    } else {
        return "Usually very busy"
    }
}

func weekdayAbbreviation(weekday: Int) -> String {
    switch weekday {
    case 0:
        return "Su"
    case 1:
        return "M"
    case 2:
        return "T"
    case 3:
        return "W"
    case 4:
        return "Th"
    case 5:
        return "F"
    case 6:
        return "S"
    default:
        return "M"
    }
}

func compare(one: Place, two: Place) -> Bool {
    switch one.density {
    case .veryBusy:
        return two.density != .veryBusy
    case .prettyBusy:
        return two.density != .veryBusy && two.density != .prettyBusy
    case .somewhatBusy:
        return two.density == .notBusy
    case .notBusy:
        return two.density == .notBusy
    }
}

func sortPlaces() {
    var index = 0
    while index < System.places.count {
        var minIndex = index
        var otherIndex = index + 1
        while otherIndex < System.places.count {
            let shouldSwap = compare(one: System.places[otherIndex], two: System.places[minIndex])
            if shouldSwap {
                minIndex = otherIndex
            }
            otherIndex += 1
        }
        let temp = System.places[index]
        System.places[index] = System.places[minIndex]
        System.places[minIndex] = temp
        index += 1
    }
}
