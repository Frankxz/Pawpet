//
//  FireStoreManager.swift
//  Pawpet
//
//  Created by Robert Miller on 26.04.2023.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseStorage
import SDWebImage

class FireStoreManager {
    static let shared = FireStoreManager()
    let user = PawpetUser()
    
    var ref: DatabaseReference = Database.database().reference()
    
    private init() {}
}

// MARK: - Save USER DATA
extension FireStoreManager {
    func saveUserData(for user: PawpetUser) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let userData: [String: Any] = [
            "name": user.name ?? "",
            "surname": user.surname ?? "",
            "country": user.country ?? "",
            "city": user.city ?? ""
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
                    self.fetchAvatarImage()
                    completion()
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
    
    // MARK: Getting EMAIL
    func getUserEmail() -> String {
        guard let user = Auth.auth().currentUser else { return "NO AUTH" }
        if let email = user.email {
            print("EMAIL: \(email)")
            return email
        } else {
            return "NO EMAIL"
        }
    }
}

// MARK: Images FETCHING AND SAVING
extension FireStoreManager {
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

    func fetchAvatarImage(imageView: UIImageView? = nil) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let imagePath = "images/\(uid)/avatar.jpg"

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
                            FireStoreManager.shared.user.image = image
                        }
                    }
                }
            }
        }
    }

}

// MARK: - EMAIL & PHONE & PASSWORD UPDATING
extension FireStoreManager {
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
extension FireStoreManager {
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
extension FireStoreManager {
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
