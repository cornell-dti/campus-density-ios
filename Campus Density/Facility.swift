//
//  Facility.swift
//  Campus Density
//
//  Created by Matthew Coufal on 10/14/18.
//  Copyright © 2018 Cornell DTI. All rights reserved.
//

import UIKit

class Facility: Codable {
    
    var name: String
    var id: String
    var opensAt: String
    var closesAt: String
    var address: String
    var density: Density
    var region: String
    
    init(name: String, id: String, opensAt: String, closesAt: String, address: String, density: Density, region: String) {
        self.name = name
        self.id = id
        self.opensAt = opensAt
        self.closesAt = closesAt
        self.address = address
        self.density = density
        self.region = region
    }
    
}
