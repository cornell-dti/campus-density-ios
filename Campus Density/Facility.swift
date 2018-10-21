//
//  Facility.swift
//  Campus Density
//
//  Created by Matthew Coufal on 10/14/18.
//  Copyright © 2018 Cornell DTI. All rights reserved.
//

import UIKit

class Facility {
    
    var name: String
    var id: String
    var opensAt: String
    var closesAt: String
    var address: String
    var currentCapacity: Double
    var totalCapacity: Double
    
    init(name: String, id: String, opensAt: String, closesAt: String, address: String, currentCapacity: Double, totalCapacity: Double) {
        self.name = name
        self.id = id
        self.opensAt = opensAt
        self.closesAt = closesAt
        self.address = address
        self.currentCapacity = currentCapacity
        self.totalCapacity = totalCapacity
    }
    
}
