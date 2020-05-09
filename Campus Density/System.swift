//
//  File.swift
//  Campus Density
//
//  Created by Matthew Coufal on 11/29/18.
//  Copyright © 2018 Cornell DTI. All rights reserved.
//

import UIKit
import CoreLocation

struct System {
    static var token: String?
    static var authKey: String?
    static var places = [Place]()
    static var gyms = [Gym]()
    static var currentUserLocation: CLLocation?
}
