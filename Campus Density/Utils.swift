//
//  Utils.swift
//  Campus Density
//
//  Created by Matthew Coufal on 2/24/19.
//  Copyright © 2019 Cornell DTI. All rights reserved.
//

import UIKit

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
