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
    var user = PawpetUser()
    let currentPublication = Publication()
    
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
        let city = UserDefaults.standard.string(forKey: "CITY") ?? ""
        let currency = getCurrencyForUser(for: user)
        let favorites: [String] = []

        let userData: [String: Any] = [
            "name": name,
            "surname": surname,
            "country": country,
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
extension FireStoreManager {
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
                   let city = userData["city"] as? String,
                   let currency = userData["currency"] as? String,
                   let favorites = userData["favorites"] as? [String]? { //
                    let user = PawpetUser(name: name, surname: surname, country: country, city: city, currency: currency, favorites: favorites)
                    if id.isEmpty {
                        FireStoreManager.shared.user = user
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

// MARK: - Publication saving
extension FireStoreManager {
    func savePublication(completion: @escaping (Result<String, Error>) -> Void) {
        let publication = FireStoreManager.shared.currentPublication
        publication.location = [user.country ?? "" : user.city ?? ""]
        publication.userID = Auth.auth().currentUser!.uid

        let databaseRef = Database.database().reference()
        let storageRef = Storage.storage().reference()

        let publicationsRef = databaseRef.child("publications").childByAutoId()
        let imagesFolderRef = storageRef.child("images/\(publicationsRef.key!)")

        // Установите id для текущей публикации
        publication.id = publicationsRef.key!

        var imageURLs: [String] = []

        let group = DispatchGroup()

        for (index, image) in publication.pictures.enumerated() {
            group.enter()

            if let imageData = image.jpegData(compressionQuality: 0.8) {
                let imageRef = imagesFolderRef.child("image_\(index).jpg")
                imageRef.putData(imageData, metadata: nil) { (metadata, error) in
                    if let error = error {
                        print("Error uploading image: \(error)")
                        group.leave()
                    } else {
                        imageRef.downloadURL { (url, error) in
                            if let error = error {
                                print("Error getting download URL: \(error)")
                            } else if let url = url {
                                imageURLs.append(url.absoluteString)
                            }
                            group.leave()
                        }
                    }
                }
            } else {
                group.leave()
            }
        }

        group.notify(queue: .main) {
            let publicationData: [String: Any] = [
                "id": publication.id, // добавьте id в словарь
                "petType": publication.petType.rawValue,
                "isCrossbreed": publication.isCrossbreed ?? false,
                "breed": publication.breed,
                "secondBreed": publication.secondBreed ?? "",
                "age": publication.age,
                "isMale": publication.isMale,
                "description": publication.description,
                "price": publication.price,
                "currency": publication.currency,
                "isCupping": publication.isCupping ?? false,
                "isSterilized": publication.isSterilized ?? false,
                "isVaccinated": publication.isVaccinated ?? false,
                "picturesURLs": imageURLs,
                "location": publication.location,
                "userID": publication.userID
            ]

            publicationsRef.setValue(publicationData) { (error, _) in
                if let error = error {
                    completion(.failure(error))
                } else {
                    FireStoreManager.shared.user.isChanged = true
                    completion(.success(publicationsRef.key!))
                }
            }
        }
    }
    
    // MARK: - REMOVE Publication
    func deletePublication(withId id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let databaseRef = Database.database().reference()
        let storageRef = Storage.storage().reference()

        let publicationsRef = databaseRef.child("publications").child(id)
        let imagesFolderRef = storageRef.child("images/\(id)")

        // Удаляем изображения публикации из хранилища
        imagesFolderRef.listAll { (result, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                if let result = result {
                    let group = DispatchGroup()

                    for item in result.items {
                        group.enter()
                        item.delete { (error) in
                            if let error = error {
                                print("Error deleting image: \(error)")
                            }
                            group.leave()
                        }
                    }

                    group.notify(queue: .main) {
                        // Удаляем запись публикации из базы данных
                        publicationsRef.removeValue { (error, _) in
                            if let error = error {
                                completion(.failure(error))
                            } else {
                                completion(.success(()))
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Fetching publications
extension FireStoreManager {
    // MARK:  Fetch User's Publications
    func fetchPublicationsForUser(userID: String, completion: @escaping ([Publication]) -> Void) {
        let databaseRef = Database.database().reference()
        let publicationsRef = databaseRef.child("publications")


        publicationsRef.queryOrdered(byChild: "userID").queryEqual(toValue: userID).observeSingleEvent(of: .value) { (snapshot, _) in
            guard let value = snapshot.value as? [String: [String: Any]] else {
                print("NO DATA")
                completion([])
                return
            }

            var publications: [Publication] = []
            let dispatchGroup = DispatchGroup()

            for (key, publicationData) in value {
                dispatchGroup.enter()
                self.publicationFromDictionary(id: key, data: publicationData) { (publication) in
                    if let publication = publication {
                        publications.append(publication)
                    }
                    dispatchGroup.leave()
                }
            }

            dispatchGroup.notify(queue: .main) {
                completion(publications)
            }
        }
    }

    // MARK:  Fetch ALL Publications
    func fetchAllPublications(completion: @escaping ([Publication]) -> Void) {
        let databaseRef = Database.database().reference()
        let publicationsRef = databaseRef.child("publications")

        publicationsRef.observeSingleEvent(of: .value) { (snapshot) in
            guard let value = snapshot.value as? [String: [String: Any]] else {
                print("NO DATA")
                completion([])
                return
            }

            var publications: [Publication] = []
            let dispatchGroup = DispatchGroup()

            for (key, publicationData) in value {
                dispatchGroup.enter()
                self.publicationFromDictionary(id: key, data: publicationData) { (publication) in
                    if let publication = publication {
                        publications.append(publication)
                        print("Posts count: \(publications.count) | ID: \(publications[0].id)")
                    }
                    dispatchGroup.leave()
                }
            }

            dispatchGroup.notify(queue: .main) {
                completion(publications)

            }
        }
    }

    // ADDITIONAL METHOD to simplify user fetching
    func publicationFromDictionary(id: String, data: [String: Any], completion: @escaping (Publication?) -> Void) {
        guard let petTypeName = data["petType"] as? String,
              let id = data["id"] as? String,
              let petType = PetType(rawValue: petTypeName.lowercased()),
              let breed = data["breed"] as? String,
              let age = data["age"] as? Int,
              let isMale = data["isMale"] as? Bool,
              let description = data["description"] as? String,
              let price = data["price"] as? Int,
              let currency = data["currency"] as? String,
              let picturesURLs = data["picturesURLs"] as? [String]?,
              let location = data["location"] as? [String: String],
              let userID = data["userID"] as? String
        else {
            print("INCORRECTED DATA")
            completion(nil)
            return
        }

        let isCrossbreed = data["isCrossbreed"] as? Bool
        let secondBreed = data["secondBreed"] as? String
        let isCupping = data["isCupping"] as? Bool
        let isSterilized = data["isSterilized"] as? Bool
        let isVaccinated = data["isVaccinated"] as? Bool

        let dispatchGroup = DispatchGroup()
        var pictures: [UIImage] = []

        if picturesURLs != nil {
            for url in picturesURLs!{
                guard let imageURL = URL(string: url) else { continue }
                dispatchGroup.enter()
                URLSession.shared.dataTask(with: imageURL) { (data, _, _) in
                    if let data = data, let image = UIImage(data: data) {
                        pictures.append(image)
                    }
                    dispatchGroup.leave()
                }.resume()
            }
        }


        dispatchGroup.notify(queue: .main) {
            let publication = Publication(id: id, petType: petType, isCrossbreed: isCrossbreed, breed: breed, secondBreed: secondBreed, age: age, isMale: isMale, description: description, price: price, currency: currency, isCupping: isCupping, isSterilized: isSterilized, isVaccinated: isVaccinated, pictures: pictures, location: location, userID: userID)
            completion(publication)
        }
    }
}

// MARK: - Favorites
extension FireStoreManager {
    func addToFavorites(publicationID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Current user not found"])))
            return
        }

        let databaseRef = Database.database().reference()
        let userRef = databaseRef.child("users").child(currentUserID)
        
        // Добавить ID публикации в массив `favorites`
        if  FireStoreManager.shared.user.favorites == nil {
            FireStoreManager.shared.user.favorites = []
        }
        FireStoreManager.shared.user.favorites?.append(publicationID)

        // Сохранить обновленный массив `favorites` в Realtime Database
        userRef.updateChildValues(["favorites":  FireStoreManager.shared.user.favorites!]) { (error, _) in
            if let error = error {
                completion(.failure(error))
            } else {
                FireStoreManager.shared.user.isChanged = true
                completion(.success(()))
            }
        }
    }

    func removeFromFavorites(publicationID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // Удалить ID публикации из массива favorites
        if let index = FireStoreManager.shared.user.favorites?.firstIndex(of: publicationID) {
            user.favorites?.remove(at: index)
        } else {
            completion(.failure(NSError(domain: "Publication not found in favorites", code: 404, userInfo: nil)))
            return
        }

        // Получить ссылку на Realtime Database
        let databaseRef = Database.database().reference()

        // Получить ссылку на текущего пользователя
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "No current user", code: 401, userInfo: nil)))
            return
        }

        // Получить ссылку на пользователя в Realtime Database
        let userRef = databaseRef.child("users").child(currentUserID)

        // Обновить данные пользователя в Realtime Database
        userRef.updateChildValues(["favorites": FireStoreManager.shared.user.favorites ?? []]) { (error, _) in
            if let error = error {
                completion(.failure(error))
            } else {
                FireStoreManager.shared.user.isChanged = true
                completion(.success(()))
            }
        }
    }

    func fetchFavoritePublications(completion: @escaping ([Publication]) -> Void) {
        print("FireStoreManager.shared.user.favorites = \(FireStoreManager.shared.user.favorites?.count)")
        guard let favorites =  FireStoreManager.shared.user.favorites else {
            completion([])
            return
        }

        let databaseRef = Database.database().reference()
        let publicationsRef = databaseRef.child("publications")

        var favoritePublications: [Publication] = []
        let dispatchGroup = DispatchGroup()

        for publicationID in favorites {
            dispatchGroup.enter()
            publicationsRef.child(publicationID).observeSingleEvent(of: .value) { (snapshot) in
                if let publicationData = snapshot.value as? [String: Any] {
                    self.publicationFromDictionary(id: publicationID, data: publicationData) { (publication) in
                        if let publication = publication {
                            favoritePublications.append(publication)
                        }
                        dispatchGroup.leave()
                    }
                } else {
                    dispatchGroup.leave()
                }
            }
        }

        dispatchGroup.notify(queue: .main) {
            completion(favoritePublications)
        }
    }
}
