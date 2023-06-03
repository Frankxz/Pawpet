//
//  PawpetTests.swift
//  PawpetTests
//
//  Created by Robert Miller on 05.02.2023.
//

import XCTest
@testable import Pawpet

final class PawpetTests: XCTestCase {

    // MARK: - Validation TESTS
    func testEmailValidationOnCorrectData() throws {
        let email = "email@mail.ru"
        let isValidEmail = isValidEmail(email)
        XCTAssertTrue(isValidEmail)
    }

    func testEmailValidationOnIncorrectData() throws {
        let emails = ["emailmail.ru", "email@mail", "email.mm@mail@mail", ""]
        emails.forEach { XCTAssertFalse(isValidEmail($0)) }
    }

    func testPasswordValidationOnCorrectData() throws {
        let password = "123456789Zz"
        XCTAssertTrue(isValidPassword(password))
    }

    func testPasswordValidationOnIncorrectData() throws {
        let passwords = ["", "123456789", "bar", "-024-@d12", "NGTU"]
        passwords.forEach { XCTAssertFalse(isValidPassword($0)) }
    }

    // MARK: - JSON Parsing TESTS
    func testPublicationFetching() {
        let petInfo = PetInfo(petType: .dog, breed: "French Bulldog", age: 12, isMale: true, color: .black, description: "Bar bus")
        let publication = Publication(id: "", authorID: "", petInfo: petInfo, pictures: PublicationPictures(), price: 1000, currency: "USD", country: "Russia", city: "Moscow")

        PublicationManager.shared.currentPublication = publication
        PublicationManager.shared.savePublication { result in
            switch result {
            case .success(_):
                XCTAssertTrue(false)

                self.testFetchPublication()
            case .failure(let error):
                XCTAssertFalse(true)
            }
        }
    }

    func testFetchPublication() {

    }

}

extension PawpetTests {
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
}
