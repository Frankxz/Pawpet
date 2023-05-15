//
//  GeoManager.swift
//  Pawpet
//
//  Created by Robert Miller on 05.05.2023.
//

import UIKit
import Firebase
import FirebaseDatabase

class GeoHelper {
    static let shared = GeoHelper()
    private init() {}

    enum Localization: String {
        case ru = "ru"
        case en = "en"
    }
}

// MARK: - Fetching CITIES
extension GeoHelper {
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

    func getCitiesOfCountry(countryName: String, localize: Localization) -> [GeoObject] {
        if let countries = readJSONFile(fileName: "countries_\(localize.rawValue)") {
            if let country = countries.first(where: { $0.name == countryName }) {
                return country.cities
            }
        }
        return []
    }
}
