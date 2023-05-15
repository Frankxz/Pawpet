//
//  UserManager.swift
//  Pawpet
//
//  Created by Robert Miller on 26.04.2023.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseStorage
import SDWebImage

class UserManager {
    static let shared = UserManager()
    var user = PawpetUser()
    var ref: DatabaseReference = Database.database().reference()
    
    private init() {}
}

// MARK: - Save USER DATA
extension UserManager {
    func saveUserData(for user: PawpetUser) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let userData: [String: Any] = [
            "name": user.name ?? "",
            "surname": user.surname ?? "",
            "country": user.country ?? "",
            "phoneNumber": user.phoneNumber ?? "",
            "city": user.city ?? "",
            "currency": user.currency ?? "",
            "favorites": user.favorites ?? [] //
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
        let phoneNumber = UserDefaults.standard.string(forKey: "PHONE") ?? ""
        let city = UserDefaults.standard.string(forKey: "CITY") ?? ""
        let currency = getCurrencyForUser(for: user)
        let favorites: [String] = []

        let userData: [String: Any] = [
            "name": name,
            "surname": surname,
            "country": country,
            "phoneNumber": phoneNumber,
            "city": city,
            "currency": currency,
            "favorites": favorites
        ]
        
        ref.child("users").child(uid).setValue(userData) { error, _ in
            if let error = error {
                print("Error saving user data: \(error.localizedDescription)")
                return
            }
            
            print("User data saved successfully")
        }
    }

    private func getCurrencyForUser(for user: PawpetUser) -> String {
        if user.country == "Russia" || user.country == "Belarus" {
            return "RUB"
        } else if user.country == "Kazakhstan" {
            return "KZT"
        } else {
            return "USD"
        }
    }
}

// MARK: - Fetch USER DATA
extension UserManager {
    func fetchUserData(for id: String = "", completion: @escaping (PawpetUser)->()) {
        var uid  = ""
        if id.isEmpty {
            uid = Auth.auth().currentUser!.uid
        } else { uid = id }
        
        ref.child("users").child(uid).observeSingleEvent(of: .value) { (snapshot, _)  in
            if let userData = snapshot.value as? [String: Any] {
                if let name = userData["name"] as? String,
                   let surname = userData["surname"] as? String,
                   let country = userData["country"] as? String,
                   let phoneNumber = userData["phoneNumber"] as? String,
                   let city = userData["city"] as? String,
                   let currency = userData["currency"] as? String,
                   let favorites = userData["favorites"] as? [String]? { //
                    let user = PawpetUser(name: name, surname: surname, country: country, phoneNumber: phoneNumber, city: city, currency: currency, favorites: favorites)
                    if id.isEmpty {
                        UserManager.shared.user = user
                        self.fetchAvatarImage {}
                    }
                    completion(user)
                } else {
                    print("Error parsing user data")
                }
            } else {
                print("User data not found")
            }
        }
    }
    
    // MARK: Getting PHONE NUMBER
    func getUserPhoneNumber() -> String {
        guard let user = Auth.auth().currentUser else { return "NO AUTH" }
        if let phoneNumber = user.phoneNumber {
            print("PHONE NUMBER: \(phoneNumber)")
            return phoneNumber
        } else {
            return "NO PHONE NUMBER"
        }
    }

    func getUserPhoneNumber(userID: String, completion: @escaping (Result<String, Error>) -> Void) {
        let ref = Database.database().reference().child("users").child(userID)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                if let phoneNumber = dictionary["phoneNumber"] as? String {
                    completion(.success(phoneNumber))
                } else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No phone number found"])))
                }
            }
        }) { (error) in
            completion(.failure(error))
        }
    }

    
    // MARK: Getting EMAIL
    func getUserEmail() -> String {
        guard let user = Auth.auth().currentUser else { return "NO AUTH" }
        if let email = user.email {
            return email
        } else {
            return "NO EMAIL"
        }
    }
}

// MARK: Images FETCHING AND SAVING
extension UserManager {
    func saveAvatarImage(image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let imagePath = "images/\(uid)/avatar.jpg"

        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to JPEG data"])))
            return
        }

        let storageRef = Storage.storage().reference().child(imagePath)
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(imagePath))
            }
        }
    }

    func fetchAvatarImage(id: String = "",imageView: UIImageView? = nil, completion: @escaping ()->()) {
        var userID = id
        if id.isEmpty {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            userID = uid
        }
        let imagePath = "images/\(userID)/avatar.jpg"

        let storageRef = Storage.storage().reference().child(imagePath)
        storageRef.downloadURL { (url, error) in
            if let error = error {
                print("Error getting download URL: \(error.localizedDescription)")
                return
            }

            if let url = url {
                if let imageView = imageView {
                    imageView.sd_setImage(with: url, placeholderImage: nil, options: .retryFailed) { (image, error, _, _) in
                        if let error = error {
                            print(error.localizedDescription)
                        } else {
                            completion()
                            UserManager.shared.user.image = image
                        }
                    }
                }
            }
        }
    }

}

// MARK: - EMAIL & PHONE & PASSWORD UPDATING
extension UserManager {
    func updateEmail(to newEmail: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().currentUser?.updateEmail(to: newEmail) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    func updatePhoneNumber(verificationID: String, verificationCode: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: verificationCode
        )

        Auth.auth().currentUser?.updatePhoneNumber(credential) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                let databaseRef = Database.database().reference()
                let user = Auth.auth().currentUser!
                let userRef = databaseRef.child("users").child(user.uid)
                let newPhoneNumber = user.phoneNumber!
                userRef.updateChildValues(["phoneNumber": newPhoneNumber ]) { (error, _) in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        UserManager.shared.user.isChanged = true
                        completion(.success(()))
                    }
                }
                completion(.success(()))
            }
        }
    }

    func updatePassword(to newPassword: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().currentUser?.updatePassword(to: newPassword) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}

// MARK: - reauthenticateUser
extension UserManager {
    func reauthenticateUser(password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        if let currentUser = Auth.auth().currentUser {
            let credential = EmailAuthProvider.credential(withEmail: currentUser.email!, password: password)
            currentUser.reauthenticate(with: credential) { authResult, error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        } else {
            completion(.failure(NSError(domain: "FirebaseAuth", code: -1, userInfo: [NSLocalizedDescriptionKey: "Current user not found"])))
        }
    }
}

// MARK: - Password reset
extension UserManager {
    func sendPasswordResetToEmail(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}

