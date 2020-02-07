//
//  API.swift
//  Campus Density
//
//  Created by Matthew Coufal on 11/15/18.
//  Copyright © 2018 Cornell DTI. All rights reserved.
//

import UIKit
import Alamofire
import IGListKit

/// APIErrors enumerates the possible errors that could arise when processing the response data
enum APIError: Error {
    /// decodeError Used when the `data` attribute from the `DataResponse` instance could not be decoded by the JSONDecoder
    case decodeError
    /// noData Used when the `data` attribute from the `DataResponse` instance is `null`
    case noData
}

/// Region enumerates the different parts of campus where the dining halls are located.
enum Region: String, Codable {
    case north
    case central
    case west
}

/**
 PlaceName contains information about an eatery's Display Name, and the identifier the eatery is referred to in the Firebase Database.
 
 **Properties**
    * `displayName`: The name for the eatery that is displayed on PlaceViewController and PlaceDetailViewController
    * `id`: The id of the eatery. The `id` in the `PlaceName` struct should **always** be set to its corresponding identifier in the Firebase Database.
*/
struct PlaceName: Codable {
    var displayName: String
    var id: String
}

/**
 PlaceDensity stores the `Density` of an eatery, and the identifier the eatery is referred to in the Firebase Database.

 **Properties**
    * `density`: The `Density` for the eatery
    * `id`: The id of the eatery. The `id` in the `PlaceName` struct should **always** be set to its corresponding identifier in the Firebase Database.
 
 - Remark: Should we be using the `id` property in various places (i.e., `PlaceDensity` and `PlaceInfo`)?
 
 - SeeAlso: `Density`
*/
struct PlaceDensity: Codable {

    var id: String
    var density: Density

}

/**
 PlaceInfo stores the `Region` of an eatery (specifying its location on campus), and the identifier the eatery is referred to in the Firebase Database.
 
 **Properties**
 * `density`: The `Density` for the eatery
 * `id`: The id of the eatery. The `id` in the `PlaceName` struct should **always** be set to its corresponding identifier in the Firebase Database.
 
 - Remark: Should we be using the `id` property in various places (i.e., `PlaceDensity` and `PlaceInfo`)?
 
 - SeeAlso: `Density`
 */
struct PlaceInfo: Codable {

    var id: String
    var campusLocation: Region
    var nextOpen: Double
    var closingAt: Double
}

class Place: ListDiffable {

    var displayName: String
    var id: String
    var density: Density
    var isClosed: Bool
    var hours: [Int: String]
    var history: [String: [String: Double]]
    var region: Region
    var menus: WeekMenus

    init(displayName: String, id: String, density: Density, isClosed: Bool, hours: [Int: String], history: [String: [String: Double]], region: Region, menus: WeekMenus) {
        self.displayName = displayName
        self.id = id
        self.density = density
        self.isClosed = isClosed
        self.hours = hours
        self.history = history
        self.region = region
        self.menus = menus
    }

    func diffIdentifier() -> NSObjectProtocol {
        return id as NSString
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true }
        guard let place = object as? Place else { return false }
        return place.id == id
    }

}

class Token: Codable {

    var token: String

    init(token: String) {
        self.token = token
    }
}

struct DailyInfo: Codable {

    var dailyHours: [String: Double]
    var date: String
    var dayOfWeek: Int
    var status: String
    var statusText: String

}

struct HoursResponse: Codable {

    var hours: [DailyInfo]
    var id: String

}

struct HistoricalData: Codable {

    var id: String
    var hours: [String: [String: Double]]

}

struct MenuItem: Codable {
    var items: [String]
    var category: String
}

struct MenuData: Codable {
    var menu: [MenuItem]
    var description: String
    var startTime: Int
    var endTime: Int
}

struct DayMenus: Codable {
    var menus: [MenuData]
    var date: String
}

struct WeekMenus: Codable {
    var weeksMenus: [DayMenus]
    var id: String
}

class API {

    static var url: String {
        guard let path = Bundle.main.path(forResource: "Keys", ofType: "plist"), let dict = NSDictionary(contentsOfFile: path) else { return "" }
        #if DEBUG
        let key = "apiDevURL"
        #else
        let key = "apiURL"
        #endif
        guard let value = dict[key] as? String else { return "" }
        return value
    }

