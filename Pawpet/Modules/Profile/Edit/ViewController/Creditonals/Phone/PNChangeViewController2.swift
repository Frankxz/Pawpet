//
//  PNChangeViewController2.swift
//  Pawpet
//
//  Created by Robert Miller on 29.04.2023.
//

import UIKit
import FirebaseAuth

class PNChangeViewController2: SignUpViewController4 {
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
    }
}

// MARK: - Verification logic
extension PNChangeViewController2 {
    @objc internal override func nextButtonTapped(_ sender: UIButton) {
        guard let code = textView.text else { return }
        UserManager.shared.updatePhoneNumber(verificationID: verificationID, verificationCode: code) { result in
            switch result {
            case .success:
                print("Phone number updated successfully")
                self.dismiss(animated: true)
                self.callback()
            case .failure(let error):
                self.alertView.showAlert(with: "Oops! Error...", message: error.localizedDescription, on: self)
                print("Error updating phone number: \(error.localizedDescription)")
            }
        }
    }

    private func makeUpdate() {

    }
}
