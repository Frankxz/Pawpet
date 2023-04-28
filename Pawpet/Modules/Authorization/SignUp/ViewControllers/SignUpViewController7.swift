//
//  SignUpViewController7.swift
//  Pawpet
//
//  Created by Robert Miller on 13.04.2023.
//

import UIKit

class SignUpViewController7: GeoSelectionViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
    }
}

// MARK: - Button logic
extension SignUpViewController7 {
    @objc private func nextButtonTapped(_ sender: UIButton) {
        UserDefaults.standard.set(self.selectedGeoObject!.name, forKey: "CITY")
        FireStoreManager.shared.saveUserDataFromUD()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.navigationController?.pushViewController(SignUpViewController_final(), animated: true)
        }
    }
}
