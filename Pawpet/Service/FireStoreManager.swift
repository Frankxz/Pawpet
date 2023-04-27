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
    let user = PawpetUser()

    var ref: DatabaseReference = Database.database().reference()

    private init() {}
}

// MARK: - Save USER DATA
extension FireStoreManager {
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

// MARK: - Fetch USER DATA
extension FireStoreManager {
    func fetchUserData(completion: @escaping ()->()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        ref.child("users").child(uid).observeSingleEvent(of: .value) { (snapshot, _)  in
            if let userData = snapshot.value as? [String: Any] {
                if let name = userData["name"] as? String,
                   let surname = userData["surname"] as? String,
                   let country = userData["country"] as? String,
                   let city = userData["city"] as? String {
                    print("\(name) \(surname), from \(country) \(city)")
                    FireStoreManager.shared.user.name = name
                    FireStoreManager.shared.user.surname = surname
                    FireStoreManager.shared.user.country = country
                    FireStoreManager.shared.user.city = city
                    completion()
                } else {
                    print("Error parsing user data")
                }
            } else {
                print("User data not found")
            }
        }
    }

    func getUserPhoneNumber() -> String {
        guard let user = Auth.auth().currentUser else { return "" }
        if let phoneNumber = user.phoneNumber {
            return phoneNumber
        } else {
            return ""
        }
    }

}
