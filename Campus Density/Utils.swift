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
    static let mlPadding: CGFloat = 40
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

func interpretDensity(place: Place) -> String {
    switch place.density {
        case .veryBusy:
            return "Very busy"
        case .prettyBusy:
            return "Pretty busy"
        case .notBusy:
            return "Not busy"
        case .somewhatBusy:
            return "Somewhat busy"
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

func compareDensity(one: Place, two: Place) -> Bool {
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

func compareFilter(one: Place, two: Place) -> Bool {
    if one.isClosed && two.isClosed {
        return one.displayName < two.displayName
    }
    if one.isClosed {
        return false
    }
    if two.isClosed {
        return true
    }
    if one.density.rawValue == two.density.rawValue {
        return one.displayName < two.displayName
    }
    return one.density.rawValue < two.density.rawValue
}

func sortFilteredPlaces(places: [Place]) -> [Place] {
    return places.sorted(by: { (one, two) -> Bool in
        return compareFilter(one: one, two: two)
    })
}

func sortPlaces() {
    System.places = System.places.sorted(by: { (one, two) -> Bool in
        return compareDensity(one: one, two: two)
    })
}

func rememberToken(token: String) {
    System.token = token
    UserDefaults.standard.set(token, forKey: "token")
    UserDefaults.standard.synchronize()
}

func forgetToken() {
    System.token = nil
    UserDefaults.standard.removeObject(forKey: "token")
    UserDefaults.standard.synchronize()
}
