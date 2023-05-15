//
//  UMProtocols.swift
//  Pawpet
//
//  Created by Robert Miller on 15.05.2023.
//

import UIKit

protocol UMFetchProtocol {
    func fetchUserData(for id: String, completion: @escaping (PawpetUser)->())
    func getUserPhoneNumber() -> String
    func getCurrencyForUser(for user: PawpetUser) -> String
    func getUserPhoneNumber(userID: String, completion: @escaping (Result<String, Error>) -> Void)
    func getUserEmail()
}

protocol UMSaveProtocol {
    func saveUserData(for user: PawpetUser)
    func saveUserDataFromUD()
}

protocol UMImageProtocol {
    func saveAvatarImage(image: UIImage, completion: @escaping (Result<String, Error>) -> Void)
    func fetchAvatarImage(id: String, imageView: UIImageView?, completion: @escaping ()->())
}

protocol UMUpdateProtocol {
    func sendPasswordResetToEmail(email: String, completion: @escaping (Result<Void, Error>) -> Void)
    func updatePhoneNumber(verificationID: String, verificationCode: String, completion: @escaping (Result<Void, Error>) -> Void)
    func updateEmail(to newEmail: String, completion: @escaping (Result<Void, Error>) -> Void)
    func updatePassword(to newPassword: String, completion: @escaping (Result<Void, Error>) -> Void)
}
