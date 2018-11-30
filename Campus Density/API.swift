//
//  API.swift
//  Campus Density
//
//  Created by Matthew Coufal on 11/15/18.
//  Copyright © 2018 Cornell DTI. All rights reserved.
//

import UIKit
import Alamofire

enum APIError: Error {
    case decodeError
    case noData
}

class PlaceName: Codable {
    
    var displayName: String
    var id: String
    
    init(displayName: String, id: String) {
        self.displayName = displayName
        self.id = id
    }
    
}

class PlaceDensity: Codable {
    var id: String
    var density: Density
    
    init(id: String, density: Density) {
        self.id = id
        self.density = density
    }
}

class PlaceInfo: Codable {
    var id: String
    var campusLocation: String
    var nextOpen: Double
    var closingAt: Double
    var dailyHours: [[String : Double]]
    
    init(id: String, campusLocation: String, nextOpen: Double, closingAt: Double, dailyHours: [[String : Double]]) {
        self.id = id
        self.campusLocation = campusLocation
        self.nextOpen = nextOpen
        self.closingAt = closingAt
        self.dailyHours = dailyHours
    }
}

class Place {
    
    var displayName: String
    var id: String
    var density: Density
    var isClosed: Bool
    
    init(displayName: String, id: String, density: Density, isClosed: Bool) {
        self.displayName = displayName
        self.id = id
        self.density = density
        self.isClosed = isClosed
    }
    
}

class Token: Codable {
    
    var token: String
    
    init(token: String) {
        self.token = token
    }
}

protocol APIDelegate {
    func didGetPlaces(updatedPlaces: [Place]?)
    func didGetDensities(updatedPlaces: [Place]?)
    func didGetInfo(updatedPlaces: [Place]?)
    func didGetToken()
}

class API {
    
    var delegate: APIDelegate
    
    init(delegate: APIDelegate) {
        self.delegate = delegate
    }
    
