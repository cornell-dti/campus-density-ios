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
    var hours: [[String: Double]]
    var history: [String: [String: Double]]
    
    init(displayName: String, id: String, density: Density, isClosed: Bool, hours: [[String : Double]], history: [String: [String: Double]]) {
        self.displayName = displayName
        self.id = id
        self.density = density
        self.isClosed = isClosed
        self.hours = hours
        self.history = history
    }
    
}

class Token: Codable {
    
    var token: String
    
    init(token: String) {
        self.token = token
    }
}

protocol APIDelegate {
    func didGetPlaces()
    func didGetDensities()
    func didGetInfo()
    func didGetToken()
    func didGetHistoricalData(data: [HistoricalData])
}

struct HistoricalData: Codable {
    
    var id: String
    var hours: [String : [String : Double]]
    
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
        if let receiptURL = Bundle.main.appStoreReceiptURL {
            guard let identifierForVendor = UIDevice.current.identifierForVendor?.uuidString else { return }
            let receipt = receiptURL.dataRepresentation
            guard let path = Bundle.main.path(forResource: "Keys", ofType: "plist"), let keyDict = NSDictionary(contentsOfFile: path) else { return }
            guard let authKey = keyDict["AUTH_KEY"] as? String else { return }
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
                        UserDefaults.standard.removeObject(forKey: "token")
                        UserDefaults.standard.removeObject(forKey: "authKey")
                        UserDefaults.standard.synchronize()
                        System.token = nil
                    }
                    self.delegate.didGetToken()
            }
        } else {
            guard let identifierForVendor = UIDevice.current.identifierForVendor?.uuidString else { return }
            guard let path = Bundle.main.path(forResource: "Keys", ofType: "plist"), let keyDict = NSDictionary(contentsOfFile: path) else { return }
            guard let authKey = keyDict["AUTH_KEY"] as? String else { return }
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
                        UserDefaults.standard.removeObject(forKey: "token")
                        UserDefaults.standard.removeObject(forKey: "authKey")
                        UserDefaults.standard.synchronize()
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
        Alamofire.request("https://flux.api.internal.cornelldti.org/v1/facilityInfo", headers: headers)
            .responseData { response in
                let decoder = JSONDecoder()
                let result: Result<[PlaceInfo]> = decoder.decodeResponse(from: response)
                switch result {
                case .success(let placeInfos):
                    System.places = placeInfos.map { placeInfo in
                        let oldPlace = updatedPlaces.first(where: { place -> Bool in
                            return place.id == placeInfo.id
                        })
                        guard let old = oldPlace else {
                            return Place(displayName: "", id: "", density: .manySpots, isClosed: true, hours: [[:]], history: [:])
                        }
                        return Place(displayName: old.displayName, id: old.id, density: old.density, isClosed: placeInfo.closingAt == -1.0, hours: placeInfo.dailyHours, history: [:])
                    }
                    self.delegate.didGetInfo()
                case .failure(let error):
                    print(error)
                    UserDefaults.standard.removeObject(forKey: "token")
                    UserDefaults.standard.removeObject(forKey: "authKey")
                    UserDefaults.standard.synchronize()
                    System.places = []
                    self.delegate.didGetInfo()
                }
        }
    }
    
    func getPlaces() {
        guard let authKey = System.authKey, let token = System.token else { return }
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(authKey)",
            "x-api-key": token
        ]
        Alamofire.request("https://flux.api.internal.cornelldti.org/v1/facilityList", headers: headers)
            .responseData { response in
                let decoder = JSONDecoder()
                let result: Result<[PlaceName]> = decoder.decodeResponse(from: response)
                switch result {
                case .success(let placeNames):
                    System.places = placeNames.map { placeName in
                        return Place(displayName: placeName.displayName, id: placeName.id, density: .manySpots, isClosed: false, hours: [[:]], history: [:])
                    }
                    self.delegate.didGetPlaces()
                case .failure(let error):
                    print(error)
                    UserDefaults.standard.removeObject(forKey: "token")
                    UserDefaults.standard.removeObject(forKey: "authKey")
                    UserDefaults.standard.synchronize()
                    System.places = []
                    self.delegate.didGetPlaces()
                }
        }
    }
    
    func getHistoricalData() {
        guard let authKey = System.authKey, let token = System.token else { return }
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(authKey)",
            "x-api-key": token
        ]
        Alamofire.request("https://flux.api.internal.cornelldti.org/v1/historicalData", headers: headers)
            .responseData { response in
                let decoder = JSONDecoder()
                let result: Result<[HistoricalData]> = decoder.decodeResponse(from: response)
                switch result {
                case .success(let data):
                    self.delegate.didGetHistoricalData(data: data)
                case .failure(let error):
                    print(error)
                    self.delegate.didGetHistoricalData(data: [])
                }
        }
    }
    
    static func updateDensities(places: [Place], place: Place, completion: @escaping (Int) -> Void) {
        guard let authKey = System.authKey, let token = System.token else { return }
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(authKey)",
            "x-api-key": token
        ]
        Alamofire.request("https://flux.api.internal.cornelldti.org/v1/howDense", headers: headers)
            .responseData { response in
                let decoder = JSONDecoder()
                let result: Result<[PlaceDensity]> = decoder.decodeResponse(from: response)
                switch result {
                case .success(let densities):
                    densities.forEach({ placeDensity in
                        let index = places.firstIndex(where: { place -> Bool in
                            return place.id == placeDensity.id
                        })
                        guard let placeIndex = index else { return }
                        let updatedPlace = places[placeIndex]
                        updatedPlace.density = placeDensity.density
                    })
                    System.places = densities.map { placeDensity in
                        let index = places.firstIndex(where: { place -> Bool in
                            return place.id == placeDensity.id
                        })
                        guard let placeIndex = index else {
                            return Place(displayName: "", id: "", density: .manySpots, isClosed: true, hours: [[:]], history: [:])
                        }
                        let updatedPlace = places[placeIndex]
                        updatedPlace.density = placeDensity.density
                        return updatedPlace
                    }
                    System.places = System.places.sorted(by: { (placeOne, placeTwo) -> Bool in
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
                case .failure(let error):
                    print(error)
                    break
                }
                guard let index = System.places.firstIndex(where: { somePlace in
                    return somePlace.id == place.id
                }) else { return }
                completion(index)
        }
    }
    
    func getDensities(updatedPlaces: [Place]) {
        guard let authKey = System.authKey, let token = System.token else { return }
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(authKey)",
            "x-api-key": token
        ]
        Alamofire.request("https://flux.api.internal.cornelldti.org/v1/howDense", headers: headers)
            .responseData { response in
                let decoder = JSONDecoder()
                let result: Result<[PlaceDensity]> = decoder.decodeResponse(from: response)
                switch result {
                case .success(let densities):
                    densities.forEach({ placeDensity in
                        let index = updatedPlaces.firstIndex(where: { place -> Bool in
                            return place.id == placeDensity.id
                        })
                        guard let placeIndex = index else { return }
                        let updatedPlace = updatedPlaces[placeIndex]
                        updatedPlace.density = placeDensity.density
                    })
                    System.places = densities.map { placeDensity in
                        let index = updatedPlaces.firstIndex(where: { place -> Bool in
                            return place.id == placeDensity.id
                        })
                        guard let placeIndex = index else {
                            return Place(displayName: "", id: "", density: .manySpots, isClosed: true, hours: [[:]], history: [:])
                        }
                        let updatedPlace = updatedPlaces[placeIndex]
                        updatedPlace.density = placeDensity.density
                        return updatedPlace
                    }
                    System.places = System.places.sorted(by: { (placeOne, placeTwo) -> Bool in
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
                    self.delegate.didGetDensities()
                case .failure(let error):
                    print(error)
                    UserDefaults.standard.removeObject(forKey: "token")
                    UserDefaults.standard.removeObject(forKey: "authKey")
                    UserDefaults.standard.synchronize()
                    System.places = []
                    self.delegate.didGetDensities()
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