    static func status(completion: @escaping (Bool) -> Void) {
        guard let token = System.token else { return }
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        Alamofire.request("\(url)/facilityInfo", headers: headers)
            .responseData { response in
                let decoder = JSONDecoder()
                let result: Result<[PlaceInfo]> = decoder.decodeResponse(from: response)
                switch result {
                    case .success(let placeInfos):
                        placeInfos.forEach { placeInfo in
                            let index = System.places.firstIndex(where: { place -> Bool in
                                return place.id == placeInfo.id
                            })
                            guard let placeIndex = index else { return }
                            System.places[placeIndex].region = placeInfo.campusLocation
                            System.places[placeIndex].isClosed = placeInfo.closingAt == -1.0
                        }
                        completion(true)
                    case .failure(let error):
                        print(error)
                        UserDefaults.standard.removeObject(forKey: "token")
                        UserDefaults.standard.removeObject(forKey: "authKey")
                        UserDefaults.standard.synchronize()
                        System.places = []
                        completion(false)
                }
        }
    }

    static func history(completion: @escaping (Bool) -> Void) {
        guard let token = System.token else { return }
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        Alamofire.request("\(url)/historicalData", headers: headers)
            .responseData { response in
                let decoder = JSONDecoder()
                let result: Result<[HistoricalData]> = decoder.decodeResponse(from: response)
                switch result {
                    case .success(let data):
                        data.forEach { placeData in
                            guard let index = System.places.firstIndex(where: { place in
                                return place.id == placeData.id
                            }) else { return }
                            System.places[index].history = placeData.hours
                        }
                        completion(true)
                    case .failure(let error):
                        print(error)
                        UserDefaults.standard.removeObject(forKey: "token")
                        UserDefaults.standard.removeObject(forKey: "authKey")
                        UserDefaults.standard.synchronize()
                        System.places = []
                        completion(false)
                }
        }
    }

    static func places(completion: @escaping (Bool) -> Void) {
        guard let token = System.token else { return }
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        Alamofire.request("\(url)/facilityList", headers: headers)
            .responseData { response in
                let decoder = JSONDecoder()
                let result: Result<[PlaceName]> = decoder.decodeResponse(from: response)
                switch result {
                    case .success(let placeNames):
                        System.places = placeNames.map { placeName in
                            return Place(displayName: placeName.displayName, id: placeName.id, density: .notBusy, isClosed: false, hours: [:], history: [:], region: .north, menus: WeekMenus(weeksMenus: [], id: placeName.id))
                        }
                        completion(true)
                    case .failure(let error):
                        print(error)
                        UserDefaults.standard.removeObject(forKey: "token")
                        UserDefaults.standard.removeObject(forKey: "authKey")
                        UserDefaults.standard.synchronize()
                        System.places = []
                        completion(false)
                }
        }
    }

    static func hours(place: Place, completion: @escaping (Bool) -> Void) {
        guard let token = System.token else { return }
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]

        var success = true