    func getToken() {
        if let token = UserDefaults.standard.value(forKey: "token") as? String, let authKey = UserDefaults.standard.value(forKey: "authKey") as? String {
            System.token = token
            System.authKey = authKey
            delegate.didGetToken()
            return
        }
        guard let receiptURL = Bundle.main.appStoreReceiptURL else { return }
        var receipt: Data!
        do {
            guard let identifierForVendor = UIDevice.current.identifierForVendor?.uuidString else { return }
            receipt = try Data(contentsOf: receiptURL)
            guard let authKey = Bundle.main.object(forInfoDictionaryKey: "AUTHKEY") as? String else { return }
            System.authKey = authKey
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(authKey)",
                "x-api-key": identifierForVendor
            ]
            let parameters: Parameters = [
                "receipt": receipt.base64EncodedString(),
                "instanceId": identifierForVendor
            ]
            Alamofire.request("https://us-central1-campus-density-backend.cloudfunctions.net/authv1", method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .responseData { response in
                    let decoder = JSONDecoder()
                    let result: Result<Token> = decoder.decodeResponse(from: response)
                    switch result {
                    case .success(let token):
                        System.token = token.token
                        UserDefaults.standard.set(token.token, forKey: "token")
                        UserDefaults.standard.set(authKey, forKey: "authKey")
                        UserDefaults.standard.synchronize()
                    case .failure(_):
                        System.token = nil
                    }
                    self.delegate.didGetToken()
            }
        } catch {
            guard let identifierForVendor = UIDevice.current.identifierForVendor?.uuidString else { return }
            guard let authKey = Bundle.main.object(forInfoDictionaryKey: "Density") as? String else { return }
            System.authKey = authKey
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(authKey)",
                "x-api-key": identifierForVendor
            ]
            Alamofire.request("https://us-central1-campus-density-backend.cloudfunctions.net/authv1", method: .put, headers: headers)
                .responseData { response in
                    let decoder = JSONDecoder()
                    let result: Result<Token> = decoder.decodeResponse(from: response)
                    switch result {
                    case .success(let token):
                        System.token = token.token
                        UserDefaults.standard.set(token.token, forKey: "token")
                        UserDefaults.standard.set(authKey, forKey: "authKey")
                        UserDefaults.standard.synchronize()
                    case .failure(_):
                        System.token = nil
                    }
                    self.delegate.didGetToken()
            }
        }
    }
    
    func getPlaceInfo(updatedPlaces: [Place]) {
        guard let authKey = System.authKey, let token = System.token else { return }
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(authKey)",
            "x-api-key": token
        ]
        Alamofire.request("https://us-central1-campus-density-backend.cloudfunctions.net/facilityInfo", headers: headers)
            .responseData { response in
                let decoder = JSONDecoder()
                let result: Result<[PlaceInfo]> = decoder.decodeResponse(from: response)
                switch result {
                case .success(let placeInfos):
                    var places = [Place]()
                    placeInfos.forEach({ placeInfo in
                        let oldPlace = updatedPlaces.first(where: { place -> Bool in
                            return place.id == placeInfo.id
                        })
                        guard let old = oldPlace else { return }
                        let place = Place(displayName: old.displayName, id: old.id, density: old.density, isClosed: Date().timeIntervalSince1970 >= placeInfo.closingAt)
                        places.append(place)
                    })
                    self.delegate.didGetInfo(updatedPlaces: places)
                case .failure(_):
                    self.delegate.didGetInfo(updatedPlaces: nil)
                }
        }
    }
    
    func getPlaces() {
        guard let authKey = System.authKey, let token = System.token else { return }
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(authKey)",
            "x-api-key": token
        ]
        Alamofire.request("https://us-central1-campus-density-backend.cloudfunctions.net/facilityList", headers: headers)
        .responseData { response in
            let decoder = JSONDecoder()
            let result: Result<[PlaceName]> = decoder.decodeResponse(from: response)
            switch result {
            case .success(let placeNames):
                var places = [Place]()
                placeNames.forEach({ placeName in
                    let place = Place(displayName: placeName.displayName, id: placeName.id, density: .manySpots, isClosed: false)
                    places.append(place)
                })
                self.delegate.didGetPlaces(updatedPlaces: places)
            case .failure(_):
                self.delegate.didGetPlaces(updatedPlaces: nil)
            }
        }
    }
    
    func getDensities(updatedPlaces: [Place]) {
        guard let authKey = System.authKey, let token = System.token else { return }
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(authKey)",
            "x-api-key": token
        ]
        Alamofire.request("https://us-central1-campus-density-backend.cloudfunctions.net/howDense", headers: headers)
        .responseData { response in
            let decoder = JSONDecoder()
            let result: Result<[PlaceDensity]> = decoder.decodeResponse(from: response)
            switch result {
            case .success(let densities):
                var newPlaces = [Place]()
                densities.forEach({ placeDensity in
                    let index = updatedPlaces.firstIndex(where: { place -> Bool in
                        return place.id == placeDensity.id
                    })
                    guard let placeIndex = index else { return }
                    let updatedPlace = updatedPlaces[placeIndex]
                    updatedPlace.density = placeDensity.density
                    newPlaces.append(updatedPlace)
                })
                let sortedPlaces = newPlaces.sorted(by: { (placeOne, placeTwo) -> Bool in
                    switch placeOne.density {
                    case .noSpots:
                        return placeTwo.density != .noSpots
                    case .fewSpots:
                        return placeTwo.density != .noSpots && placeTwo.density != .fewSpots
                    case .someSpots:
                        return placeTwo.density == .manySpots
                    case .manySpots:
                        return placeTwo.density == .manySpots
                    }
                })
                self.delegate.didGetDensities(updatedPlaces: sortedPlaces)
            case .failure(_):
                self.delegate.didGetDensities(updatedPlaces: nil)
            }
        }
    }
    
}

extension JSONDecoder {
    func decodeResponse<T: Decodable>(from response: DataResponse<Data>) -> Result<T> {
        if let error = response.error {
            return .failure(error)
        }
        
        guard let responseData = response.data else {
            return .failure(APIError.noData)
        }
        
        do {
            let item = try decode(T.self, from: responseData)
            return .success(item)
        } catch {
            return .failure(APIError.decodeError)
        }
    }
}
