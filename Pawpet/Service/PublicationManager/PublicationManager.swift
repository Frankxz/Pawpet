//
//  PublicationManager.swift
//  Pawpet
//
//  Created by Robert Miller on 04.05.2023.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseFirestore
import SDWebImage

class PublicationManager {
    static let shared = PublicationManager()
    private init() {}

    let databaseRef = Database.database().reference()
    let firestore = Firestore.firestore()
    let storage = Storage.storage()

    var currentPublication: Publication = Publication()
}

// MARK: - SAVE Publication
extension PublicationManager {
    func savePublication(completion: @escaping (Result<String, Error>) -> Void) {
        let publication = currentPublication

        let storageRef = Storage.storage().reference()

        let publicationsRef = firestore.collection("publications").document()
        let imagesFolderRef = storageRef.child("images/publications/\(publicationsRef.documentID)")


        publication.id = publicationsRef.documentID
        publication.authorID = Auth.auth().currentUser!.uid
        publication.country = UserManager.shared.user.country ?? ""
        publication.city = UserManager.shared.user.city ?? ""
        
        // Загружаем изображения
        uploadImages(publication.pictures.images ?? [], to: imagesFolderRef) { result in
            switch result {
            case .success(let uploadedImages):
                // Обновляем ссылки на изображения в объекте публикации
                var updatedPublication = publication
                if !uploadedImages.isEmpty {
                    updatedPublication = publication.copy(withUpdatedImages: uploadedImages)
                }
                
                // Сохраняем данные публикации
                self.savePublicationData(updatedPublication, to: publicationsRef) { result in
                    switch result {
                    case .success:
                        completion(.success(updatedPublication.id))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // MARK: HELPER METHODS
    private func uploadImages(_ images: [PawpetImage], to storageRef: StorageReference, completion: @escaping (Result<[PawpetImage], Error>) -> Void) {
        if images.isEmpty {
            completion(.success([]))
            return
        }

        var uploadedImages: [PawpetImage] = []
        let group = DispatchGroup()

        for (index, image) in images.enumerated() {
            group.enter()

            if let imageData = image.image.jpegData(compressionQuality: 0.8) {
                let imageRef = storageRef.child("image_\(index).jpg")
                imageRef.putData(imageData, metadata: nil) { (metadata, error) in
                    if let error = error {
                        print("Error uploading image: \(error)")
                        group.leave()
                    } else {
                        imageRef.downloadURL { (url, error) in
                            if let error = error {
                                print("Error getting download URL: \(error)")
                            } else if let url = url {
                                uploadedImages.append(PawpetImage(image: image.image, url: url))
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
            completion(.success(uploadedImages))
        }
    }

    private func savePublicationData(_ publication: Publication, to documentRef: DocumentReference, completion: @escaping (Result<Void, Error>) -> Void) {
        let publicationData: [String: Any] = [
            "id": publication.id,
            "authorID": publication.authorID,
            "petInfo": publication.petInfo.dictionaryRepresentation(),
            "pictures": publication.pictures.dictionaryRepresentation(),
            "price": publication.price,
            "currency": publication.currency,
            "country": publication.country,
            "city": publication.city
        ]

        documentRef.setData(publicationData) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    func deleteImages(publicationID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let storageRef = Storage.storage().reference()
        let imagesFolderRef = storageRef.child("images/publications/\(publicationID)")

        imagesFolderRef.listAll { (result, error) in
            if let error = error {
                completion(.failure(error))
            } else if let result = result {
                let dispatchGroup = DispatchGroup()
                var errors: [Error] = []

                for item in result.items {
                    dispatchGroup.enter()

                    item.delete { error in
                        if let error = error {
                            errors.append(error)
                        }
                        dispatchGroup.leave()
                    }
                }

                dispatchGroup.notify(queue: .main) {
                    if errors.isEmpty {
                        completion(.success(()))
                    } else {
                        completion(.failure(CustomError.multipleErrors(errors: errors)))
                    }
                }
            }
        }
    }
}

// MARK: - UPDATE Publication
extension PublicationManager {
    func updatePublication(_ oldPublication: Publication, changedData: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
        let publicationID = oldPublication.id

        // Создаем новый объект публикации с обновленными данными
        let updatedPublication = oldPublication.copy(withChangedData: changedData)

        let publicationData: [String: Any] = [
            "id": updatedPublication.id,
            "authorID": updatedPublication.authorID,
            "petInfo": updatedPublication.petInfo.dictionaryRepresentation(),
            "pictures": updatedPublication.pictures.dictionaryRepresentation(),
            "price": updatedPublication.price,
            "currency": updatedPublication.currency
        ]

        // Сохраняем обновленные данные публикации
        firestore.collection("publications").document(publicationID).setData(publicationData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}

// MARK: - DELETE Publication
extension PublicationManager {
    func deletePublication(_ publication: Publication, completion: @escaping (Result<Void, Error>) -> Void) {
        let publicationID = publication.id
        let firestore = Firestore.firestore()
        let publicationRef = firestore.collection("publications").document(publicationID)

        // Remove images
        deleteImages(publicationID: publicationID) { result in
            switch result {
            case .success:
                // Удаляем данные публикации
                self.deletePublicationData(from: publicationRef, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func deletePublicationData(from documentRef: DocumentReference, completion: @escaping (Result<Void, Error>) -> Void) {
        documentRef.delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}


// MARK: - Fetch ALL Publication
extension PublicationManager {
    func fetchAllPublications(completion: @escaping ([Publication]?, Error?) -> Void) {
        firestore.collection("publications").getDocuments { (snapshot, error) in
            if let error = error {
                completion(nil, error)
            } else if let snapshot = snapshot {
                var publications: [Publication] = []
                for document in snapshot.documents {
                    if let publication = Publication.fromDictionary(id: document.documentID, dictionary: document.data()) {
                        publications.append(publication)
                    }
                }
                completion(publications, nil)
            } else {
                completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No publications found"]))
            }
        }
    }
}


// MARK: - Fetch User's Publications
extension PublicationManager {
    func fetchPublications(forUserID userID: String = "", completion: @escaping ([Publication]?, Error?) -> Void) {
        var authorID = userID
        if userID.isEmpty {
            authorID = Auth.auth().currentUser!.uid
        }

        firestore.collection("publications").whereField("authorID", isEqualTo: authorID).getDocuments { (snapshot, error) in
            if let error = error {
                completion(nil, error)
            } else if let snapshot = snapshot {
                var publications: [Publication] = []
                for document in snapshot.documents {
                    if let publication = Publication.fromDictionary(id: document.documentID, dictionary: document.data()) {
                        publications.append(publication)
                    }
                }
                completion(publications, nil)
            } else {
                completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No publications found"]))
            }
        }
    }
}


// MARK: - Save publication to favorites
extension PublicationManager {
    func addToFavorites(publicationID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Current user not found"])))
            return
        }

        let databaseRef = Database.database().reference()
        let userRef = databaseRef.child("users").child(currentUserID)

        // Добавить ID публикации в массив `favorites`
        if  UserManager.shared.user.favorites == nil {
            UserManager.shared.user.favorites = []
        }
        UserManager.shared.user.favorites?.append(publicationID)

        // Сохранить обновленный массив `favorites` в Realtime Database
        userRef.updateChildValues(["favorites":  UserManager.shared.user.favorites!]) { (error, _) in
            if let error = error {
                completion(.failure(error))
            } else {
                UserManager.shared.user.isChanged = true
                completion(.success(()))
            }
        }
    }
}

// MARK: - Remove from Favorites
extension PublicationManager {
    func removeFromFavorites(publicationID: String, completion: @escaping (Result<Void, Error>) -> Void) {
            // Удалить ID публикации из массива favorites
            if let index = UserManager.shared.user.favorites?.firstIndex(of: publicationID) {
                UserManager.shared.user.favorites?.remove(at: index)
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
            userRef.updateChildValues(["favorites": UserManager.shared.user.favorites ?? []]) { (error, _) in
                if let error = error {
                    completion(.failure(error))
                } else {
                    UserManager.shared.user.isChanged = true
                    completion(.success(()))
                }
            }
        }
}

// MARK: - Fetching favorites
extension PublicationManager {
    func fetchFavoritePublications(completion: @escaping (Result<[Publication], Error>) -> Void) {

        guard let favorites = UserManager.shared.user.favorites else {
            completion(.success([])) // If no favorites, return an empty array
            return
        }

        var favoritePublications: [Publication] = []
        let dispatchGroup = DispatchGroup()

        for publicationID in favorites {
            dispatchGroup.enter()
            firestore.collection("publications").document(publicationID).getDocument { (snapshot, error) in
                if let error = error {
                    dispatchGroup.leave()
                    completion(.failure(error))
                    return
                }

                if let snapshot = snapshot,
                   let publicationData = snapshot.data(),
                   let publication = Publication.fromDictionary(id: publicationID, dictionary: publicationData) {
                    favoritePublications.append(publication)
                }

                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            completion(.success(favoritePublications))
        }
    }
}

// MARK: - Fetch Publication by Pet Type
extension PublicationManager {
    func fetchPublicationsByPetType(_ petType: PetType, completion: @escaping (Result<[Publication], Error>) -> Void) {
        firestore.collection("publications")
            .whereField("petInfo.petType", isEqualTo: petType.rawValue)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    completion(.failure(error))
                } else if let snapshot = snapshot {
                    var publications: [Publication] = []
                    for document in snapshot.documents {
                        if let publication = Publication.fromDictionary(id: document.documentID, dictionary: document.data()) {
                            publications.append(publication)
                        }
                    }
                    completion(.success(publications))
                } else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No publications found"])))
                }
            }
    }
}

// MARK: - Fetch publications by breed to search
extension PublicationManager {
    func fetchPublicationsByBreed(_ breed: String, completion: @escaping (Result<[Publication], Error>) -> Void) {
        firestore.collection("publications").whereField("petInfo.breed", isEqualTo: breed)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    completion(.failure(error))
                } else if let snapshot = snapshot {
                    var publications: [Publication] = []
                    for document in snapshot.documents {
                        if let publication = Publication.fromDictionary(id: document.documentID, dictionary: document.data()) {
                            publications.append(publication)
                        }
                    }
                    completion(.success(publications))
                } else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No publications found"])))
                }
            }
    }
}

// MARK: - DETAIL Search Publications
extension PublicationManager {
    func fetchPublicationsWithFilter(searchData: [String: Any], completion: @escaping (Result<[Publication], Error>) -> Void) {
        var query: Query = firestore.collection("publications")

        if let petType = searchData["petType"] as? Pawpet.PetType {
            query = query.whereField("petInfo.petType", isEqualTo: petType.rawValue)
        }

        if let breed = searchData["breed"] as? String {
            query = query.whereField("petInfo.breed", isEqualTo: breed)
        }

        if let regions = searchData["regions"] as? [String] {
            query = query.whereField("city", in: regions)
        }

        if let ageFrom = searchData["ageFrom"] as? Int, let ageTo = searchData["ageTo"] as? Int {
            query = query.whereField("petInfo.age", isGreaterThan: ageFrom).whereField("petInfo.age", isLessThan: ageTo)
        }

        if let colors = searchData["colors"] as? [String] {
            query = query.whereField("petInfo.color", in: colors)
        }

        if let isMale = searchData["isMale"] as? Bool {
            query = query.whereField("petInfo.isMale", isEqualTo: isMale)
        }

        if let isVaccinated = searchData["isVaccinated"] as? Bool {
            query = query.whereField("petInfo.isVaccinated", isEqualTo: isVaccinated)
        }

        if let withDocuments = searchData["withDocuments"] as? Bool {
            query = query.whereField("petInfo.isWithDocuments", isEqualTo: withDocuments)
        }


        if let priceFrom = searchData["priceFrom"] as? Int {
            // Если есть интервал цены ОТ проверяем если если ДО
            if let priceTo = searchData["priceTo"] as? Int {
                // Если есть интервал цены ОТ и ДО
                query = query.whereField("price", isGreaterThan: priceFrom).whereField("price", isLessThan: priceTo)
            } else {
                // Если нет интервала цены ДО
                query = query.whereField("price", isGreaterThan: priceFrom)
            }
        } else {
            // Если нет интервала цены ОТ
            if let priceTo = searchData["priceTo"] as? Int {
                query = query.whereField("price", isLessThan: priceTo)
            }
        }

        query.getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                var publications: [Publication] = []
                for document in snapshot.documents {
                    if let publication = Publication.fromDictionary(id: document.documentID, dictionary: document.data()) {
                        publications.append(publication)
                    }
                }
                completion(.success(publications))
            } else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No publications found"])))
            }
        }
    }

}

enum CustomError: Error {
    case multipleErrors(errors: [Error])

    var localizedDescription: String {
        switch self {
        case .multipleErrors(let errors):
            let errorDescriptions = errors.map { $0.localizedDescription }
            return "Multiple errors occurred: \(errorDescriptions.joined(separator: ", "))"
        }
    }
}
