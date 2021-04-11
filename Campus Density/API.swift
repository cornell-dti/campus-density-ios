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
 Represents the information of an eatery's name
 
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
 Represents the crowdedness of an eatery
 
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
 Represents the location and open times of an eatery
 
 PlaceInfo stores the `Region` of an eatery (specifying its location on campus), the identifier the eatery is referred to in the Firebase Database, and the next time it opens/closes.
 
 **Properties**
 * `id`: The id of the eatery. The `id` in the `PlaceName` struct should **always** be set to its corresponding identifier in the Firebase Database.
 * `campusLocation`: The `Region` where the eatery is located on campus
 * `nextOpen`: A timestamp representing the time this eatery will open again. If it is already open, this value is -1.0
 * `closingAt`: A timestamp representing the time this eatery will close. If it is already closed, this value is -1.0
 
 - Remark: Should we be using the `id` property in various places (i.e., `PlaceDensity` and `PlaceInfo`)?
 
 - SeeAlso: `Density`
 */
struct PlaceInfo: Codable {

    var id: String
    var campusLocation: Region
    var nextOpen: Double
    var closingAt: Double
}

/**
 Represents all the information about that is displayed on the `PlaceDetailViewController` view for a specific eatery.
 */

class Place {

    var displayName: String
    var id: String
    var density: Density
    var waitTime: Double?
    var isClosed: Bool
    var hours: [DailyInfo]
    var history: [String: [String: Double]]
    var region: Region
    var diningMenus: [DayMenus]?

    /// Initilizes a new Place object with the eatety's display name, it's corresponding FIrebase id, its `Density`, whether it is closed or not, its hours, history, location and its week's menus.
    ///
    /// - Parameters:
    ///   - displayName: A string representing the label this eatery will be identified by on the PlaceVC PlaceDetailVC pages
    ///   - id: The corresponding Firebase id
    ///   - density: Represents how crowded this eatery is. `density` is an instance of `Density`
    ///   - isClosed: Whether this place is closed or not
    ///   - hours: A dictionary where the key [TODO]
    ///   - history: TODO
    ///   - region: A `Region` instance specifying where this object is located on campus
    ///   - menus: A `WeekMenus` instance representing all the menus for this eatery for the entire week, starting from today.
    init(displayName: String, id: String, density: Density, waitTime: Double?, isClosed: Bool, hours: [DailyInfo], history: [String: [String: Double]], region: Region, diningMenus: [DayMenus]?) {
        self.displayName = displayName
        self.id = id
        self.density = density
        self.waitTime = waitTime
        self.isClosed = isClosed
        self.hours = hours
        self.history = history
        self.region = region
        self.diningMenus = diningMenus
    }

}

/** Represents the authorization token required for Firebase authentication */
class Token: Codable {

    var token: String

    init(token: String) {
        self.token = token
    }
}

struct DailyHours: Codable {

    var startTimestamp: Double
    var endTimestamp: Double

}

struct DailyInfo: Codable {

    var dailyHours: DailyHours
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

/// Group of individual menu items under one category such as "Grill Station"
struct MenuItem: Codable {
    /// List of individual food items
    var items: [String]
    /// The "station" that these food items are available at, e.g. "Salad Bar Station", "Cereal/Bagel Bar"
    var category: String
}

/// The menu for one meal at a particular dining hall on a particular day.
struct MenuData: Codable {
    /// List of menu items, grouped by category (see `MenuItem`)
    var menu: [MenuItem]
    /// The meal description, e.g. "Lunch"
    var description: String
    /// The absolute start time of this meal, in Unix time
    var startTime: Int
    /// The absolute end time of this meal, in Unix time
    var endTime: Int
}

/// All menu data for a dining hall on a particular day.
struct DayMenus: Codable {
    /// The list of meal menus, ordered in breakfast, lunch, dinner (could be brunch)
    var menus: [MenuData]
    /// The date that these menus belong to, e.g. "2020-12-17"
    var date: String
}

/// A week's worth of menus for a particular dining hall.
struct WeekMenus: Codable {
    /// The list of menus for each day, in chronological order
    var weeksMenus: [DayMenus]
    /// Eatery id, e.g. "becker"
    var id: String
}

struct AddFeedbackResponse: Codable {
    var success: Bool
    var message: String?
}

class API {

