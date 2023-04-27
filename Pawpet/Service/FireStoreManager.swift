//
//  FireStoreManager.swift
//  Pawpet
//
//  Created by Robert Miller on 26.04.2023.
//

import Foundation
import Firebase

class FireStoreManager {
    static let shared = FireStoreManager()
    var ref: DatabaseReference = Database.database().reference()

    private init() {}

    func saveUserData(name: String, lastName: String, country: String, city: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let userData: [String: Any] = [
            "name": name,
            "lastName": lastName,
            "country": country,
            "city": city
        ]

        ref.child("users").child(uid).setValue(userData) { error, _ in
            if let error = error {
                print("Error saving user data: \(error.localizedDescription)")
                return
            }

            print("User data saved successfully")
        }
    }

    func saveUserDataFromUD() {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let name = UserDefaults.standard.string(forKey: "NAME") ?? ""
        let surname = UserDefaults.standard.string(forKey: "SURNAME") ?? ""
        let country = UserDefaults.standard.string(forKey: "COUNTRY") ?? ""
        let city = UserDefaults.standard.string(forKey: "CITY") ?? ""

        print("\(name) \(surname) from \(country) \(city)")
        let userData: [String: Any] = [
            "name": name,
            "surname": surname,
            "country": country,
            "city": city
        ]

        ref.child("users").child(uid).setValue(userData) { error, _ in
            if let error = error {
                print("Error saving user data: \(error.localizedDescription)")
                return
            }

            print("User data saved successfully")
        }
    }


}