        let formatter = DateFormatter()
        formatter.dateStyle = .short
        let today = Date()
        if let sixDaysLater = Calendar.current.date(byAdding: Calendar.Component.day, value: 6, to: today) {

            let start = formatter.string(from: today)
            let end = formatter.string(from: sixDaysLater)
            let startComponents = start.components(separatedBy: "/")
            let startYear = String(startComponents[2].suffix(2))
            let startDay = startComponents[1].count == 1 ? "0\(startComponents[1])" : startComponents[1]
            let startMonth = startComponents[0].count == 1 ? "0\(startComponents[0])" : startComponents[0]
            let endComponents = end.components(separatedBy: "/")
            let endYear = String(endComponents[2].suffix(2))
            let endDay = endComponents[1].count == 1 ? "0\(endComponents[1])" : endComponents[1]
            let endMonth = endComponents[0].count == 1 ? "0\(endComponents[0])" : endComponents[0]
            let startDate = "\(startMonth)-\(startDay)-\(startYear)"
            let endDate = "\(endMonth)-\(endDay)-\(endYear)"

            let parameters = [
                "id": place.id,
                "startDate": startDate,
                "endDate": endDate
            ]

            Alamofire.request("\(url)/facilityHours", parameters: parameters, headers: headers)
                .responseData { response in
                    let decoder = JSONDecoder()
                    let result: Result<[HoursResponse]> = decoder.decodeResponse(from: response)
                    switch result {
                        case .success(let hoursResponseArray):
                            let hoursResponse = hoursResponseArray[0]
                            var hours = [Int: String]()
                            var index: Int = 0
                            while index < hoursResponse.hours.count {
                                let dailyInfo = hoursResponse.hours[index]
                                let day = dailyInfo.dayOfWeek
                                let dailyHours = dailyInfo.dailyHours
                                let timeFormatter = DateFormatter()
                                timeFormatter.timeStyle = .short
                                guard let openTimestamp = dailyHours["startTimestamp"], let closeTimestamp = dailyHours["endTimestamp"] else { return }
                                let open = Date(timeIntervalSince1970: openTimestamp)
                                let close = Date(timeIntervalSince1970: closeTimestamp)
                                let openTime = timeFormatter.string(from: open)
                                let closeTime = timeFormatter.string(from: close)
                                let isLastIndex = index == hoursResponse.hours.count - 1
                                if let hoursString = hours[day] {
                                    hours[day] = hoursString + "\(openTime) - \(closeTime)"
                                } else {
                                    hours[day] = "\(openTime) - \(closeTime)"
                                }
                                if let hoursString = hours[day], !isLastIndex {
                                    hours[day] = hoursString + "\n"
                                }
                                index += 1
                            }
                            if let placeIndex = System.places.firstIndex(where: { other -> Bool in
                                return other.id == place.id
                            }) {
                                System.places[placeIndex].hours = hours
                            } else {
                                success = false
                            }
                        case .failure(let error):
                            print(error)
                            success = false
                    }
                    completion(success)
            }
        } else {
            success = false
            completion(success)
        }

    }

    static func densities(completion: @escaping (Bool) -> Void) {
        guard let token = System.token else { return }
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        Alamofire.request("\(url)/howDense", headers: headers)
            .responseData { response in
                let decoder = JSONDecoder()
                let result: Result<[PlaceDensity]> = decoder.decodeResponse(from: response)
                switch result {
                    case .success(let densities):
                        densities.forEach({ placeDensity in
                            let index = System.places.firstIndex(where: { place -> Bool in
                                return place.id == placeDensity.id
                            })
                            guard let placeIndex = index else { return }
                            System.places[placeIndex].density = placeDensity.density
                        })
                        completion(true)
                    case .failure(let error):
                        print(error)
                        completion(false)
                }
        }
    }

    static func convertToMenuString(menudata: DayMenus) -> NSMutableAttributedString {
        let menus = menudata.menus
        let newLine = NSAttributedString(string: "\n")
        let resultString = NSMutableAttributedString(string: "")
        for menu in menus {
            let desc = NSMutableAttributedString(string: menu.description)
            desc.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.grayishBrown, range: desc.mutableString.range(of: menu.description))
            desc.addAttribute(NSAttributedString.Key.font, value: UIFont.eighteenBold, range: desc.mutableString.range(of: menu.description))
            let menuitemlist = menu.menu
            if (menuitemlist.count != 0) {
                resultString.append(desc)
                resultString.append(newLine)
            }
            for menuitem in menuitemlist {
                for item in menuitem.items {
                    let itemNS = NSAttributedString(string: item)
                    resultString.append(itemNS)
                    resultString.append(newLine)
                }
            }
            if (menuitemlist.count != 0) {
                resultString.append(newLine)
            }
        }

        return resultString
    }

    static func convertToDict(menudata: DayMenus) -> [String: [String: [String]]] {
        let menus = menudata.menus
        var res = [String: [String: [String]]]()
        for menu in menus {
            res[menu.description] = [String: [String]]()
            for station in menu.menu {
                res[menu.description]?[station.category] = station.items
            }
        }
        print(res)
        return res
    }

    static func menus(place: Place, completion: @escaping (Bool) -> Void) {
        guard let token = System.token else { return }
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]

        print("PLACE: \(place.id)")

        let parameters = [
           "facility": place.id
        ]

        Alamofire.request("\(url)/menuData", parameters: parameters, headers: headers)
            .responseData { response in
                let decoder = JSONDecoder()
                let result: Result<[WeekMenus]> = decoder.decodeResponse(from: response)
                switch result {
                    case .success(let menulist):
                        menulist.forEach({menu in
                            let index = System.places.firstIndex(where: { place -> Bool in
                                return place.id == menu.id
                            })
                            guard let placeIndex = index else { return }
                            System.places[placeIndex].menus = menu
                            print(menu)
                        })
                        completion(true)

                    case .failure(let error):
                        print(error)
                        completion(false)
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