    /// API remembering when it last updated density
    static var lastUpdatedDensityTime: Date?
    static let lastUpdatedRoundingSeconds: Double = 300

    //sets up the base url for fetching data
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

    // MARK: - PlacesView Functions

    /// Fetches the information about the opening/closing times of all the eateries (as specified in the `PlaceInfo` definition, and then sets the `region` and `isClosed` properties of this eateries corresponding `Place` instance in System.places based on this fetched data
    static func status(completion: @escaping (Bool) -> Void) {
        guard let token = System.token else { return }
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        AF.request("\(url)/facilityInfo", headers: headers)
            .responseData { response in
                let decoder = JSONDecoder()
                //resulting JSON array should be parsed into a PlaceInfo object array
                let result: AFResult<[PlaceInfo]> = decoder.decodeResponse(from: response)
                switch result {
                case .success(let placeInfos):
                    //find corresponding instances of `Place` in System.places for every element in the resulting PlaceInfo array, and set the values of `region` and `isClosed` accordingly.
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
                    //handle errors
                    print(error, "facilityInfo")
                    UserDefaults.standard.removeObject(forKey: "token")
                    UserDefaults.standard.removeObject(forKey: "authKey")
                    UserDefaults.standard.synchronize()
                    System.places = []
                    completion(false)
                }
        }
    }

    static func waitTimes(completion: @escaping (Bool) -> Void) {
        guard let token = System.token else { return }
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        AF.request("\(url)/waitTime", headers: headers)
            .responseData { response in
                let decoder = JSONDecoder()
                let result: AFResult<[String: Double]> = decoder.decodeResponse(from: response)
                switch result {
                case .success(let data):
                    data.forEach { id, waitTime in
                        guard let index = System.places.firstIndex(where: { place in
                            return place.id == id
                        }) else { return }
                        // note: timestamp ignored -- currently "last updated" text corresponds to last time density was updated (every 5 mins)
                        System.places[index].waitTime = waitTime
                    }
                    completion(true)
                case .failure(let error):
                    print(error, "waitTimes")
                    completion(false)
                }
        }
    }

