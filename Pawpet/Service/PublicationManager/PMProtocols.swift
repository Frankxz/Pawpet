//
//  PMProtocols.swift
//  Pawpet
//
//  Created by Robert Miller on 15.05.2023.
//

import Foundation
protocol PMPDataProtocol {
    func savePublication(completion: @escaping (Result<String, Error>) -> Void)
    func updatePublication(_ oldPublication: Publication, changedData: [String: Any], completion: @escaping (Result<Void, Error>) -> Void)
    func deletePublication(_ publication: Publication, completion: @escaping (Result<Void, Error>) -> Void)
}

protocol PMFavoritesProtocol {
    func addToFavorites(publicationID: String, completion: @escaping (Result<Void, Error>) -> Void)
    func removeFromFavorites(publicationID: String, completion: @escaping (Result<Void, Error>) -> Void)
    func fetchFavoritePublications(completion: @escaping (Result<[Publication], Error>) -> Void)
}

protocol PMFetchProtocol {
    func fetchAllPublications(completion: @escaping ([Publication]?, Error?) -> Void)
    func fetchPublications(forUserID userID: String, completion: @escaping ([Publication]?, Error?) -> Void)
    func fetchPublicationsByPetType(_ petType: PetType, completion: @escaping (Result<[Publication], Error>) -> Void)
    func fetchPublicationsByBreed(_ breed: String, completion: @escaping (Result<[Publication], Error>) -> Void)
    func fetchPublicationsWithFilter(searchData: [String: Any], completion: @escaping (Result<[Publication], Error>) -> Void)
}
