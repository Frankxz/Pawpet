//
//  GeoManager.swift
//  Pawpet
//
//  Created by Robert Miller on 05.05.2023.
//

import UIKit
import Firebase
import FirebaseDatabase

class GeoManager {
    let databaseRef = Database.database().reference()

    static let shared = GeoManager()
    private init() {}

    enum Localization: String {
        case ru = "ru"
        case en = "en"
    }
}

// MARK: - Fetching CITIES
extension GeoManager {
    func readJSONFile(fileName: String) -> [Country]? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: [String]] {

                    var countries: [Country] = []
                    for (countryName, cities) in json {
                        let country = Country(name: countryName, cities: cities)
                        countries.append(country)
                    }
                    return countries
                }
            } catch {
                print("Error while reading JSON file: \(error)")
                return nil
            }
        }
        return nil
    }

    func getAllCountries(localize: Localization) -> [Country] {
        if let countries = readJSONFile(fileName: "countries_\(localize.rawValue)") {
            return countries
        }
        return []
    }



//    func findCities(for country: String) -> [GeoObject]{
//        guard let path = Bundle.main.path(forResource: "countries", ofType: "json") else {
//            return []
//        }
//        do {
//            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
//            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
//
//            if let citiesDict = jsonResult as? [String: [String]],
//               let fethcedCities = citiesDict[country] {
//                var cities: [GeoObject] = []
//                for item in fethcedCities {
//                    let city = GeoObject(name: item, isChecked: false)
//                    cities.append(city)
//                    print("\(item) add")
//                }
//                print(cities.count)
//                return cities
//            } else { return []}
//        } catch { return []}
//    }
}