    static func history(completion: @escaping (Bool) -> Void) {
        guard let token = System.token else { return }
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        AF.request("\(url)/historicalData", headers: headers)
            .responseData { response in
                let decoder = JSONDecoder()
                let result: AFResult<[HistoricalData]> = decoder.decodeResponse(from: response)
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
                    print(error, "historicalData")
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
        AF.request("\(url)/facilityList", headers: headers)
            .responseData { response in
                let decoder = JSONDecoder()
                let result: AFResult<[PlaceName]> = decoder.decodeResponse(from: response)
                switch result {
                case .success(let placeNames):
                    System.places = placeNames.map { placeName in
                        return Place(displayName: placeName.displayName, id: placeName.id, density: .notBusy, waitTime: nil, isClosed: false, hours: [], history: [:], region: .north, diningMenus: nil)
                    }
                    completion(true)
                case .failure(let error):
                    print(error, "facilityList")
                    UserDefaults.standard.removeObject(forKey: "token")
                    UserDefaults.standard.removeObject(forKey: "authKey")
                    UserDefaults.standard.synchronize()
                    System.places = []
                    completion(false)
                }
        }
    }

    static func densities(completion: @escaping (Bool) -> Void) {
        guard let token = System.token else { return }
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        AF.request("\(url)/howDense", headers: headers)
            .responseData { response in
                let decoder = JSONDecoder()
                let result: AFResult<[PlaceDensity]> = decoder.decodeResponse(from: response)
                switch result {
                case .success(let densities):
                    self.lastUpdatedDensityTime = Date() // Set last updated density time to now
                    densities.forEach({ placeDensity in
                        let index = System.places.firstIndex(where: { place -> Bool in
                            return place.id == placeDensity.id
                        })
                        guard let placeIndex = index else { return }
                        System.places[placeIndex].density = placeDensity.density
                    })
                    completion(true)
                case .failure(let error):
                    print(error, "howDense")
                    completion(false)
                }
        }
    }

    static func getLastUpdatedDensityTime() -> Date {
        let multiples = floor(lastUpdatedDensityTime!.timeIntervalSince1970 / lastUpdatedRoundingSeconds)
        return Date(timeIntervalSince1970: multiples * lastUpdatedRoundingSeconds)
    }

    // MARK: - PlaceDetailView Functions

    static func menus(place: Place, completion: @escaping (Bool) -> Void) {
        guard let token = System.token else { return }
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]

        print("PLACE: \(place.id)")

        let parameters = [
            "facility": place.id
        ]

        AF.request("\(url)/menuData", parameters: parameters, headers: headers)
            .responseData { response in
                let decoder = JSONDecoder()
                let result: AFResult<[WeekMenus]> = decoder.decodeResponse(from: response)
                switch result {
                case .success(let menulist):
                    menulist.forEach({menu in
                        let index = System.places.firstIndex(where: { place -> Bool in
                            return place.id == menu.id
                        })
                        guard let placeIndex = index else { return }
                        System.places[placeIndex].diningMenus = menu.weeksMenus
                    })
                    completion(true)

                case .failure(let error):
                    print(error, "menuData")
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

        let today = Date()
        if let sixDaysLater = Calendar.current.date(byAdding: Calendar.Component.day, value: 6, to: today) {

            let formatter = DateFormatter()
            formatter.dateFormat = "MM-dd-yy" // weird format
            // Always get hours based on the time in New York
            formatter.timeZone = TimeZone(identifier: "America/New_York")
            let startDate = formatter.string(from: today)
            let endDate = formatter.string(from: sixDaysLater)

            let parameters = [
                "id": place.id,
                "startDate": startDate,
                "endDate": endDate
            ]

            AF.request("\(url)/facilityHours", parameters: parameters, headers: headers)
                .responseData { response in
                    let decoder = JSONDecoder()
                    let result: AFResult<[HoursResponse]> = decoder.decodeResponse(from: response)
                    switch result {
                    case .success(let hoursResponseArray):
                        if let placeIndex = System.places.firstIndex(where: { other -> Bool in
                            return other.id == place.id
                        }) {
                            System.places[placeIndex].hours = hoursResponseArray[0].hours
                        } else {
                            success = false
                        }
                    case .failure(let error):
                        print(error, "faciliyHours")
                        success = false
                    }
                    completion(success)
            }
        } else {
            success = false
            completion(success)
        }
    }

    static func addFeedback(feedback: Feedback, completion: @escaping (Bool) -> Void) {
        guard let token = System.token else { return }
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]

        AF.request("\(url)/addFeedback", method: .post, parameters: feedback, encoder: JSONParameterEncoder.default, headers: headers).responseData { response in
            let decoder = JSONDecoder()
            let result: AFResult<AddFeedbackResponse> = decoder.decodeResponse(from: response)
            switch result {
            case .success(let data):
                print(data)
                if data.success {
                    completion(true)
                } else {
                    completion(false) // Feedback was processed but rejected
                }
            case .failure(let error):
                print(error, "addFeedback")
                print("(Could not decode response to AddFeedbackResponse struct!!)")
                completion(false)
            }
        }
    }
}

extension JSONDecoder {
    func decodeResponse<T: Decodable>(from response: AFDataResponse<Data>) -> AFResult<T> {
        if let error = response.error {
            return .failure(error)
        }

        guard let responseData = response.data else {
            return .failure(AFError.responseValidationFailed(reason: .dataFileNil))
        }

        do {
            let item = try decode(T.self, from: responseData)
            return .success(item)
        } catch {
            return .failure(AFError.responseSerializationFailed(reason: .decodingFailed(error: APIError.noData)))
        }
    }
}
