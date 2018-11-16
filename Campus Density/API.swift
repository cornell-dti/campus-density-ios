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

class PlaceInfo: Codable {
    
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

class Place {
    
    var displayName: String
    var id: String
    var density: Density
    let region: String = "north"
    
    init(displayName: String, id: String, density: Density) {
        self.displayName = displayName
        self.id = id
        self.density = density
    }
    
}

protocol APIDelegate {
    func didGetPlaces(updatedPlaces: [Place]?)
    func didGetDensities(updatedPlaces: [Place]?)
}

class API {
    
    var delegate: APIDelegate
    
    init(delegate: APIDelegate) {
        self.delegate = delegate
    }
    
    func getPlaces() {
        Alamofire.request("https://us-central1-campus-density-backend.cloudfunctions.net/facilityList")
        .responseData { response in
            let decoder = JSONDecoder()
            let result: Result<[PlaceInfo]> = decoder.decodeResponse(from: response)
            switch result {
            case .success(let placeInfos):
                var places = [Place]()
                placeInfos.forEach({ placeInfo in
                    let place = Place(displayName: placeInfo.displayName, id: placeInfo.id, density: .manySpots)
                    places.append(place)
                })
                self.delegate.didGetPlaces(updatedPlaces: places)
            case .failure(_):
                self.delegate.didGetPlaces(updatedPlaces: nil)
            }
        }
    }
    
    func getDensities(updatedPlaces: [Place]) {
        Alamofire.request("https://us-central1-campus-density-backend.cloudfunctions.net/howDense")
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
                let sortedPlaces = updatedPlaces.sorted(by: { (placeOne, placeTwo) -> Bool in
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
